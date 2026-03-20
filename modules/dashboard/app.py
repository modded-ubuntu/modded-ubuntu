from flask import Flask, jsonify
import subprocess
import os

app = Flask(__name__)

@app.route('/')
def index():
    return "Ubuntu Termux Manager Dashboard Running. Use /status, /modules, or /logs"

@app.route('/status')
def status():
    # Placeholder for actual status
    return jsonify({"status": "running", "cpu": "12%", "ram": "25%"})

@app.route('/modules')
def modules():
    return jsonify({"modules": ["gui", "dev", "security", "dashboard"]})

@app.route('/logs')
def logs():
    if os.path.exists('../../logs/system.log'):
        with open('../../logs/system.log', 'r') as f:
            return jsonify({"logs": f.read().splitlines()[-10:]})
    return jsonify({"logs": []})

@app.route('/marketplace')
def marketplace():
    modules_list = []
    modules_path = '../../modules'
    if os.path.exists(modules_path):
        for d in os.listdir(modules_path):
            if os.path.exists(os.path.join(modules_path, d, 'meta.json')):
                with open(os.path.join(modules_path, d, 'meta.json'), 'r') as f:
                    import json
                    try:
                        meta = json.load(f)
                        modules_list.append(meta)
                    except:
                        pass
    # simple HTML view
    html = "<h1>Ubuntu Termux Manager Marketplace</h1><ul>"
    for m in modules_list:
        html += f"<li><b>{m.get('name', 'Unknown')}</b> v{m.get('version', '1.0')} - {m.get('description', 'No description')}</li>"
    html += "</ul><p>Use the CLI to install these modules or click to explore more features!</p>"
    return html

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080)
