<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Values</title>
    <link rel="stylesheet" href="style.css">
    <!-- Additional CSS styles  -->
    <style>
        .split-container {
            display: flex;
            height: 80vh;
        }
        .left-section {
            flex: 35%;
            padding: 20px;
        }
        .linesplit{
            margin-top: 3%;
            margin-bottom: 3%;
            border: 1px solid black; 
        }
        .right-section {
            flex: 65%;
            padding: 20px;
        }
    </style>
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

    <div class="split-container">
        <div class="left-section">
            <div class="form-container">
                <h2 class="enterval_formtitle">View Prerequisite</h2>
                <form action="/prerequisites" method="post" class="form">
                    <label for="deptCode">Department Code:</label>
                    <input type="text" id="deptCode" name="deptCode" required="required">
                    <label for="courseNum">Course Number:</label>
                    <input type="text" id="courseNum" name="courseNum" required="required">
                    <button type="submit">Search</button>
                </form>
            </div>
        </div>
        <div class = "linesplit"></div>
        <div class="right-section">
            <div class="main-content-showval">
                <h2 class="page-title">Course Prerequisites List</h2>



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
            </div>
        </div>
    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
