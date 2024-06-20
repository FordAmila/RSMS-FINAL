<%@ page import="java.sql.*" %>
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
        .form input[type=email],
        .form select {
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
    </style>
    <title>Admin Dashboard</title>
</head>
<body onload="showTable('users')">
    <div class="sidebar">
        <img src="images/logoub2.png" alt="University Logo" class="logo">
        <nav>
            <ul>
                <li><a href="#" onclick="showTable('users')">Manage Users</a></li>
                <li><a href="books.jsp">Manage Resources</a></li>
                <li><a href="issue.jsp">Borrowed Resources</a></li>
                <li><a href="index.jsp">Logout</a></li>
            </ul>
        </nav>
    </div>
    <div class="content">
        <div id="users" class="table-container active">
            <h2>Users Table</h2>
            <button class="action-buttons" onclick="showAddUserForm()">Add User</button>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Firstname</th>
                    <th>Lastname</th>
                    <th>Password</th>
                    <th>Email</th>
                    <th>Course</th>
                    <th>Action</th>
                </tr>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "");
                        PreparedStatement ps = con.prepareStatement("SELECT * FROM users");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("lastname") %></td>
                    <td><%= rs.getString("password") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("course") %></td>
                    <td class="action-buttons">
                        <center>
                            <button onclick="showUpdateUserForm('<%= rs.getInt("id") %>', '<%= rs.getString("username") %>', '<%= rs.getString("lastname") %>', '<%= rs.getString("password") %>', '<%= rs.getString("email") %>', '<%= rs.getString("course") %>')">Update</button>
                            <form action="deleteUser.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                <button type="submit" value="Delete" class="action-buttons">Delete</button>
                            </form>
                        </center>
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
    <!-- Add User Form -->
    <div id="add-user-form" style="display:none;">
        <form id="admin-add-user-form" action="addUser.jsp" method="post" class="form">
            <h2>Add User</h2>
            <label for="add-username">Username:</label>
            <input type="text" id="add-username" name="username" required><br><br>
            <label for="add-lastname">Lastname:</label>
            <input type="text" id="add-lastname" name="lastname" required><br><br>
            <label for="add-password">Password:</label>
            <input type="password" id="add-password" name="password" required><br><br>
            <label for="add-email">Email:</label>
            <input type="email" id="add-email" name="email" required><br><br>
            <label for="add-course">Course:</label>
            <select id="add-course" name="course" required>
                <option value="">Select a course</option>
                <option value="BSCE-ST">Bachelor of Science in Civil Engineering ? Structural (BSCE - ST)</option>
                <option value="BSCE-WR">Bachelor of Science in Civil Engineering ? Water Resources (BSCE ? WR)</option>
                <option value="BSGE">Bachelor of Science in Geodetic Engineering (BSGE)</option>
                <option value="BSECE">Bachelor of Science in Electronics and Communications Engineering (BSECE)</option>
                <option value="BSEE">Bachelor of Science in Electrical Engineering (BSEE)</option>
                <option value="BSIE">Bachelor of Science in Industrial Engineering (BSIE)</option>
                <option value="BSME">Bachelor of Science in Mechanical Engineering (BSME)</option>
                <option value="BSCpE">Bachelor of Science in Computer Engineering (BSCpE)</option>
                <option value="BSCS">Bachelor of Science in Computer Science (BSCS)</option>
                <option value="BSAMT">Bachelor of Science in Aircraft Maintenance Technology (BSAMT)</option>
                <option value="ASAMT">Associate in Aircraft Maintenance Technology (ASAMT)</option>
                <option value="BSArch">Bachelor of Science in Architecture (BSArch)</option>
                <option value="BFA">Bachelor of Fine Arts major in Visual Communication/Advertising (BFA)</option>
            </select><br><br>
            <input type="submit" value="Add User">
            <button type="button" onclick="hideAddUserForm()">Cancel</button>
        </form>
    </div>

    <!-- Update User Form -->
    <div id="update-user-form" style="display:none;">
        <form id="admin-update-user-form" action="updateUser.jsp" method="post" class="form">
            <h2>Update User</h2>
            <input type="hidden" id="update-user-id" name="id">
            <label for="update-username">Username:</label>
            <input type="text" id="update-username" name="username" required><br><br>
            <label for="update-lastname">Lastname:</label>
            <input type="text" id="update-lastname" name="lastname" required><br><br>
            <label for="update-password">Password:</label>
            <input type="password" id="update-password" name="password" required><br><br>
            <label for="update-email">Email:</label>
            <input type="email" id="update-email" name="email" required><br><br>
            <label for="update-course">Course:</label>
            <select id="update-course" name="course" required>
                <option value="">Select a course</option>
                <option value="BSCE-ST">Bachelor of Science in Civil Engineering ? Structural (BSCE - ST)</option>
                <option value="BSCE-WR">Bachelor of Science in Civil Engineering ? Water Resources (BSCE ? WR)</option>
                <option value="BSGE">Bachelor of Science in Geodetic Engineering (BSGE)</option>
                <option value="BSECE">Bachelor of Science in Electronics and Communications Engineering (BSECE)</option>
                <option value="BSEE">Bachelor of Science in Electrical Engineering (BSEE)</option>
                <option value="BSIE">Bachelor of Science in Industrial Engineering (BSIE)</option>
                <option value="BSME">Bachelor of Science in Mechanical Engineering (BSME)</option>
                <option value="BSCpE">Bachelor of Science in Computer Engineering (BSCpE)</option>
                <option value="BSCS">Bachelor of Science in Computer Science (BSCS)</option>
                <option value="BSAMT">Bachelor of Science in Aircraft Maintenance Technology (BSAMT)</option>
                <option value="ASAMT">Associate in Aircraft Maintenance Technology (ASAMT)</option>
                <option value="BSArch">Bachelor of Science in Architecture (BSArch)</option>
                <option value="BFA">Bachelor of Fine Arts major in Visual Communication/Advertising (BFA)</option>
            </select><br><br>
            <input type="submit" value="Update User">
            <button type="button" onclick="hideUpdateUserForm()">Cancel</button>
        </form>
    </div>

    <script>
        function showTable(tableName) {
            // Hide all table containers
            var tableContainers = document.getElementsByClassName('table-container');
            for (var i = 0; i < tableContainers.length; i++) {
                tableContainers[i].classList.remove('active');
            }

            // Show the selected table container
            var tableContainer = document.getElementById(tableName);
            tableContainer.classList.add('active');
        }

        function showAddUserForm() {
            document.getElementById('add-user-form').style.display = 'block';
            document.getElementById('update-user-form').style.display = 'none';
        }

        function hideAddUserForm() {
            document.getElementById('add-user-form').style.display = 'none';
        }

        function showUpdateUserForm(user_id, username, lastname, password, email, course) {
            document.getElementById('update-user-id').value = user_id;
            document.getElementById('update-username').value = username;
            document.getElementById('update-lastname').value = lastname;
            document.getElementById('update-password').value = password;
            document.getElementById('update-email').value = email;
            document.getElementById('update-course').value = course;
            document.getElementById('update-user-form').style.display = 'block';
            document.getElementById('add-user-form').style.display = 'none';
        }

        function hideUpdateUserForm() {
            document.getElementById('update-user-form').style.display = 'none';
        }
    </script>
</body>
</html>
