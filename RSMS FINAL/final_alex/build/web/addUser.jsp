<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String lastname = request.getParameter("lastname");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String course = request.getParameter("course");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
        PreparedStatement ps = con.prepareStatement("INSERT INTO users (username, lastname, password, email, course) VALUES (?, ?, ?, ?, ?)");
        ps.setString(1, username);
        ps.setString(2, lastname);
        ps.setString(3, password);
        ps.setString(4, email);
        ps.setString(5, course);
        ps.executeUpdate();
        ps.close();
        con.close();
        response.sendRedirect("users.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
