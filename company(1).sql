-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: mysql
-- Generation Time: Feb 05, 2025 at 11:19 AM
-- Server version: 9.2.0
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `company`
--

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `item_pk` bigint UNSIGNED NOT NULL,
  `item_title` varchar(50) NOT NULL,
  `item_price` int UNSIGNED NOT NULL,
  `item_created_at` bigint UNSIGNED NOT NULL,
  `item_updated_at` bigint UNSIGNED NOT NULL,
  `item_deleted_at` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_pk` bigint UNSIGNED NOT NULL,
  `user_fk` bigint UNSIGNED NOT NULL,
  `order_created_at` bigint UNSIGNED NOT NULL,
  `order_updated_at` bigint UNSIGNED NOT NULL,
  `order_deleted_at` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_has_items`
--

CREATE TABLE `order_has_items` (
  `order_fk` bigint UNSIGNED NOT NULL,
  `item_fk` bigint UNSIGNED NOT NULL,
  `quantity` smallint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_pk` bigint UNSIGNED NOT NULL,
  `user_fk` bigint UNSIGNED NOT NULL,
  `post_data` varchar(500) NOT NULL,
  `post_created_at` bigint UNSIGNED NOT NULL,
  `post_updated_at` bigint UNSIGNED NOT NULL,
  `post_deleted_at` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_pk` bigint UNSIGNED NOT NULL,
  `user_username` varchar(20) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `user_last_name` varchar(20) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_created_at` bigint UNSIGNED NOT NULL,
  `user_updated_at` bigint UNSIGNED NOT NULL,
  `user_deleted_at` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_follows_users`
--

CREATE TABLE `user_follows_users` (
  `user_follower_fk` bigint UNSIGNED NOT NULL,
  `user_followee_fk` bigint UNSIGNED NOT NULL,
  `created_at` bigint UNSIGNED NOT NULL,
  `deleted_at` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_friends`
--

CREATE TABLE `user_friends` (
  `user_friender_fk` bigint UNSIGNED NOT NULL,
  `user_friendee_fk` bigint UNSIGNED NOT NULL,
  `status` char(1) NOT NULL,
  `created_at` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_pk`),
  ADD UNIQUE KEY `item_pk` (`item_pk`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_pk`),
  ADD UNIQUE KEY `order_pk` (`order_pk`),
  ADD KEY `user_fk` (`user_fk`);

--
-- Indexes for table `order_has_items`
--
ALTER TABLE `order_has_items`
  ADD PRIMARY KEY (`order_fk`,`item_fk`),
  ADD KEY `item_fk` (`item_fk`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_pk`),
  ADD UNIQUE KEY `post_pk` (`post_pk`),
  ADD KEY `user_fk` (`user_fk`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_pk`),
  ADD UNIQUE KEY `user_pk` (`user_pk`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- Indexes for table `user_follows_users`
--
ALTER TABLE `user_follows_users`
  ADD PRIMARY KEY (`user_follower_fk`,`user_followee_fk`),
  ADD KEY `user_followee_fk` (`user_followee_fk`);

--
-- Indexes for table `user_friends`
--
ALTER TABLE `user_friends`
  ADD PRIMARY KEY (`user_friender_fk`,`user_friendee_fk`),
  ADD KEY `user_friendee_fk` (`user_friendee_fk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `item_pk` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_pk` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_pk` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_pk` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `order_has_items`
--
ALTER TABLE `order_has_items`
  ADD CONSTRAINT `order_has_items_ibfk_1` FOREIGN KEY (`order_fk`) REFERENCES `orders` (`order_pk`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `order_has_items_ibfk_2` FOREIGN KEY (`item_fk`) REFERENCES `items` (`item_pk`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `user_follows_users`
--
ALTER TABLE `user_follows_users`
  ADD CONSTRAINT `user_follows_users_ibfk_1` FOREIGN KEY (`user_follower_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_follows_users_ibfk_2` FOREIGN KEY (`user_followee_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `user_friends`
--
ALTER TABLE `user_friends`
  ADD CONSTRAINT `user_friends_ibfk_1` FOREIGN KEY (`user_friendee_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_friends_ibfk_2` FOREIGN KEY (`user_friender_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
