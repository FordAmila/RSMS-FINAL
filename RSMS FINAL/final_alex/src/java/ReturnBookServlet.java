package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/returnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String borrowId = request.getParameter("borrow_id");
        String dbURL = "jdbc:mysql://localhost:3306/library_db";
        String username = "root";
        String password = "";
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, username, password);
            String updateQuery = "UPDATE borrowed_books SET is_returned = TRUE WHERE id = ?";
            preparedStatement = connection.prepareStatement(updateQuery);
            preparedStatement.setInt(1, Integer.parseInt(borrowId));
            int result = preparedStatement.executeUpdate();

            if (result > 0) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failure");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        } finally {
            if (preparedStatement != null) try { preparedStatement.close(); } catch (Exception ignore) {}
            if (connection != null) try { connection.close(); } catch (Exception ignore) {}
        }
    }
}
