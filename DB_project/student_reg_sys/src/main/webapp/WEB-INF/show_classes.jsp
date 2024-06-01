<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Show Classes</title>
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
        <h2 class="page-title">Classes List</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Class ID</th>
                        <th>Department Code</th>
                        <th>Course Number</th>
                        <th>Section Number</th>
                        <th>Year</th>
                        <th>Semester</th>
                        <th>Limit</th>
                        <th>Class Size</th>
                        <th>Room</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="classObj" items="${classes}">
                        <tr>
                            <td><c:out value="${classObj.classId}"/></td>
                            <td><c:out value="${classObj.departmentCode}"/></td>
                            <td><c:out value="${classObj.courseNumber}"/></td>
                            <td><c:out value="${classObj.sectionNumber}"/></td>
                            <td><c:out value="${classObj.year}"/></td>
                            <td><c:out value="${classObj.semester}"/></td>
                            <td><c:out value="${classObj.limit}"/></td>
                            <td><c:out value="${classObj.classSize}"/></td>
                            <td><c:out value="${classObj.room}"/></td>
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
