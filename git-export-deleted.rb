#!/usr/bin/env ruby
#
#= Export deleted file list on specific revisions
#
# Export deleted file list on specific revisions.
#
#= Usage
#
# git-export-deleted.rb {hash} ({hash})
#
# If you want to use with SourceTree, set custom action with argument $SHA
#
require "yaml"
require "optparse"
require 'shellwords'

root_path = Dir::pwd # get repository fill path without $REPO.
root_dir  = File.basename(root_path)

unless File.exists?(File.join(root_path, ".git"))
  puts "Oops! Current directory is not a git repository."
  exit 1
end

# default options
options = {
  :archive => nil,
  :output => File.join(root_path, "..")
}

# load config if exist
path_yml = File.join(root_path, "git-export-config.yml")
global_config = File.exists?(path_yml) ? YAML.load_file(path_yml) : {}
config = global_config['deleted'] # FIXME: be more flexible

# overwrite options by values from yaml
if config
  [:output, :format].each do |k|
    options[k] = config[k.to_s] if config[k.to_s]
  end
end

# overwrite options by argument options
OptionParser.new do |opt|
  opt.on('-o VALUE', 'OUTPUT PATH') do |v|
    options[:output] = v
  end
  opt.on('-f VALUE', 'OUTPUT NAME FORMAT (ex. OUTPUT-%y%m%d)') do |v|
    options[:format] = v
  end
  opt.parse!(ARGV)
end



sha = ARGV.first # get last selected rev. newer commit
sha_old = ARGV.last  # get last selected rev. older commit

unless /[a-z0-9]{4,40}/ === sha and /[a-z0-9]{4,40}/ === sha_old
  puts "Give me valid SHA hash!"
  exit 1
end



# set previous hash to "from" if not selected multiple revision
sha_old = sha + "^" if sha_old === sha



if options[:format]
  dir = Time.now.strftime(options[:format])
else
  # get tag name or branch name
  desc = %x[git describe --contains --all #{sha}]
  name = case desc
    when /^tags/
      desc[/tags\/(\w+)\^0/, 1].strip
    when /^remotes/
      desc[/remotes\/(\w+\/\w+)/, 1].gsub("/", "-").strip + "-#{sha[0,7]}"
    else
      desc.sub(/~\d/, "").strip + "-#{sha[0,7]}"
    end

  dir = "#{root_dir}-#{name}"
end

output = File.join(options[:output], dir)

puts "sha\t: "     + "#{sha}"
puts "sha_old\t: " + "#{sha}"
puts "root\t: "    + "#{root_path}"
puts "name\t: "    + "#{name}"
puts "dir\t:  "    + "#{dir}"
puts "output\t: "  + "#{output}"

puts "---- options ----  "

options.keys.each do |k|
  puts "#{k.to_s}\t: #{options[k]}"
end



diff_cmd = "git diff --stat --diff-filter=D --name-only #{sha_old}..#{sha}"
diff_files = %x[#{diff_cmd}]

puts "\n"
puts "----  export deleted files  ----"
puts diff_files
puts "--------------------------------"
puts "\n"

if diff_files.empty?
  puts "There are no deleted files."
  exit 0
end



# suffix number if already exist file or directory
suffix_no = 0
suffix_format = "-%03d"
suffix = ""
ext = options[:archive] ? options[:archive] : ""

while File.exists?(output + suffix + ext)
  suffix_no = suffix_no + 1
  suffix = suffix_format % [suffix_no]
end
output = (output + suffix + ".txt").shellescape

File.open(output, "w") do |f|
  f.puts diff_files
end

exit 0
