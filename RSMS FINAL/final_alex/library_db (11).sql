-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2024 at 06:42 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `firstname`, `lastname`, `password`, `email`) VALUES
(1, 'admin', 'rollorata', '123', 'aaron.rollorata.2004@gmail.com'),
(2, 'ford', 'amila', '123456', 'ford'),
(3, 'admin2', 'rollorata2', '123', 'aaron.rollorata.2004@gmail.com'),
(4, 'Edden', 'Guzman', 'juk', 'eddenguzman1@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `copies` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `author`, `description`, `copies`) VALUES
(5, 'The LAST SUPPER', 'CHADWICK', 'PANIHAPON', 43),
(6, 'The Books of Lost Names', 'Kristin Harmel', 'A Novel', 998);

-- --------------------------------------------------------

--
-- Table structure for table `issued_books`
--

CREATE TABLE `issued_books` (
  `id` int(11) NOT NULL,
  `user_id` int(50) NOT NULL,
  `book_id` int(50) NOT NULL,
  `issue_date` date NOT NULL,
  `issue_time` time NOT NULL DEFAULT current_timestamp(),
  `due_date` date NOT NULL,
  `due_time` time NOT NULL,
  `is_returned` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `issued_books`
--

INSERT INTO `issued_books` (`id`, `user_id`, `book_id`, `issue_date`, `issue_time`, `due_date`, `due_time`, `is_returned`) VALUES
(2, 1, 6, '2024-06-19', '05:24:35', '2024-06-22', '05:24:35', 1),
(3, 1, 6, '2024-06-19', '05:28:17', '2024-06-22', '05:28:17', 1),
(6, 1, 5, '2024-06-19', '05:37:00', '2024-06-19', '06:37:00', 1),
(7, 1, 5, '2024-06-19', '05:37:00', '2024-06-19', '06:37:00', 1),
(8, 1, 6, '2024-06-19', '05:37:00', '2024-06-19', '05:38:00', 1),
(9, 1, 6, '2024-06-19', '05:42:00', '2024-06-19', '05:42:00', 1),
(10, 1, 6, '2024-06-19', '05:44:00', '2024-06-19', '05:44:00', 1),
(12, 1, 6, '2024-06-19', '05:44:00', '2024-06-19', '05:44:00', 1),
(13, 1, 6, '2024-06-19', '05:45:42', '2024-06-22', '05:45:42', 1),
(14, 1, 5, '2024-06-19', '05:45:49', '2024-06-22', '05:45:49', 1),
(15, 2, 5, '2024-06-19', '12:01:19', '2024-06-22', '12:01:19', 1),
(16, 2, 6, '2024-06-19', '00:04:00', '2024-06-20', '01:06:00', 1),
(17, 2, 6, '2024-06-19', '12:04:00', '2024-06-19', '12:05:00', 1),
(18, 2, 6, '2024-06-19', '12:05:00', '2024-06-20', '02:07:00', 1),
(19, 2, 5, '2024-06-19', '15:09:00', '2024-06-20', '05:11:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `course` varchar(255) NOT NULL,
  `status` enum('active','blocked') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `lastname`, `password`, `email`, `course`, `status`) VALUES
(1, 'aaron', 'rollorata', '123', 'aaron.rollorata.2004@gmail.com', 'BSCpE', 'active'),
(2, 'Edden', 'Guzman', '1234', 'eddenguzman1@gmail.com', 'BSCpE', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `issued_books`
--
ALTER TABLE `issued_books`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id_2` (`user_id`),
  ADD KEY `fk_book_id` (`book_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `issued_books`
--
ALTER TABLE `issued_books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `issued_books`
--
ALTER TABLE `issued_books`
  ADD CONSTRAINT `fk_book_id` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_id_7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
