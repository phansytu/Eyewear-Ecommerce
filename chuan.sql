-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: eyewear_shop
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `variant_id` int DEFAULT NULL,
  `quantity` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `cart_id` (`cart_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`),
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `cart_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (12,1,52,NULL,1),(13,2,55,NULL,1),(14,1,56,NULL,1);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
INSERT INTO `carts` VALUES (1,3,'2026-04-23 08:11:40'),(2,1,'2026-04-23 09:38:24');
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (18,'Gọng kính thời trang','Các loại gọng kính cận thời trang nam nữ, đa dạng chất liệu','images/anhdanhmuc/gong-can.jpg',NULL),(19,'Kính Râm / Kính Mát','Kính thời trang bảo vệ mắt khỏi tia UV và khói bụi','images/anhdanhmuc/kinh-ram.jpg',NULL),(20,'Kính Chống Ánh Sáng Xanh','Chuyên dụng cho người dùng máy tính và điện thoại','images/anhdanhmuc/anh-sang-xanh.jpg',NULL),(21,'Tròng Kính','Các loại tròng kính thuốc từ Hàn Quốc, Nhật Bản, Pháp','images/anhdanhmuc/gong-kinh.jpg',NULL),(22,'Kính Áp Tròng','Lens thẩm mỹ và lens cận với nhiều màu sắc, phong cách','images/anhdanhmuc/kinh-ap-trong.jpg',NULL),(23,'Phụ Kiện Kính','Hộp kính, nước rửa kính, khăn lau Nano chuyên dụng','images/anhdanhmuc/phu-kien.jpeg',NULL),(24,'Gọng Titanium','Chất liệu siêu nhẹ, bền bỉ, cao cấp','images/anhdanhmuc/gong-titanium.jpg',18),(25,'Gọng Nhựa Dẻo TR90','Nhựa dẻo chịu lực, màu sắc trẻ trung','images/anhdanhmuc/gong-nhua-deo.jpg',18),(26,'Kính Ray-Ban','Thương hiệu kính râm hàng đầu thế giới','images/anhdanhmuc/rayban.jpg',19),(27,'Kính Thể Thao','Thiết kế ôm mặt, chuyên dụng cho hoạt động ngoài trời','images/anhdanhmuc/kinh-the-thao.jpg',19),(28,'Kính Chống Ánh Sáng Xanh Gaming','Bảo vệ mắt khi chơi game, làm việc lâu trên màn hình','images/anhdanhmuc/gaming.jpg',20),(29,'Kính Chống Ánh Sáng Xanh Văn Phòng','Thiết kế thanh lịch cho dân văn phòng','images/anhdanhmuc/van-phong.jpg',20),(30,'Tròng Đổi Màu','Tự động đổi màu khi ra nắng','images/anhdanhmuc/trong-doi-mau.jpg',21),(31,'Tròng Chống Bụi / UV','Bảo vệ mắt khỏi tia UV và bụi bẩn','images/anhdanhmuc/trong-chong-bui.jpg',21),(32,'Lens Màu Thời Trang','Lens đổi màu, phong cách trẻ trung','images/anhdanhmuc/lens-mau.jpg',22),(33,'Lens Cận / Viễn','Lens điều chỉnh tật khúc xạ cho mắt','images/anhdanhmuc/lens-can-vien.jpg',22),(34,'Hộp Kính Sang Trọng','Bảo quản kính an toàn, kiểu dáng đẹp','images/anhdanhmuc/hop-kinh.jpg',23),(35,'Nước Rửa Kính & Khăn Lau Nano','Chăm sóc kính hiệu quả, bảo vệ tròng','images/anhdanhmuc/nuoc-rua-kinh.jpg',23);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','replied','closed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_logs`
--

DROP TABLE IF EXISTS `inventory_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `variant_id` int DEFAULT NULL,
  `change_amount` int DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `inventory_logs_ibfk_1` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_logs`
--

LOCK TABLES `inventory_logs` WRITE;
/*!40000 ALTER TABLE `inventory_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_history`
--

DROP TABLE IF EXISTS `login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  `status` enum('success','failed') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `login_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_history`
--

LOCK TABLES `login_history` WRITE;
/*!40000 ALTER TABLE `login_history` DISABLE KEYS */;
INSERT INTO `login_history` VALUES (1,5,'2026-04-16 06:48:14','0:0:0:0:0:0:0:1','success'),(2,5,'2026-04-16 06:48:17','0:0:0:0:0:0:0:1','success'),(3,1,'2026-04-16 07:34:11','0:0:0:0:0:0:0:1','success'),(4,1,'2026-04-16 07:34:13','0:0:0:0:0:0:0:1','success'),(5,1,'2026-04-19 08:30:42','0:0:0:0:0:0:0:1','success'),(6,1,'2026-04-19 08:56:39','0:0:0:0:0:0:0:1','failed'),(7,1,'2026-04-19 08:56:44','0:0:0:0:0:0:0:1','success'),(8,1,'2026-04-19 08:57:20','0:0:0:0:0:0:0:1','success'),(9,1,'2026-04-19 08:57:49','0:0:0:0:0:0:0:1','success'),(10,1,'2026-04-19 09:06:27','0:0:0:0:0:0:0:1','success'),(11,1,'2026-04-19 09:09:12','0:0:0:0:0:0:0:1','success'),(12,1,'2026-04-19 09:10:27','0:0:0:0:0:0:0:1','success'),(13,1,'2026-04-19 09:14:17','0:0:0:0:0:0:0:1','success'),(14,1,'2026-04-19 09:20:16','0:0:0:0:0:0:0:1','success'),(15,1,'2026-04-19 09:25:44','0:0:0:0:0:0:0:1','success'),(16,1,'2026-04-19 09:46:11','0:0:0:0:0:0:0:1','success'),(17,1,'2026-04-19 09:51:32','0:0:0:0:0:0:0:1','success'),(18,1,'2026-04-19 10:02:53','0:0:0:0:0:0:0:1','success'),(19,3,'2026-04-19 10:33:05','0:0:0:0:0:0:0:1','success'),(20,1,'2026-04-19 10:33:49','0:0:0:0:0:0:0:1','success'),(21,1,'2026-04-19 10:53:12','0:0:0:0:0:0:0:1','success'),(22,1,'2026-04-19 11:07:47','0:0:0:0:0:0:0:1','success'),(23,1,'2026-04-19 11:08:23','0:0:0:0:0:0:0:1','success'),(24,6,'2026-04-19 11:21:27','0:0:0:0:0:0:0:1','success'),(25,1,'2026-04-19 11:23:01','0:0:0:0:0:0:0:1','success'),(26,1,'2026-04-19 18:36:26','0:0:0:0:0:0:0:1','success'),(27,1,'2026-04-19 18:48:28','0:0:0:0:0:0:0:1','success'),(28,1,'2026-04-19 19:08:34','0:0:0:0:0:0:0:1','success'),(29,1,'2026-04-20 02:57:42','0:0:0:0:0:0:0:1','success'),(30,1,'2026-04-20 03:17:29','0:0:0:0:0:0:0:1','success'),(31,1,'2026-04-20 03:20:33','0:0:0:0:0:0:0:1','success'),(32,3,'2026-04-20 03:20:44','0:0:0:0:0:0:0:1','success'),(33,3,'2026-04-20 04:29:01','0:0:0:0:0:0:0:1','success'),(34,3,'2026-04-21 06:28:34','0:0:0:0:0:0:0:1','success'),(35,3,'2026-04-21 07:00:51','0:0:0:0:0:0:0:1','success'),(36,3,'2026-04-21 07:01:39','0:0:0:0:0:0:0:1','success'),(37,3,'2026-04-21 07:18:21','0:0:0:0:0:0:0:1','success'),(38,3,'2026-04-21 07:35:34','0:0:0:0:0:0:0:1','success'),(39,1,'2026-04-21 07:40:46','0:0:0:0:0:0:0:1','success'),(40,1,'2026-04-21 15:18:41','0:0:0:0:0:0:0:1','success'),(41,1,'2026-04-21 15:36:32','0:0:0:0:0:0:0:1','success'),(42,1,'2026-04-21 15:52:22','0:0:0:0:0:0:0:1','success'),(43,1,'2026-04-21 16:04:24','0:0:0:0:0:0:0:1','success'),(44,1,'2026-04-21 16:04:38','0:0:0:0:0:0:0:1','success'),(45,1,'2026-04-21 16:04:56','0:0:0:0:0:0:0:1','success'),(46,1,'2026-04-21 17:31:37','0:0:0:0:0:0:0:1','success'),(47,1,'2026-04-21 17:31:51','0:0:0:0:0:0:0:1','success'),(48,3,'2026-04-22 06:53:11','0:0:0:0:0:0:0:1','success'),(49,3,'2026-04-22 07:17:05','0:0:0:0:0:0:0:1','success'),(50,1,'2026-04-22 07:38:50','0:0:0:0:0:0:0:1','success'),(51,1,'2026-04-22 08:48:02','0:0:0:0:0:0:0:1','success'),(52,1,'2026-04-22 09:48:08','0:0:0:0:0:0:0:1','success'),(53,1,'2026-04-22 10:03:22','0:0:0:0:0:0:0:1','success'),(54,1,'2026-04-22 10:11:52','0:0:0:0:0:0:0:1','success'),(55,1,'2026-04-22 15:57:08','0:0:0:0:0:0:0:1','success'),(56,1,'2026-04-23 06:21:30','0:0:0:0:0:0:0:1','success'),(57,3,'2026-04-23 06:23:23','0:0:0:0:0:0:0:1','success'),(58,3,'2026-04-23 06:34:44','0:0:0:0:0:0:0:1','success'),(59,3,'2026-04-23 08:11:37','0:0:0:0:0:0:0:1','success'),(60,1,'2026-04-23 09:16:46','0:0:0:0:0:0:0:1','success'),(61,1,'2026-04-23 15:41:03','0:0:0:0:0:0:0:1','success'),(62,1,'2026-04-23 15:42:28','0:0:0:0:0:0:0:1','success'),(63,1,'2026-04-23 16:04:51','0:0:0:0:0:0:0:1','success'),(64,1,'2026-04-23 16:09:38','0:0:0:0:0:0:0:1','success'),(65,1,'2026-04-24 06:07:56','0:0:0:0:0:0:0:1','success'),(66,1,'2026-04-24 06:43:07','0:0:0:0:0:0:0:1','success'),(67,3,'2026-04-24 06:49:19','0:0:0:0:0:0:0:1','success'),(68,3,'2026-04-24 06:57:41','0:0:0:0:0:0:0:1','success'),(69,1,'2026-04-24 06:59:11','0:0:0:0:0:0:0:1','success'),(70,1,'2026-04-24 07:32:55','0:0:0:0:0:0:0:1','success'),(71,3,'2026-04-24 08:00:49','0:0:0:0:0:0:0:1','success'),(72,3,'2026-04-24 08:18:37','0:0:0:0:0:0:0:1','success'),(73,3,'2026-04-27 08:04:02','0:0:0:0:0:0:0:1','success'),(74,3,'2026-04-27 08:08:22','0:0:0:0:0:0:0:1','success'),(75,3,'2026-04-27 08:09:27','0:0:0:0:0:0:0:1','success'),(76,3,'2026-04-27 08:31:56','0:0:0:0:0:0:0:1','success'),(77,3,'2026-04-27 09:29:09','0:0:0:0:0:0:0:1','success'),(78,3,'2026-04-27 09:58:10','0:0:0:0:0:0:0:1','success'),(79,3,'2026-04-27 10:17:02','0:0:0:0:0:0:0:1','success'),(80,1,'2026-04-27 14:35:13','0:0:0:0:0:0:0:1','success'),(81,1,'2026-04-30 02:43:36','0:0:0:0:0:0:0:1','success'),(82,1,'2026-04-30 11:06:25','0:0:0:0:0:0:0:1','success'),(83,1,'2026-04-30 11:57:39','0:0:0:0:0:0:0:1','success'),(84,1,'2026-05-01 02:14:09','0:0:0:0:0:0:0:1','success'),(85,1,'2026-05-01 02:47:04','0:0:0:0:0:0:0:1','success'),(86,1,'2026-05-01 03:20:11','0:0:0:0:0:0:0:1','success'),(87,1,'2026-05-01 03:26:58','0:0:0:0:0:0:0:1','success'),(88,1,'2026-05-01 04:17:43','0:0:0:0:0:0:0:1','success'),(89,1,'2026-05-01 07:00:23','0:0:0:0:0:0:0:1','success'),(90,1,'2026-05-01 09:29:46','0:0:0:0:0:0:0:1','success'),(91,1,'2026-05-03 08:30:27','0:0:0:0:0:0:0:1','success'),(92,3,'2026-05-03 08:30:56','0:0:0:0:0:0:0:1','success'),(93,3,'2026-05-04 14:46:24','0:0:0:0:0:0:0:1','success'),(94,3,'2026-05-04 15:35:05','0:0:0:0:0:0:0:1','success'),(95,3,'2026-05-04 15:35:41','0:0:0:0:0:0:0:1','success'),(96,3,'2026-05-06 08:43:20','0:0:0:0:0:0:0:1','success'),(97,1,'2026-05-06 09:52:23','0:0:0:0:0:0:0:1','success'),(98,1,'2026-05-06 09:53:09','0:0:0:0:0:0:0:1','success'),(99,1,'2026-05-06 09:55:15','0:0:0:0:0:0:0:1','success'),(100,3,'2026-05-06 10:03:19','0:0:0:0:0:0:0:1','success'),(101,1,'2026-05-06 10:03:53','0:0:0:0:0:0:0:1','success'),(102,3,'2026-05-06 10:04:40','0:0:0:0:0:0:0:1','success'),(103,1,'2026-05-06 10:05:35','0:0:0:0:0:0:0:1','success'),(104,1,'2026-05-07 06:04:31','0:0:0:0:0:0:0:1','success'),(105,3,'2026-05-07 06:05:00','0:0:0:0:0:0:0:1','success'),(106,3,'2026-05-07 07:11:58','0:0:0:0:0:0:0:1','success'),(107,1,'2026-05-07 07:41:25','0:0:0:0:0:0:0:1','success'),(108,1,'2026-05-08 08:58:50','0:0:0:0:0:0:0:1','success'),(109,1,'2026-05-08 08:59:41','0:0:0:0:0:0:0:1','success'),(110,3,'2026-05-08 09:00:50','0:0:0:0:0:0:0:1','success'),(111,1,'2026-05-11 03:47:31','0:0:0:0:0:0:0:1','success'),(112,1,'2026-05-11 10:15:50','0:0:0:0:0:0:0:1','success'),(113,1,'2026-05-11 10:16:08','0:0:0:0:0:0:0:1','success'),(114,1,'2026-05-12 06:59:51','0:0:0:0:0:0:0:1','success'),(115,3,'2026-05-12 07:02:56','0:0:0:0:0:0:0:1','success'),(116,3,'2026-05-13 06:38:37','0:0:0:0:0:0:0:1','success'),(117,3,'2026-05-13 06:52:12','0:0:0:0:0:0:0:1','success');
/*!40000 ALTER TABLE `login_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `variant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `order_details_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,1,1,2,150000.00,NULL),(2,1,3,1,50000.00,NULL),(3,2,1,2,150000.00,NULL),(4,2,3,1,50000.00,NULL),(5,3,1,2,150000.00,NULL),(6,3,3,1,50000.00,NULL),(7,4,1,2,150000.00,NULL),(8,4,3,1,50000.00,NULL),(9,5,1,2,150000.00,NULL),(10,5,3,1,50000.00,NULL),(11,6,1,2,150000.00,NULL),(12,6,3,1,50000.00,NULL),(13,7,1,2,150000.00,NULL),(14,7,3,1,50000.00,NULL),(15,8,1,2,150000.00,NULL),(16,8,3,1,50000.00,NULL),(17,9,1,2,150000.00,NULL),(18,9,3,1,50000.00,NULL),(19,10,1,2,150000.00,NULL),(20,10,3,1,50000.00,NULL),(21,11,1,2,150000.00,NULL),(22,11,3,1,50000.00,NULL),(23,12,1,2,150000.00,NULL),(24,12,3,1,50000.00,NULL),(25,13,1,2,150000.00,NULL),(26,13,3,1,50000.00,NULL),(27,14,55,1,320000.00,NULL),(28,14,56,8,270000.00,NULL);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','confirmed','shipping','delivered','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `voucher_id` int DEFAULT NULL,
  `payment_status` enum('unpaid','paid') DEFAULT 'unpaid',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `voucher_id` (`voucher_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,3,350000.00,'pending','2026-04-23 06:35:04',NULL,NULL,NULL,'unpaid'),(2,3,350000.00,'pending','2026-04-23 08:12:01',NULL,NULL,NULL,'unpaid'),(3,1,350000.00,'pending','2026-04-23 15:42:38',NULL,NULL,NULL,'unpaid'),(4,1,350000.00,'pending','2026-04-23 15:42:59',NULL,NULL,NULL,'unpaid'),(5,1,350000.00,'pending','2026-04-23 15:43:00',NULL,NULL,NULL,'unpaid'),(6,1,350000.00,'pending','2026-04-24 07:00:29',NULL,NULL,NULL,'unpaid'),(7,1,350000.00,'pending','2026-05-01 04:24:59',NULL,NULL,NULL,'unpaid'),(8,1,350000.00,'pending','2026-05-03 08:30:31',NULL,NULL,NULL,'unpaid'),(9,3,350000.00,'pending','2026-05-03 08:31:01',NULL,NULL,NULL,'unpaid'),(10,3,350000.00,'pending','2026-05-04 15:35:09',NULL,NULL,NULL,'unpaid'),(11,3,350000.00,'pending','2026-05-04 15:35:46',NULL,NULL,NULL,'unpaid'),(12,3,350000.00,'pending','2026-05-04 15:40:38',NULL,NULL,NULL,'unpaid'),(13,3,350000.00,'pending','2026-05-04 15:43:22',NULL,NULL,NULL,'unpaid'),(14,1,2480000.00,'delivered','2026-05-11 10:18:25','Hà Nội','0365945842',NULL,'paid');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_codes`
--

DROP TABLE IF EXISTS `otp_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `otp_code` varchar(10) NOT NULL,
  `type` enum('unlock','reset_password') DEFAULT 'unlock',
  `is_used` tinyint(1) DEFAULT '0',
  `expired_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_otp_code` (`otp_code`),
  KEY `idx_user_type` (`user_id`,`type`,`is_used`),
  CONSTRAINT `otp_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_codes`
--

LOCK TABLES `otp_codes` WRITE;
/*!40000 ALTER TABLE `otp_codes` DISABLE KEYS */;
INSERT INTO `otp_codes` VALUES (1,4,'861663','reset_password',1,'2026-04-24 07:56:23','2026-04-24 07:51:23');
/*!40000 ALTER TABLE `otp_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','completed','failed') DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `is_main` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_reviews`
--

DROP TABLE IF EXISTS `product_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `images` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('pending','approved','hidden') DEFAULT 'approved',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_reviews_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_reviews`
--

LOCK TABLES `product_reviews` WRITE;
/*!40000 ALTER TABLE `product_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `size` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT '0',
  `sku` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT '0',
  `sold_quantity` int DEFAULT '0',
  `total_reviews` int DEFAULT '0',
  `average_rating` decimal(2,1) DEFAULT '0.0',
  `category_id` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `brand` varchar(100) DEFAULT NULL,
  `gender` enum('male','female','unisex') DEFAULT NULL,
  `frame_material` varchar(100) DEFAULT NULL,
  `lens_type` varchar(100) DEFAULT NULL,
  `uv_protection` tinyint(1) DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `status` enum('active','inactive') DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Kính mắt Vippro','víp pro',200000.00,1999.00,10,0,0,0.0,20,'/image/anhdanhmuc/1776960648940_d35241e6.jpg','2026-04-19 19:09:14','Gucci',NULL,'','Chống ánh sáng xanh',0,0,'active'),(2,'Kính mắt Vippro 2','quá chất',99999.00,9990.00,1,0,0,0.0,19,'/image/anhdanhmuc/1776959250212_f6d9c31f.jpg','2026-04-19 19:15:02','Gucci','unisex','Plastic','Phân cực',0,0,'active'),(3,'Kính chống ánh sáng xanh pro','víp pro luôn',1000000.00,999999.00,5,0,0,0.0,20,'/image/anhdanhmuc/1777016007489_8da62cb4.jpg','2026-04-19 19:22:18','Gucci','unisex','Titanium','Chống ánh sáng xanh',0,0,'active'),(4,'Kính râm v2 pro','',200000.00,190000.00,9,0,0,0.0,19,'/image/anhdanhmuc/1777013036332_0c74e7f1.jpg','2026-04-23 15:48:50','Ran-Bay','unisex','Plastic','Thường',0,0,'active'),(5,'Kính chống ánh sáng xanh pro','',150000.00,99999.00,9,0,0,0.0,18,'/image/anhdanhmuc/1777013189704_70628558.jpg','2026-04-24 06:46:29','Gucci','male','Acetate','Chống ánh sáng xanh',0,0,'active'),(6,'Tròng kính vip pro','',359000.00,259000.00,100,0,0,0.0,21,'/image/anhdanhmuc/1777016067757_8344da06.jpg','2026-04-24 07:34:27','Ran-Bay','female','Acetate','Thường',0,0,'active'),(7,'Gọng Kính Cận Nam Titanium Siêu Nhẹ T800','Gọng kính cận nam cao cấp được làm từ chất liệu Titanium nguyên chất T800, nổi tiếng với độ siêu nhẹ và bền bỉ vượt trội. Thiết kế tối giản, sang trọng với đường nét gọn gàng phù hợp với gương mặt nam tính, trưởng thành.\n\n✅ Chất liệu: Titanium T800 – nhẹ hơn thép 45%, chống gỉ sét hoàn toàn\n✅ Khung: Mỏng chỉ 1.2mm, ôm sát gương mặt, không tạo áp lực lên sống mũi\n✅ Bản lề: Bản lề lò xo đàn hồi, chịu được lực bẻ ngược 180 độ\n✅ Tay gọng: Có đệm silicone chống trượt sau tai\n✅ Màu sắc: Bạc, Gunmetal, Vàng nhạt\n✅ Phù hợp: Gương mặt oval, chữ nhật, trái xoan\n✅ Kèm theo: Hộp cứng cao cấp, khăn lau microfiber, túi đựng nhung\n\nSản phẩm được kiểm định chất lượng theo tiêu chuẩn ISO 12312-1, đảm bảo an toàn tuyệt đối cho mắt người dùng. Phù hợp lắp tròng cận từ -0.25 đến -10.00 độ và loạn từ -0.25 đến -4.00 độ.',850000.00,720000.00,50,12,5,4.8,18,'/image/anhdanhmuc/gong-can.jpg','2026-04-20 01:00:00','Ray-Ban','male','Titanium','Thường',0,1,'active'),(8,'Gọng Kính Nữ Acetate Hoa Văn Hàn Quốc','Gọng kính nữ thời trang nhập khẩu từ Hàn Quốc, chất liệu Acetate cao cấp với hoa văn vân gỗ và đồi mồi sang trọng. Thiết kế mắt vuông hơi bo góc, tạo vẻ ngoài trí thức nhưng không kém phần dịu dàng, nữ tính.\n\n✅ Chất liệu: Acetate Mazzucchelli nhập Ý – độ bền cao, màu sắc không phai\n✅ Mắt kính: Hình vuông bo góc, kích thước 52-18-140mm\n✅ Màu sắc: Vân đồi mồi nâu, vân gỗ đen, trong suốt hồng pastel\n✅ Bản lề: Bản lề thép không gỉ 7 nốt vít siêu chắc\n✅ Nose pad: Đệm mũi silicone điều chỉnh được\n✅ Phù hợp: Mặt tròn, mặt tim, mặt vuông\n✅ Tương thích tròng: Cận, viễn, loạn, đổi màu, chống ánh sáng xanh\n\nMỗi chiếc gọng được gia công thủ công bởi nghệ nhân lành nghề, đảm bảo tính thẩm mỹ và chất lượng đồng đều. Hộp đựng sang trọng kèm giấy bảo hành 12 tháng chính hãng.',680000.00,550000.00,60,20,8,4.7,18,'/image/anhdanhmuc/gong-can.jpg','2026-04-20 01:30:00','Gucci','female','Acetate','Thường',0,1,'active'),(9,'Gọng Kính Unisex TR90 Siêu Dẻo Chống Vỡ','Gọng kính unisex chất liệu TR90 – loại nhựa dẻo kỹ thuật cao thế hệ mới, nổi tiếng với khả năng chống va đập và uốn cong mà không gãy. Lý tưởng cho người năng động, hay di chuyển hoặc trẻ em học sinh.\n\n✅ Chất liệu: TR90 – nhẹ hơn nhựa thông thường 40%, chịu nhiệt đến 130°C\n✅ Tính năng đặc biệt: Có thể uốn cong 180 độ mà không gãy\n✅ Trọng lượng: Chỉ 14g – nhẹ nhất trong các loại gọng hiện nay\n✅ Màu sắc: Đen mờ, xanh navy, đỏ cherry, xám bạc\n✅ Kích thước: Phù hợp cả nam và nữ với gọng 54mm\n✅ Bản lề: Bản lề lò xo đôi siêu bền\n✅ Ứng dụng: Học sinh, sinh viên, dân thể thao, người hay đặt kính vào túi\n\nKiểm tra chất lượng qua 50 bài thử nghiệm va đập và biến dạng. Không chứa BPA, an toàn cho mọi lứa tuổi.',420000.00,350000.00,100,35,15,4.6,18,'/image/anhdanhmuc/gong-nhua-deo.jpg','2026-04-21 02:00:00','Ran-Bay','unisex','TR90','Thường',0,0,'active'),(10,'Gọng Kính Nam Thép Không Gỉ Dáng Phi Công','Gọng kính nam kiểu phi công (aviator) cổ điển, \r\nchất liệu thép không gỉ 316L cao cấp với lớp mạ PVD bền màu. \r\nThiết kế mắt kép đặc trưng mang lại vẻ mạnh mẽ, cá tính, phù hợp với phong cách retro – vintage đang thịnh hành.\r\n\r\n✅ Chất liệu: Stainless Steel 316L – chống ăn mòn, không gây dị ứng da\r\n✅ Kiểu dáng: Aviator/Phi công – mắt giọt nước đôi cổ điển\r\n✅ Mạ PVD: Lớp mạ ion bền gấp 3 lần mạ thông thường\r\n✅ Màu sắc: Vàng gold, bạc chrome, đen gunmetal\r\n✅ Tay gọng: Thiết kế cable – dây kim loại xoắn đặc trưng phi công\r\n✅ Nose pad: Điều chỉnh được, phù hợp sống mũi người Á Đông\r\n✅ Phù hợp lắp: Tròng phân cực, tròng đổi màu, tròng cận\r\n\r\nSản phẩm được ưa chuộng bởi những tín đồ thời trang yêu thích phong cách vintage Mỹ thập niên 70-80. Mỗi chiếc đều trải qua kiểm tra độ bền kéo và xoắn 10,000 lần.',560000.00,480000.00,40,8,3,4.5,18,'/image/anhdanhmuc/gong-can.jpg','2026-04-21 03:00:00','Ray-Ban','unisex',NULL,'Thường',0,0,'active'),(11,'Gọng Titanium Beta Siêu Mỏng Nhật Bản','Gọng kính cao cấp sử dụng hợp kim Titanium Beta – loại titanium đặc biệt có khả năng đàn hồi như lò xo, không cần bản lề vẫn có thể mở rộng tay gọng. Sản xuất tại Nhật Bản theo tiêu chuẩn JIS T7401.\n\n✅ Chất liệu: Beta Titanium – hợp kim titanium-niken đàn hồi\n✅ Công nghệ: Rimless half – gọng nửa viền tối giản\n✅ Trọng lượng: Chỉ 9g – cảm giác không đeo kính\n✅ Bản lề: Không cần bản lề truyền thống, tay gọng tự đàn hồi\n✅ Màu sắc: Bạc mờ, đen titan, vàng champagne\n✅ Xuất xứ: Sabae, Fukui Prefecture – thủ đô kính mắt Nhật Bản\n✅ Bảo hành: 24 tháng chính hãng\n\nĐây là lựa chọn số 1 cho người dùng bị dị ứng kim loại hoặc cần đeo kính suốt nhiều giờ liên tục. Tương thích với mọi loại tròng cao cấp.',1200000.00,980000.00,25,7,4,4.9,24,'/image/anhdanhmuc/gong-titanium.jpg','2026-04-21 04:00:00','Gucci','unisex','Titanium','Thường',0,1,'active'),(12,'Gọng Titanium Nguyên Khối CNC Cao Cấp','Gọng kính được phay CNC từ khối titanium nguyên chất, không hàn, không ghép nối – tạo ra sản phẩm có độ bền và tính thẩm mỹ vượt trội. Mỗi chiếc gọng là một tác phẩm nghệ thuật kỹ thuật tinh xảo.\n\n✅ Công nghệ: CNC machining từ khối Ti-6Al-4V nguyên khối\n✅ Không mối hàn: Bền gấp đôi so với gọng hàn thông thường\n✅ Bề mặt: Hoàn thiện hairline brushed + anodized\n✅ Trọng lượng: 11g\n✅ Kích thước mắt: 50mm và 52mm (2 size)\n✅ Màu sắc: Xanh anodized, đỏ anodized, tự nhiên bạc\n✅ Limited edition: Sản xuất giới hạn 500 chiếc/màu\n\nPhù hợp với những khách hàng yêu cầu sản phẩm chất lượng tuyệt đối, sẵn sàng đầu tư cho một chiếc gọng kính trọn đời.',2500000.00,2200000.00,15,3,2,5.0,24,'/image/anhdanhmuc/gong-titanium.jpg','2026-04-22 02:00:00','Gucci','unisex','Titanium','Thường',0,1,'active'),(13,'Gọng Titanium Nữ Dáng Cat-Eye Sang Trọng','Gọng kính nữ dáng mắt mèo (cat-eye) làm từ titanium cao cấp, kết hợp giữa sự nhẹ nhàng của titanium và vẻ gợi cảm của kiểu dáng cat-eye kinh điển. Điểm nhấn là phần đuôi mắt vút cao tạo vẻ sắc sảo, cuốn hút.\n\n✅ Chất liệu: Titanium grade 5 (Ti-6Al-4V) mạ PVD rose gold\n✅ Kiểu dáng: Cat-eye – đuôi mắt vút cao 15 độ\n✅ Điểm nhấn: Cầu mũi tinh tế với viền kim cương nhỏ (cubic zirconia)\n✅ Trọng lượng: 12g\n✅ Màu sắc: Rose gold, gold champagne, silver chrome\n✅ Phù hợp mặt: Tròn, vuông, trái tim\n✅ Kèm: Hộp nhung cao cấp, khăn microfiber, chứng nhận chính hãng\n\nLựa chọn hoàn hảo cho phụ nữ hiện đại muốn thể hiện cá tính mà vẫn tinh tế, sang trọng. Gọng được thiết kế bởi team designer từ Milan, Ý.',1800000.00,1500000.00,20,5,3,4.8,24,'/image/anhdanhmuc/gong-titanium.jpg','2026-04-22 03:00:00','Gucci','female','Titanium','Thường',0,1,'active'),(14,'Gọng TR90 Học Sinh Màu Sắc Tươi Sáng','Gọng kính học sinh chất liệu TR90 siêu bền, thiết kế dành riêng cho trẻ em và học sinh với màu sắc tươi sáng, bắt mắt. Khả năng chống gãy vượt trội giúp phụ huynh yên tâm khi con vui chơi, học tập.\n\n✅ Chất liệu: TR90 FDA-approved – an toàn tuyệt đối cho trẻ em\n✅ Chống gãy: Chịu được lực uốn 270 độ mà không gãy\n✅ Màu sắc: Xanh lá, tím lavender, hồng, cam, xanh biển (5 màu)\n✅ Size: S (dành cho 6-10 tuổi) và M (dành cho 10-15 tuổi)\n✅ Mũi: Đệm mũi silicon mềm, không gây đau\n✅ Tai: Đầu tay gọng bọc silicone chống trượt, không gây đau vành tai\n✅ Trọng lượng: Chỉ 12g\n\nĐược kiểm định bởi tổ chức an toàn trẻ em châu Âu EN71. Không chứa BPA, phthalate hay chì. Bảo hành 12 tháng, đổi miễn phí nếu gọng bị gãy trong 3 tháng đầu.',350000.00,290000.00,80,25,10,4.7,25,'/image/anhdanhmuc/gong-nhua-deo.jpg','2026-04-22 04:00:00','Ran-Bay','unisex','TR90','Thường',0,0,'active'),(15,'Gọng TR90 Unisex Thể Thao Năng Động','Gọng kính thể thao unisex chất liệu TR90 với thiết kế ôm sát mặt, chống trượt, lý tưởng cho người năng động, tập gym, chạy bộ hoặc đạp xe. Thiết kế wrap-around bảo vệ mắt toàn diện.\n\n✅ Chất liệu: TR90 high-impact – vượt chuẩn ANSI Z87.1\n✅ Thiết kế: Wrap-around, ôm mặt 180 độ\n✅ Mũi: Nose pad silicone 3 điểm chống trượt\n✅ Tai: Temple rubber tip chống trượt khi đổ mồ hôi\n✅ Độ cong mặt kính: 6-base curve tăng tầm nhìn ngoại vi\n✅ Màu sắc: Đen/đỏ, xanh navy/xanh lá, trắng/cam\n✅ Tương thích: Lắp tròng phân cực hoặc tròng thể thao cao cấp\n\nThường được sử dụng trong các giải chạy marathon, đạp xe địa hình và hoạt động ngoài trời. Chứng nhận CE và FDA cho thể thao.',480000.00,420000.00,55,18,7,4.6,25,'/image/anhdanhmuc/gong-nhua-deo.jpg','2026-04-23 02:00:00','Ran-Bay','unisex','TR90','Thường',0,0,'active'),(16,'Kính Râm Phân Cực UV400 Nam Dáng Vuông','Kính râm nam dáng vuông với tròng phân cực (polarized) tiêu chuẩn UV400 – chặn 100% tia UVA và UVB. Thiết kế mạnh mẽ, cá tính, phù hợp với chàng trai yêu thích phong cách đường phố hiện đại.\n\n✅ Tròng: Phân cực TAC 7 lớp – chống chói tuyệt đối\n✅ Bảo vệ UV: UV400 – chặn 100% UVA, UVB, UVC\n✅ Độ dày tròng: 1.1mm – chống va đập tốt\n✅ Gọng: TR90 siêu nhẹ kết hợp khung kim loại\n✅ Màu tròng: Xám khói, nâu gradient, xanh lam gương\n✅ Phù hợp hoạt động: Lái xe, câu cá, leo núi, biển\n✅ Kèm theo: Túi đựng mềm, khăn lau, hộp cứng\n\nTròng phân cực giúp loại bỏ hoàn toàn ánh sáng phản chiếu từ mặt đường, mặt nước – tăng độ an toàn khi lái xe, đặc biệt lúc trời nhiều sương.',450000.00,380000.00,70,30,12,4.7,19,'/image/anhdanhmuc/kinh-ram.jpg','2026-04-23 03:00:00','Ray-Ban','male','TR90','Phân cực',1,1,'active'),(17,'Kính Mát Nữ Dáng Oversized Thời Trang','Kính mát nữ kiểu oversized (khổ lớn) cực thịnh hành hiện nay, tạo vẻ sang chảnh như fashionista thực thụ. Tròng UV400 màu gradient ombre từ đậm đến nhạt từ trên xuống dưới, vô cùng trendy.\n\n✅ Kiểu dáng: Oversized butterfly – cánh bướm khổ lớn\n✅ Tròng: Gradient UV400 – màu chuyển ombre tinh tế\n✅ Gọng: Acetate cao cấp, nhẹ và chắc\n✅ Màu: Gradient nâu/nude, gradient xanh/trong, gradient hồng/cam\n✅ Kích thước mắt: 62mm – oversized thực sự\n✅ Phù hợp: Đi biển, dự sự kiện, chụp ảnh sống ảo\n✅ Phong cách: Y2K, vintage 70s, fashion week\n\nĐược lấy cảm hứng từ các thiết kế xuất hiện trên runway Paris Fashion Week. Sản phẩm hot nhất mùa hè năm nay, được order trước hàng tuần.',520000.00,440000.00,45,22,9,4.8,19,'/image/anhdanhmuc/kinh-ram.jpg','2026-04-23 04:00:00','Gucci','female','Acetate','Phân cực',1,1,'active'),(18,'Kính Mát Unisex Gương Kim Loại Classic','Kính mát unisex kiểu gương kim loại cổ điển lấy cảm hứng từ những năm 60-70, mang vẻ đẹp timeless không bao giờ lỗi mốt. Tròng gương phản chiếu tạo điểm nhấn thời trang nổi bật.\n\n✅ Gọng: Hợp kim nhôm – nhẹ và bền\n✅ Tròng: Gương phản chiếu (mirror) + nền màu UV400\n✅ Màu gương: Vàng gold, bạc silver, xanh sapphire, đỏ ruby\n✅ Kiểu mắt: Tròn classic 50mm\n✅ Tay gọng: Kim loại với đầu bọc acetate\n✅ Nose pad: Điều chỉnh được cho mọi loại sống mũi\n✅ Phù hợp: Nam nữ đều đẹp, mặt oval và trái xoan\n\nKiểu kính gương tròn đã xuất hiện trên nhiều MV âm nhạc và đường phố thời trang quốc tế. Một chiếc kính mang về cả tủ đồ năng động lẫn elegant.',380000.00,320000.00,60,15,6,4.5,19,'/image/anhdanhmuc/kinh-ram.jpg','2026-04-24 02:00:00','Ran-Bay','unisex','Metal','Phân cực',1,0,'active'),(19,'Kính Ray-Ban Wayfarer RB2140 Chính Hãng','Kính Ray-Ban Wayfarer RB2140 – biểu tượng thời trang kính mắt thế giới từ 1956, đã xuất hiện trên khuôn mặt của hàng ngàn ngôi sao từ James Dean đến Lady Gaga. Hàng chính hãng nhập khẩu có tem hologram xác thực.\n\n✅ Model: RB2140 Wayfarer – iconic design since 1956\n✅ Gọng: Acetate cao cấp Mazzucchelli Italy\n✅ Tròng: Crystal G-15 – màu xanh lá cổ điển của Ray-Ban\n✅ Bảo vệ: UV400 100%\n✅ Size: 50mm và 54mm (S và M)\n✅ Màu: Đen/crystal, vân đồi mồi, đỏ/crystal\n✅ Xuất xứ: Italy\n✅ Bảo hành: 24 tháng Ray-Ban chính hãng\n✅ Kèm: Hộp Ray-Ban, khăn microfiber, certificate of authenticity\n\nMã barcode và QR code có thể quét trực tiếp trên app Ray-Ban để xác thực hàng chính hãng. Đây là model bán chạy nhất của Ray-Ban trong lịch sử, hơn 10 triệu chiếc được bán mỗi năm.',3200000.00,2900000.00,30,10,8,4.9,26,'/image/anhdanhmuc/rayban.jpg','2026-04-24 03:00:00','Ray-Ban','unisex','Acetate','Thường',1,1,'active'),(20,'Kính Ray-Ban Aviator RB3025 Classic Gold','Ray-Ban Aviator RB3025 – chiếc kính phi công huyền thoại ra đời năm 1937 dành cho lực lượng không quân Mỹ. Phiên bản classic gold vẫn là best-seller xuyên suốt gần 90 năm lịch sử.\n\n✅ Model: RB3025 Aviator Large Metal\n✅ Gọng: Hợp kim mạ vàng 23K PVD bền màu\n✅ Tròng: G-15 green classic – tăng độ tương phản, giảm mỏi mắt\n✅ Kiểu dáng: Teardrop double bridge\n✅ Kích thước: 58mm (L) – classic aviator size\n✅ Bảo vệ: UV400 + AR coating mặt trong\n✅ Tay gọng: Cable/bayonet temple cổ điển phi công\n✅ Xuất xứ: Italy\n✅ Bảo hành: 24 tháng\n\nĐây là model xuất hiện trong hàng trăm bộ phim Hollywood, từ Top Gun (Tom Cruise) đến The Aviator (Leonardo DiCaprio). Sản phẩm đầu tư, mua một lần dùng mãi.',3500000.00,3200000.00,20,8,5,4.9,26,'/image/anhdanhmuc/rayban.jpg','2026-04-24 04:00:00','Ray-Ban','unisex','Metal','Thường',1,1,'active'),(21,'Kính Ray-Ban Clubmaster RB3016 Browline','Ray-Ban Clubmaster RB3016 – kiểu browline đặc trưng với phần trên là kim loại, phần dưới không viền. Phong cách intellectual-chic được ưa chuộng trong giới học thuật, nghệ thuật và thời trang cao cấp.\n\n✅ Model: RB3016 Clubmaster\n✅ Thiết kế: Browline – nửa viền độc đáo\n✅ Vật liệu: Phần trên acetate + phần dưới dây kim loại\n✅ Tròng: Brown classic – tone ấm tự nhiên\n✅ Size: 49mm (classic) và 51mm (large)\n✅ Màu: Đen/vàng, nâu/vàng, xanh navy/vàng\n✅ Bảo vệ: UV400\n✅ Xuất xứ: Italy\n\nPhong cách Clubmaster gợi nhớ tới các trí thức, nghệ sĩ của thập niên 50-60. Hiện đang là xu hướng \"old money aesthetic\" rất được yêu thích trên social media.',2800000.00,2500000.00,25,6,4,4.8,26,'/image/anhdanhmuc/rayban.jpg','2026-04-25 02:00:00','Ray-Ban','unisex','Acetate','Thường',1,0,'active'),(22,'Kính Thể Thao Đạp Xe Photochromic Tự Đổi Màu','Kính thể thao chuyên dụng cho đạp xe và chạy bộ với tròng photochromic (tự đổi màu theo ánh sáng). Trong nhà gần như trong suốt, ra nắng tự tối dần – không cần thay kính khi vào/ra nhà.\n\n✅ Tròng: Photochromic – trong nhà: 15% tint, ngoài nắng: 75% tint\n✅ Thời gian đổi màu: 30 giây ra nắng, 60 giây vào nhà\n✅ Gọng: TR90 + rubber grip insert\n✅ Thiết kế: Wrap-around 8-base curve\n✅ Hệ thống thông gió: 4 lỗ thông hơi trên khung giảm mờ hơi\n✅ Bảo vệ: UV400 + tác động mạnh (ANSI Z87.1)\n✅ Kèm: 3 tròng thay thế (trong, màu, gương)\n\nĐược sử dụng bởi nhiều VĐV xe đạp chuyên nghiệp tại Việt Nam. Phù hợp cho cả buổi sáng sớm, trưa nắng gay gắt lẫn chiều tối.',890000.00,750000.00,35,12,5,4.7,27,'/image/anhdanhmuc/kinh-the-thao.jpg','2026-04-25 03:00:00','Ran-Bay','unisex','TR90','Phân cực',1,1,'active'),(23,'Kính Bơi Lội Chống Tia UV Cao Cấp','Kính bơi chuyên nghiệp với tròng chống tia UV và chống sương mờ, đệm silicon mềm ôm kín mắt chống thấm nước hoàn toàn. Phù hợp cả bơi trong hồ và bơi biển.\n\n✅ Tròng: PC (polycarbonate) chống va đập + anti-fog coating\n✅ Bảo vệ: UV400 – bảo vệ mắt khi bơi biển\n✅ Đệm mắt: Silicon y tế mềm, ôm khít không rò nước\n✅ Dây đeo: Silicone đôi điều chỉnh độ dài\n✅ Kích thước mắt: Phù hợp người lớn và trẻ em (2 size)\n✅ Màu tròng: Khói (hồ trong), màu gương (bơi biển)\n✅ Chống rò nước: Kiểm tra áp lực 5m độ sâu\n\nSử dụng được trong hồ bơi có chlorine, nước biển, nước ngọt. Giúp nhìn rõ dưới nước, bảo vệ mắt khỏi chlorine và vi khuẩn.',320000.00,270000.00,50,20,8,4.6,27,'/image/anhdanhmuc/kinh-the-thao.jpg','2026-04-25 04:00:00','Ran-Bay','unisex','PC','Thường',1,0,'active'),(24,'Kính Leo Núi Trekking Chống Gió Bụi','Kính leo núi và trekking thiết kế seal hoàn toàn quanh mắt, chống gió, bụi, mảnh vỡ đá và côn trùng. Lý tưởng cho các hoạt động outdoor khắc nghiệt như leo núi, đi phượt, đua moto địa hình.\n\n✅ Thiết kế: Sealed goggles – kín hoàn toàn xung quanh mắt\n✅ Tròng: Polycarbonate impact-resistant 2.5mm\n✅ Bảo vệ: UV400 + chống gió + chống bụi\n✅ Thông gió: Foam filter thở được, chống bụi vào trong\n✅ Đệm: EVA foam + silicon seal kép\n✅ Dây đeo: Elastic strap điều chỉnh, phù hợp đầu mũ bảo hiểm\n✅ Màu: Đen/khói, xanh quân đội/vàng, cam/trong\n✅ Chứng nhận: CE EN166 cho kính bảo hộ\n\nCần thiết cho bất kỳ ai lên đường trekking Tây Bắc, leo Fansipan hay đi tour moto xuyên Việt. Bảo vệ mắt toàn diện trong mọi điều kiện thời tiết.',650000.00,550000.00,30,8,3,4.8,27,'/image/anhdanhmuc/kinh-the-thao.jpg','2026-04-26 02:00:00','Ran-Bay','unisex','PC','Thường',1,0,'active'),(25,'Kính Chống Ánh Sáng Xanh Văn Phòng Nam','Kính chống ánh sáng xanh (blue light blocking) dành cho nam công sở, thiết kế lịch sự trang trọng có thể đeo cả ngày làm việc 8-10 tiếng trước màn hình máy tính mà không gây mỏi mắt.\n\n✅ Tròng: Blue light blocking lens – lọc 95% ánh sáng xanh 380-500nm\n✅ Hiệu quả: Giảm 70% mỏi mắt kỹ thuật số (Digital Eye Strain)\n✅ Gọng: Acetate cao cấp – dáng vuông công sở\n✅ Chứng nhận: TÜV Rheinland Eye Comfort Certificate\n✅ Độ truyền sáng: 90% – tròng gần như trong suốt\n✅ Lớp phủ: AR coating + anti-fingerprint + anti-static\n✅ Màu: Đen, nâu havana, xanh navy\n\nNhiều bác sĩ nhãn khoa Việt Nam khuyến nghị sản phẩm này cho dân văn phòng. Có thể lắp thêm tròng cận theo đơn.',650000.00,520000.00,80,40,18,4.8,20,'/image/anhdanhmuc/anh-sang-xanh.jpg','2026-04-26 03:00:00','Gucci','male','Acetate','Chống ánh sáng xanh',0,1,'active'),(26,'Kính Chống Ánh Sáng Xanh Nữ Dáng Tròn Cute','Kính chống ánh sáng xanh nữ dáng tròn cực cute và trendy, phù hợp cho các bạn gái yêu thích phong cách Hàn Quốc, học sinh sinh viên dùng máy tính nhiều.\n\n✅ Tròng: Blue light filter 90% ở bước sóng 415-455nm\n✅ Kiểu dáng: Mắt tròn 48mm – cute Hàn Quốc\n✅ Gọng: TR90 nhẹ + viền kim loại mảnh tạo điểm nhấn\n✅ Màu: Trong suốt/vàng, hồng/vàng, tím pastel/bạc\n✅ Trọng lượng: 13g – đeo cả ngày không nặng\n✅ Phù hợp: Học sinh, sinh viên, content creator\n✅ Hiệu quả: Cải thiện chất lượng giấc ngủ nếu đeo buổi tối\n\nNhiều Youtuber và TikToker Việt Nam đang dùng sản phẩm này. Đeo kính chống ánh sáng xanh buổi tối giúp não nhận biết đêm tốt hơn, ngủ ngon hơn theo nghiên cứu của Harvard Medical School.',420000.00,350000.00,90,45,20,4.7,20,'/image/anhdanhmuc/anh-sang-xanh.jpg','2026-04-26 04:00:00','Ran-Bay','female','TR90','Chống ánh sáng xanh',0,1,'active'),(27,'Kính Gaming Chống Ánh Sáng Xanh RGB Style','Kính gaming chống ánh sáng xanh với thiết kế cực kỳ cool ngầu dành cho game thủ. Tích hợp tròng amber (màu hổ phách) lọc tối đa ánh sáng xanh, tăng độ tương phản màn hình, giúp nhìn rõ hơn trong game.\n\n✅ Tròng: Amber lens – lọc 99% ánh sáng xanh\n✅ Công dụng: Tăng độ tương phản, dễ nhìn rõ mục tiêu trong FPS\n✅ Gọng: TR90 gaming style với điểm nhấn màu sắc\n✅ Thiết kế: Ergonomic fit – đeo thoải mái 6-8 tiếng liên tục\n✅ Tương thích: Đeo vừa cả tai nghe gaming headset\n✅ Màu tròng: Vàng amber (lọc tối đa) và vàng nhạt (cân bằng)\n✅ Màu gọng: Đen/đỏ gaming, đen/xanh lá, đen/tím\n\nĐược test bởi đội tuyển esport chuyên nghiệp. Sau 2 tuần sử dụng, 85% game thủ phản hồi giảm đau đầu và mỏi mắt sau mỗi session gaming dài.',580000.00,490000.00,60,28,12,4.7,28,'/image/anhdanhmuc/gaming.jpg','2026-04-26 05:00:00','Ran-Bay','unisex','TR90','Chống ánh sáng xanh',0,1,'active'),(28,'Kính Gaming Pro Esport Không Độ Tặng Kèm Túi','Kính gaming không độ cao cấp dành cho game thủ nghiêm túc, thiết kế full-frame bảo vệ mắt toàn diện, chống ánh sáng xanh và ánh sáng UV từ màn hình.\n\n✅ Tròng: Clear blue light blocking – trong suốt, không đổi màu thật của màn hình\n✅ Lọc: 40% ánh sáng xanh + 100% UV400\n✅ Chống mờ: Anti-fog coating chuẩn cho phòng lạnh điều hòa\n✅ Gọng: Metal + TR90 hybrid, siêu nhẹ 15g\n✅ Thiết kế: Flexible temple fit mọi hình dạng tai\n✅ Kèm: Túi đựng gaming pouch, khăn lau, spray rửa kính\n✅ Chứng nhận: TÜV SÜD và SGS\n\nLý tưởng cho những ai ngồi gaming 4-12 tiếng/ngày. Bảo vệ thị lực lâu dài, đặc biệt quan trọng với game thủ trẻ đang trong giai đoạn phát triển mắt.',720000.00,620000.00,40,15,6,4.8,28,'/image/anhdanhmuc/gaming.jpg','2026-04-27 02:00:00','Gucci','unisex','Metal','Chống ánh sáng xanh',0,0,'active'),(29,'Kính Văn Phòng Chống Blue Light Nữ Thanh Lịch','Kính chống ánh sáng xanh dành cho nữ nhân viên văn phòng, thiết kế thanh lịch, sang trọng, phù hợp trang phục công sở formal hay smart casual.\n\n✅ Tròng: Blue light blocking 85% + multi-layer AR coating\n✅ Kiểu dáng: Mắt hình hạnh nhân – feminine và professional\n✅ Gọng: Acetate + titanium temple – nhẹ và chắc\n✅ Màu: Be/vàng rose gold, đen/bạc, nâu tortoise/vàng\n✅ Kích thước: 54-17-140mm – fit gương mặt vừa và nhỏ\n✅ Lớp phủ thêm: Chống bụi, chống dầu (dấu vân tay)\n✅ Có thể lắp tròng cận, viễn theo đơn\n\nThiết kế bởi nhà thiết kế người Pháp, đảm bảo vừa bảo vệ mắt vừa nâng tầm phong cách công sở.',780000.00,650000.00,45,20,9,4.8,29,'/image/anhdanhmuc/van-phong.jpg','2026-04-27 03:00:00','Gucci','female','Acetate','Chống ánh sáng xanh',0,1,'active'),(30,'Kính Văn Phòng Nam Gọng Kim Loại Sang Trọng','Kính chống ánh sáng xanh nam gọng kim loại mảnh, sang trọng và trang nghiêm, phù hợp cho môi trường công sở, họp hành, gặp gỡ đối tác.\n\n✅ Tròng: Blue light filter lens + AR coating 7 lớp\n✅ Lọc hiệu quả: 380-500nm – vùng ánh sáng xanh gây hại nhất\n✅ Gọng: Titanium mỏng 1mm – vẻ ngoài tinh tế tối giản\n✅ Màu: Bạc, vàng đồng, đen mờ\n✅ Kích thước: 55-17-145mm – phù hợp nam\n✅ Chứng nhận: ISO 8980-3 và EN ISO 14889\n✅ Có thể lắp tròng theo đơn cận/viễn/loạn\n\nLà sự kết hợp hoàn hảo giữa thời trang công sở và sức khỏe thị lực. Đặc biệt phù hợp cho kỹ sư IT, lập trình viên, nhân viên thiết kế đồ họa.',850000.00,720000.00,35,15,6,4.7,29,'/image/anhdanhmuc/van-phong.jpg','2026-04-27 04:00:00','Gucci','male','Titanium','Chống ánh sáng xanh',0,0,'active'),(31,'Tròng Kính Cận Hàn Quốc 1.56 Chống Ánh Sáng Xanh','Tròng kính cận chỉ số chiết suất 1.56 nhập khẩu từ Hàn Quốc, tích hợp sẵn lớp chống ánh sáng xanh. Phù hợp với độ cận từ 0.25 đến 4.00 độ, mỏng và nhẹ, lý tưởng cho người dùng phổ thông.\n\n✅ Chỉ số chiết suất: 1.56 – độ dày phù hợp cận nhẹ đến trung bình\n✅ Xuất xứ: Hàn Quốc – thương hiệu Seiko Korea\n✅ Tích hợp: Blue light filter + UV400\n✅ Lớp phủ: 6 lớp AR coating + chống bụi + chống dầu\n✅ Phạm vi độ: Cận -0.25 đến -4.00, loạn đến -2.00\n✅ Thời gian làm: 3-5 ngày làm việc\n✅ Bảo hành: 12 tháng tróc lớp phủ, 6 tháng trầy xước\n\nGiá đã bao gồm gia công cắt lắp vào gọng. Tư vấn chỉ số phù hợp miễn phí khi mua hàng.',450000.00,380000.00,200,80,30,4.8,21,'/image/anhdanhmuc/gong-kinh.jpg','2026-04-20 02:00:00','Ran-Bay',NULL,NULL,'Chống ánh sáng xanh',0,0,'active'),(32,'Tròng Kính Cận Nhật Bản 1.67 Siêu Mỏng','Tròng kính cận chỉ số chiết suất cao 1.67, siêu mỏng và siêu nhẹ, nhập khẩu từ Nhật Bản. Lý tưởng cho người cận nặng từ 4.00 đến 8.00 độ muốn tròng kính mỏng, đẹp mắt.\n\n✅ Chỉ số chiết suất: 1.67 – mỏng hơn tròng 1.56 đến 25%\n✅ Xuất xứ: Nhật Bản – Seiko Japan hoặc Hoya Japan\n✅ Phạm vi độ: Cận -4.00 đến -8.00, loạn đến -3.50\n✅ Lớp phủ: Super multi-coat 9 lớp (AR + UV + Blue light + chống bụi + chống dầu)\n✅ Công nghệ: Free-form digital surfacing – mài CNC cá nhân hóa\n✅ Thời gian làm: 5-7 ngày làm việc\n✅ Bảo hành: 18 tháng\n\nVới tròng 1.67, người cận 6 độ có thể đeo gọng mảnh mà vẫn mỏng đẹp. Không còn cảm giác \"đáy ly bia\" nữa.',750000.00,650000.00,150,45,20,4.9,21,'/image/anhdanhmuc/gong-kinh.jpg','2026-04-20 03:00:00','Gucci',NULL,NULL,'Thường',0,1,'active'),(33,'Tròng Kính Pháp Essilor Crizal Forte UV','Tròng kính cao cấp hàng đầu thế giới của Essilor Pháp, dòng Crizal Forte UV – công nghệ chống phản chiếu tốt nhất hiện có. Là lựa chọn của các bác sĩ và chuyên gia thị giác toàn cầu.\n\n✅ Thương hiệu: Essilor – #1 thế giới về tròng kính quang học\n✅ Dòng sản phẩm: Crizal Forte UV – đỉnh cao công nghệ\n✅ Chiết suất: 1.50, 1.60, 1.67, 1.74 (4 lựa chọn)\n✅ Xuất xứ: Pháp\n✅ Lớp phủ: E-SPF 35 – chỉ số chống UV tốt nhất ngành\n✅ Bổ sung: Dust & water repellent, scratch resistant\n✅ Phạm vi độ: Cận đến -20.00, viễn đến +8.00\n✅ Bảo hành: 24 tháng tróc lớp, 12 tháng trầy xước\n\nEssilor Crizal là tròng kính được chỉ định nhiều nhất bởi bác sĩ nhãn khoa châu Âu. Xem thêm review của khách hàng trên website.',1200000.00,1050000.00,100,30,12,4.9,21,'/image/anhdanhmuc/gong-kinh.jpg','2026-04-21 02:00:00','Gucci',NULL,NULL,'Thường',0,1,'active'),(34,'Tròng Kính Viễn Thị + Đọc Sách 1.56 Hàn Quốc','Tròng kính dành riêng cho người viễn thị và cần thị, kể cả người lớn tuổi cần kính đọc sách. Chỉ số 1.56 với thiết kế đặc biệt cho tầm nhìn gần.\n\n✅ Chỉ số: 1.56 viễn thị\n✅ Phạm vi độ: Viễn +0.25 đến +6.00\n✅ Xuất xứ: Hàn Quốc\n✅ Màu tròng: Trong suốt hoặc tinted nhẹ theo yêu cầu\n✅ Lớp phủ: AR coating + UV protection\n✅ Phù hợp: Người trên 40 tuổi lão thị, trẻ em viễn thị bẩm sinh\n✅ Bảo hành: 12 tháng\n\nViễn thị nếu không đeo kính sớm dễ gây nhức đầu, mỏi mắt mãn tính. Đặt lịch khám mắt miễn phí tại cửa hàng để đo chính xác số kính.',380000.00,320000.00,120,25,10,4.7,21,'/image/anhdanhmuc/gong-kinh.jpg','2026-04-21 03:00:00','Ran-Bay',NULL,NULL,'Thường',0,0,'active'),(35,'Tròng Đổi Màu Transitions Signature Gen 8','Tròng kính đổi màu Transitions thế hệ 8 – nhanh nhất và đẹp nhất từ trước đến nay. Trong nhà gần như trong suốt, ra ánh sáng tự động tối và đổi màu trong 30 giây.\n\n✅ Thương hiệu: Transitions Optical – cha đẻ công nghệ tròng đổi màu\n✅ Thế hệ: Signature GEN 8 – nhanh hơn 30% so với đời trước\n✅ Ngoài nắng: Tối đến 80-85% trong 30-45 giây\n✅ Trong nhà: Nhạt đến 20% (gần như trong suốt)\n✅ Màu sắc tùy chọn: Xanh sapphire, nâu amber, xám graphite, xanh lá\n✅ Chiết suất: 1.50, 1.60, 1.67\n✅ Kết hợp: AR coating + UV400 + blue light filter\n✅ Bảo hành: 36 tháng\n\nLý tưởng cho người đi nhiều nơi, vào ra nhà thường xuyên. Không cần mang 2 cặp kính nữa. Thay thế hoàn hảo cho cả kính cận lẫn kính râm.',1500000.00,1300000.00,80,25,10,4.9,30,'/image/anhdanhmuc/trong-doi-mau.jpg','2026-04-22 02:00:00','Gucci',NULL,NULL,'Thường',0,1,'active'),(36,'Tròng Đổi Màu Hàn Quốc 1.56 Giá Tốt','Tròng đổi màu photochromic nhập khẩu từ Hàn Quốc, giá phổ thông nhưng chất lượng tốt, phù hợp cho người muốn trải nghiệm tròng đổi màu lần đầu mà chưa muốn đầu tư nhiều.\n\n✅ Xuất xứ: Hàn Quốc\n✅ Chiết suất: 1.56\n✅ Đổi màu: Xám hoặc nâu\n✅ Ngoài nắng: Tối 70% trong 60 giây\n✅ Trong nhà: Nhạt 30% sau 2-3 phút\n✅ Phạm vi độ: Cận -0.25 đến -6.00\n✅ Lớp phủ: AR coating + UV400\n✅ Bảo hành: 18 tháng\n\nLưu ý: Tròng đổi màu không tối khi ngồi trong xe ô tô vì kính xe chặn tia UV. Nên chọn thêm tròng phân cực nếu hay lái xe.',680000.00,580000.00,100,35,14,4.6,30,'/image/anhdanhmuc/trong-doi-mau.jpg','2026-04-22 03:00:00','Ran-Bay',NULL,NULL,'Thường',0,0,'active'),(37,'Tròng Phân Cực Nhật Bản 1.60 Cực Mỏng','Tròng phân cực (polarized) chỉ số 1.60 nhập từ Nhật Bản, kết hợp khả năng lọc ánh sáng phân cực và bảo vệ UV400. Lý tưởng cho tài xế, ngư dân, vận động viên ngoài trời.\n\n✅ Chiết suất: 1.60 – mỏng và nhẹ\n✅ Công nghệ: Polarized TAC multi-layer lamination\n✅ Lọc: 99.9% ánh sáng phân cực ngang\n✅ UV: 100% UVA + UVB\n✅ Màu: Nâu, xám, xanh lá (3 màu)\n✅ Xuất xứ: Nhật Bản\n✅ Phạm vi độ: Cận -0.25 đến -6.00 (có loạn)\n✅ Bảo hành: 18 tháng\n\nTài xế đường dài cực kỳ nên dùng tròng phân cực – giảm chói từ đường nhựa, mặt nước, kính xe khác. Tăng an toàn lái xe đáng kể.',820000.00,700000.00,90,28,11,4.8,31,'/image/anhdanhmuc/trong-chong-bui.jpg','2026-04-23 02:00:00','Gucci',NULL,NULL,'Phân cực',1,1,'active'),(38,'Tròng Kính Chống Tia UV 400 Bảo Vệ Mắt Toàn Diện','Tròng kính trong suốt với lớp phủ chống tia UV400 toàn diện, phù hợp cho cả kính cận lẫn kính không độ dùng hàng ngày dưới ánh nắng mặt trời Việt Nam.\n\n✅ Bảo vệ: UV400 – chặn 100% UVA (320-400nm) và UVB (280-320nm)\n✅ Tròng: Trong suốt, không màu\n✅ Chiết suất: 1.56\n✅ Lớp phủ: Multi-AR + UV block + anti-scratch\n✅ Phạm vi: Cận, viễn, loạn, không độ\n✅ Xuất xứ: Hàn Quốc\n✅ Lý do cần: Tia UV là nguyên nhân gây đục thủy tinh thể sớm\n\nNgay cả kính không độ cũng nên có lớp bảo vệ UV – đặc biệt quan trọng ở Việt Nam với chỉ số UV thường ở mức rất cao (8-12+) vào mùa hè.',350000.00,290000.00,150,50,18,4.7,31,'/image/anhdanhmuc/trong-chong-bui.jpg','2026-04-23 03:00:00','Ran-Bay',NULL,NULL,'Thường',1,0,'active'),(39,'Kính Áp Tròng Màu Hàn Quốc 1 Tháng - Xanh Đại Dương','Kính áp tròng màu (colored contact lens) nhập khẩu từ Hàn Quốc, màu xanh đại dương tự nhiên. Công nghệ màu sandwich không tiếp xúc mắt, an toàn tuyệt đối.\n\n✅ Xuất xứ: Hàn Quốc – Lenstown/O-Lens\n✅ Thời hạn sử dụng: 1 tháng (thay mỗi 30 ngày)\n✅ Màu sắc: Xanh đại dương – natural gradient\n✅ Đường kính: 14.2mm – phóng to và làm sáng mắt\n✅ Hàm lượng nước: 38% – thoải mái đeo cả ngày\n✅ Thời gian đeo: Tối đa 8 tiếng/ngày\n✅ Có độ: Không độ và cận từ -0.50 đến -8.00\n✅ Hộp: 2 chiếc/hộp (1 cặp)\n✅ Cần: Dung dịch rửa và ngâm lens\n\nKhông nên đeo khi đi bơi hoặc khi ngủ. Rửa tay sạch trước khi đeo/tháo lens. Kiểm tra hạn sử dụng trước khi dùng.',180000.00,150000.00,200,90,35,4.7,22,'/image/anhdanhmuc/kinh-ap-trong.jpg','2026-04-24 02:00:00','Ran-Bay','female',NULL,'Thường',0,1,'active'),(40,'Kính Áp Tròng Không Màu Cận Nhật Bản 1 Ngày','Kính áp tròng không màu dùng 1 ngày (daily disposable) nhập khẩu Nhật Bản, tiện lợi nhất và vệ sinh nhất. Không cần hộp, không cần dung dịch ngâm, dùng xong vứt.\n\n✅ Xuất xứ: Nhật Bản\n✅ Loại: Daily disposable – dùng 1 lần\n✅ Hàm lượng nước: 58% – cực thoải mái, ít khô mắt\n✅ Đường kính: 14.0mm\n✅ Độ cong cơ sở (BC): 8.6mm\n✅ Có độ: Cận -0.25 đến -10.00 (bước 0.25)\n✅ Hộp: 30 chiếc/hộp (dùng 30 ngày)\n✅ Ưu điểm: Không tích tụ vi khuẩn, không cần vệ sinh\n\nLens daily là lựa chọn an toàn nhất cho mắt. FDA khuyến nghị daily lens cho người mới đeo và người hay bị kích ứng mắt.',350000.00,300000.00,150,60,22,4.8,22,'/image/anhdanhmuc/kinh-ap-trong.jpg','2026-04-24 03:00:00','Gucci','unisex',NULL,'Thường',0,0,'active'),(41,'Lens Màu Nâu Rêu Natural Hàn Quốc 3 Tháng','Lens màu nâu rêu (olive brown) thiên nhiên, tạo ánh mắt sâu thẳm và cuốn hút mà vẫn tự nhiên như màu mắt thật. Hot nhất trên thị trường lens màu hiện nay.\n\n✅ Màu: Nâu rêu olive – màu hot nhất 2024-2025\n✅ Thời hạn: 3 tháng\n✅ Đường kính đồ họa: 13.8mm – phóng to tự nhiên\n✅ Hàm lượng nước: 42%\n✅ Công nghệ màu: Sandwichcolour – màu không tiếp xúc giác mạc\n✅ Thời gian đeo: Tối đa 8h/ngày\n✅ Xuất xứ: Hàn Quốc – thương hiệu Olens\n✅ Phù hợp: Da ngăm, da sáng đều đẹp\n\nMàu nâu rêu tương phản đẹp với đa số màu da người Á, tạo vẻ huyền bí, lôi cuốn. Được các beauty blogger Việt Nam review rất tích cực.',220000.00,190000.00,300,120,45,4.8,32,'/image/anhdanhmuc/lens-mau.jpg','2026-04-25 02:00:00','Ran-Bay','female',NULL,'Thường',0,1,'active'),(42,'Lens Màu Xám Khói Style Hàn Quốc Cao Cấp','Lens màu xám khói sang trọng, lạnh lùng – phong cách Hàn Quốc đang cực thịnh. Tạo ánh mắt sắc bén, cá tính, lý tưởng cho buổi chụp ảnh, sự kiện hoặc thường ngày.\n\n✅ Màu: Xám khói gradient từ rìa đen đến xám nhạt giữa\n✅ Thương hiệu: Lensme Korea\n✅ Thời hạn: 3 tháng\n✅ Đường kính đồ họa: 14.0mm\n✅ Hàm lượng nước: 38%\n✅ Công nghệ: 3-tone color blending\n✅ Có độ: Không độ và cận đến -6.00\n✅ Hộp: 2 chiếc/hộp\n\nXám khói là màu lens được search nhiều nhất trên các nền tảng mạng xã hội Việt Nam. Tạo vẻ ngoài ấn tượng, khác biệt ngay lập tức.',250000.00,210000.00,250,100,38,4.7,32,'/image/anhdanhmuc/lens-mau.jpg','2026-04-25 03:00:00','Ran-Bay','female',NULL,'Thường',0,0,'active'),(43,'Lens Cận Không Màu 1 Tháng Acuvue Oasys','Lens cận không màu dòng Acuvue Oasys với Hydraclear Plus – công nghệ giữ ẩm tiên tiến nhất của Johnson & Johnson, phù hợp cho người khô mắt.\n\n✅ Thương hiệu: Acuvue Oasys (Johnson & Johnson)\n✅ Công nghệ: Hydraclear Plus – lớp chất giữ ẩm cài vào lens\n✅ Hàm lượng nước: 38% Senofilcon A\n✅ Thời hạn: 2 tuần (bi-weekly)\n✅ Chỉ số Dk/t: 147 – cao, giúp mắt thở tốt\n✅ Chống UV: Loại 1 (cao nhất)\n✅ Có độ: -0.25 đến -12.00 và +0.25 đến +8.00\n✅ Hộp: 6 chiếc/hộp\n\nAcuvue Oasys là lens cận được bác sĩ nhãn khoa kê nhiều nhất thế giới. Đặc biệt phù hợp người làm việc AC lạnh hoặc hay nhìn màn hình nhiều giờ.',420000.00,370000.00,120,50,20,4.9,33,'/image/anhdanhmuc/lens-can-vien.jpg','2026-04-26 02:00:00','Gucci','unisex',NULL,'Thường',1,1,'active'),(44,'Lens Cận Hàn Quốc 1 Tháng Giá Sinh Viên','Lens cận không màu nhập khẩu Hàn Quốc, chất lượng tốt với mức giá phù hợp sinh viên và người mới bắt đầu dùng lens.\n\n✅ Xuất xứ: Hàn Quốc\n✅ Thời hạn: 1 tháng\n✅ Hàm lượng nước: 45% – thoải mái\n✅ Đường kính: 14.0mm\n✅ Có độ: Cận -0.25 đến -8.00\n✅ Hộp: 2 chiếc/hộp\n✅ Bảo quản: Cần dung dịch ngâm và hộp lens\n\nLý tưởng cho người muốn thử dùng lens lần đầu với chi phí hợp lý. Hướng dẫn đeo/tháo lens miễn phí tại cửa hàng.',120000.00,99000.00,400,180,65,4.6,33,'/image/anhdanhmuc/lens-can-vien.jpg','2026-04-26 03:00:00','Ran-Bay','unisex',NULL,'Thường',0,0,'active'),(45,'Dung Dịch Rửa Kính Áp Tròng All-In-One 360ml','Dung dịch đa năng cho kính áp tròng mềm – làm sạch, khử khuẩn, tráng rửa, lưu trữ chỉ với 1 sản phẩm. Tiện lợi và an toàn cho mọi loại lens mềm.\n\n✅ Công dụng: Làm sạch + khử khuẩn + ngâm bảo quản\n✅ Thể tích: 360ml\n✅ Thành phần: Polyhexamethylene Biguanide 0.0001%\n✅ pH: 7.0-7.4 – tương thích hoàn toàn với nước mắt\n✅ Tương thích: Mọi loại soft lens\n✅ Hạn sử dụng sau mở: 3 tháng\n✅ Xuất xứ: Nhật Bản\n✅ Kèm: Hộp đựng lens 2 ngăn\n\nSau mỗi lần tháo lens, phải chà rửa lens bằng dung dịch này rồi mới ngâm. Không dùng nước máy hay nước cất để thay thế dung dịch lens.',120000.00,99000.00,300,150,55,4.8,23,'/image/anhdanhmuc/phu-kien.jpeg','2026-04-20 01:00:00','Ran-Bay',NULL,NULL,'Thường',0,0,'active'),(46,'Nước Rửa Kính Mắt Kính Gọng Nano 100ml','Dung dịch làm sạch kính gọng (kính cận, kính mát, kính chống ánh sáng xanh) công thức Nano, tẩy sạch dầu, bụi bẩn, dấu vân tay mà không ăn mòn lớp phủ AR.\n\n✅ Thể tích: 100ml (đủ dùng khoảng 3-4 tháng)\n✅ Công thức: Nano surfactant – làm sạch cấp độ nano\n✅ An toàn: Không cồn, không acid – bảo vệ lớp AR coating\n✅ Tiện lợi: Chai xịt với đầu phun sương mịn\n✅ Kèm theo: Khăn microfiber 30x30cm\n✅ Tương thích: Tất cả loại tròng và lớp phủ kính\n✅ Xuất xứ: Hàn Quốc\n\nNên vệ sinh kính gọng ít nhất 2 lần/tuần để bảo vệ lớp phủ và kéo dài tuổi thọ tròng kính. Không dùng cồn hay nước nóng để lau kính.',65000.00,55000.00,500,250,80,4.7,23,'/image/anhdanhmuc/nuoc-rua-kinh.jpg','2026-04-20 02:00:00','Ran-Bay',NULL,NULL,'Thường',0,0,'active'),(47,'Hộp Kính Da Cao Cấp Khóa Nam Châm','Hộp đựng kính làm từ da PU cao cấp với lớp lót nhung mềm bên trong, thiết kế khóa nam châm tiện lợi, bảo vệ kính khỏi va đập và trầy xước.\n\n✅ Chất liệu ngoài: Da PU cao cấp\n✅ Lớp lót: Nhung mềm không trầy kính\n✅ Kích thước: 16.5 x 7 x 5cm – vừa hầu hết gọng\n✅ Khóa: Nam châm siêu mạnh, đóng mở êm ái\n✅ Màu sắc: Đen, nâu, xanh navy, đỏ đô\n✅ Kèm: Khăn microfiber + hộp giấy gift-ready\n✅ Phù hợp làm quà tặng sinh nhật, tốt nghiệp\n\nHộp kính tốt kéo dài đáng kể tuổi thọ của gọng kính. Đặc biệt quan trọng với kính giá trị cao hay gọng Titanium, Acetate.',150000.00,120000.00,200,85,30,4.7,34,'/image/anhdanhmuc/hop-kinh.jpg','2026-04-21 01:00:00','Ran-Bay',NULL,NULL,'Thường',0,0,'active'),(48,'Hộp Kính Cứng Metal Siêu Bền Chống Va Đập','Hộp kính vỏ kim loại cứng được sơn tĩnh điện, thiết kế chống va đập cực tốt, bảo vệ kính ngay cả khi bị rơi hoặc đặt đồ lên.\n\n✅ Chất liệu: Vỏ nhôm alloy siêu cứng\n✅ Lớp lót: Foam EVA + nhung microfiber\n✅ Khóa: Snap-lock bật ra tự động\n✅ Kích thước: 17 x 7.5 x 6cm\n✅ Chịu lực: Test thả từ 1m xuống đất cứng vẫn bảo vệ tốt kính bên trong\n✅ Màu sắc: Bạc, đen, vàng đồng\n✅ Kèm: Dây đeo tay, khăn lau\n\nLựa chọn số 1 cho người hay đi lại, du lịch, mang kính trong hành lý. Hộp kim loại chịu lực tốt hơn hộp nhựa hay da 3-5 lần.',220000.00,185000.00,120,40,15,4.8,34,'/image/anhdanhmuc/hop-kinh.jpg','2026-04-21 02:00:00','Gucci',NULL,NULL,'Thường',0,0,'active'),(49,'Bộ Vệ Sinh Kính Toàn Diện 5 Món','Bộ vệ sinh kính gọng và kính áp tròng đầy đủ nhất trên thị trường, gồm 5 sản phẩm thiết yếu đóng gói trong hộp quà tiện lợi.\n\n✅ Bao gồm: \n  1. Nước rửa kính gọng 100ml\n  2. Khăn microfiber 30x30cm (2 chiếc)\n  3. Khăn lau Nano siêu sạch 15x15cm\n  4. Dụng cụ chỉnh vít gọng kính (2 đầu)\n  5. Hộp đựng nhỏ đi du lịch\n✅ Không cồn, không làm mờ tròng\n✅ Phù hợp: Kính cận, kính mát, kính chống xanh\n✅ Xuất xứ: Hàn Quốc\n✅ Ý tưởng quà tặng: Phù hợp tặng cho người thân đang đeo kính\n\nBộ 5 món tiết kiệm hơn 30% so với mua lẻ. Giao hàng có hộp quà ngay khi đặt.',185000.00,155000.00,150,60,22,4.8,35,'/image/anhdanhmuc/nuoc-rua-kinh.jpg','2026-04-22 01:00:00','Ran-Bay',NULL,NULL,'Thường',0,1,'active'),(50,'Khăn Lau Kính Nano Siêu Thấm Chống Bụi 5 Chiếc','Bộ 5 khăn lau kính chất liệu Nano microfiber cao cấp, sợi nano siêu mịn lau sạch bụi bẩn, dầu nhờn, dấu vân tay mà không để lại vệt hay làm xước tròng kính.\n\n✅ Chất liệu: Nano microfiber 400GSM\n✅ Kích thước: 20x20cm/chiếc (lớn hơn khăn thông thường)\n✅ Số lượng: 5 chiếc/bộ (đủ màu dễ phân biệt)\n✅ Công dụng: Lau kính gọng, màn hình điện thoại, laptop, tablet\n✅ Giặt được: Máy giặt bình thường, tái sử dụng 300+ lần\n✅ Không xơ vải: Không để lại sợi vải trên kính\n✅ Kháng khuẩn: Kháng 99% vi khuẩn E.Coli và Staphylococcus\n\nKhăn microfiber Nano tốt hơn khăn cotton thông thường vì sợi siêu nhỏ luồn vào các khe lấy bụi ra thay vì chỉ đẩy bụi sang nơi khác.',75000.00,62000.00,400,200,75,4.7,35,'/image/anhdanhmuc/nuoc-rua-kinh.jpg','2026-04-22 02:00:00','Ran-Bay',NULL,NULL,'Thường',0,0,'active'),(51,'Kính Mát Phân Cực Chống UV Cao Cấp Nam Gọng Bán Viền','Kính mát nam gọng bán viền (semi-rimless) với tròng phân cực cao cấp, thiết kế tối giản sang trọng phù hợp công sở lẫn dã ngoại cuối tuần.\n\n✅ Tròng: TAC Polarized + UV400\n✅ Kiểu gọng: Semi-rimless – bán viền trên\n✅ Gọng: Titanium siêu nhẹ\n✅ Màu tròng: Xám phân cực, nâu phân cực\n✅ Kích thước: 58mm – phù hợp mặt vừa và to\n✅ Trọng lượng: 16g\n✅ Phù hợp: Lái xe, câu cá, đi biển\n\nGọng bán viền tạo tầm nhìn thông thoáng hơn gọng đầy, phù hợp người mặt dài. Tròng phân cực giảm 100% chói loá từ mặt đường và mặt nước.',680000.00,580000.00,40,14,5,4.7,19,'/image/anhdanhmuc/kinh-ram.jpg','2026-04-27 01:00:00','Gucci','male','Titanium','Phân cực',1,0,'active'),(52,'Gọng Kính Nữ Kim Loại Mảnh Minimalist','Gọng kính nữ kim loại siêu mảnh, phong cách tối giản (minimalist) đang là xu hướng thời trang 2024-2025. Thiết kế không cầu kỳ nhưng cực kỳ tinh tế và sang trọng.\n\n✅ Chất liệu: Stainless steel 316L mạ vàng rose gold\n✅ Kiểu dáng: Mắt oval nhỏ – minimalist chic\n✅ Độ dày gọng: 0.9mm – siêu mảnh\n✅ Kích thước: 50-19-138mm\n✅ Màu: Rose gold, silver, gold\n✅ Phù hợp: Mặt tròn, oval, trái xoan\n✅ Lắp được: Tròng cận, viễn, chống xanh\n\nPhong cách minimalist đang chiếm lĩnh feed Instagram và Pinterest thời trang. Một chiếc gọng đẹp nâng tầm cả outfit.',520000.00,440000.00,55,18,7,4.6,18,'/image/anhdanhmuc/gong-can.jpg','2026-04-27 02:00:00','Gucci','female','Stainless Steel','Thường',0,0,'active'),(53,'Tròng Đa Tròng Progressive Essilor 1.60 Nhật','Tròng đa tròng (progressive/bifocal) cao cấp Essilor chiết suất 1.60, phù hợp cho người trên 40 tuổi bị lão thị cần nhìn rõ cả xa lẫn gần trên một cặp kính duy nhất.\n\n✅ Loại: Progressive – nhìn rõ xa, trung và gần\n✅ Thương hiệu: Essilor Varilux X series\n✅ Chiết suất: 1.60\n✅ Công nghệ: Xtend™ – vùng nhìn rõ lớn hơn 30%\n✅ Thích nghi: 80% người đeo quen trong 3-5 ngày\n✅ Phạm vi: Cận đến -8 + Add đến +3.50\n✅ Bảo hành: 24 tháng + 6 tháng đổi trả nếu không thích nghi được\n\nTròng đa tròng là giải pháp hoàn hảo cho người lớn tuổi không muốn mang 2 cặp kính. Cần đo mắt chuyên sâu và fitting chính xác – dịch vụ miễn phí tại cửa hàng.',2200000.00,1900000.00,30,8,3,4.9,21,'/image/anhdanhmuc/gong-kinh.jpg','2026-04-27 03:00:00','Gucci',NULL,NULL,'Thường',0,1,'active'),(54,'Lens Màu Xanh Ngọc Lục Bảo Emerald Hàn Quốc','Lens màu xanh ngọc lục bảo hiếm và độc đáo, tạo ánh mắt ấn tượng như nhân vật trong truyện tranh. Màu sắc huyền bí, phù hợp cosplay, chụp ảnh nghệ thuật và thời trang.\n\n✅ Màu: Emerald xanh ngọc – 3-tone gradient\n✅ Xuất xứ: Hàn Quốc – Dueba\n✅ Đường kính đồ họa: 14.5mm – phóng to ấn tượng\n✅ Thời hạn: 1 năm (không đeo liên tục)\n✅ Hàm lượng nước: 38%\n✅ Thời gian đeo: Tối đa 6 tiếng\n✅ Có độ: Không độ và cận đến -6.00\n\nMàu emerald rất nổi bật trong ảnh chụp studio và outdoor. Được nhiều cosplayer và nhiếp ảnh gia chọn dùng.',280000.00,240000.00,180,70,25,4.6,32,'/image/anhdanhmuc/lens-mau.jpg','2026-04-27 04:00:00','Ran-Bay','female',NULL,'Thường',0,0,'active'),(55,'Kính Chống Ánh Sáng Xanh Trẻ Em 6-12 Tuổi','Kính chống ánh sáng xanh thiết kế đặc biệt cho trẻ em từ 6-12 tuổi, bảo vệ đôi mắt đang phát triển khỏi tác hại của màn hình điện thoại và máy tính.\n\n✅ Tròng: Blue light blocking 95% + UV400\n✅ Gọng: TR90 siêu nhẹ + siêu dẻo – chống gãy hoàn toàn\n✅ Thiết kế: Màu sắc tươi sáng thu hút trẻ em thích đeo\n✅ Size: Đặc biệt cho trẻ em 6-12 tuổi (kích thước nhỏ)\n✅ An toàn: Không BPA, không kim loại nặng – CE kids certified\n✅ Màu: Xanh, hồng, vàng, tím\n✅ Kèm: Dây đeo chống rơi, hộp đựng hình thú\n\nTrẻ em tiếp xúc màn hình từ 3-6 giờ/ngày. Ánh sáng xanh ảnh hưởng nặng hơn đến mắt trẻ vì thủy tinh thể chưa lọc được tốt. Bảo vệ sớm là bảo vệ tương lai.',380000.00,320000.00,70,25,10,4.8,20,'/image/anhdanhmuc/anh-sang-xanh.jpg','2026-04-27 05:00:00','Ran-Bay','unisex','TR90','Chống ánh sáng xanh',0,1,'active'),(56,'Kính Mát Trẻ Em Phân Cực UV400 Chống Gãy','Kính mát dành riêng cho trẻ em với tròng phân cực bảo vệ UV400, gọng TR90 siêu dẻo không gãy. Bảo vệ đôi mắt nhỏ khỏi tia nắng mặt trời nguy hiểm.\r\n\r\n✅ Tròng: TAC polarized + UV400\r\n✅ Gọng: TR90 – không gãy dù bẻ ngược\r\n✅ Kích thước: S (3-6 tuổi) và M (6-12 tuổi)\r\n✅ Màu tròng: Xám, nâu, hồng, xanh\r\n✅ Thiết kế: Không cạnh sắc, không đinh nhọn\r\n✅ Dây: Có dây đeo elastic kèm theo\r\n✅ Chứng nhận: EN ISO 12312-1 Châu Âu\r\n\r\nTia UV gây hại cho mắt trẻ em nghiêm trọng hơn người lớn vì thủy tinh thể trẻ em trong suốt hơn. Hãy bảo vệ mắt con từ sớm!',320000.00,270000.00,60,20,8,4.7,19,'/image/anhdanhmuc/kinh-ram.jpg','2026-04-27 06:00:00','Ran-Bay','unisex','TR90','Phân cực',0,0,'active');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_replies`
--

DROP TABLE IF EXISTS `review_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_replies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `user_id` int NOT NULL,
  `reply_text` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `review_id` (`review_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `review_replies_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `product_reviews` (`id`) ON DELETE CASCADE,
  CONSTRAINT `review_replies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_replies`
--

LOCK TABLES `review_replies` WRITE;
/*!40000 ALTER TABLE `review_replies` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','approved','hidden') DEFAULT 'approved',
  `images` text COMMENT 'Lưu JSON array của ảnh',
  `helpful_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping`
--

DROP TABLE IF EXISTS `shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `shipping_method` varchar(100) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `shipping_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping`
--

LOCK TABLES `shipping` WRITE;
/*!40000 ALTER TABLE `shipping` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `phone` varchar(20) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','banned') DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `login_attempts` int DEFAULT '0',
  `locked_until` timestamp NULL DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` timestamp NULL DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'phansytu','hot98777@gmail.com','$2a$12$yg19HbOeVZrQWmi/YQvZcOmggmun5LNP.yL8Dcj9N06FYVkdUdVoi','admin','2026-04-09 14:36:13','0365945842',NULL,'active','2026-05-12 06:59:51',0,NULL,NULL,NULL,'Nam','2005-08-24',NULL,NULL),(3,'phansytu1','tu674137@gmail.com','$2a$12$zP13Y30JBRWkf8dmfiftcukTkecSuEMQkfWvtzYhoevz1muv3cl4q','user','2026-04-09 15:35:05',NULL,'Phan Sỹ Tú','active','2026-05-13 06:52:12',0,NULL,NULL,NULL,NULL,NULL,'/BanKinhThoiTrang/uploads/avatars/4362b37d-c491-4c4a-988d-85cb27b171d1_1776842248235.jpg',NULL),(4,'phansytu12','phansytu02@gmail.com','$2a$12$HpIPSOyYNfAMRurNJ0P1yO.Qz3j6fnt3LgEVOQWS2aD1eyJeTxYdy','user','2026-04-14 17:37:36',NULL,'Phan Sỹ Tú','active',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'daovankhanh','khanhdao@gmail.com','$2a$12$cEKwVxX6vYM.VUw4sa0z7etOiMgFIYvVikTil5eAp/J9bzaGbGIlW','user','2026-04-16 06:32:26',NULL,'Đào Văn Khánh','active','2026-04-16 06:48:17',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'vuquanghuy','vuquanghuyabc1405@gmail.com','$2a$12$9m7mPK8uhkj7.heyTg/QOOfN.6ThTwb7a4n1.gvyNqtfnJ7Qpoos6','user','2026-04-19 11:21:09',NULL,'vũ quang huy','active','2026-04-19 11:21:27',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `discount_percent` int DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `max_usage` int DEFAULT '1',
  `used_count` int DEFAULT '0',
  `expiry_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-13 14:39:24
