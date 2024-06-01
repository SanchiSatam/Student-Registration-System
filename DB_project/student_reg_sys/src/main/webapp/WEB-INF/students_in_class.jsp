<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db_proj.student_reg_sys.models.Student" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Show Students in Class</title>
    <link rel="stylesheet" href="style.css">
    <!-- Additional CSS styles -->
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
                <h2 class="enterval_formtitle">Show Students in Class</h2>
                <form action="/students_in_class" method="post" class="form">
                    <label for="classId">Enter Class ID:</label>
                    <input type="text" id="classId" name="classId">
                    <button type="submit">Show Students</button>
                </form>
                <c:if test="${not empty outputMessages}">
                    <ul>
                        <c:forEach var="message" items="${outputMessages}">
                            <li><c:out value="${message}"/></li>
                        </c:forEach>
                    </ul>
                </c:if>
            </div>
        </div>
        <div class = "linesplit"></div>
        <div class="right-section">
            <% List<Student> students = (List<Student>) request.getAttribute("students");
                if (students != null && !students.isEmpty()) {
            %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>B#</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Student Level</th>
                            <th>GPA</th>
                            <th>Email</th>
                            <th>Birth Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Student student : students) { %>
                        <tr>
                            <td><%= student.getbNumber() %></td>
                            <td><%= student.getFirstName() %></td>
                            <td><%= student.getLastName() %></td>
                            <td><%= student.getStudentLevel() %></td>
                            <td><%= student.getGpa() %></td>
                            <td><%= student.getEmail() %></td>
                            <td><%= student.getBirthDate() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
