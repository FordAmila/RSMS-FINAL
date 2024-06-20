<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 56px; /* Adjust based on your navigation bar height */
        }
        .container {
            margin-top: 20px;
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

<div class="container">
    <h2>Return Book</h2>

    <% 
        String dbURL = "jdbc:mysql://localhost:3306/library_db";
        String dbUsername = "root";
        String dbPassword = "";
        Connection connection = null;
        PreparedStatement psUpdateIssued = null;
        PreparedStatement psUpdateBooks = null;

        try {
            int bookId = Integer.parseInt(request.getParameter("book_id"));

            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            // Update the is_returned status in the issued_books table
            String updateIssuedQuery = "UPDATE issued_books SET is_returned = ? WHERE book_id = ?";
            psUpdateIssued = connection.prepareStatement(updateIssuedQuery);
            psUpdateIssued.setBoolean(1, true); // Set is_returned to true (returned)
            psUpdateIssued.setInt(2, bookId);
            psUpdateIssued.executeUpdate();

            // Increment the copies in the books table
            String updateBooksQuery = "UPDATE books SET copies = copies + 1 WHERE id = ?";
            psUpdateBooks = connection.prepareStatement(updateBooksQuery);
            psUpdateBooks.setInt(1, bookId);
            psUpdateBooks.executeUpdate();

            // Redirect back to issue.jsp after successful update
            response.sendRedirect("issue.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (psUpdateIssued != null) try { psUpdateIssued.close(); } catch (SQLException ignore) {}
            if (psUpdateBooks != null) try { psUpdateBooks.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    %>
</div>

<!-- Bootstrap and JavaScript libraries -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
