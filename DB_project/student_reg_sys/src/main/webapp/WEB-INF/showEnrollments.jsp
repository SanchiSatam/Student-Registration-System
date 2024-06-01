<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Show Enrollments</title>
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
        <h2 class="page-title">Enrollments List</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>B#</th>
                        <th>Class ID</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="enrollment" items="${enrollments}">
                        <tr>
                            <td><c:out value="${enrollment.bNumber}"/></td>
                            <td><c:out value="${enrollment.classId}"/></td>
                            <td><c:out value="${enrollment.score}"/></td>
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
