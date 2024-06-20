
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="style.css">
    <style>
        *{  
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            display: flex;
            height: 100vh;
            background: #f4f4f4;
        }
        .sidebar {
            width: 250px;
            height: 100vh;
            background: #2c3e50;
            color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .sidebar .logo {
            width: 100px;
            margin: 20px 0;
        }
        .sidebar nav {
            width: 100%;
        }
        .sidebar nav ul {
            list-style: none;
            width: 100%;
        }
        .sidebar nav ul li {
            width: 100%;
        }
        .sidebar nav ul li a {
            display: block;
            padding: 15px;
            color: #fff;
            text-decoration: none;
            transition: background 0.3s;
        }
        .sidebar nav ul li a:hover {
            background: #34495e;
        }
        .content {
            flex: 1;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        table th {
            background-color: #2c3e50;
            color: white;
        }
        button {
            margin-right: 5px;
            background-color: #4CAF50; /* Green */
            border: none;
            color: white;
            padding: 10px 24px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .form {
            background-color: #f2f2f2;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .form label {
            font-weight: bold;
        }
        .form input[type=text],
        .form input[type=password],
        .form input[type=email],
        .form select,
        .form input[type=date],
        .form input[type=time] {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form input[type=submit],
        .form button {
            width: auto;
            background-color: #4CAF50;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .form input[type=submit]:hover,
        .form button:hover {
            background-color: #45a049;
        }

</style>
    <title>Issue Book</title>
</head>
<body>
    <div class="sidebar">
        <img src="images/logoub2.png" alt="University Logo" class="logo">
        <nav>
            <ul>
                <li><a href="users.jsp">Manage Users</a></li>
                <li><a href="books.jsp">Manage Resources</a></li>
                <li><a href="issue.jsp">Borrowed Resources</a></li>
                <li><a href="index.jsp">Logout</a></li>
            </ul>
        </nav>
    </div>
    <div class="content">
        <!-- Users Table -->
        <div id="users" class="table-container active">
            <h2>Users and Borrowed Resources</h2>
            <table>
                <tr>
                    <th>User ID</th>
                    <th>Firstname</th>
                    <th>Lastname</th>
                    <th>Resources Title</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Action</th>
                </tr>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
                        String query = "SELECT u.id, u.username, u.lastname, b.title, i.issue_date, i.issue_time, i.due_date, i.is_returned, i.book_id " +
                                       "FROM users u " +
                                       "JOIN issued_books i ON u.id = i.user_id " +
                                       "JOIN books b ON i.book_id = b.id " +
                                       "ORDER BY i.issue_date DESC, i.issue_time DESC"; // Order by issue date and time DESC

                        PreparedStatement ps = con.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            boolean returned = rs.getBoolean("is_returned");
                %>
                <tr>
                    <td><%= rs.getString("id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("lastname") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("issue_date") %></td>
                    <td><%= rs.getString("due_date") %></td>
                    <td>
                        <% if (!returned) { %>
                            <form action="returnBook2.jsp" method="post" class="return-btn">
                                <input type="hidden" name="book_id" value="<%= rs.getString("book_id") %>">
                                <button type="submit" >Return</button>
                            </form>
                        <% } else { %>
                            <span class="badge badge-success">Returned</span>
                        <% } %>
                    </td>
                </tr>
                <% 
                        }
                        rs.close();
                        ps.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </table>
        </div>

        <!-- Issue Book Form -->
        <div id="issue-book-form">
            <form id="issue-book" action="processIssueBook.jsp" method="post" class="form">
                <h2>Issue Resources</h2>
                <label for="user-id">User ID:</label>
                <input type="text" id="user-id" name="user_id" required><br><br>
                <label for="book-id">Resource ID:</label>
                <input type="text" id="book-id" name="book_id" required><br><br>
                <label for="issue-date">Issue Date:</label>
                <input type="date" id="issue-date" name="issue_date" required><br><br>
                <label for="issue-time">Issue Time:</label>
                <input type="time" id="issue-time" name="issue_time" required><br><br>
                <label for="due-date">Due Date:</label>
                <input type="date" id="due-date" name="due_date" required><br><br>
                <label for="due-time">Due Time:</label>
                <input type="time" id="due-time" name="due_time" required><br><br>
                <input type="submit" value="Issue Resources">
            </form>
        </div>
    </div>
</body>
</html>