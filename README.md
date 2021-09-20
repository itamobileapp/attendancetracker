# AttendanceTracker

AttendanceTracker is an iOS based mobile application used to track attendance for students attending weekend classes.

It uses Swift in the frontend, Python for the service layer and MySQL RDS in the backend.

## SwiftMobile

SwiftMobile is the directory that contains the Swift UI, controller and plist files. The version used is Swift 4.

XCode version 12 is required.

[Here](https://www.donnywals.com/appropriately-using-dispatchqueue-main/) is a good article on understanding DispatchQueue

## Python

The middleware code uses Python and runs as a Flask App in an AWS LightSail container.

[Here](https://www.awsgeek.com/How-To-Serve-a-Flask-App-with-Amazon-Lightsail-Containers/) is a good reference article on LightSail for Flask applications

### LightSail

#### Prerequisites

1. [Install Docker](https://docs.docker.com/engine/install/)
2. [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
3. [Install LightSail Control Plugin](https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-install-software)
4. [Install MySQL Workbench](https://dev.mysql.com/downloads/workbench/)
5. Install Flask on your local machine using the command `pip install flask`
6. Install Restful Flask on your local machine using the command `pip install flask_restful`
7. Install MySQL connector on your local machine using the command `pip install mysql_connector`

### Build

There are three modes to consider when building the source code

#### Local Mode

1. Navigate to the sub-directory named `Python`
2. Run the Flask app on the localhost as the first step using the command `FLASK_APP=restful_apis.py flask run`
3. This should start a web server on the terminal window with the default port of 5000 used by Flask
4. You should be able to navigate to `http://localhost:5000/branchinfo` and view the results from the database

#### Docker Mode

1. Build the Docker image from the file named `DockerFile` by using the command `docker build -t itamobileapp:v1 .`
2. Verify the creation of the image using the command `docker images --filter reference=itamobileapp`. This should provide information about the image created.
3. Run an instance of the container from the image created using the command `docker container run -d -p 8083:5000 --name itamobileapp itamobileapp:v1`
4. Verify the creation and running of the container. Note that the local port of `8083` is mapped to the container port of `5000`
5. Get the details of the container using the command `docker container ls -a` (optional)
6. Remove the container created using the command `docker container rm itamobileapp --force` (optional)
7. You should be able to navigate to `http://localhost:8083/branchinfo` and view the results from the database

#### LightSail

There is no need to perform any of these steps for the itamobileapp project. This is for information only.

1. Create a Lightsail container service using the command `aws lightsail create-container-service --service-name itamobileapp --power small --scale 1`
2. Monitor the status of the container service creation by using the following command `aws lightsail get-container-services --service-name itamobileapp`
3. Wait until the status is "ACTIVE"
4. Login into LightSail using the link [here] (https://lightsail.aws.amazon.com/ls/webapp/home/databases) and create a new database
5. Create a new MySQL database and set the master user name and password
6. Push the container image using the command `aws lightsail push-container-image --region us-east-2 --service-name itamobileapp --label itamobileapp --image itamobileapp:v1`
7. Create a new file `containers.json` with the following lines (Note that the value for `image` in the code below is the same as what is returned in the previous step)
        {
            "itamobileapp": {
                "image": ":itamobileapp.itamobileapp:1",
                "ports": {
                    "5000": "HTTP"
                }
            }
        }
8. Create a new file `public-endpoint.json`
        {
            "containerName":"itamobileapp",
            "containerPort":5000
        }
9. Deploy the container using the following command `aws lightsail create-container-service-deployment --service-name itamobileapp --containers file://containers.json --public-endpoint file://public-endpoint.json`
10. Monitor the state of the container service using the following command `aws lightsail get-container-services --service-name itamobileapp`
11. Wait until the state of the service changes to "RUNNING"
12. Get the `url` value from the above command and launch the URL to access the service

##### Note

Every time, the docker image is updated, you will have to repeat step 6 that pushes the container image and steps 9 and 10 that deploy and monitor the container image.


### MySQL database

1. Login to the MySQL database created using the client MySQL Workbench
2. The database endpoint, port number, user name and password are available [here] (https://lightsail.aws.amazon.com/ls/webapp/home/databases)
3. Establish a new connection in MySQL Workbench using the information above
4. Run the following commands to seed the database

        use dbitamobileapp;
        insert into UserInfo (email,password) values ('officer1@gmail.com','officer123');
        insert into UserInfo (email,password) values ('officer2@gmail.com','officer234');
        insert into UserInfo (email,password) values ('officer3@gmail.com','officer345');

        insert into BranchInfo (BranchName) values ('Evergreen');
        insert into BranchInfo (BranchName) values ('Cupertino');
        insert into BranchInfo (BranchName) values ('Pleasanton');
        insert into BranchInfo (BranchName) values ('San Ramon');
        insert into BranchInfo (BranchName) values ('Fremont-Central');

        insert into GradeInfo (BranchId, GradeName) values (1, 'Preschool');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 1');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 2');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 3');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 4');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 5');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 6');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 7');
        insert into GradeInfo (BranchId, GradeName) values (1, 'Grade 8');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Preschool');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 1');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 2');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 3');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 4');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 5');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 6');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 7');
        insert into GradeInfo (BranchId, GradeName) values (2, 'Grade 8');

        insert into SectionInfo (GradeId, SectionName, TeacherName) values (1, 'Section A','Nagammai Ramiah');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (2, 'Section A','Sumathi Padmanabhan');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (2, 'Section B','Ganesh Raman');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (3, 'Section A','Vinothini Arunachalam');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (3, 'Section B','Rajani Sankarappan');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (11, 'Section A','Dhanashanthi Durairaju');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (11, 'Section B','Karthick Annamalai');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (12, 'Section A','Latha Muthukumar');
        insert into SectionInfo (GradeId, SectionName, TeacherName) values (12, 'Section B','Geethapriya Thiagarajan');

        insert into StudentInfo (SectionId, StudentName) values (1, 'Krishnan Kumar');
        insert into StudentInfo (SectionId, StudentName) values (1, 'Ahswini Ponnuswamy');
        insert into StudentInfo (SectionId, StudentName) values (1, 'Mary Arul');
        insert into StudentInfo (SectionId, StudentName) values (1, 'Shravan Kathirvel');

        insert into StudentInfo (SectionId, StudentName) values (2, 'Thirumalai Thangavel');
        insert into StudentInfo (SectionId, StudentName) values (2, 'Praveen Kumaresh');
        insert into StudentInfo (SectionId, StudentName) values (2, 'Mohammad Nazir');
        insert into StudentInfo (SectionId, StudentName) values (2, 'Sirin Siva');

        insert into StudentInfo (SectionId, StudentName) values (3, 'Suhasini Kannan');
        insert into StudentInfo (SectionId, StudentName) values (3, 'Krithiwas Neelakantan');
        insert into StudentInfo (SectionId, StudentName) values (3, 'Novex Alex');
        insert into StudentInfo (SectionId, StudentName) values (3, 'Murali Gowrisankar');

        insert into StudentInfo (SectionId, StudentName) values (4, 'Krishna Goplan');
        insert into StudentInfo (SectionId, StudentName) values (4, 'Pannerselvam Duraiswamy');
        insert into StudentInfo (SectionId, StudentName) values (4, 'Justin Baker');
        insert into StudentInfo (SectionId, StudentName) values (4, 'Ranjani Gayatri');

        insert into StudentInfo (SectionId, StudentName) values (6, 'Sheikh Mohammad');
        insert into StudentInfo (SectionId, StudentName) values (6, 'Satish Thirumalai');
        insert into StudentInfo (SectionId, StudentName) values (6, 'Poongodi Muthukumar');
        insert into StudentInfo (SectionId, StudentName) values (6, 'Vani Kumar');

        insert into StudentInfo (SectionId, StudentName) values (7, 'Pranesh Kumar');
        insert into StudentInfo (SectionId, StudentName) values (7, 'Pazhani Murthy');
        insert into StudentInfo (SectionId, StudentName) values (7, 'James Martin');
        insert into StudentInfo (SectionId, StudentName) values (7, 'Arulmozhi Krishnan');

        insert into StudentInfo (SectionId, StudentName) values (8, 'Guna Krishnamoorthy');
        insert into StudentInfo (SectionId, StudentName) values (8, 'Meera Srinivasan');
        insert into StudentInfo (SectionId, StudentName) values (8, 'Aparna Govind');
        insert into StudentInfo (SectionId, StudentName) values (8, 'Vyas Rajesh');

        select * from UserInfo;
        select * from BranchInfo;
        select * from GradeInfo;
        select * from SectionInfo;
        select * from StudentInfo;
