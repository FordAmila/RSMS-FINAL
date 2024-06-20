<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
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
        .list-group-item {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            margin-bottom: 15px;
            border-radius: 10px;
        }
        .book-details {
            flex: 1;
        }
        .book-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        .book-actions .btn {
            margin-bottom: 5px;
        }
        .book-availability {
            font-size: 0.9rem;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <a class="navbar-brand" href="#">USER DASHBOARD</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </nav>

    <!-- Sidebar -->
    <div class="sidebar">
        <a href="userviewbook.jsp">View Resources</a>
        <a href="borrowedresources.jsp">Borrowed Resources</a>
        <a href="index.jsp">Logout</a>
<!--        <a href="resourcesnotreturned.jsp">Resources Not Returned Yet</a>-->
    </div>

    <!-- Content -->
    <div class="content">
        <h2>Search Results</h2>
        <!-- Search Books Section -->
<div id="searchBooks" class="mb-4">
    <form class="form-inline my-2 my-lg-0" method="get" action="searchBooks.jsp">
        <input class="form-control mr-sm-2" type="search" name="query" placeholder="Search for a resource" aria-label="Search">
        <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
    </form>
</div>

        <!-- Results Section -->
        <div class="list-group">
            <%
                String dbURL = "jdbc:mysql://localhost:3306/library_db";
                String username = "root";
                String password = "";
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultSet = null;
                String query = request.getParameter("query");

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    connection = DriverManager.getConnection(dbURL, username, password);
                    String sql = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ?";
                    preparedStatement = connection.prepareStatement(sql);
                    preparedStatement.setString(1, "%" + query + "%");
                    preparedStatement.setString(2, "%" + query + "%");
                    resultSet = preparedStatement.executeQuery();

                    while (resultSet.next()) {
                        int id = resultSet.getInt("id");
                        String title = resultSet.getString("title");
                        String author = resultSet.getString("author");
                        String description = resultSet.getString("description");
                        int copies = resultSet.getInt("copies");
            %>
            <div class="list-group-item list-group-item-action">
                <div class="book-details">
                    <h5 class="mb-1"><%= title %></h5>
                    <p class="mb-1">Author: <%= author %></p>
                    <small><%= description %></small>
                </div>
                <div class="book-actions">
                    <span class="book-availability text-success">Available: <%= copies %></span>
                    <form action="borrowBook.jsp" method="post" style="margin-bottom: 0;">
                        <input type="hidden" name="book_id" value="<%= id %>">
                        <button class="btn btn-success btn-sm" type="submit" <%= copies <= 0 ? "disabled" : "" %>>Borrow</button>
                    </form>
                </div>
            </div>
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
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
