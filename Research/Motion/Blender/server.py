# Run the server with this Blender code:
# import bpy
# import os
#
# filename = os.path.join(os.path.dirname(bpy.data.filepath), "Blender Plugins/server.py")
# exec(compile(open(filename).read(), filename, 'exec'))  #

import socket
import select
import json
import threading
import traceback

class ServerThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.running = True

    def stopServer(self):
        self.running = False
        self.server.running = False

    def run(self):
        try:
            self.server = Server()
            while self.running:
                self.server.receive()
        except:
            pass


class Server:
    def __init__(self):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.socket.setblocking(False)
        self.socket.bind((str(socket.INADDR_ANY), 9845))
        self.socket.listen(2)
        self.running = True

    def __exit__(self, exc_type, exc_value, traceback):
        self.socket.close()

    def receive(self):
        pairs = []
        timeout = 1
        while self.running:
            sockets = list(map(lambda x: x[0], pairs))
            if len(pairs) > 0:
                read_sockets, write_sockets, error_sockets = select.select(sockets, [], [], timeout)
                for sock in read_sockets:
                  data = sock.recv(4096)
                  if not data :
                    print('Client disconnected')
                    pairs = []
                  else :
                     self.connectionReceivedData(connection, data.decode())
            try:
                try:
                    connection,address = self.socket.accept()
                    print("new connection: ", connection)
                    pairs.append((connection, address))
                except:
                    pass

            except:
                pass

        for pair in pairs:
            (connection, address) = pair
            connection.close()

    def connectionReceivedData(self, connection, data):
        try:
            motionData = json.loads(data)
        except json.decoder.JSONDecodeError:
            print("Invalid JSON: ", data)
            return None
        receivedMotionData(motionData)

# This is a global so when we run the script again, we can keep the server alive
# but change how it works
import bpy
def receivedMotionData(motionData):
    phone = bpy.context.scene.objects["iPhone"]
    phone.rotation_quaternion.x = float(motionData['x'])
    phone.rotation_quaternion.y = 0 - float(motionData['z'])
    phone.rotation_quaternion.z = float(motionData['y'])
    phone.rotation_quaternion.w = float(motionData['w'])
    pass

try:
    if serverThread.running == False:
        serverThread = ServerThread()
        serverThread.start()
        print("Starting server")
    else:
        print("Server already running, using new motion handler.")
except:
    serverThread = ServerThread()
    serverThread.start()
    print("Starting server")
