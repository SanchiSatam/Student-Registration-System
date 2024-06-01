<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Course</title>
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
    <form action="deleteCourse" method="post" class="form">
        <h2 class = "enterval_formtitle">Delete a course</h2>
        <label for="deptCode">Department Code:</label>
        <input type="text" id="deptCode" name="deptCode" required><br><br>
        
        <label for="courseNumber">Course Number:</label>
        <input type="number" id="courseNumber" name="courseNumber" required min="100" max="799"><br><br>
        
        <input type="submit" value="Delete Course">

        <%-- Display output messages --%>
        <%
            List<String> outputMessages = (List<String>) request.getAttribute("outputMessages");
            if (outputMessages != null && !outputMessages.isEmpty()) {
                for(String message : outputMessages) {
        %>
        <div><%= message %></div>
        <%
                }
            }
        %>
        
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
