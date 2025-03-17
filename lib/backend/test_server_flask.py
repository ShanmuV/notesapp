from flask import Flask, request, jsonify, send_from_directory, abort
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

users = ['Sharon', 'Shanmu', 'Tharun', 'Varshan']
passwords = ['pass'] * 4

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if data.get("user") in users:
        index = users.index(data.get("user"))
        if passwords[index] == data.get("password"):
            return jsonify({"status" : "success"}), 200
    return jsonify({"status": "failed"}), 500 

@app.route('/view-pdf/<pdfid>', methods=['GET'])
def view_pdf(pdfid):
    try:
        return send_from_directory('static', f"{pdfid}.pdf")
    except:
        abort(404)

if __name__ == "__main__":
    app.run("0.0.0.0", port=5000)