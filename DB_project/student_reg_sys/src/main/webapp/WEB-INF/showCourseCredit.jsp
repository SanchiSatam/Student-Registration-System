<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Show Course Credits</title>
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
        <h2 class="page-title">Course Credits List</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Course Number</th>
                        <th>Credits</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="courseCredit" items="${courseCredits}">
                        <tr>
                            <td><c:out value="${courseCredit.courseNumber}"/></td>
                            <td><c:out value="${courseCredit.credits}"/></td>
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
