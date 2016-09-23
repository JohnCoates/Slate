scriptsDirectory = __dir__
projectDirectory = File.expand_path("..", scriptsDirectory)
projectName = "Slate.xcodeproj"
projectPath = File.join(projectDirectory, projectName)

Dir.chdir(projectDirectory) do
  `synx --no-sort-by-name "#{projectPath}"`
end
