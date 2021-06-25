import sqlite3

# Connect to test database
connection = sqlite3.connect('./TestDatabase/testdb.db')
cursor = connection.cursor()



# User login test
def login(email, password):
    cursor.execute(f'''
    SELECT UserInfo.email FROM UserInfo WHERE '{email}' = UserInfo.email AND '{password}' = UserInfo.password 
    ''')

    match = cursor.fetchone()
    if match is None:
        return "Login Failure"
    else:
        return "Login Success"



# Retrieve branch info test
def getBranchInfo():
    cursor.execute('''
    SELECT BranchInfo.branch FROM BranchInfo
    ''')

    branches = cursor.fetchall()
    if branches is None:
        return []
    else:
        branch_list = []
        for br in branches:
            branch_list.append(br[0])
        return branch_list



# Retrieve section info test
def getSectionInfo(branch):
    cursor.execute(f'''
    SELECT SectionInfo.section FROM SectionInfo JOIN BranchInfo ON \
        '{branch}' = BranchInfo.branch AND BranchInfo.id = SectionInfo.branch_id
    ''')

    sections = cursor.fetchall()
    if sections is None:
        return []
    else:
        section_list = []
        for sect in sections:
            section_list.append(sect[0])
        return section_list



# Retrieve student info test
def getStudentInfo(branch, section):
    cursor.execute(f'''
    SELECT StudentInfo.name FROM StudentInfo JOIN SectionInfo JOIN BranchInfo ON \
        '{branch}' = BranchInfo.branch AND BranchInfo.id = StudentInfo.branch_id AND '{section}' = SectionInfo.section \
            AND SectionInfo.id = StudentInfo.section_id
    ''')

    students = cursor.fetchall()
    if students is None:
        return []
    else:
        student_list = []
        for stu in students:
            student_list.append(stu[0])
        return student_list



# Student ID function for submitting attendance
def getStudentID(branch, section, name):
    cursor.execute(f'''
    SELECT StudentInfo.id FROM StudentInfo JOIN BranchInfo JOIN SectionInfo ON '{branch}' = BranchInfo.branch \
        AND BranchInfo.id = StudentInfo.branch_id AND '{section}' = SectionInfo.section AND SectionInfo.id \
        = StudentInfo.section_id AND '{name}' = StudentInfo.name
    ''')

    result = cursor.fetchall()
    if result is None or len(result) == 0 or len(result) > 1:
        return None
    else:
        return result[0][0]



# Submit attendance test
def submitAttendance(branch, section, name, date, status):
    id = getStudentID(branch, section, name)
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
        return "Successfully updated", 200
    else:
        cursor.execute(f'''
        INSERT INTO AttendanceInfo (student_id, date_id, status) VALUES ({id}, '{date}', '{status}')
        ''')
        connection.commit()
        return "Successfully submitted", 200



# ----- Function Tests -----
# print(login("student1@gmail.com", "incorrectpassword"))
# print(getBranchInfo())
# print(getSectionInfo('Branch 1'))
# print(getStudentInfo('Branch 2', 'Grade 5'))
# print(getStudentID('Branch 1', 'Grade 4', 'Student 4'))
# print(submitAttendance('Branch 2', 'Grade 5', 'Student 3', '5/25/21', 'Tardy'))

connection.close()