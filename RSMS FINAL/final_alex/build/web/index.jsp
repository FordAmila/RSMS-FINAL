<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
    String errorMessage = "";
    String successMessage = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String formType = request.getParameter("formType");

        String username = request.getParameter("username");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/library_db";
        String dbUsername = "root"; // Change to your database username
        String dbPassword = ""; // Change to your database password

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, dbUsername, dbPassword);

            if ("login".equals(formType)) {
                String confirmPassword = request.getParameter("confirmPassword");
                if (!password.equals(confirmPassword)) {
                    errorMessage = "Passwords do not match.";
                } else {
                    ps = con.prepareStatement("SELECT id, email FROM users WHERE email= ? AND username = ? AND lastname = ? AND password = ?");
                    ps.setString(1, email);
                    ps.setString(2, username);
                    ps.setString(3, lastname);
                    ps.setString(4, password);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        int userId = rs.getInt("id");
                        session.setAttribute("userId", userId);
                        session.setAttribute("user", email);
                        response.sendRedirect("userhome.jsp");
                    } else {
                        errorMessage = "Invalid username or password";
                    }
                }
            } else if ("register".equals(formType)) {
                String confirmPassword = request.getParameter("confirmPassword");
                if (!password.equals(confirmPassword)) {
                    errorMessage = "Passwords do not match.";
                } else {
                    // Check if username or email already exists
                    ps = con.prepareStatement("SELECT id FROM users WHERE username = ? OR email = ?");
                    ps.setString(1, username);
                    ps.setString(2, email);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        errorMessage = "Username or email is already taken.";
                    } else {
                        String course = request.getParameter("course");

                        ps = con.prepareStatement("INSERT INTO users (username, lastname, password, email, course) VALUES (?, ?, ?, ?, ?)");
                        ps.setString(1, username);
                        ps.setString(2, lastname);
                        ps.setString(3, password);
                        ps.setString(4, email);
                        ps.setString(5, course);
                        int i = ps.executeUpdate();

                        if (i > 0) {
                            successMessage = "Registration successful. You can now login.";
                        } else {
                            errorMessage = "Error in registration.";
                        }
                    }
                }
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            errorMessage = "Username or email already exists.";
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Database connection error.";
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="style.css">
    <style>
        /* POPPINS FONT */
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

*{  
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}
body {
    background-image: url('images/ub1.jpg');
    height: 100vh;
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
}
.wrapper{
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 110vh;
    background: rgba(0, 0, 0, 0.4);
}
.nav{
    position: fixed;
    top: 0;
    display: flex;
    justify-content: space-around;
    width: 100%;
    height: 100px;
    line-height: 100px;
    background: linear-gradient(rgba(39,39,39, 0.6), transparent);
    z-index: 100;
}
.nav-logo {
    display: flex;
    align-items: center; /* Vertically align items */
}

.nav-logo p {
    color: white;
    font-size: 40px;
    font-weight: 600;
    margin: 0; /* Remove default margin */
}

.logo {
    width: 100px; /* Adjust width as needed */
    height: 100px; /* Adjust height as needed */
    margin-right: 10px; /* Add margin to create space between the logo and text */
}

.nav-menu ul{
    display: flex;
}
.nav-menu ul li{
    list-style-type: none;
}
.nav-menu ul li .link{
    text-decoration: none;
    font-weight: 500;
    color: #ffffff;
    padding-bottom: 15px;
    margin: 0 25px;
}
.link:hover, .active{
    border-bottom: 2px solid #fff;
}
.nav-button .btn{
    width: 130px;
    height: 40px;
    font-weight: 500;
    background: rgba(255, 255, 255, 0.4);
    border: none;
    border-radius: 30px;
    cursor: pointer;
    transition: .3s ease;
}
.btn:hover{
    background: rgba(255, 255, 255, 0.3);
}
#registerBtn{
    margin-left: 15px;
}
#adminBtn{
    margin-left: 15px;
}
.btn.white-btn{
    background: rgba(255, 255, 255, 0.7);
}
.btn.btn.white-btn:hover{
    background: rgba(255, 255, 255, 0.5);
}
.nav-menu-btn{
    display: none;
}
.form-box{
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 512px;
    height: 520px;
    overflow: hidden;
    z-index: 2;
}
.login-container{
    position: absolute;
    left: 4px;
    width: 500px;
    display: flex;
    flex-direction: column;
    transition: .5s ease-in-out;
}
.register-container{
    position: absolute;
    right: -520px;
    width: 500px;
    display: flex;
    flex-direction: column;
    transition: .5s ease-in-out;
}
.top span{
    color: #fff;
    font-size: small;
    padding: 10px 0;
    display: flex;
    justify-content: center;
}
.top span a{
    font-weight: 500;
    color: #fff;
    margin-left: 5px;
}
header{
    color: #fff;
    font-size: 30px;
    text-align: center;
    padding: 10px 0 30px 0;
}
.two-forms{
    display: flex;
    gap: 10px;
}
.input-field{
    font-size: 15px;
    background: rgba(255, 255, 255, 0.2);
    color: #fff;
    height: 50px;
    width: 100%;
    padding: 0 10px 0 45px;
    border: none;
    border-radius: 30px;
    outline: none;
    transition: .2s ease;
}
.input-field:hover, .input-field:focus{
    background: rgba(255, 255, 255, 0.25);
}
::-webkit-input-placeholder{
    color: #fff;
}
.input-box i{
    position: relative;
    top: -35px;
    left: 17px;
    color: #fff;
}
.submit{
    font-size: 15px;
    font-weight: 500;
    color: black;
    height: 45px;
    width: 100%;
    border: none;
    border-radius: 30px;
    outline: none;
    background: rgba(255, 255, 255, 0.7);
    cursor: pointer;
    transition: .3s ease-in-out;
}
.submit:hover{
    background: rgba(255, 255, 255, 0.5);
    box-shadow: 1px 5px 7px 1px rgba(0, 0, 0, 0.2);
}
.two-col{
    display: flex;
    justify-content: space-between;
    color: #fff;
    font-size: small;
    margin-top: 10px;
}
.two-col .one{
    display: flex;
    gap: 5px;
}
.two label a{
    text-decoration: none;
    color: #fff;
}
.two label a:hover{
    text-decoration: underline;
}
@media only screen and (max-width: 786px){
    .nav-button{
        display: none;
    }
    .nav-menu.responsive{
        top: 100px;
    }
    .nav-menu{
        position: absolute;
        top: -800px;
        display: flex;
        justify-content: center;
        background: rgba(255, 255, 255, 0.2);
        width: 100%;
        height: 90vh;
        backdrop-filter: blur(20px);
        transition: .3s;
    }
    .nav-menu ul{
        flex-direction: column;
        text-align: center;
    }
    .nav-menu-btn{
        display: block;
    }
    .nav-menu-btn i{
        font-size: 25px;
        color: #fff;
        padding: 10px;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        cursor: pointer;
        transition: .3s;
    }
    .nav-menu-btn i:hover{
        background: rgba(255, 255, 255, 0.15);
    }
}
@media only screen and (max-width: 540px) {
    .wrapper{
        min-height: 100vh;
    }
    .form-box{
        width: 100%;
        height: 500px;
    }
    .register-container, .login-container{
        width: 100%;
        padding: 0 20px;
    }
    .register-container .two-forms{
        flex-direction: column;
        gap: 0;
    }

.admin-container {
    display: none;
     transition: right 0.3s ease, opacity 0.3s ease;
}
}
option{
    color: black;
}
    </style>
    <title>University Of Bohol | Login & Registration</title>
</head>
<body>
<div class="wrapper">     
    <nav class="nav">      
    <div class="nav-logo">
            <img src="images/logoub2.png" alt="University Logo" class="logo">
            <p>University of Bohol</p>
        </div>
 
        <div class="nav-menu" id="navMenu">
            <ul>
<!--                <li><a href="#" class="link active">Home</a></li>
                <li><a href="#" class="link">Blog</a></li>-->
            </ul>
        </div>

        <div class="nav-button">
            <button class="btn white-btn" id="loginBtn" onclick="login()">Sign In</button>
            <button class="btn" id="registerBtn" onclick="register()">Sign Up</button>
            <button class="btn" id="adminBtn" onclick="admin()">Admin</button>
        </div>
        <div class="nav-menu-btn">
            <i class="bx bx-menu" onclick="myMenuFunction()"></i>
        </div>
    </nav>
<div class="form-box">
        <!------------------- login form -------------------------->

        <form class="login-container" id="login" method="post" >
            <input type="hidden" name="formType" value="login">
            <div class="top">
<!--                <span>Don't have an account? <a href="#" onclick="register()">Sign Up</a></span>-->
                <header>Login</header>
            </div>
            <div class="input-box">
                <input type="email" class="input-field" name="email" placeholder="Email">
                <i class="bx bx-user"></i>
            </div>
            <div class="two-forms">
                <div class="input-box">
                    <input type="text" class="input-field" name="username" placeholder="Firstname">
                    <i class="bx bx-user"></i>
                </div>
                <div class="input-box">
                    <input type="text" class="input-field" name="lastname" placeholder="Lastname">
                    <i class="bx bx-user"></i>
                </div>
            </div>
            <div class="input-box">
                <input type="password" class="input-field" name="password" placeholder="Password">
                <i class="bx bx-lock-alt"></i>
            </div>
            <div class="input-box">
                <input type="password" class="input-field" name="confirmPassword" placeholder="Confirm Password">
                <i class="bx bx-lock-alt"></i>
            </div>
            <div class="input-box">
                <input type="submit" class="submit" value="Sign In">
            </div>
<%
    if (!errorMessage.isEmpty()) {
%>
        <script>
            alert('<%= errorMessage %>');
        </script>
<%
    }
%>
        </form>

        <!------------------- registration form -------------------------->
        <form class="register-container" id="register" method="post">
            <input type="hidden" name="formType" value="register">
            <div class="top">
<!--                <span>Have an account? <a href="#" onclick="login()">Login</a></span>-->
                <header>Sign Up</header>
            </div>
            <div class="input-box">
                <input type="email" class="input-field" name="email" placeholder="Email">
                <i class="bx bx-envelope"></i>
            </div>
            <div class="two-forms">
                <div class="input-box">
                    <input type="text" class="input-field" name="username" placeholder="Firstname">
                    <i class="bx bx-user"></i>
                </div>
                <div class="input-box">
                    <input type="text" class="input-field" name="lastname" placeholder="Lastname">
                    <i class="bx bx-user"></i>
                </div>
            </div>
            <div class="input-box">
        <select class="input-field" name="course" required>
        <option value="" disabled selected>Select Course</option>
        <!-- College of Engineering, Technology, Architecture, and Fine Arts -->
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
        </select>
        <i class="bx bx-book"></i>
        </div>
            <div class="input-box">
                <input type="password" class="input-field" name="password" placeholder="Password">
                <i class="bx bx-lock-alt"></i>
            </div>
            <div class="input-box">
                <input type="password" class="input-field" name="confirmPassword" placeholder="Confirm Password">
                <i class="bx bx-lock-alt"></i>
            </div>
            <div class="input-box">
                <input type="submit" class="submit" value="Register">
            </div>
<%
    if (!successMessage.isEmpty()) {
%>
        <script>
            alert('<%= successMessage %>');
        </script>
<%
    }
    if (!errorMessage.isEmpty()) {
%>
        <script>
            alert('<%= errorMessage %>');
        </script>
<%
    }
%>

        </form>

    </div>
</div>   

<script>
    function myMenuFunction() {
        var i = document.getElementById("navMenu");

        if(i.className === "nav-menu") {
            i.className += " responsive";
        } else {
            i.className = "nav-menu";
        }
    }

    var a = document.getElementById("loginBtn");
    var b = document.getElementById("registerBtn");

    var x = document.getElementById("login");
    var y = document.getElementById("register");

 function login() {
        x.style.left = "4px";
        y.style.right = "-520px";
        z.style.right = "-520px"; // Move admin form out of view
        a.className += " white-btn";
        b.className = "btn";
        c.className = "btn";
        x.style.opacity = 1;
        y.style.opacity = 0;
        z.style.opacity = 0; // Hide admin form
    }

    function register() {
        x.style.left = "-510px";
        y.style.right = "5px";
        z.style.right = "-520px"; // Move admin form out of view
        a.className = "btn";
        b.className += " white-btn";
        c.className = "btn";
        x.style.opacity = 0;
        y.style.opacity = 1;
        z.style.opacity = 0; // Hide admin form
    }
    function admin(){
        window.location.href ='admin_signup.jsp'
    }
</script>

</body>
</html>
