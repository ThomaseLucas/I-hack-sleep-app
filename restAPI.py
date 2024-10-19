from flask import Flask, jsonify, request
from pymongo import MongoClient
import os
from dotenv import load_dotenv
import bcrypt

#This acesses the env file.
load_dotenv()
mongo_uri = os.getenv("mongo_uri")

#this access the db client and goes into the db
client = MongoClient(mongo_uri)
db = client['sleep_app']

#this creates collections within the db to hold user info such as hashed passwords, and also sleep time. 
users_collection = db['users']
sleep_logs_collection = db['sleep_logs']

app = Flask(__name__)


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
    return jsonify({"message": "User registed successfully"})

@app.route('/login', methods=['POST'])
def login_user():
    data = request.json
    username = data['username']
    password = data['password']
    
    user = users_collection.find_one({"username": username})
    if user and bcrypt.checkpw(password.encode('utf-8'), user['hashed_password'].encode('utf-8')):
        return jsonify({"message": "Login successful!"}), 200
    
    return jsonify({"message":})

#This stores data from the app when you press the button into the sleep logs collection
@app.route('/log_sleep', methods=['POST'])
def log_sleep_data(username, hours_slept, date):
    sleep_logs_collection({
        "user": username,
        "hours_slept": hours_slept,
        "date":date
    })
    return jsonify({"message"}: "Sleep data logged successfully!"), 201

@app.route('/sleep_logs/<username>', methods=['GET'])
def get_user(username):
    return users_collection.find_one({"username": username})


def get_sleep_logs(username):
    return list(sleep_logs_collection.find({"user": username}))