<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete a Student</title>
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
    <%-- Delete student form --%>
    <form action="/delete_student" method="post" class="form">
        <h2 class = "enterval_formtitle">Delete a student </h2>
        <label for="bNumber">Enter B#:</label>
        <input type="text" id="bNumber" name="bNumber">
        <br>
        <button type="submit">Delete Student</button>

        <%-- Display error message --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div style="color: red;"><%= errorMessage %></div>
        <%
            }
        %>
    
        <%-- Display output messages --%>
        <%
            List<String> outputMessages = (List<String>) request.getAttribute("outputMessages");
            if (outputMessages != null && !outputMessages.isEmpty()) {
                for(String message : outputMessages) {
        %>
        <div style="color: red;"><%= message %></div>
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
