#!/usr/bin/ruby
STDOUT.sync = true

require 'fileutils'
require 'pp'

scriptsDirectory = __dir__
$projectDirectory = File.expand_path(File.join(scriptsDirectory, ".."))
$benchmarksDirectory = File.join($projectDirectory, "Benchmarks")
$iterations = 10

targetFunctions = [
  "componentEditBarSetup",
  "loadComponentEditBar",
  "controlMenuSetup",
  "setUpContentView",
  "setUpValueLabel",
  "setUpIconProxy",
  "setUpSaveButton",
  "setUpCancelButton",
  "setUpCancelButton",
  "setUpTitleButton",
  "setUpTitleLabel",
  "addDeleteControl",
  "setLeftConstraint",
  "addTitleLabel",
  "setUpControl",
  "setUpLabel",
  "setUpStackView",
  "addProgressControl",
  "setUpIconProxy",
  "setUpViews",
  "setUpDialog",
  "setUpImageView",
  "setUpExplanation",
  "privacyCellPreview",
  "addCellSeparator",
  "setUpButtons",
  "generateView",
  "cameraSetup"
]

$foundFunctions = {}

targetFunctions.each do |name|
  $foundFunctions[name] = 0
end

def runBenchmark()
  Dir.chdir($projectDirectory) do
    filename = "benchmark.txt"
    command = "xcodebuild -workspace Slate.xcworkspace -scheme Slate -derivedDataPath profileBuild -configuration Release clean build OTHER_SWIFT_FLAGS=\"-Xfrontend -debug-time-function-bodies\" | grep .[0-9]ms | grep -v ^0.[0-9]ms | sort -nr > #{filename}"
    # Clean and build, capturing only lines containing `X.Yms` where X > 0, sorting from largest to smallest
    for iteration in 0...$iterations do
      if File.exist?(filename)
        File.unlink(filename)
      end

      puts "Compiling iteration ##{iteration}"
      system command
      readResults(filename: filename, iteration: iteration)
    end
  end

  writeOutResults()
end # runBenchmark

$results = {

}
$totals = {

}

def readResults(filename: nil, iteration: nil)
  totalTime = 0.to_f
  File.open(filename).each do |line|
    match = /([0-9\.]+)ms.*?([^\/]+\.swift[0-9\:]+)[^\(]+func ([^\(]+)\(+/.match(line)
    if !match
      next
    end

    time = match[1].to_f
    filename = match[2]
    function = match[3]

    if $foundFunctions[function] == nil
      next
    end

    totalTime += time
    $foundFunctions[function] += 1

    $key = "#{filename} : #{function}"
    if $results[$key] == nil
      $results[$key] = time
    else
      $results[$key] += time
    end
  end # File.open

  $foundFunctions.each do |name, value|
    if value == 0
      puts "Error: Couldn't find function #{name} in benchmark!"
    end
  end

  totalTime = totalTime.round(2)
  $totals[iteration] = totalTime
  puts "iteration #{iteration} time: #{totalTime}ms"
end # readResults

def writeOutResults()
  currentTime = Time.now.strftime("%m-%d-%Y %H-%M-%S")
  iterations = $totals.count
  out = "Ran #{iterations} tests @ #{currentTime}\n"
  out += "Monitored #{$results.count} functions\n\n"

  $results.each do |key, value|
    total = value.round(2)
    average = (value / iterations.to_f).round(2)
    out += "#{key} = #{total}ms total, #{average}ms average\n"
  end
  out += "\n"

  totalTime = 0.to_f
  $totals.each do |key, time|
    totalTime += time
    out += "Iteration ##{key}: #{time}ms\n"
  end
  average = (totalTime / iterations.to_f).round(2)
  out += "\nTotal time: #{totalTime}ms, average: #{average}ms"
  puts out

  filename = File.join($benchmarksDirectory, "swiftBenchmark-#{currentTime}.txt")
  File.open(filename, 'w') { |file| file.write(out) }
  puts "wrote to #{filename}"
end

runBenchmark
