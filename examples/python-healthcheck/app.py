from flask import Flask
app = Flask(__name__)

@app.get('/health')
def health():
    return 'ok', 200

@app.get('/')
def index():
    return 'Hello from Python healthcheck demo!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
