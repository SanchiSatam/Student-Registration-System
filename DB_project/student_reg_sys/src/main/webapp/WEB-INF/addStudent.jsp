<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student</title>
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
        <form action="/addStudent" method="post" class="form">
            <h2 class = "enterval_formtitle">Add a student</h2>
            <label for="bNumber">B#:</label>
            <input type="text" id="bNumber" name="bNumber" required><br><br>
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" required><br><br>
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" required><br><br>
            <label for="studentLevel">Student Level:</label>
            <select id="studentLevel" name="studentLevel" required>
                <option value="freshman">Freshman</option>
                <option value="sophomore">Sophomore</option>
                <option value="junior">Junior</option>
                <option value="senior">Senior</option>
                <option value="master">Master</option>
                <option value="PhD">PhD</option>
            </select><br><br>
            <label for="gpa">GPA:</label>
            <input type="number" id="gpa" name="gpa" min="0" max="4" step="0.01" required><br><br>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br><br>
            <label for="birthDate">Birth Date (DD-MMM-YY):</label>
            <input type="text" id="birthDate" name="birthDate" placeholder="e.g., 17-JAN-94" required><br><br>
            <input type="submit" value="Submit">
            <c:if test="${not empty errorMessage}">
                <p style="color: red;">${errorMessage}</p>
            </c:if>
            <c:if test="${not empty outputMessages}">
                <ul>
                    <c:forEach var="message" items="${outputMessages}">
                        <li><c:out value="${message}"/></li>
                    </c:forEach>
                </ul>
            </c:if>            
        </form>

    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
