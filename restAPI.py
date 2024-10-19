from flask import Flask, jsonify, request
from flask_cors import CORS
from pymongo import MongoClient
import os
from dotenv import load_dotenv
import bcrypt

#This acesses the env file.
load_dotenv()
MONGO_URI = os.getenv("MONGO_URI")

#this access the db client and goes into the db
client = MongoClient(MONGO_URI)
db = client.get_database("sleep_app")

#this creates collections within the db to hold user info such as hashed passwords, and also sleep time. 
users_collection = db.get_collection('users')
sleep_logs_collection = db.get_collection('sleep_logs')

app = Flask(__name__)

CORS(app)


#This stores inputs into the collections into the users collection
@app.route('/register', methods=['POST'])
def register_user():
    data = request.json
    username = data['username']
    password = data['password']
    email = data['email']

    hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
    users_collection.insert_one({
        "username": username,
        "hashed_password": hashed.decode('utf-8'),
        "email": email
    })
    return jsonify({"message": "User registed successfully"}), 201

@app.route('/login', methods=['POST'])
def login_user():
    data = request.json
    username = data['username']
    password = data['password']
    
    user = users_collection.find_one({"username": username})
    if user and bcrypt.checkpw(password.encode('utf-8'), user['hashed_password'].encode('utf-8')):
        return jsonify({"message": "Login successful!"}), 200
    
    return jsonify({"message": "Invalid username or password"}), 401

#This stores data from the app when you press the button into the sleep logs collection
@app.route('/log_sleep', methods=['POST'])
def log_sleep_data():
    data = request.json
    username = data['user']
    hours_slept = data['time_slept']
    date = data['date']


    sleep_logs_collection.insert_one({
        "user": username,
        "time_slept": hours_slept,
        "date":date
    })
    return jsonify({"message": "Sleep data logged successfully!"}), 201

#get sleep logs endpoint
@app.route('/sleep_logs/<username>', methods=['GET'])
def get_sleep_logs(username):
    logs = list(sleep_logs_collection.find({"user": username}))

    for log in logs:
        log['_id'] = str(log['_id'])

    return jsonify(logs), 200



@app.route('/stats', methods=['GET'])
def display_stats():
    username = request.args.get('username')

    sleep_logs = sleep_logs_collection.find({'user': username})

    total_sleep = 0
    sleep_entries = []
    
    for log in sleep_logs:
        total_sleep += log.get('time_slept', 0)
        sleep_entries.append(log)

    num_entries = len(sleep_entries)
    avg_sleep = total_sleep / num_entries if num_entries > 0 else 0

    return jsonify({
        'total_sleep_hours': total_sleep,
        'avg_sleep_per_night': avg_sleep,
        'num_entries': num_entries
    }), 200


if __name__ == "__main__":
    #jacob's laptop app.run(debug=True, host='10.244.30.167', port=5000)
    app.run(debug=True, host='192.168.56.1', port=5000) #Thomas' laptop