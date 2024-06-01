<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Class</title>
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

    <div class="form-container">
    <form action="deleteClass" method="post" class="form">
        <h2 class = "enterval_formtitle">Delete a Class</h2>
        <label for="classId">Class ID:</label>
        <input type="text" id="classId" name="classId" required><br><br>
        
        <input type="submit" value="Delete Class">

        <%-- Display output messages --%>
        <c:if test="${not empty outputMessages}">
            <c:forEach var="message" items="${outputMessages}">
                <p>${message}</p>
            </c:forEach>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <p>${errorMessage}</p>
        </c:if>        
    </form>
</div>

    
    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
    
</body>
</html>
