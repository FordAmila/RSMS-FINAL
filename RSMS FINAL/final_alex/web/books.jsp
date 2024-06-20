
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="style.css">
    <style>
        *{  
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            display: flex;
            height: 100vh;
            background: #f4f4f4;
        }
        .sidebar {
            width: 250px;
            height: 100%;
            background: #2c3e50;
            color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .sidebar .logo {
            width: 100px;
            margin: 20px 0;
        }
        .sidebar nav {
            width: 100%;
        }
        .sidebar nav ul {
            list-style: none;
            width: 100%;
        }
        .sidebar nav ul li {
            width: 100%;
        }
        .sidebar nav ul li a {
            display: block;
            padding: 15px;
            color: #fff;
            text-decoration: none;
            transition: background 0.3s;
        }
        .sidebar nav ul li a:hover {
            background: #34495e;
        }
        .content {
            flex: 1;
            padding: 20px;
        }
        .table-container {
            display: none;
        }
        .table-container.active {
            display: block;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        table th {
            background-color: #2c3e50;
            color: white;
        }
        button {
            margin-right: 5px;
            background-color: #4CAF50; /* Green */
            border: none;
            color: white;
            padding: 10px 24px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .form {
            background-color: #f2f2f2;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .form label {
            font-weight: bold;
        }
        .form input[type=text],
        .form input[type=password],
        .form input[type=email] {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form input[type=submit],
        .form button {
            width: auto;
            background-color: #4CAF50;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .form input[type=submit]:hover,
        .form button:hover {
            background-color: #45a049;
        }
        .action-buttons {
    margin: 0 5px; /* Add margin to create space between buttons */
        }
    </style>
    <title>Admin Dashboard</title>
    <script>
        function showTable(tableId) {
            var tables = document.getElementsByClassName('table-container');
            for (var i = 0; i < tables.length; i++) {
                tables[i].classList.remove('active');
            }
            document.getElementById(tableId).classList.add('active');
        }

        function showAddBookForm() {
            document.getElementById('add-book-form').style.display = 'block';
            document.getElementById('update-book-form').style.display = 'none';
        }

        function showUpdateBookForm(id, title, author, description, copies) {
            document.getElementById('update-book-form').style.display = 'block';
            document.getElementById('update-book-id').value = id;
            document.getElementById('update-title').value = title;
            document.getElementById('update-author').value = author;
            document.getElementById('update-description').value = description;
            document.getElementById('update-copies').value = copies;
        }

//        function closeUpdateBookForm() {
//            document.getElementById('update-book-form').style.display = 'none';
//        }

        function closeAddBookForm() {
            document.getElementById('add-book-form').style.display = 'none';
        }
    </script>
</head>
<body onload="showTable('books')">
    <div class="sidebar">
        <img src="images/logoub2.png" alt="University Logo" class="logo">
        <nav>
            <ul>
                <li><a href="users.jsp">Manage Users</a></li>
                <li><a href="books.jsp">Manage Resources</a></li>
                <li><a href="issue.jsp">Borrowed Resources</a></li>
<!--                <li><a href="returnresources.jsp">Return Resources</a></li>-->
                <li><a href="index.jsp">Logout</a></li>
            </ul>
        </nav>
    </div>
<div class="content">
        <div id="books" class="table-container active">
            <h2>Manage Resources</h2>
            <button class="action-buttons" onclick="showAddBookForm()">Add Book</button>
            <table>
                <tr>
                    <th>Resources ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Description</th>
                    <th>Available</th>
                    <th>Borrowed</th>
                    <th>Action</th>
                </tr>
                <% 
                  try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
                        PreparedStatement ps = con.prepareStatement("SELECT books.id, books.title, books.author, books.description, books.copies, COUNT(issued_books.book_id) AS borrowed FROM books LEFT JOIN issued_books ON books.id = issued_books.book_id GROUP BY books.id");
                        ResultSet rs = ps.executeQuery();
                        
                        while (rs.next()) {  
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("author") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getString("copies") %></td>
                    <td><%= rs.getString("borrowed") %></td>
                    <td class="action-buttons">
                        <!-- Corrected button onclick event -->
                        <button onclick="showUpdateBookForm('<%= rs.getInt("id") %>', '<%= rs.getString("title") %>', '<%= rs.getString("author") %>', '<%= rs.getString("description") %>', '<%= rs.getString("copies") %>')">Update</button>
                        <form action="deleteBook.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <button type="submit" value="Delete" class="action-buttons">Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        ps.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </table>
        </div>
    </div>

    <!-- Update Book Form -->
    <!-- Corrected form id -->
    <div id="update-book-form" style="display:none;">
        <form id="admin-update-book-form" action="updateBook.jsp" method="post" class="form">
            <h2>Update Resources</h2>
            <!-- Corrected input id -->
            <input type="hidden" id="update-book-id" name="id">
            <label for="update-title">Title:</label>
            <input type="text" id="update-title" name="title" required><br><br>
            <label for="update-author">Author:</label>
            <input type="text" id="update-author" name="author" required><br><br>
            <label for="update-description">Description:</label>
            <input type="text" id="update-description" name="description" required><br><br>
            <label for="update-copies">Available:</label>
            <input type="text" id="update-copies" name="copies" required><br><br>
            <input type="submit" value="Update">
            <!-- Removed cancel button -->
        </form>
    </div>


    <!-- Add Book Form -->
    <div id="add-book-form" style="display:none;">
        <form id="admin-add-book-form" action="addBook.jsp" method="post" class="form">
            <h2>Add Resources</h2>
            <label for="add-title">Title:</label>
            <input type="text" id="add-title" name="title" required><br><br>
            <label for="add-author">Author:</label>
            <input type="text" id="add-author" name="author" required><br><br>
            <label for="add-description">Description:</label>
            <input type="text" id="add-description" name="description" required><br><br>
            <label for="add-copies">Available:</label>
            <input type="text" id="add-copies" name="copies" required><br><br>
            <input type="submit" value="Submit">
            <button type="button" onclick="closeAddBookForm()">Cancel</button>
        </form>
    </div>
</body>
</html>
