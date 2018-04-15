import socket

send = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
send.connect(("localhost", 9845))
send.send("{ \"x\": 1.2, \"y\": 0, \"z\": 1.2, \"w\": 0}")
send.close()
