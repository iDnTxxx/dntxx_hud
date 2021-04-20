-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.8-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para dntxx
CREATE DATABASE IF NOT EXISTS `dntxx` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `dntxx`;

-- Copiando estrutura para tabela cloud.phone_app_chat
CREATE TABLE IF NOT EXISTS `phone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela cloud.phone_app_chat: ~0 rows (aproximadamente)
DELETE FROM `phone_app_chat`;
/*!40000 ALTER TABLE `phone_app_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_app_chat` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.phone_calls
CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(10) NOT NULL COMMENT 'Num tel proprio',
  `num` varchar(10) NOT NULL COMMENT 'Num reférence du contact',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela cloud.phone_calls: ~0 rows (aproximadamente)
DELETE FROM `phone_calls`;
/*!40000 ALTER TABLE `phone_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_calls` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela cloud.phone_messages: 0 rows
DELETE FROM `phone_messages`;
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.phone_users_contacts
CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela cloud.phone_users_contacts: 0 rows
DELETE FROM `phone_users_contacts`;
/*!40000 ALTER TABLE `phone_users_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_users_contacts` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.twitter_accounts
CREATE TABLE IF NOT EXISTS `twitter_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Copiando dados para a tabela cloud.twitter_accounts: ~0 rows (aproximadamente)
DELETE FROM `twitter_accounts`;
/*!40000 ALTER TABLE `twitter_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_accounts` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.twitter_likes
CREATE TABLE IF NOT EXISTS `twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_likes_twitter_accounts` (`authorId`),
  KEY `FK_twitter_likes_twitter_tweets` (`tweetId`),
  CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`),
  CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Copiando dados para a tabela cloud.twitter_likes: ~0 rows (aproximadamente)
DELETE FROM `twitter_likes`;
/*!40000 ALTER TABLE `twitter_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_likes` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.twitter_tweets
CREATE TABLE IF NOT EXISTS `twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_tweets_twitter_accounts` (`authorId`),
  CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela cloud.twitter_tweets: ~0 rows (aproximadamente)
DELETE FROM `twitter_tweets`;
/*!40000 ALTER TABLE `twitter_tweets` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_tweets` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_business
CREATE TABLE IF NOT EXISTS `vrp_business` (
  `user_id` int(11) NOT NULL,
  `capital` int(11) DEFAULT NULL,
  `laundered` int(11) DEFAULT NULL,
  `reset_timestamp` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_business_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_business: ~0 rows (aproximadamente)
DELETE FROM `vrp_business`;
/*!40000 ALTER TABLE `vrp_business` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_business` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_estoque
CREATE TABLE IF NOT EXISTS `vrp_estoque` (
  `vehicle` varchar(100) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_estoque: ~316 rows (aproximadamente)
DELETE FROM `vrp_estoque`;
/*!40000 ALTER TABLE `vrp_estoque` DISABLE KEYS */;
INSERT INTO `vrp_estoque` (`vehicle`, `quantidade`, `user_id`) VALUES
	('blista', 9, 1),
	('brioso', 9, 2),
	('emperor', 9, 3),
	('emperor2', 9, 4),
	('dilettante', 9, 5),
	('issi2', 9, 6),
	('panto', 10, 7),
	('prairie', 10, 8),
	('rhapsody', 10, 9),
	('cogcabrio', 10, 10),
	('exemplar', 10, 11),
	('f620', 10, 12),
	('felon', 10, 13),
	('ingot', 10, 14),
	('jackal', 10, 15),
	('oracle', 10, 16),
	('oracle2', 10, 17),
	('sentinel', 10, 18),
	('sentinel', 10, 19),
	('windsor', 10, 20),
	('windsor2', 10, 21),
	('zion', 10, 22),
	('zion2', 10, 23),
	('blade', 10, 24),
	('buccaneer', 10, 25),
	('buccaneer2', 10, 26),
	('primo', 10, 27),
	('chino', 10, 28),
	('coquette3', 10, 29),
	('dukes', 10, 30),
	('faction', 10, 31),
	('faction3', 10, 32),
	('gauntlet', 10, 33),
	('gauntlet2', 10, 34),
	('hermes', 10, 35),
	('hotknife', 10, 36),
	('moonbeam', 10, 37),
	('moonbeam2', 10, 38),
	('nightshade', 10, 39),
	('picador', 10, 40),
	('ruiner', 10, 41),
	('sabregt', 10, 42),
	('sabregt2', 10, 43),
	('slamvan', 10, 44),
	('slamvan3', 10, 45),
	('stalion', 10, 46),
	('stalion2', 10, 47),
	('tampa', 10, 48),
	('vigero', 10, 49),
	('virgo', 10, 50),
	('virgo2', 10, 51),
	('virgo3', 10, 52),
	('voodoo', 10, 53),
	('voodoo2', 10, 54),
	('yosemite', 10, 55),
	('bfinjection', 10, 56),
	('bifta', 10, 57),
	('bodhi2', 10, 58),
	('brawler', 10, 59),
	('trophytruck', 10, 60),
	('trophytruck2', 10, 61),
	('dubsta3', 10, 62),
	('mesa3', 10, 63),
	('rancherxl', 10, 64),
	('rebel2', 10, 65),
	('riata', 10, 66),
	('dloader', 10, 67),
	('sandking', 10, 68),
	('sandking2', 10, 69),
	('baller', 10, 70),
	('baller2', 10, 71),
	('baller3', 10, 72),
	('baller4', 5, 73),
	('baller5', 3, 74),
	('baller6', 3, 75),
	('bjxl', 10, 76),
	('cavalcade', 10, 77),
	('cavalcade2', 10, 78),
	('dubsta', 10, 79),
	('dubsta2', 10, 80),
	('fq2', 10, 81),
	('granger', 10, 82),
	('gresley', 10, 83),
	('habanero', 10, 84),
	('seminole', 10, 85),
	('serrano', 10, 86),
	('xls', 10, 87),
	('xls2', 10, 88),
	('asea', 10, 89),
	('asterope', 10, 90),
	('cog552', 10, 91),
	('cognoscenti', 10, 92),
	('cognoscenti2', 10, 93),
	('stanier', 10, 94),
	('stratum', 10, 95),
	('surge', 10, 96),
	('tailgater', 10, 97),
	('warrener', 10, 98),
	('washington', 10, 99),
	('alpha', 10, 100),
	('banshee', 10, 101),
	('bestiagts', 10, 102),
	('blista2', 10, 103),
	('blista3', 10, 104),
	('buffalo', 10, 105),
	('buffalo2', 10, 106),
	('buffalo3', 10, 107),
	('carbonizzare', 10, 108),
	('comet2', 10, 109),
	('comet3', 10, 110),
	('comet5', 10, 111),
	('coquette', 10, 112),
	('elegy', 10, 113),
	('elegy2', 10, 114),
	('feltzer2', 10, 115),
	('furoregt', 10, 116),
	('fusilade', 10, 117),
	('futo', 10, 118),
	('jester', 10, 119),
	('khamelion', 10, 120),
	('kuruma', 10, 121),
	('massacro', 10, 122),
	('massacro2', 10, 123),
	('ninef', 10, 124),
	('ninef2', 10, 125),
	('omnis', 5, 126),
	('pariah', 10, 127),
	('penumbra', 10, 128),
	('raiden', 10, 129),
	('raiden2', 10, 130),
	('rapidgt', 10, 131),
	('rapidgt2', 10, 132),
	('ruston', 10, 133),
	('schafter3', 10, 134),
	('schafter4', 10, 135),
	('schafter5', 10, 136),
	('schwarzer', 10, 137),
	('sentinel3', 10, 138),
	('seven70', 10, 139),
	('specter', 10, 140),
	('specter2', 10, 141),
	('streiter', 10, 142),
	('sultan', 10, 143),
	('surano', 10, 144),
	('tampa2', 10, 145),
	('tropos', 10, 146),
	('verlierer2', 10, 147),
	('btype2', 10, 148),
	('btype3', 10, 149),
	('casco', 10, 150),
	('cheetah', 10, 151),
	('coquette2', 10, 152),
	('feltzer3', 10, 153),
	('gt500', 10, 154),
	('infernus2', 10, 155),
	('jb700', 10, 156),
	('mamba', 10, 157),
	('manana', 10, 158),
	('monroe', 10, 159),
	('peyote', 10, 160),
	('pigalle', 10, 161),
	('rapidgt3', 10, 162),
	('retinue', 10, 163),
	('stinger', 10, 164),
	('stingergt', 10, 165),
	('torero', 10, 166),
	('tornado2', 10, 167),
	('tornado6', 10, 168),
	('tornado', 10, 169),
	('turismo2', 10, 170),
	('ztype', 10, 171),
	('adder', 5, 172),
	('autarch', 5, 173),
	('banshee2', 5, 174),
	('bullet', 5, 175),
	('cheetah2', 5, 176),
	('entityxf', 5, 177),
	('fmj', 5, 178),
	('gp1', 10, 179),
	('infernus', 10, 180),
	('nero', 10, 181),
	('nero2', 10, 182),
	('osiris', 10, 183),
	('penetrator', 10, 184),
	('pfister811', 10, 185),
	('reaper', 10, 186),
	('sc1', 10, 187),
	('sultanrs', 10, 188),
	('t20', 3, 189),
	('tempesta', 10, 190),
	('turismor', 10, 191),
	('tyrus', 10, 192),
	('vacca', 10, 193),
	('visione', 5, 194),
	('voltic', 10, 195),
	('zentorno', 5, 196),
	('sadler', 10, 197),
	('bison', 10, 198),
	('bison2', 10, 199),
	('bobcatxl', 10, 200),
	('burrito', 10, 201),
	('burrito2', 10, 202),
	('burrito4', 10, 203),
	('mule4', 10, 204),
	('rallytruck', 10, 205),
	('minivan', 10, 206),
	('minivan2', 10, 207),
	('paradise', 10, 208),
	('pony', 10, 209),
	('pony2', 10, 210),
	('rumpo', 10, 211),
	('rumpo2', 10, 212),
	('rumpo3', 10, 213),
	('surfer', 10, 214),
	('youga', 10, 215),
	('huntley', 10, 216),
	('landstalker', 10, 217),
	('mesa', 10, 218),
	('patriot', 10, 219),
	('radi', 10, 220),
	('rocoto', 10, 221),
	('tyrant', 5, 222),
	('entity2', 5, 223),
	('cheburek', 10, 224),
	('hotring', 10, 225),
	('jester3', 10, 226),
	('flashgt', 10, 227),
	('ellie', 10, 228),
	('michelli', 10, 229),
	('fagaloa', 10, 230),
	('dominator', 10, 231),
	('dominator2', 10, 232),
	('dominator3', 10, 233),
	('issi3', 10, 234),
	('taipam', 10, 235),
	('gb200', 10, 236),
	('stretch', 10, 237),
	('guardian', 10, 238),
	('kamacho', 10, 239),
	('neon', 10, 240),
	('cyclone', 10, 241),
	('italigtb', 10, 242),
	('italigtb2', 10, 243),
	('vagner', 5, 244),
	('xa21', 5, 245),
	('tezeract', 3, 246),
	('prototipo', 3, 247),
	('patriot2', 10, 248),
	('swinger', 10, 249),
	('clique', 10, 250),
	('deveste', 2, 251),
	('deviant', 10, 252),
	('impaler', 10, 253),
	('italigto', 10, 254),
	('toros', 10, 255),
	('schlagen', 10, 256),
	('tulip', 10, 257),
	('vamos', 10, 258),
	('freecrawler', 10, 259),
	('fugitive', 10, 260),
	('glendale', 10, 261),
	('intruder', 10, 262),
	('le7b', 10, 263),
	('lurcher', 10, 264),
	('lynx', 10, 265),
	('phoenix', 10, 266),
	('premier', 10, 267),
	('raptor', 10, 268),
	('sheava', 10, 269),
	('z190', 10, 270),
	('akuma', 10, 271),
	('avarus', 10, 272),
	('bagger', 10, 273),
	('bati', 10, 274),
	('bati2', 10, 275),
	('bf400', 10, 276),
	('carbonrs', 10, 277),
	('chimera', 10, 278),
	('cliffhanger', 10, 279),
	('daemon2', 10, 280),
	('defiler', 10, 281),
	('diablous', 10, 282),
	('diablous2', 10, 283),
	('double', 10, 284),
	('enduro', 10, 285),
	('esskey', 10, 286),
	('faggio', 10, 287),
	('faggio2', 10, 288),
	('faggio3', 10, 289),
	('fcr', 10, 290),
	('gcr2', 10, 291),
	('gargoyle', 10, 292),
	('hakuchou', 5, 293),
	('hakuchou2', 5, 294),
	('hexer', 10, 295),
	('innovation', 10, 296),
	('lectro', 10, 297),
	('manchez', 10, 298),
	('nemesis', 10, 299),
	('nightblade', 10, 300),
	('pcj', 10, 301),
	('ruffian', 10, 302),
	('sanchez', 10, 303),
	('sanchez2', 10, 304),
	('sovereign', 10, 305),
	('thrust', 10, 306),
	('vader', 10, 307),
	('vindicator', 10, 308),
	('vortex', 10, 309),
	('wolfsbane', 10, 310),
	('zombiea', 10, 311),
	('zombieb', 10, 312),
	('shotaro', 10, 313),
	('rabike', 10, 312),
	('blazer', 10, 313),
	('blazer4', 10, 314);
/*!40000 ALTER TABLE `vrp_estoque` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_homes_permissions
CREATE TABLE IF NOT EXISTS `vrp_homes_permissions` (
  `owner` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `garage` int(11) NOT NULL,
  `home` varchar(100) NOT NULL DEFAULT '',
  `tax` varchar(24) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_homes_permissions: ~0 rows (aproximadamente)
DELETE FROM `vrp_homes_permissions`;
/*!40000 ALTER TABLE `vrp_homes_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_homes_permissions` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_priority
CREATE TABLE IF NOT EXISTS `vrp_priority` (
  `user_id` int(1) NOT NULL DEFAULT 0,
  `steam` varchar(50) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `steam` (`steam`),
  KEY `priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_priority: ~0 rows (aproximadamente)
DELETE FROM `vrp_priority`;
/*!40000 ALTER TABLE `vrp_priority` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_priority` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_srv_data
CREATE TABLE IF NOT EXISTS `vrp_srv_data` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_srv_data: ~0 rows (aproximadamente)
DELETE FROM `vrp_srv_data`;
/*!40000 ALTER TABLE `vrp_srv_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_srv_data` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_users
CREATE TABLE IF NOT EXISTS `vrp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dntxx_login` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `whitelisted` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_users: ~0 rows (aproximadamente)
DELETE FROM `vrp_users`;
/*!40000 ALTER TABLE `vrp_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_users` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_user_data
CREATE TABLE IF NOT EXISTS `vrp_user_data` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  CONSTRAINT `fk_user_data_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_user_data: ~0 rows (aproximadamente)
DELETE FROM `vrp_user_data`;
/*!40000 ALTER TABLE `vrp_user_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_user_data` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_user_homes
CREATE TABLE IF NOT EXISTS `vrp_user_homes` (
  `user_id` int(11) NOT NULL,
  `home` varchar(255) NOT NULL,
  `number` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`home`),
  CONSTRAINT `fk_user_homes_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_user_homes: ~0 rows (aproximadamente)
DELETE FROM `vrp_user_homes`;
/*!40000 ALTER TABLE `vrp_user_homes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_user_homes` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_user_identities
CREATE TABLE IF NOT EXISTS `vrp_user_identities` (
  `user_id` int(11) NOT NULL,
  `registration` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `registration` (`registration`),
  KEY `phone` (`phone`),
  CONSTRAINT `fk_user_identities_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_user_identities: ~0 rows (aproximadamente)
DELETE FROM `vrp_user_identities`;
/*!40000 ALTER TABLE `vrp_user_identities` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_user_identities` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_user_ids
CREATE TABLE IF NOT EXISTS `vrp_user_ids` (
  `identifier` varchar(100) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  KEY `fk_user_ids_users` (`user_id`),
  CONSTRAINT `fk_user_ids_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_user_ids: ~0 rows (aproximadamente)
DELETE FROM `vrp_user_ids`;
/*!40000 ALTER TABLE `vrp_user_ids` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_user_ids` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_user_moneys
CREATE TABLE IF NOT EXISTS `vrp_user_moneys` (
  `user_id` int(11) NOT NULL,
  `wallet` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_user_moneys_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_user_moneys: ~0 rows (aproximadamente)
DELETE FROM `vrp_user_moneys`;
/*!40000 ALTER TABLE `vrp_user_moneys` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_user_moneys` ENABLE KEYS */;

-- Copiando estrutura para tabela cloud.vrp_user_vehicles
CREATE TABLE IF NOT EXISTS `vrp_user_vehicles` (
  `user_id` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `ipva` int(11) NOT NULL DEFAULT 0,
  `detido` int(1) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `engine` int(4) NOT NULL DEFAULT 1000,
  `body` int(4) NOT NULL DEFAULT 1000,
  `fuel` int(3) NOT NULL DEFAULT 100,
  PRIMARY KEY (`user_id`,`vehicle`),
  CONSTRAINT `fk_user_vehicles_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela cloud.vrp_user_vehicles: ~0 rows (aproximadamente)
DELETE FROM `vrp_user_vehicles`;
/*!40000 ALTER TABLE `vrp_user_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrp_user_vehicles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
