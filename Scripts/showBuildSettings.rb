scriptsDirectory = __dir__
projectDirectory = File.expand_path("..", scriptsDirectory)
projectName = "Slate.xcodeproj"
projectPath = File.join(projectDirectory, projectName)

Dir.chdir(projectDirectory) do
  # iOS Device
  # ret = `xcodebuild -project "#{projectPath}" -target Slate -showBuildSettings`
  # simulator
  ret = `xcodebuild -project "#{projectPath}" -target Slate -destination 'platform=iOS Simulator,name=iPhone 6s' -showBuildSettings`
  puts ret
end
