/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;
import java.sql.*;
import java.time.LocalDate;

public class BlockOverdueUsers {
    public static void main(String[] args) {
        Connection connection = null;
        PreparedStatement psOverdueBooks = null;
        PreparedStatement psBlockUser = null;
        ResultSet rsOverdueBooks = null;

        try {
            String dbURL = "jdbc:mysql://localhost:3306/library_db";
            String username = "root";
            String password = "";

            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, username, password);

            // Select users with overdue books
            String overdueBooksQuery = "SELECT user_id, COUNT(*) as overdue_count FROM borrowed_books WHERE due_date < ? AND return_date IS NULL GROUP BY user_id";
            psOverdueBooks = connection.prepareStatement(overdueBooksQuery);
            psOverdueBooks.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            rsOverdueBooks = psOverdueBooks.executeQuery();

            while (rsOverdueBooks.next()) {
                int userId = rsOverdueBooks.getInt("user_id");
                int overdueCount = rsOverdueBooks.getInt("overdue_count");

                if (overdueCount > 0) {
                    // Block the user for 3 days
                    LocalDate blockEndDate = LocalDate.now().plusDays(3);
                    String blockUserQuery = "UPDATE users SET is_blocked = TRUE, block_end_date = ? WHERE id = ?";
                    psBlockUser = connection.prepareStatement(blockUserQuery);
                    psBlockUser.setDate(1, java.sql.Date.valueOf(blockEndDate));
                    psBlockUser.setInt(2, userId);
                    psBlockUser.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            if (rsOverdueBooks != null) try { rsOverdueBooks.close(); } catch (SQLException ignore) {}
            if (psOverdueBooks != null) try { psOverdueBooks.close(); } catch (SQLException ignore) {}
            if (psBlockUser != null) try { psBlockUser.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    }
}
