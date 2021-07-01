'''
Middleware Logic - Python RESTful APIs
'''

from sqlite3 import dbapi2
from flask import Flask
from flask_restful import Resource, Api, reqparse
import sqlite3

# Create Flask app / api
app = Flask(__name__)
api = Api(app)

DB_PATH = './TestDatabase/newtestdb.db'



# User Login (POST)
class UserLogin(Resource):

    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('email', location='headers', required=True)
        parser.add_argument('password', location='headers', required=True)

        args = parser.parse_args()
        email = args['email']
        password = args['password']

        connection = sqlite3.connect(DB_PATH)
        cursor = connection.cursor()
    
        cursor.execute(f'''
        SELECT UserInfo.Email \
            FROM UserInfo \
                WHERE '{email}' = UserInfo.Email \
                    AND '{password}' = UserInfo.Password 
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
        connection = sqlite3.connect(DB_PATH)
        cursor = connection.cursor()

        cursor.execute('''
        SELECT BranchInfo.BranchId, BranchInfo.BranchName \
            FROM BranchInfo
        ''')

        branches = cursor.fetchall()
        connection.close()

        if branches is None or not len(branches):
            return {}, 404
        else:
            branch_dict = {}
            for id, branch in branches:
                branch_dict[id] = branch
            return branch_dict, 200



# Retrieve Grade Info (GET)
class GradeInfo(Resource):
    
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('branchId', location='headers', required=True)

        args = parser.parse_args()
        branch_id = int(args['branchId'])

        connection = sqlite3.connect(DB_PATH)
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT GradeInfo.GradeId, GradeInfo.GradeName \
            FROM GradeInfo \
                WHERE {branch_id} = GradeInfo.BranchId
        ''')

        grades = cursor.fetchall()
        connection.close()

        if grades is None or not len(grades):
            return {}, 404
        else:
            grade_dict = {}
            for id, grade in grades:
                grade_dict[id] = grade
            return grade_dict, 200        



# Retrieve Section Info (GET)
class SectionInfo(Resource):
    
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('gradeId', location='headers', required=True)

        args = parser.parse_args()
        grade_id = int(args['gradeId'])

        connection = sqlite3.connect(DB_PATH)
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT SectionInfo.SectionId, SectionInfo.SectionName, SectionInfo.TeacherName \
            FROM SectionInfo \
                WHERE {grade_id} = SectionInfo.GradeId
        ''')

        sections = cursor.fetchall()
        connection.close()

        if sections is None or not len(sections):
            return {}, 404
        else:
            section_dict = {}
            for id, section, teacher in sections:
                section_dict[id] = [section, teacher]
            return section_dict, 200



# Retrieve Student Info (GET)
class StudentInfo(Resource):

    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('sectionId', location='headers', required=True)

        args = parser.parse_args()
        section_id = int(args['sectionId'])

        connection = sqlite3.connect(DB_PATH)
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT StudentInfo.StudentId, StudentInfo.StudentName \
            FROM StudentInfo \
                WHERE {section_id} = StudentInfo.SectionId
        ''')

        students = cursor.fetchall()
        connection.close()

        if students is None or not len(students):
            return {}, 404
        else:
            student_dict = {}
            for id, student in students:
                student_dict[id] = student
            return student_dict, 200



# Submit Attendance Info (POST)
class SubmitAttendance(Resource):

    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('studentId', location='headers', required=True)
        parser.add_argument('date', location='headers', required=True)
        parser.add_argument('status', location='headers', required=True)

        args = parser.parse_args()
        student_id = int(args['studentId'])
        date = args['date']
        status = args['status']

        connection = sqlite3.connect(DB_PATH)
        cursor = connection.cursor()

        cursor.execute(f'''
        SELECT EntryId \
            From AttendanceInfo \
                WHERE {student_id} = AttendanceInfo.StudentId \
                    AND '{date}' = AttendanceInfo.Date
        ''')

        match = cursor.fetchall()
        if match is None or not len(match):
            cursor.execute(f'''
            INSERT INTO AttendanceInfo (StudentId, Date, Status) \
                VALUES ({student_id}, '{date}', '{status}')
            ''')
            connection.commit()
            connection.close()
            return "Successfully Submitted", 200
        else:
            cursor.execute(f'''
            UPDATE AttendanceInfo SET Status = '{status}' \
                WHERE {student_id} = AttendanceInfo.StudentId \
                    AND '{date}' = AttendanceInfo.Date
            ''')
            connection.commit()
            connection.close()
            return "Successfully Updated", 200



# Add resources to API
api.add_resource(UserLogin, '/userlogin')
api.add_resource(BranchInfo, '/branchinfo')
api.add_resource(GradeInfo, '/gradeinfo')
api.add_resource(SectionInfo, '/sectioninfo')
api.add_resource(StudentInfo, '/studentinfo')
api.add_resource(SubmitAttendance, '/submitattendance')



if __name__ == '__main__':
    app.run()