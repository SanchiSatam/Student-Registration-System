<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Class</title>
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
        
        <form action="addClass" method="post" class="form">
            <h2 class = "enterval_formtitle">Add a class</h2>
            <label for="classId">Class ID:</label>
            <input type="text" id="classId" name="classId" required><br><br>
            
            <label for="departmentCode">Department Code:</label>
            <input type="text" id="departmentCode" name="departmentCode"><br><br>
            
            <label for="courseNumber">Course Number:</label>
            <input type="number" id="courseNumber" name="courseNumber" required min="100" max="799"><br><br>
            
            <label for="sectionNumber">Section Number:</label>
            <input type="number" id="sectionNumber" name="sectionNumber" required min="1" max="99"><br><br>
            
            <label for="year">Year:</label>
            <input type="number" id="year" name="year" required><br><br>
            
            <label for="semester">Semester:</label>
            <input type="text" id="semester" name="semester" required><br><br>
            
            <label for="limit">Limit:</label>
            <input type="number" id="limit" name="limit" required min="1" max="999"><br><br>
            
            <label for="classSize">Class Size:</label>
            <input type="number" id="classSize" name="classSize" required min="1" max="999"><br><br>
            
            <label for="room">Room:</label>
            <input type="text" id="room" name="room"><br><br>
            
            <input type="submit" value="Add Class">

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

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
