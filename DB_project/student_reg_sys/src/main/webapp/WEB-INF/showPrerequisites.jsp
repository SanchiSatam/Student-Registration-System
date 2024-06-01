<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Show Prerequisites</title>
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
        <h2 class="page-title">Prerequisites List</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Department Code</th>
                        <th>Course Number</th>
                        <th>Prerequisite Department Code</th>
                        <th>Prerequisite Course Number</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="prerequisite" items="${prerequisites}">
                        <tr>
                            <td><c:out value="${prerequisite.departmentCode}"/></td>
                            <td><c:out value="${prerequisite.courseNumber}"/></td>
                            <td><c:out value="${prerequisite.prerequisiteDepartmentCode}"/></td>
                            <td><c:out value="${prerequisite.prerequisiteCourseNumber}"/></td>
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
