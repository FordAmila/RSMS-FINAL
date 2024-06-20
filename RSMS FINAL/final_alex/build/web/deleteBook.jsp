<%@ page import="java.sql.*" %>
<%
    int bookId = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
        
        // Step 1: Delete the specified record
        PreparedStatement deletePs = con.prepareStatement("DELETE FROM books WHERE id = ?");
        deletePs.setInt(1, bookId);
        deletePs.executeUpdate();
        deletePs.close();

        // Step 2: Reorder the IDs of the remaining records
        // Retrieve all books after the deleted book
        PreparedStatement selectPs = con.prepareStatement("SELECT id FROM books WHERE id > ? ORDER BY id");
        selectPs.setInt(1, bookId);
        ResultSet rs = selectPs.executeQuery();

        int newId = bookId;
        while (rs.next()) {
            int currentId = rs.getInt("id");
            // Update each book to have a new sequential ID
            PreparedStatement updatePs = con.prepareStatement("UPDATE books SET id = ? WHERE id = ?");
            updatePs.setInt(1, newId);
            updatePs.setInt(2, currentId);
            updatePs.executeUpdate();
            updatePs.close();
            newId++;
        }
        rs.close();
        selectPs.close();

        con.close();
        response.sendRedirect("books.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println(e.getMessage());
    }
%>
