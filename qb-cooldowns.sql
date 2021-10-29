CREATE TABLE IF NOT EXISTS `cooldowns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `cooldown` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE KEY` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
