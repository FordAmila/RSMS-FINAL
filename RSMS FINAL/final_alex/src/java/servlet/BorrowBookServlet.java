package servlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/BorrowBookServlet")
public class BorrowBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dbURL = "jdbc:mysql://localhost:3306/library_db";
        String dbUsername = "root";
        String dbPassword = "";
        
        // Retrieve session information
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve book_id from request parameter
        int bookId = Integer.parseInt(request.getParameter("book_id"));

        Connection connection = null;
        PreparedStatement psBorrow = null;
        PreparedStatement psUpdateCopies = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            // Calculate issue date (current date)
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String issueDateStr = dateFormat.format(new Date());

            // Insert into issued_books
            String borrowQuery = "INSERT INTO issued_books (book_id, user_id, issue_date) VALUES (?, ?, ?)";
            psBorrow = connection.prepareStatement(borrowQuery);
            psBorrow.setInt(1, bookId);
            psBorrow.setInt(2, userId);
            psBorrow.setString(3, issueDateStr);
            psBorrow.executeUpdate();

            // Update books table to decrement copies
            String updateCopiesQuery = "UPDATE books SET copies = copies - 1 WHERE id = ?";
            psUpdateCopies = connection.prepareStatement(updateCopiesQuery);
            psUpdateCopies.setInt(1, bookId);
            psUpdateCopies.executeUpdate();

            // Redirect back to userviewbook.jsp or another appropriate page
            response.sendRedirect("borrowedresources.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Handle error appropriately
        } finally {
            try { if (psBorrow != null) psBorrow.close(); } catch (SQLException ignore) {}
            try { if (psUpdateCopies != null) psUpdateCopies.close(); } catch (SQLException ignore) {}
            try { if (connection != null) connection.close(); } catch (SQLException ignore) {}
        }
    }
}
