import os
import socket
import time
from http.server import HTTPServer, BaseHTTPRequestHandler

APP_VERSION = os.getenv("APP_VERSION", "v1")
STARTUP_DELAY = int(os.getenv("STARTUP_DELAY", "0"))
HOSTNAME = socket.gethostname()
PORT = int(os.getenv("PORT", 8080))
START_TIME = time.time()

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        uptime = time.time() - START_TIME
        if self.path == "/health":
            if uptime < STARTUP_DELAY:
                self.send_response(503)
                self.send_header("Content-type", "application/json")
                self.end_headers()
                self.wfile.write(b'{"status": "warming_up"}\n')
            else:
                self.send_response(200)
                self.send_header("Content-type", "application/json")
                self.end_headers()
                self.wfile.write(b'{"status": "healthy"}\n')
        else:
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            response = f"Acumen-Web | Version: {APP_VERSION} | Instance: {HOSTNAME}\n"
            self.wfile.write(response.encode())

    def log_message(self, format, *args):
        return

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", PORT), SimpleHandler)
    print(f"Starting server on port {PORT}, version {APP_VERSION} (delay: {STARTUP_DELAY}s)...")
    server.serve_forever()