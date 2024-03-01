from flask import Flask
import os
app = Flask(__name__)


@app.route("/")
def hello_world():
    host_name = os.uname().nodename
    result = f"Hello World! (server; {host_name})"
    return result

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)