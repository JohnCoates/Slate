scriptsDirectory = __dir__
projectDirectory = File.expand_path("..", scriptsDirectory)
projectName = "Slate.xcodeproj"
projectPath = File.join(projectDirectory, projectName)

Dir.chdir(projectDirectory) do
  # iOS Device
  # ret = `xcodebuild -project "#{projectPath}" -target Slate -showBuildSettings`
  # simulator
  ret = `xcodebuild -project "#{projectPath}" -scheme Slate -destination 'platform=iOS Simulator,name=iPhone 6s' -showBuildSettings test`
  puts ret
end
