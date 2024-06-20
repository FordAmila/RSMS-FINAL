<%@ page import="java.sql.*, java.time.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrowed Resources</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 56px; /* Adjust based on your navigation bar height */
        }
        .list-group-item {
            margin-bottom: 20px;
            border-radius: 10px;
        }
        .list-group-item h5 {
            color: #007bff;
        }
        .list-group-item p {
            margin-bottom: 5px;
        }
        .list-group-item small {
            display: block;
            margin-bottom: 10px;
        }
        .list-group-item .text-success {
            font-weight: bold;
        }
        .list-group-item .text-danger {
            font-weight: bold;
        }
        .return-btn {
            float: right;
        }
        .sidebar {
            height: 100vh;
            position: fixed;
            top: 56px;
            left: 0;
            width: 200px;
            background-color: #343a40;
            padding-top: 20px;
            color: white;
        }
        .sidebar a {
            padding: 10px 20px;
            text-decoration: none;
            display: block;
            color: #adb5bd;
        }
        .sidebar a:hover {
            background-color: #495057;
            color: #fff;
        }
        .content {
            margin-left: 220px;
            padding: 20px;
        }
    </style>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <a class="navbar-brand" href="userhome.jsp">USER DASHBOARD</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
</nav>

<!-- Sidebar -->
<div class="sidebar">
    <a href="userviewbook.jsp">View Resources</a>
    <a href="borrowedresources.jsp">Borrowed Resources</a>
    <a href="index.jsp">Logout</a>
</div>

<div class="content">
    <h2>Borrowed Resources</h2>

    <div class="list-group">
        <% 
            String dbURL = "jdbc:mysql://localhost:3306/library_db";
            String dbUsername = "root";
            String dbPassword = "";
            Connection connection = null;
            PreparedStatement psResources = null;
            PreparedStatement psCheckBlock = null;
            ResultSet resultSet = null;

            try {
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                Class.forName("com.mysql.jdbc.Driver");
                connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                // Check if user is blocked

                    // Fetch borrowed resources and order by issue date and time in descending order
                    String resourcesQuery = "SELECT b.*, ib.issue_date, ib.due_date, ib.issue_time, ib.due_time, ib.is_returned " +
                                            "FROM books b " +
                                            "JOIN issued_books ib ON b.id = ib.book_id " +
                                            "WHERE ib.user_id = ? " +
                                            "ORDER BY ib.issue_date DESC, ib.issue_time DESC";
                    psResources = connection.prepareStatement(resourcesQuery);
                    psResources.setInt(1, userId);
                    resultSet = psResources.executeQuery();

                    while (resultSet.next()) {
                        int bookId = resultSet.getInt("id");
                        String title = resultSet.getString("title");
                        String author = resultSet.getString("author");
                        String description = resultSet.getString("description");
                        String issueDate = resultSet.getString("issue_date");
                        String dueDateTime = resultSet.getString("due_date");
                        String issueTime = resultSet.getString("issue_time");
                        String dueTime = resultSet.getString("due_time");
                        boolean returned = resultSet.getBoolean("is_returned");

        %>
        <div class="list-group-item">
            <h5 class="mb-1"><%= title %></h5>
            <p class="mb-1">Author: <%= author %></p>
            <small class="text-muted">Description: <%= description %></small>
            <p class="text-success">Issued Date: <%= issueDate %> </p>
            <p class="text-success">Issued Time: <%= issueTime %> </p>
            <p class="text-danger">Due Date: <%= dueDateTime %></p>
            <p class="text-danger">Due Time: <%= dueTime %></p>
            <!-- Display different button based on returned status -->
            <% if (!returned) { %>
                <form action="returnBook.jsp" method="post" class="return-btn">
                    <input type="hidden" name="book_id" value="<%= bookId %>">
                    <button type="submit" class="btn btn-primary">Return</button>
                </form>
            <% } else { %>
                <span class="badge badge-success">Returned</span>
            <% } %>
        </div>
        <%
                    }
            } catch (Exception e) {
                e.printStackTrace();
                out.println(e.getMessage());
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (psResources != null) try { psResources.close(); } catch (SQLException ignore) {}
                if (psCheckBlock != null) try { psCheckBlock.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            }
        %>
    </div>
</div>

<!-- Bootstrap and JavaScript libraries -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
