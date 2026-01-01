from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask in a Docker container!"

if __name__ == "__main__":
    # Listen on all interfaces (0.0.0.0) and port 5000
    app.run(host='0.0.0.0', port=5000)
