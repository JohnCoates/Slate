require 'pp'
devicesDirectory = File.expand_path("~/Library/Developer/CoreSimulator/Devices")
devices = Dir.entries(devicesDirectory)

def clearPermissionsCommand(forBundleIdentifier: nil)
  return "DELETE FROM access WHERE client = '#{forBundleIdentifier}'"
end

def clearCommand(forTCCPath: nil, bundleIdentifier: nil)
  sqlCommand = clearPermissionsCommand(forBundleIdentifier: bundleIdentifier)
  return "sqlite3 \"#{forTCCPath}\" \"#{sqlCommand}\""
end
def clearCommands(forTCCPath: nil)
  [ clearCommand(forTCCPath: forTCCPath, bundleIdentifier: "com.johncoates.Slate"),
    clearCommand(forTCCPath: forTCCPath, bundleIdentifier: "com.johncoates.slate.Feature-Catalog")
  ]
end
count = 0
devices.each do |filename|
  if filename[0] == '.' || filename.length != 36
    next
  end
  device = File.join(devicesDirectory, filename)
  tccPath = "data/Library/TCC/TCC.db"

  fullPath = File.join(device, tccPath)
  if !File.exists?(fullPath)
    next
  end
  count += 1
  puts "Clearing TCC for Simulator #{filename}"
  commands = clearCommands(forTCCPath: fullPath)
  commands.each do |command|
    `#{command}`
    # puts command
  end
end

puts "Cleared TCC for #{count} simulators"
