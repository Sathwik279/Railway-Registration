-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: railway_db
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `train_id` int DEFAULT NULL,
  `journey_date` date NOT NULL,
  `from_station_id` int DEFAULT NULL,
  `to_station_id` int DEFAULT NULL,
  `booking_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `user_id` (`user_id`),
  KEY `train_id` (`train_id`),
  KEY `from_station_id` (`from_station_id`),
  KEY `to_station_id` (`to_station_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`),
  CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`from_station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `bookings_ibfk_4` FOREIGN KEY (`to_station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` int NOT NULL,
  `station_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `station_name` (`station_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (204,'bhimadolu'),(209,'bhimavaram'),(201,'dwarapudi'),(205,'eluru'),(203,'nidadavolu'),(207,'nuzivid'),(206,'powerpet'),(202,'rajahmundry'),(208,'vijayawada');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_routes`
--

DROP TABLE IF EXISTS `train_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_routes` (
  `train_id` int NOT NULL,
  `stop_order` int NOT NULL,
  `station_id` int DEFAULT NULL,
  PRIMARY KEY (`train_id`,`stop_order`),
  UNIQUE KEY `train_id` (`train_id`,`station_id`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `train_routes_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`),
  CONSTRAINT `train_routes_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_routes`
--

LOCK TABLES `train_routes` WRITE;
/*!40000 ALTER TABLE `train_routes` DISABLE KEYS */;
INSERT INTO `train_routes` VALUES (102,1,201),(103,1,201),(101,1,202),(102,2,202),(103,2,202),(101,2,203),(103,3,203),(103,4,204),(101,3,205),(103,5,205),(103,6,206),(103,7,207),(101,4,208),(102,4,208),(103,8,208),(102,3,209);
/*!40000 ALTER TABLE `train_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_running_days`
--

DROP TABLE IF EXISTS `train_running_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_running_days` (
  `train_id` int NOT NULL,
  `day_of_week` tinyint NOT NULL,
  PRIMARY KEY (`train_id`,`day_of_week`),
  CONSTRAINT `train_running_days_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_running_days`
--

LOCK TABLES `train_running_days` WRITE;
/*!40000 ALTER TABLE `train_running_days` DISABLE KEYS */;
INSERT INTO `train_running_days` VALUES (101,1),(101,3),(101,5),(102,2),(102,4),(102,6),(103,1),(103,2),(103,3),(103,4),(103,5),(103,6),(103,7);
/*!40000 ALTER TABLE `train_running_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_station_schedules`
--

DROP TABLE IF EXISTS `train_station_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_station_schedules` (
  `train_id` int NOT NULL,
  `station_id` int NOT NULL,
  `arrival_time` time DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  `day_offset` int DEFAULT NULL,
  PRIMARY KEY (`train_id`,`station_id`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `train_station_schedules_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`),
  CONSTRAINT `train_station_schedules_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_station_schedules`
--

LOCK TABLES `train_station_schedules` WRITE;
/*!40000 ALTER TABLE `train_station_schedules` DISABLE KEYS */;
INSERT INTO `train_station_schedules` VALUES (101,202,NULL,'06:00:00',0),(101,203,'06:45:00','06:50:00',0),(101,205,'08:00:00','08:05:00',0),(101,208,'10:00:00',NULL,0),(102,201,NULL,'22:30:00',0),(102,202,'23:45:00','22:50:00',0),(102,208,'04:00:00',NULL,1),(102,209,'01:30:00','01:35:00',1),(103,201,NULL,'21:00:00',0),(103,202,'22:30:00','22:35:00',0),(103,203,'23:15:00','23:20:00',0),(103,204,'00:10:00','00:15:00',1),(103,205,'01:00:00','01:05:00',1),(103,206,'01:30:00','01:35:00',1),(103,207,'02:10:00','02:15:00',1),(103,208,'04:30:00',NULL,1);
/*!40000 ALTER TABLE `train_station_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `train_id` int NOT NULL,
  `train_name` varchar(100) NOT NULL,
  `total_seats` int NOT NULL,
  PRIMARY KEY (`train_id`),
  UNIQUE KEY `train_name` (`train_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (101,'ratnachal',10),(102,'simhadri',8),(103,'memu',20);
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'santosh'),(1,'sathwik');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-19 10:45:43
