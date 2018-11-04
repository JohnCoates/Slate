# from https://gist.github.com/cabeca/cbaacbeb6a1cc4683aa5
#!/usr/bin/ruby
STDOUT.sync = true

device_types_output = `xcrun simctl list devicetypes`
device_types = device_types_output.scan /(.*) \((.*)\)/

runtimes_output = `xcrun simctl list runtimes`
runtimes = runtimes_output.scan /(.*) \(.*\) \((com.apple[^)]+)\)$/

devices_output = `xcrun simctl list devices`
devices = devices_output.scan /\s\s\s\s(.*) \(([^)]+)\) (.*)/
keep = [
  "iPhone 8 Plus",
  "iPhone 8",
  "iPhone SE",
  "iPhone X",
  "iPad iOS 9",
  "iPhone 6 iOS 9",
  "iPad Air"
]
kept = [
]

devices.each do |device|
  name = device[0].strip
  if keep.include?(name) && kept.include?(name) == false
    puts "Keeping #{name}"
    kept.push(name)
    next
  end
  puts "Removing device #{device[0]} (#{device[1]})"

  `xcrun simctl delete #{device[1]}`
end


device_types.each do |device_type|
  runtimes.each do |runtime|
    name = device_type[0].strip
    if keep.include?(name) && kept.include?(name) == false
      puts "Creating #{device_type} with #{runtime}"

      command = "xcrun simctl create '#{name}' #{device_type[1]} #{runtime[1]}"
      command_output = `#{command}`
      sleep 0.5
    end
  end
end
