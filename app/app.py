from flask import Flask, jsonify
import datetime

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <html>
    <head><title>DevOps Practice App</title></head>
    <body style="font-family: Arial; text-align: center; padding: 50px; background: #f0f4f8;">
        <h1>🚀 DevOps Practice App</h1>
        <p>Flask app running inside Docker on AWS EC2</p>
        <p>Deployed via Jenkins CI/CD Pipeline</p>
        <p style="color: green;">✅ App is healthy and running!</p>
    </body>
    </html>
    """

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.datetime.utcnow().isoformat(),
        "app": "devops-practice-app",
        "version": "1.0.0"
    })

@app.route("/info")
def info():
    return jsonify({
        "message": "DevOps Practice Project",
        "stack": ["Python Flask", "Docker", "Terraform", "Ansible", "Jenkins", "Prometheus", "Grafana"],
        "cloud": "AWS EC2"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
