'''
Middleware Logic - Python RESTful APIs
'''

from flask import Flask
from flask_restful import Resource, Api, reqparse
import sqlite3
import ast

# Create Flask app / api
app = Flask(__name__)
api = Api(app)



# User Login (POST)
class UserLogin(Resource):

    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('email', required=True)
        parser.add_argument('password', required=True)

        args = parser.parse_args()
        email = args['email']
        password = args['password']

        connection = sqlite3.connect('./TestDatabase/testdb.db')
        cursor = connection.cursor()
    
        cursor.execute(f'''
        SELECT UserInfo.email FROM UserInfo WHERE '{email}' = UserInfo.email AND '{password}' = UserInfo.password 
        ''')

        match = cursor.fetchone()
        connection.close()

        if match is None:
            return "Login Failure", 401
        else:
            return "Login Success", 200



# Retrieve Branch Info (GET)
class BranchInfo(Resource):

    def get(self):
        connection = sqlite3.connect('./TestDatabase/testdb.db')
        cursor = connection.cursor()

        cursor.execute('''
        SELECT BranchInfo.branch FROM BranchInfo
        ''')

        branches = cursor.fetchall()
        connection.close()

        if branches is None:
            return [], 404
        else:
            branch_list = []
            for br in branches:
                branch_list.append(br[0])
            return branch_list, 200



# Retrieve Section Info (GET)
class SectionInfo(Resource):
    
    def get(self):
        pass



# Retrieve Student Info (GET)
class StudentInfo(Resource):

    def get(self):
        pass



# Submit Attendance Info (POST)
class SubmitAttendance(Resource):

    def post(self):
        pass



# Add resources to API
api.add_resource(UserLogin, '/userlogin')
api.add_resource(BranchInfo, '/branchinfo')
api.add_resource(SectionInfo, '/sectioninfo')
api.add_resource(StudentInfo, '/studentinfo')
api.add_resource(SubmitAttendance, '/submitattendance')



if __name__ == '__main__':
    app.run()