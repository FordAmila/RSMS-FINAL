package servlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/returnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String borrowId = request.getParameter("borrow_id");
        
        // Perform database update
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            String dbURL = "jdbc:mysql://localhost:3306/library_db";
            String dbUsername = "root";
            String dbPassword = "";

            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);
            
            // Update borrowed_books table
            String updateQuery = "UPDATE borrowed_books SET is_returned = true WHERE id = ?";
            ps = connection.prepareStatement(updateQuery);
            ps.setString(1, borrowId);
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Successful update
                response.getWriter().write("{\"status\": \"success\"}");
            } else {
                // No rows updated, handle error scenario
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to update database.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Exception occurred: " + e.getMessage() + "\"}");
        } finally {
            // Close resources
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException ignore) {
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ignore) {
                }
            }
        }
    }
}
