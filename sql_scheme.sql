
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `callEvents`
--

DROP TABLE IF EXISTS `callEvents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callEvents` (
  `type` enum('callStart','callEnd') DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `recordIndex` int(11) DEFAULT NULL,
  `correlatorIndex` int(11) NOT NULL DEFAULT '0',
  `call` varchar(255) DEFAULT NULL,
  `session` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`correlatorIndex`,`session`),
  KEY `call` (`call`),
  CONSTRAINT `callEvents_ibfk_1` FOREIGN KEY (`call`) REFERENCES `calls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `callLegEvents`
--

DROP TABLE IF EXISTS `callLegEvents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callLegEvents` (
  `type` enum('callLegStart','callLegEnd','callLegUpdate') DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `recordIndex` int(11) DEFAULT NULL,
  `correlatorIndex` int(11) NOT NULL DEFAULT '0',
  `callLeg` varchar(255) DEFAULT NULL,
  `session` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`correlatorIndex`,`session`),
  KEY `callLeg` (`callLeg`),
  CONSTRAINT `callLegEvents_ibfk_1` FOREIGN KEY (`callLeg`) REFERENCES `callLegs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `callLegs`
--

DROP TABLE IF EXISTS `callLegs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callLegs` (
  `id` varchar(48) NOT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `remoteParty` varchar(255) DEFAULT NULL,
  `displayName` varchar(255) DEFAULT NULL,
  `type` enum('acano','sip') DEFAULT NULL,
  `subType` enum('sip','lync','avaya') DEFAULT NULL,
  `lyncSubType` enum('audioVideo','applicationSharing','instantMessaging') DEFAULT NULL,
  `direction` enum('incomming','outgoing') DEFAULT NULL,
  `localAddress` varchar(255) DEFAULT NULL,
  `remoteAddress` varchar(255) DEFAULT NULL,
  `cdrTag` varchar(255) DEFAULT NULL,
  `guestConnection` tinyint(1) DEFAULT NULL,
  `recording` tinyint(1) DEFAULT NULL,
  `streaming` tinyint(1) DEFAULT NULL,
  `call` varchar(255) DEFAULT NULL,
  `ownerId` varchar(255) DEFAULT NULL,
  `sipCallId` varchar(255) DEFAULT NULL,
  `groupId` varchar(255) DEFAULT NULL,
  `replacesSipCallId` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `remoteTeardown` tinyint(1) DEFAULT NULL,
  `encryptedMedia` tinyint(1) DEFAULT NULL,
  `unencryptedMedia` tinyint(1) DEFAULT NULL,
  `durationSeconds` int(11) DEFAULT NULL,
  `mediaUsagePercentages` varchar(255) DEFAULT NULL,
  `alarm` varchar(255) DEFAULT NULL,
  `rxVideo` varchar(255) DEFAULT NULL,
  `txVideo` varchar(255) DEFAULT NULL,
  `rxAudio` varchar(255) DEFAULT NULL,
  `txAudio` varchar(255) DEFAULT NULL,
  `connected` datetime DEFAULT NULL,
  `state` enum('connected') DEFAULT NULL,
  `deactivated` tinyint(1) DEFAULT NULL,
  `activatedDuration` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `calls`
--

DROP TABLE IF EXISTS `calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calls` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `coSpace` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `tenant` varchar(255) DEFAULT NULL,
  `cdrTag` varchar(255) DEFAULT NULL,
  `callCorrelator` varchar(255) DEFAULT NULL,
  `callType` enum('coSpace','adHoc','lyncConferencing','forwarding') DEFAULT NULL,
  `callLegsCompleted` int(11) DEFAULT NULL,
  `callLegsMaxActive` int(11) DEFAULT NULL,
  `durationSeconds` int(11) DEFAULT NULL,
  `ownerName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

