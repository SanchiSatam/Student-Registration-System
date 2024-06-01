<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Course</title>
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
        <div class="form-container">
        <form action="addCourse" method="post" class="form">
            <h2 class = "enterval_formtitle">Add a course</h2>
            <label for="deptCode">Department Code:</label>
            <input type="text" id="deptCode" name="deptCode" required><br><br>
            
            <label for="courseNumber">Course Number:</label>
            <input type="number" id="courseNumber" name="courseNumber" required min="100" max="799"><br><br>
            
            <label for="title">Course Title:</label>
            <input type="text" id="title" name="title" required><br><br>
            
            <input type="submit" value="Add Course">

            <c:if test="${not empty outputMessages}">
                <ul>
                    <c:forEach var="message" items="${outputMessages}">
                        <li><c:out value="${message}"/></li>
                    </c:forEach>
                </ul>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <p><c:out value="${errorMessage}"/></p>
            </c:if>            
        </form>
    </div>        
    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
