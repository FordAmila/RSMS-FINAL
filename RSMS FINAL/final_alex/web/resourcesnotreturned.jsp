<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resources Not Returned Yet</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 56px;
        }
        .navbar-brand {
            font-size: 1.75rem;
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
        .table-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin: 20px;
        }
        .table thead th {
            background-color: #007bff;
            color: white;
        }
        .status-pending {
            color: #ffc107; /* Yellow for pending */
            font-weight: bold;
        }
        .status-returned {
            color: #28a745; /* Green for returned */
            font-weight: bold;
        }
    </style>
</head>
<body>
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
        <a href="resourcesnotreturned.jsp">Resources Not Returned Yet</a>
        <a href="index.jsp">Logout</a>
        
    </div>

    <!-- Content -->
    <div class="content">
        <h2>Resources Not Returned Yet</h2>

        <!-- Resources Not Returned Yet Table -->
        <div class="table-container">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">Resource Name</th>
                        <th scope="col">Borrow Date</th>
                        <th scope="col">Return Date</th>
                        <th scope="col">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String dbURL = "jdbc:mysql://localhost:3306/library_db";
                        String username = "root";
                        String password = "";
                        Connection connection = null;
                        PreparedStatement preparedStatement = null;
                        ResultSet resultSet = null;

                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            connection = DriverManager.getConnection(dbURL, username, password);

                            String sql = "SELECT b.title, bb.borrow_date, bb.return_date " +
                                         "FROM borrowed_books bb " +
                                         "JOIN books b ON bb.book_id = b.id " +
                                         "WHERE bb.user_id = ?"; // Assuming user_id 1 for now
                            preparedStatement = connection.prepareStatement(sql);
                            preparedStatement.setInt(1, 1); // Use actual user_id from session or request
                            resultSet = preparedStatement.executeQuery();

                            while (resultSet.next()) {
                                String title = resultSet.getString("title");
                                String borrowDate = resultSet.getString("borrow_date");
                                String returnDate = resultSet.getString("return_date");
                                String status = (returnDate == null) ? "Pending" : "Returned";
                    %>
                    <tr>
                        <td><%= title %></td>
                        <td><%= borrowDate %></td>
                        <td><%= (returnDate == null) ? "Not Returned Yet" : returnDate %></td>
                        <td class="<%= (returnDate == null) ? "status-pending" : "status-returned" %>"><%= status %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
                            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

     <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
