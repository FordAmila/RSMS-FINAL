<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    String id = request.getParameter("id");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String description = request.getParameter("description");
    String copies = request.getParameter("copies");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
        PreparedStatement ps = con.prepareStatement("UPDATE books SET title = ?, author = ?, description = ?, copies = ? WHERE id = ?");
        ps.setString(1, title);
        ps.setString(2, author);
        ps.setString(3, description);
        ps.setString(4, copies);
        ps.setString(5, id);

        int rowsAffected = ps.executeUpdate(); // Get the number of rows affected

        ps.close();
        con.close();

        // Check if any rows were affected
        if(rowsAffected > 0) {
            // If rows were updated successfully, redirect to admin homepage
            response.sendRedirect("books.jsp");
        } else {
            // If no rows were updated, handle the situation (e.g., display an error message)
            out.println("No user found with ID: " + id);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
