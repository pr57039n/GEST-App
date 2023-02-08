# Kura final project - Student management application
At the end of my journey at Kura. I worked on improving and deploying this application with my fellow collaborators. 
The concept, and idea of the deployment was to successfully deploy an application with a live database in the cloud; and then eventually make improvements to the website. It was created using Django as a base.

## Features of this Project

### A. Admin Users Can
1. See Overall Summary Charts of Students Performances, Staff Performances, Courses, Subjects, Leave, etc.
2. Manage Staff (Add, Update and Delete)
3. Manage Students (Add, Update and Delete)
4. Manage Course (Add, Update and Delete)
5. Manage Subjects (Add, Update and Delete)
6. Manage Sessions (Add, Update and Delete)
7. View Student Attendance
8. Review and Reply Student/Staff Feedback
9. Review (Approve/Reject) Student/Staff Leave

### B. Staff/Teachers Can
1. See the Overall Summary Charts related to their students, their subjects, leave status, etc.
2. Take/Update Students Attendance
3. Add/Update Result
4. Apply for Leave
5. Send Feedback to HOD

### C. Students Can
1. See the Overall Summary Charts related to their attendance, their subjects, leave status, etc.
2. View Attendance
3. View Result
4. Apply for Leave
5. Send Feedback to HOD

#### Difficulties that were encountered during the project.

Handling secrets during a deployment. In order to use Jenkins and keep the database username and password safe for the database connection. We would have needed to utilize github; or amazon secrets to provide to the application before containerizing it with Docker. Otherwise the database would not be accessible to the application.

Deployment speed. We attempted to deconstruct what aspects needed to be deployed continually, and which could be removed between stages. Without keeping the base infrastructure the deployment time took as long as 15-20 minutes. After keeping the base VPC persistent; the deployment speed lowered to approximately 5-7 minutes. However I believe this time can still be lowered.

Chef. During our discussions, we wanted to use Chef initially, but those discussions never truly went anywhere due to the time constraint. I believe that with Chef I think controlling some of the nodes and servers would have been easier. Which leads into the next difficulty.

Staging environment. With the configuration in the repository, our staging environment first never ran; and then when it did - we suffered numerous bad gateway errors. This is of course a problem because the staging environment in this deployment serves to be a way for a developer to test and ensure that the application that was created earlier in the pipeline actually runs and works. Strangely, when we sent the container through ECS, it worked fine. Definitely need to find a fix for this.
