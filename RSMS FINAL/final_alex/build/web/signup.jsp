<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    String errorMessage = "";
    String successMessage = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/library_db";
        String dbUsername = "root"; // Change to your database username
        String dbPassword = ""; // Change to your database password

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, dbUsername, dbPassword);

            ps = con.prepareStatement("INSERT INTO users (username, password, email) VALUES (?, ?, ?)");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            int i = ps.executeUpdate();

            if (i > 0) {
                successMessage = "Registration successful. You can now login.";
            } else {
                errorMessage = "Error in registration.";
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            errorMessage = "Username already exists.";
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Database connection error.";
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
<html>
<head>
    <title>University Library Signup</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .signup-container {
            width: 300px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin-top: 100px;
        }
        .signup-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .signup-container input[type="text"],
        .signup-container input[type="password"],
        .signup-container input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .signup-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: #007BFF;
            color: #fff;
            cursor: pointer;
        }
        .signup-container input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error-message, .success-message {
            text-align: center;
        }
        .error-message {
            color: red;
        }
        .success-message {
            color: green;
        }
                .signup-container .signup-link {
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2>University Library Signup</h2>
        <form method="post" >
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="submit" value="Signup"><br>
            
            <div class="error-message"><%= errorMessage %></div>
            <div class="success-message"><%= successMessage %></div>
        </form>
        <div class="signup-link">
            <p>already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>
</body>
</html>
