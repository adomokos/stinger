DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) DEFAULT NULL,
  `ip_address_locator` varchar(255) DEFAULT NULL,
  `hostname_locator` varchar(255) DEFAULT NULL,
  `url_locator` varchar(255) DEFAULT NULL,
  `file_locator` varchar(255) DEFAULT NULL,
  `external_id_locator` varchar(255) DEFAULT NULL,
  `notes` mediumtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_assets_on_client_id` (`client_id`),
  KEY `client_id_ip_address_locator` (`client_id`,`ip_address_locator`),
  KEY `client_id_hostname_locator` (`client_id`,`hostname_locator`),
  KEY `client_id_url_locator` (`client_id`,`url_locator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `vulnerabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vulnerabilities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `cve_id` int(11) DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_vulnerabilities_on_client_id` (`client_id`),
  KEY `index_vulnerabilities_on_asset_id` (`asset_id`),
  KEY `index_vulnerabilities_on_cve_id` (`cve_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
