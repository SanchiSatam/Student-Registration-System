<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bing Student Registration System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <div class="header-content">
            <h1>Bing Student Registration System</h1>
            <a href="/">
                <img src="homepg.png" alt="Homepage Icon" class="homepage-icon">
            </a>
        </div>
    </header>

    <div class="main-content">
        <div class="hp-container-1">
            <div class="section classes">
                <h2>Classes</h2>
                <a href="/show_classes" class="button">Show Class</a>
                <a href="/enroll_student" class="button">Enroll Student</a>
                <a href="/students_in_class" class="button">View Student</a>
                <a href="/drop_grad_student" class="button">Drop G_Student</a>
                <a href="/prerequisites" class="button">View Prerequisite</a>
                <a href="/addClass" class="button">Add Class</a>
                <a href="/deleteClass" class="button" id="delete-button">Delete Class</a>
            </div>
            <div class="section course">
                <h2>Course</h2>
                <a href="/showCourses" class="button">Show Course</a>
                <a href="/showCourseCredit" class="button">Show Course Credits</a>
                <a href="/showPrerequisites" class="button">Show Prerequisite</a>
                <a href="/showScoreGrade" class="button">Show Score Grade</a>
                <a href="/addCourse" class="button">Add Course</a>
                <a href="/deleteCourse" class="button" id="delete-button">Delete Course</a>
            </div>
            <div class="section student">
                <h2>Student</h2>
                <a href="showStudents" class="button">Show Students</a>
                <a href="/showEnrollments" class="button">Show G_Enrollment</a>
                <a href="/addStudent" class="button">Add Student</a>
                <a href="/delete_student" class="button" id="delete-button">Delete Student</a>
            </div>
            <div class="section logs">
                <h2>Logs</h2>
                <a href="/showLogs" class="button">Show Logs</a>
            </div>
        </div>
    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>

