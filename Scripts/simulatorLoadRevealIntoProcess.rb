# Loads Reveal Into Simulator System Processes

require 'pp'
require 'sys/proctable'
require 'tty-command'

targetBinary = "Preferences"

# sorted processes by newest first
processes = Sys::ProcTable.ps.sort { |a, b| b.pid <=> a.pid}
processes.each do |process|
  binary = process.exe
  filename = File.basename(binary)
  if binary.include?("iPhoneSimulator.sdk") == false
    next
  end
  if filename != targetBinary
    next
  end

  pid = process.pid
  scriptPath = File.join(__dir__, "loadReveal.lldb")
  puts "Injecting reveal into #{filename} PID ##{pid}"
  cmd = TTY::Command.new
  cmd.run("xcrun lldb -p #{pid} -s", scriptPath)
  puts "Injected"
  exit
end
