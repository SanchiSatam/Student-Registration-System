<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Show Logs</title>
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
        <h2 class="page-title">Logs List</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Log Number</th>
                        <th>User Name</th>
                        <th>Operation Time</th>
                        <th>Table Name</th>
                        <th>Operation</th>
                        <th>Tuple Key Value</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${logs}">
                        <tr>
                            <td><c:out value="${log.logNumber}"/></td>
                            <td><c:out value="${log.userName}"/></td>
                            <td><c:out value="${log.operationTime}"/></td>
                            <td><c:out value="${log.tableName}"/></td>
                            <td><c:out value="${log.operation}"/></td>
                            <td><c:out value="${log.tupleKeyValue}"/></td>
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
