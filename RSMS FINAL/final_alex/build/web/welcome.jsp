<%@ page import="javax.servlet.http.*" %>
<%
     session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("user");
%>
<html>
<head>
    <title>Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .welcome-container {
            width: 300px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin-top: 100px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <h2>Welcome, <%= username %>!</h2>
        <p>You have successfully logged in to the University Resource Sharing Management System.</p>
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>
