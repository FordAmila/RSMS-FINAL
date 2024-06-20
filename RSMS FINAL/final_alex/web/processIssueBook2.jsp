<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Process Issue Book</title>
</head>
<body>
    <%
        String userId = request.getParameter("user_id");
        String bookId = request.getParameter("book_id");
        String issueDate = request.getParameter("issue_date");
        String issueTime = request.getParameter("issue_time");
        String dueDate = request.getParameter("due_date");
        String dueTime = request.getParameter("due_time");

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement checkUserStmt = null;
        PreparedStatement checkBookStmt = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");

            // Check if the user exists
            String checkUserQuery = "SELECT id FROM users WHERE id = ?";
            checkUserStmt = con.prepareStatement(checkUserQuery);
            checkUserStmt.setString(1, userId);
            ResultSet userRs = checkUserStmt.executeQuery();

            // Check if the book exists and has available copies
            String checkBookQuery = "SELECT id, copies FROM books WHERE id = ?";
            checkBookStmt = con.prepareStatement(checkBookQuery);
            checkBookStmt.setString(1, bookId);
            ResultSet bookRs = checkBookStmt.executeQuery();

            if (!userRs.next()) {
                out.println("<p>Error: User ID does not exist.</p>");
                out.println("<a href='issue.jsp'>Go back</a>");
            } else if (!bookRs.next() || bookRs.getInt("copies") <= 0) {
                out.println("<p>Error: Book ID does not exist or no copies available.</p>");
                out.println("<a href='issue.jsp'>Go back</a>");
            } else {
                // Proceed with issuing the book
                String query = "INSERT INTO issued_books (user_id, book_id, issue_date, issue_time, due_date, due_time, is_returned) VALUES (?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(query);
                ps.setString(1, userId);
                ps.setString(2, bookId);
                ps.setString(3, issueDate);
                ps.setString(4, issueTime);
                ps.setString(5, dueDate);
                ps.setString(6, dueTime);
                ps.setBoolean(7, false); // Set is_returned to false (not returned yet)
                ps.executeUpdate();

                // Decrement the copies in the books table
                String updateBooksQuery = "UPDATE books SET copies = copies - 1 WHERE id = ?";
                PreparedStatement psUpdateBooks = con.prepareStatement(updateBooksQuery);
                psUpdateBooks.setString(1, bookId);
                psUpdateBooks.executeUpdate();
                psUpdateBooks.close();

                response.sendRedirect("issue.jsp");
            }
            userRs.close();
            bookRs.close();
        } catch (SQLException e) {
            out.println("<p>SQL Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (checkUserStmt != null) try { checkUserStmt.close(); } catch (SQLException ignore) {}
            if (checkBookStmt != null) try { checkBookStmt.close(); } catch (SQLException ignore) {}
            if (con != null) try { con.close(); } catch (SQLException ignore) {}
        }
    %>
</body>
</html>
