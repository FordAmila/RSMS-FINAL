<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
    // Retrieve parameters from the form
    String userId = request.getParameter("user_id");
    String bookId = request.getParameter("book_id");
    String returnDate = request.getParameter("return_date");

    Connection con = null;
    PreparedStatement ps = null;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.jdbc.Driver");
        // Establish connection to the database
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");

        // Update the borrowed_books table to set the return_date
        String updateQuery = "UPDATE borrowed_books SET return_date = ? WHERE user_id = ? AND book_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setString(1, returnDate);
        ps.setString(2, userId);
        ps.setString(3, bookId);

        int rowsUpdated = ps.executeUpdate();
        
        // Check if the update was successful
        if (rowsUpdated > 0) {
            // Update the books table to increment the quantity
            String incrementQuery = "UPDATE books SET copies = copies + 1 WHERE id = ?";
            ps = con.prepareStatement(incrementQuery);
            ps.setString(1, bookId);
            ps.executeUpdate();

            out.println("<h2>Resource returned successfully.</h2>");
        } else {
            out.println("<h2>Failed to return the resource. Please check the details and try again.</h2>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>There was an error processing your request. Please try again later.</h2>");
    } finally {
        // Close the resources
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
%>
<a href="return.jsp">Return Another Resource</a>
<a href="index.jsp">Back to Dashboard</a>
