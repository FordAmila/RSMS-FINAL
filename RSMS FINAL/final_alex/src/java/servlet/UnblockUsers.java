/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;
import java.sql.*;
import java.time.LocalDate;

public class UnblockUsers {
    public static void main(String[] args) {
        Connection connection = null;
        PreparedStatement psUnblockUsers = null;

        try {
            String dbURL = "jdbc:mysql://localhost:3306/library_db";
            String username = "root";
            String password = "";

            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, username, password);

            // Unblock users whose block period has ended
            String unblockUsersQuery = "UPDATE users SET is_blocked = FALSE, block_end_date = NULL WHERE block_end_date < ?";
            psUnblockUsers = connection.prepareStatement(unblockUsersQuery);
            psUnblockUsers.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            psUnblockUsers.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            if (psUnblockUsers != null) try { psUnblockUsers.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    }
}
