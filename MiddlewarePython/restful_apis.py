'''
Middleware Logic - Python RESTful APIs
'''

from flask import Flask
from flask_restful import Resource, Api, reqparse
import sqlite3

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

        if branches is None or not len(branches):
            return [], 404
        else:
            branch_list = []
            for br in branches:
                branch_list.append(br[0])
            return branch_list, 200



# Retrieve Section Info (GET)
class SectionInfo(Resource):
    
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('branch', required=True)

        args = parser.parse_args()
        branch = args['branch']

        connection = sqlite3.connect('./TestDatabase/testdb.db')
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT SectionInfo.section FROM SectionInfo JOIN BranchInfo ON \
            '{branch}' = BranchInfo.branch AND BranchInfo.id = SectionInfo.branch_id
        ''')

        sections = cursor.fetchall()
        connection.close()

        if sections is None or not len(sections):
            return [], 404
        else:
            section_list = []
            for sect in sections:
                section_list.append(sect[0])
            return section_list, 200        



# Retrieve Student Info (GET)
class StudentInfo(Resource):

    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('branch', required=True)
        parser.add_argument('section', required=True)

        args = parser.parse_args()
        branch = args['branch']
        section = args['section']

        connection = sqlite3.connect('./TestDatabase/testdb.db')
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT StudentInfo.name FROM StudentInfo JOIN SectionInfo JOIN BranchInfo ON \
            '{branch}' = BranchInfo.branch AND BranchInfo.id = StudentInfo.branch_id AND '{section}' = SectionInfo.section \
                AND SectionInfo.id = StudentInfo.section_id
        ''')

        students = cursor.fetchall()
        connection.close()

        if students is None or not len(students):
            return [], 404
        else:
            student_list = []
            for stu in students:
                student_list.append(stu[0])
            return student_list, 200



# Submit Attendance Info (POST)
class SubmitAttendance(Resource):

    # Student ID function for submitting attendance
    def getStudentID(self, branch, section, name):
        connection = sqlite3.connect('./TestDatabase/testdb.db')
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT StudentInfo.id FROM StudentInfo JOIN BranchInfo JOIN SectionInfo ON '{branch}' = BranchInfo.branch \
            AND BranchInfo.id = StudentInfo.branch_id AND '{section}' = SectionInfo.section AND SectionInfo.id \
            = StudentInfo.section_id AND '{name}' = StudentInfo.name
        ''')

        result = cursor.fetchall()
        connection.close()

        if result is None or len(result) == 0 or len(result) > 1:
            return None
        else:
            return result[0][0]

    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('branch', required=True)
        parser.add_argument('section', required=True)
        parser.add_argument('name', required=True)
        parser.add_argument('date', required=True)
        parser.add_argument('status', required=True)

        args = parser.parse_args()
        branch = args['branch']
        section = args['section']
        name = args['name']
        date = args['date']
        status = args['status']

        connection = sqlite3.connect('./TestDatabase/testdb.db')
        cursor = connection.cursor()

        id = self.getStudentID(branch, section, name)
        if id is None:
            return "Failed to submit", 404

        cursor.execute(f'''
        SELECT AttendanceInfo.student_id FROM AttendanceInfo WHERE {id} = AttendanceInfo.student_id AND \
            '{date}' = AttendanceInfo.date_id
        ''')

        if len(cursor.fetchall()):
            cursor.execute(f'''
            UPDATE AttendanceInfo SET status = '{status}' \
                WHERE {id} = AttendanceInfo.student_id AND '{date}' = AttendanceInfo.date_id
            ''')
            connection.commit()
            connection.close()
            return "Successfully updated", 200
        else:
            cursor.execute(f'''
            INSERT INTO AttendanceInfo (student_id, date_id, status) VALUES ({id}, '{date}', '{status}')
            ''')
            connection.commit()
            connection.close()
            return "Successfully submitted", 200



# Add resources to API
api.add_resource(UserLogin, '/userlogin')
api.add_resource(BranchInfo, '/branchinfo')
api.add_resource(SectionInfo, '/sectioninfo')
api.add_resource(StudentInfo, '/studentinfo')
api.add_resource(SubmitAttendance, '/submitattendance')



if __name__ == '__main__':
    app.run()