<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book</title>
</head>
<body>
<%
    String dbURL = "jdbc:mysql://localhost:3306/library_db";
    String username = "root";
    String password = "";
    Connection connection = null;
    PreparedStatement preparedStatement = null;

    String borrowId = request.getParameter("borrow_id");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, username, password);

        String sql = "DELETE FROM borrowed_books WHERE id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, Integer.parseInt(borrowId));
        preparedStatement.executeUpdate();
        
        response.sendRedirect("borrowedresources.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>
</body>
</html>
