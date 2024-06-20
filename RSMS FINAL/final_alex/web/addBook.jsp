<%@ page import="java.sql.*" %>
<%
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String description = request.getParameter("description");
    String isbn = request.getParameter("isbn");
    String copies = request.getParameter("copies");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
        PreparedStatement ps = con.prepareStatement("INSERT INTO books (title, author, description, copies) VALUES (?, ?, ?, ?)");
        ps.setString(1, title);
        ps.setString(2, author);
        ps.setString(3, description);
        ps.setString(4, copies);
        ps.executeUpdate();
        ps.close();
        con.close();
        response.sendRedirect("books.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
