#!/usr/bin.env python3


# extractor.py - This script is used to extract data from a network service port.
# Usage: extractor.py -a <address> [-p <port>] [-w] [-d <dir>] [-s] [-f <file>]

def http_req(host, port, dir, ssl):
    import requests
    protocol = 'https' if ssl else 'http'
    response = requests.get(f"{protocol}://{host}:{port}{dir}")
    data = response.text
    return data

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='A selection of tools to extract and convert data.')
    parser.add_argument('-a', '--address', help='The address to send the request to.', required=True, type=str)
    parser.add_argument('-p', '--port', help='The port to send the request to.', default=80, type=int)
    parser.add_argument('-w', '--web', help='Send a request to a web server.', default=False, action='store_true')
    parser.add_argument('-d', '--dir', help='The directory to request to.', default='/', type=str)
    parser.add_argument('-s', '--ssl', help='Use SSL.', default=False, action='store_true')
    parser.add_argument('-f', '--file', help='The file to write the data to.', default='data', type=str)
    args = parser.parse_args()

    if args.web:
        data = http_req(args.address, args.port, args.dir, args.ssl)
        with open(args.file, 'w') as f:
            f.write(data)
    else:
        import connector
        try:
            connector.connect(args.address, args.port, args.file)
        except KeyboardInterrupt:
            print("Interrupted")
        finally:
            print("Exiting...")
