<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
    String userId = request.getParameter("user_id");
    String bookId = request.getParameter("book_id");
    String issueDate = request.getParameter("issue_date");
    String issueTime = request.getParameter("issue_time");
    String dueDate = request.getParameter("due_date");
    String dueTime = request.getParameter("due_time");

    // Combine date and time into a single datetime string
    String issueDateTime = issueDate + " " + issueTime + ":00";
    String dueDateTime = dueDate + " " + dueTime + ":00";

    Connection con = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");

        // Disable autocommit to start a transaction
        con.setAutoCommit(false);

        // Validate existence of user_id and book_id in their respective tables
        PreparedStatement userQuery = con.prepareStatement("SELECT id FROM users WHERE id = ?");
        userQuery.setString(1, userId);
        ResultSet userResult = userQuery.executeQuery();
        if (!userResult.next()) {
            throw new SQLException("User with ID " + userId + " does not exist.");
        }

        PreparedStatement bookQuery = con.prepareStatement("SELECT id FROM books WHERE id = ?");
        bookQuery.setString(1, bookId);
        ResultSet bookResult = bookQuery.executeQuery();
        if (!bookResult.next()) {
            throw new SQLException("Book with ID " + bookId + " does not exist.");
        }

        // Insert into issued_books table
        PreparedStatement ps = con.prepareStatement("INSERT INTO issued_books (user_id, book_id, issue_date, issue_time, due_date, due_time, is_returned) VALUES (?, ?, ?, ?, ?, ?, ?)");
        ps.setString(1, userId);
        ps.setString(2, bookId);
        ps.setString(3, issueDateTime); // Combine issue date and time
        ps.setString(4, issueTime); // Separate issue time
        ps.setString(5, dueDateTime); // Combine due date and time
        ps.setString(6, dueTime); // Separate due time
        ps.setBoolean(7, false); // Set is_returned to false initially
        ps.executeUpdate();

        // Update the book quantity
        PreparedStatement psUpdate = con.prepareStatement("UPDATE books SET copies = copies - 1 WHERE id = ?");
        psUpdate.setString(1, bookId);
        psUpdate.executeUpdate();

        // Commit transaction
        con.commit();

        // Close all statements
        ps.close();
        psUpdate.close();
        userResult.close();
        userQuery.close();
        bookResult.close();
        bookQuery.close();
        con.close();

        response.sendRedirect("issue.jsp");
    } catch (Exception e) {
        e.printStackTrace(); // Print stack trace for debugging
        out.println(e.getMessage()); // Display error message
        try {
            if (con != null) {
                con.rollback(); // Rollback transaction in case of error
            }
        } catch (SQLException se) {
            se.printStackTrace(); // Handle rollback error
        }
    } finally {
        try {
            if (con != null && !con.isClosed()) {
                con.close(); // Ensure the connection is closed
            }
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
