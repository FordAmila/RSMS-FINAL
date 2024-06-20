<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    String userId = request.getParameter("id");
    String username = request.getParameter("username");
    String lastname = request.getParameter("lastname");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String course = request.getParameter("course");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
        PreparedStatement ps = con.prepareStatement("UPDATE users SET username = ?, lastname = ?, password = ?, email = ? , course= ? WHERE id = ?");
        ps.setString(1, username);
        ps.setString(2, lastname);
        ps.setString(3, password);
        ps.setString(4, email);
        ps.setString(5, course);
        ps.setString(6, userId);

        int rowsAffected = ps.executeUpdate(); // Get the number of rows affected

        ps.close();
        con.close();

        // Check if any rows were affected
        if(rowsAffected > 0) {
            // If rows were updated successfully, redirect to admin homepage
            response.sendRedirect("users.jsp");
        } else {
            // If no rows were updated, handle the situation (e.g., display an error message)
            out.println("No user found with ID: " + userId);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
