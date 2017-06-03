#!/usr/bin/ruby
# show output ASAP
STDOUT.sync = true

require 'fileutils'
require 'pp'

scriptsDirectory = __dir__
projectDirectory = File.expand_path(File.join(scriptsDirectory, ".."))

Dir.chdir(projectDirectory) do
  # Clean and build, capturing only lines containing `X.Yms` where X > 0, sorting from largest to smallest
  puts "Compiling"
  command = "xcodebuild -workspace Slate.xcworkspace -scheme Slate -derivedDataPath profileBuild -configuration Release clean build OTHER_SWIFT_FLAGS=\"-Xfrontend -debug-time-function-bodies\" | grep .[0-9]ms | grep -v ^0.[0-9]ms | sort -nr > swiftProfile.txt"
  system command
  puts "Done"
end
