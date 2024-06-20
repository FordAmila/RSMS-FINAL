<%-- 
    Document   : userhome
    Created on : Jun 7, 2024, 1:44:28 PM
    Author     : ana marie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resource Management Dashboard</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 56px;
            margin: 0;
        }
        .navbar {
            background-color: #007bff;
        }
        .navbar-brand {
            font-size: 1.75rem;
        }
        .sidebar {
            height: 100vh;
            position: fixed;
            top: 56px;
            left: 0;
            width: 200px;
            background-color: #343a40;
            padding-top: 20px;
            color: white;
        }
        .sidebar .sidebar-header {
            padding: 10px 20px;
            font-size: 1.25rem;
            background-color: #495057;
            text-align: center;
        }
        .sidebar a {
            padding: 10px 20px;
            text-decoration: none;
            display: block;
            color: #adb5bd;
        }
        .sidebar a:hover {
            background-color: #495057;
            color: #fff;
        }
        .welcome, .content {
            margin-left: 220px;
            padding: 20px;
            position: relative;
            z-index: 1;
            background: rgba(0, 0, 0, 0.5);
            color: white;
        }
        .slideshow {
            position: fixed;
            top: 56px;
            left: 200px;
            width: calc(100% - 200px);
            height: calc(100vh - 56px);
            z-index: 0;
        }
        .slideshow img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            opacity: 0;
            transition: opacity 1s;
        }
        .slideshow img.active {
            opacity: 1;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <a class="navbar-brand" href="userhome.jsp">USER DASHBOARD</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </nav>

    <!-- Sidebar -->
    <div class="sidebar">
        <a href="userviewbook.jsp">View Resources</a>
        <a href="borrowedresources.jsp">Borrowed Resources</a>
        <a href="index.jsp">Logout</a>
    </div>

    <!-- Welcome Section -->
    <div class="welcome">WELCOME USER</div>

    <!-- Content -->
    <div class="content">
        <h2>Welcome to the Resource Management Dashboard</h2>
        <p>Please use the sidebar to navigate through the different sections.</p>
    </div>

    <!-- Slideshow Background -->
    <div class="slideshow">
        <img src="images\back1.jpg" class="active">
        <img src="images\back2.jpg">
        <img src="images\back3.jpg">
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        let currentSlide = 0;
        const slides = document.querySelectorAll('.slideshow img');
        const totalSlides = slides.length;

        function showSlide(index) {
            slides.forEach((slide, i) => {
                slide.classList.remove('active');
                if (i === index) {
                    slide.classList.add('active');
                }
            });
        }

        function nextSlide() {
            currentSlide = (currentSlide + 1) % totalSlides;
            showSlide(currentSlide);
        }

        setInterval(nextSlide, 3000); // Change slide every 3 seconds
    </script>
</body>
</html>

