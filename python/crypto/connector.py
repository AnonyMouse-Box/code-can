#!/usr/bin/env python3


# connector.py - This script is used to connect to a network service port.
# Usage: should be called from extractor.py
import socket, json

file = ""

def write_file(data):
    global file
    with open(file, 'a') as f:
        f.write(data)
    print(data)
    return

def read_data(sock):
    data = b''
    while True:
        data += sock.recv(4096)
        if len(data) == 0:
            break
    write_file('data', data)
    return data

def send_data(sock, data):
    write_file(data)
    sock.sendall(data)
    return

def json_recv(sock):
    data = read_data(sock)
    return json.loads(data)

def json_send(sock, data):
    send_data(sock, json.dumps(data).encode())
    return

def connect(host, port, output_file):
    global file 
    file = output_file
    open(file, 'w').close()
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    s.setblocking(0)
    try:
        
        # Edit here
        data = read_data(s)

    except BlockingIOError:
        data = "No data available"
        pass
    finally:
        s.close()
        print(f"final: {data}")
        return
