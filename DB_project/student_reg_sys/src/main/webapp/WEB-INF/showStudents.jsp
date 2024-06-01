<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>All Students</title>
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

    <div class="main-content-showval">
        <h2 class="page-title">Students List</h2>
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
                    <c:forEach var="student" items="${students}">
                        <tr>
                            <td><c:out value="${student.bNumber}"/></td>
                            <td><c:out value="${student.firstName}"/></td>
                            <td><c:out value="${student.lastName}"/></td>
                            <td><c:out value="${student.studentLevel}"/></td>
                            <td><c:out value="${student.gpa}"/></td>
                            <td><c:out value="${student.email}"/></td>
                            <td><c:out value="${student.birthDate}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <footer>
        <p>@S4 Spring 2024</p>
    </footer>
</body>
</html>
