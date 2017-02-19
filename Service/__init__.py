#!/usr/bin/env python3
import os, socket, json, sqlite3
from flask import Flask, request

app = Flask(__name__)
new_data = "default"

@app.route('/', methods=['GET', 'POST'])
def index():
    global new_data
    if(request.method == 'POST'):
        new_data = request.data
        print(new_data)
        return r'got'
    if(request.method == 'GET'):
        return new_data

@app.route('/api/history')
def history():
    conn = sqlite3.connect('testDB.db')
    cursor = conn.execute("SELECT * from dataTB")
    data = []
    for row in cursor:
        data.append({})
        data[-1]["deviceId"] = row[0]
        data[-1]["temp"] = row[1]
        data[-1]["flame"] = row[2]
        data[-1]["gas"] = row[3]
        data[-1]["timeStamp"] = row[4]
        data[-1]["sound"] = row[5]
        data[-1]["level"] = row[6]
    conn.close()
    data = json.dumps(data)
    return data

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
