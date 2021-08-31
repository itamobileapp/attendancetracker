'''
Middleware Logic - Python RESTful APIs
'''

from flask import Flask
from flask_restful import Resource, Api, reqparse
import mysql.connector

# Create Flask app / api
app = Flask(__name__)
api = Api(app)


#DB_PATH = './TestDatabase/newtestdb.db'

def connectToMySQL():
    cnx = mysql.connector.connect(user='itamobileapp', password='Tamizha1!',
                                  host='ls-dc26922938a0c9a784a5fddc6297f8b91c0f9e89.cro5gvtdewyh.us-east-2.rds.amazonaws.com',
                                  database='dbitamobileapp')
    return cnx



# User Login (POST)
class UserLogin(Resource):

    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('email', location='headers', required=True)
        parser.add_argument('password', location='headers', required=True)

        args = parser.parse_args()
        email = args['email']
        password = args['password']
        match = None

        cnx = connectToMySQL()
        cursor = cnx.cursor()

        cursor.execute(f'''
        SELECT UserInfo.Email \
            FROM UserInfo \
                WHERE '{email}' = UserInfo.Email \
                    AND '{password}' = UserInfo.Password
        ''')

        match = cursor.fetchone()
        cnx.close()

        if match is None:
            return "Login Failure", 401
        else:
            return "Login Success", 200



# Retrieve Branch Info (GET)
class BranchInfo(Resource):

    def get(self):
        cnx = connectToMySQL()
        cursor = cnx.cursor()

        cursor.execute('''
        SELECT BranchInfo.BranchId, BranchInfo.BranchName \
            FROM BranchInfo
        ''')

        branches = cursor.fetchall()
        cnx.close()

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

        cnx = connectToMySQL()
        cursor = cnx.cursor()

        cursor.execute(f'''
        SELECT GradeInfo.GradeId, GradeInfo.GradeName \
            FROM GradeInfo \
                WHERE {branch_id} = GradeInfo.BranchId
        ''')

        grades = cursor.fetchall()
        cnx.close()

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

        cnx = connectToMySQL()
        cursor = cnx.cursor()

        cursor.execute(f'''
        SELECT SectionInfo.SectionId, SectionInfo.SectionName, SectionInfo.TeacherName \
            FROM SectionInfo \
                WHERE {grade_id} = SectionInfo.GradeId
        ''')

        sections = cursor.fetchall()
        cnx.close()

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

        cnx = connectToMySQL()
        cursor = cnx.cursor()

        cursor.execute(f'''
        SELECT StudentInfo.StudentId, StudentInfo.StudentName \
            FROM StudentInfo \
                WHERE {section_id} = StudentInfo.SectionId
        ''')

        students = cursor.fetchall()
        cnx.close()

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

        cnx = connectToMySQL()
        cursor = cnx.cursor()

        cursor.execute(f'''
        SELECT EntryId \
            From AttendanceInfo \
                WHERE {student_id} = AttendanceInfo.StudentId \
                    AND '{date}' = AttendanceInfo.AttendanceDate
        ''')

        match = cursor.fetchall()
        if match is None or not len(match):
            cursor.execute(f'''
            INSERT INTO AttendanceInfo (StudentId, AttendanceDate, AttendanceStatus) \
                VALUES ({student_id}, '{date}', '{status}')
            ''')
            cnx.commit()
            cnx.close()
            return "Successfully Submitted", 200
        else:
            cursor.execute(f'''
            UPDATE AttendanceInfo SET AttendanceStatus = '{status}' \
                WHERE {student_id} = AttendanceInfo.StudentId \
                    AND '{date}' = AttendanceInfo.AttendanceDate
            ''')
            cnx.commit()
            cnx.close()
            return "Successfully Updated", 200



# Add resources to API
api.add_resource(UserLogin, '/userlogin')
api.add_resource(BranchInfo, '/branchinfo')
api.add_resource(GradeInfo, '/gradeinfo')
api.add_resource(SectionInfo, '/sectioninfo')
api.add_resource(StudentInfo, '/studentinfo')
api.add_resource(SubmitAttendance, '/submitattendance')



if __name__ == '__main__':
    app.run(host='0.0.0.0')
