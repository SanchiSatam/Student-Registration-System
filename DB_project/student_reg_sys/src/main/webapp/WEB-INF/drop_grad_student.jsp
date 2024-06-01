<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Drop a Grad Student from Class</title>
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
        <h2 class="enterval_formtitle">Delete Student from Class</h2>
        <%-- Delete student form --%>
        <form action="/drop_grad_student" method="post" class="form">
            <label for="bNumber">Enter B#:</label>
            <input type="text" id="bNumber" name="bNumber" required>
            <br>
            <label for="classId">Enter Class ID:</label>
            <input type="text" id="classId" name="classId" required>
            <br>
            <button type="submit">Delete Student from Class</button>

            <%-- Display error message --%>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="error-message"><%= errorMessage %></div>
            <%
                }
            %>
    
            <%-- Display output messages --%>
            <%
                List<String> outputMessages = (List<String>) request.getAttribute("outputMessages");
                if (outputMessages != null && !outputMessages.isEmpty()) {
                    for(String message : outputMessages) {
            %>
            <div class="error-message"><%= message %></div>
            <%
                    }
                }
            %>            
        </form>
    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
