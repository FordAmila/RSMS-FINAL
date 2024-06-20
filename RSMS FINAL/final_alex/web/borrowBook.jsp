<%@ page import="java.sql.*, java.util.*, java.time.*, java.time.format.*, java.sql.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrow Book</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <div class="container">
        <h2>Borrow Book</h2>

        <div class="card">
            <div class="card-body">
                <% 
                    String dbURL = "jdbc:mysql://localhost:3306/library_db";
                    String dbUsername = "root";
                    String dbPassword = "";
                    Connection connection = null;
                    PreparedStatement psBorrow = null;
                    PreparedStatement psUpdateCopies = null;

                    try {
                        Integer userId = (Integer) session.getAttribute("userId");
                        if (userId == null) {
                            response.sendRedirect("login.jsp");
                            return;
                        }

                        Class.forName("com.mysql.jdbc.Driver");
                        connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                        // Retrieve form parameter (book_id)
                        String bookIdStr = request.getParameter("book_id");

                        // Validate input
                        if (bookIdStr == null || bookIdStr.isEmpty()) {
                %>
                <div class="alert alert-danger" role="alert">
                    Invalid book selection.
                </div>
                <% 
                    } else {
                        int bookId = Integer.parseInt(bookIdStr);

                        // Calculate due date and time (3 days from now)
                        LocalDateTime currentDateJSP = LocalDateTime.now();
                        LocalDateTime dueDateTime = currentDateJSP.plusDays(3);

                        // Format due date and time separately
                        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                        String formattedDueDate = dueDateTime.format(dateFormatter);

                        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
                        String formattedDueTime = dueDateTime.format(timeFormatter);

                        // Insert into issued_books
                        String borrowQuery = "INSERT INTO issued_books (book_id, user_id, issue_date, due_date, due_time) VALUES (?, ?, ?, ?, ?)";
                        psBorrow = connection.prepareStatement(borrowQuery);
                        psBorrow.setInt(1, bookId);
                        psBorrow.setInt(2, userId);

                        // Set current date as issue_date (java.sql.Date)
                        Date currentDateSQL = Date.valueOf(currentDateJSP.toLocalDate());
                        psBorrow.setDate(3, currentDateSQL);

                        // Set due date and time
                        psBorrow.setString(4, formattedDueDate);
                        psBorrow.setString(5, formattedDueTime);

                        int rowsInserted = psBorrow.executeUpdate();

                        if (rowsInserted > 0) {
                            // Update books table to decrement copies
                            String updateCopiesQuery = "UPDATE books SET copies = copies - 1 WHERE id = ?";
                            psUpdateCopies = connection.prepareStatement(updateCopiesQuery);
                            psUpdateCopies.setInt(1, bookId);
                            int rowsUpdated = psUpdateCopies.executeUpdate();

                            if (rowsUpdated > 0) {
                                // Redirect to borrowedresources.jsp after success
                                response.sendRedirect("borrowedresources.jsp");
                            } else {
                                throw new SQLException("Failed to update book copies.");
                            }
                        } else {
                            throw new SQLException("Failed to insert into issued_books.");
                        }
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace(); // Print stack trace for debugging
                    %>
                    <div class="alert alert-danger" role="alert">
                        An error occurred: <%= e.getMessage() %>
                    </div>
                    <%
                } finally {
                    try { if (psBorrow != null) psBorrow.close(); } catch (SQLException ignore) {}
                    try { if (psUpdateCopies != null) psUpdateCopies.close(); } catch (SQLException ignore) {}
                    try { if (connection != null) connection.close(); } catch (SQLException ignore) {}
                }
                %>
            </div>
        </div>
    </div>

    <!-- Bootstrap and JavaScript libraries -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
