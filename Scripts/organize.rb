STDOUT.sync = true
require 'tty-command'

scriptsDirectory = __dir__
projectDirectory = File.expand_path("..", scriptsDirectory)
projectName = "Slate.xcodeproj"
projectPath = File.join(projectDirectory, projectName)

Dir.chdir(projectDirectory) do
  cmd = TTY::Command.new
  cmd.run("synx --no-sort-by-name", projectPath)
end
