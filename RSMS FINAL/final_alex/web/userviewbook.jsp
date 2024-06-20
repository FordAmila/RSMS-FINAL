<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Resources</title>
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
        .book-image {
            flex: 0 0 150px;
            height: 150px;
            margin-right: 20px;
            background-color: #f5f5f5;
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

<!-- Content -->
<div class="content">
    <h2>View Resources</h2>
    <!-- Search Books Section -->
    <div id="searchBooks" class="mb-4">
        <form class="form-inline my-2 my-lg-0" method="get" action="searchBooks.jsp">
            <input class="form-control mr-sm-2" type="search" name="query" placeholder="Search for a resource" aria-label="Search">
            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
        </form>
    </div>

    <!-- List of Books -->
    <div class="list-group">
        <% 
            String dbURL = "jdbc:mysql://localhost:3306/library_db";
            String dbUsername = "root";
            String dbPassword = "";
            Connection connection = null;
            PreparedStatement psBooks = null;
            ResultSet resultSet = null;

            try {
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                Class.forName("com.mysql.jdbc.Driver");
                connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                // Fetch all available books that the user has not borrowed
                String booksQuery = "SELECT DISTINCT b.id, b.title, b.author, b.description, b.copies " +
                                    "FROM books b " +
                                    "LEFT JOIN issued_books ib ON b.id = ib.book_id AND ib.user_id = ? AND ib.is_returned = false " +
                                    "WHERE b.copies > 0 AND (ib.id IS NULL OR ib.id = '')";


                psBooks = connection.prepareStatement(booksQuery);
                psBooks.setInt(1, userId);
                resultSet = psBooks.executeQuery();

                while (resultSet.next()) {
                    int bookId = resultSet.getInt("id");
                    String title = resultSet.getString("title");
                    String author = resultSet.getString("author");
                    String description = resultSet.getString("description");
                    int copies = resultSet.getInt("copies");

                    // Display each book
        %>
        <div class="list-group-item list-group-item-action">
            <div class="book-details">
                <h5 class="mb-1"><%= title %></h5>
                <p class="mb-1">Author: <%= author %></p>
                <small><%= description %></small>
            </div>
            <div class="book-actions">
                <span class="book-availability text-success">Available: <%= copies %></span>
                <form action="borrowBook.jsp" method="post">
                    <input type="hidden" name="book_id" value="<%= bookId %>">
                    <button class="btn btn-success btn-sm borrow-button" type="submit">Borrow</button>
                </form>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (psBooks != null) try { psBooks.close(); } catch (SQLException ignore) {}
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
