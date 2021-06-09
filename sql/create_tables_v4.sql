-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: secu
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Table structure for table `basics`
--

DROP TABLE IF EXISTS `basics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `basics` (
  `code` varchar(6) NOT NULL COMMENT '股票代码',
  `name` varchar(10) DEFAULT NULL COMMENT '名称',
  `market` varchar(2) DEFAULT NULL COMMENT '市场',
  `industry` varchar(20) DEFAULT NULL COMMENT '所属行业',
  `ind_lv1` varchar(45) DEFAULT NULL COMMENT '行业分类（一级）',
  `ind_lv2` varchar(45) DEFAULT NULL COMMENT '行业分类（二级）',
  `ind_lv3` varchar(45) DEFAULT NULL COMMENT '行业分类（三级）',
  `area` varchar(20) DEFAULT NULL COMMENT '地区',
  `pe` double DEFAULT NULL COMMENT '市盈率',
  `pu` double DEFAULT NULL COMMENT 'Price / UDPPS',
  `po` double DEFAULT NULL COMMENT 'Price / OCFPS',
  `outstanding` double DEFAULT NULL COMMENT '流通股本（亿）',
  `totals` double DEFAULT NULL COMMENT '总股本（亿）',
  `totalAssets` double DEFAULT NULL COMMENT '总资产（万）',
  `liquidAssets` double DEFAULT NULL COMMENT '流动资产',
  `fixedAssets` double DEFAULT NULL COMMENT '固定资产',
  `reserved` double DEFAULT NULL COMMENT '公积金',
  `reservedPerShare` double DEFAULT NULL COMMENT '每股公积金',
  `esp` double DEFAULT NULL COMMENT '每股收益',
  `bvps` double DEFAULT NULL COMMENT '每股净资',
  `pb` double DEFAULT NULL COMMENT '市净率',
  `timeToMarket` varchar(10) DEFAULT NULL COMMENT '上市日期',
  `undp` double DEFAULT NULL COMMENT '未分配利润',
  `perundp` double DEFAULT NULL COMMENT '每股未分配利润',
  `rev` double DEFAULT NULL COMMENT '收入同比（%）',
  `profit` double DEFAULT NULL COMMENT '利润同比（%）',
  `gpr` double DEFAULT NULL COMMENT '毛利率（%）',
  `npr` double DEFAULT NULL COMMENT '净利润率（%）',
  `holders` bigint DEFAULT NULL COMMENT '股东人数',
  `price` decimal(6,3) DEFAULT NULL COMMENT '现价',
  `varate` decimal(4,2) DEFAULT NULL COMMENT '涨跌幅（%）',
  `var` decimal(6,3) DEFAULT NULL COMMENT '涨跌',
  `xrate` decimal(5,2) DEFAULT NULL COMMENT '换手率（%）',
  `volratio` decimal(10,2) DEFAULT NULL COMMENT '量比',
  `ampl` decimal(5,2) DEFAULT NULL COMMENT '振幅（%）',
  `turnover` decimal(10,5) DEFAULT NULL COMMENT '成交额（亿）',
  `accer` decimal(5,2) DEFAULT NULL COMMENT '涨速（%）',
  `circMarVal` decimal(10,2) DEFAULT NULL COMMENT '流通市值',
  `share_sum` double DEFAULT NULL COMMENT '总股本(亿股)',
  `a_share_sum` double DEFAULT NULL COMMENT 'A股总股本(亿股)',
  `a_share_exch` double DEFAULT NULL COMMENT '流通A股(亿股)',
  `a_share_r` double DEFAULT NULL COMMENT '限售A股(亿股)',
  `b_share_sum` double DEFAULT NULL COMMENT 'B股总股本(亿股)',
  `b_share_exch` double DEFAULT NULL COMMENT '流通B股(亿股)',
  `b_share_r` double DEFAULT NULL COMMENT '限售B股(亿股)',
  `h_share_sum` double DEFAULT NULL COMMENT 'H股总股本(亿股)',
  `h_share_exch` double DEFAULT NULL COMMENT '流通H股(亿股)',
  `h_share_r` double DEFAULT NULL COMMENT '限售H股(亿股)',
  `udate` varchar(10) DEFAULT NULL COMMENT '最后更新日期',
  `utime` varchar(8) DEFAULT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cmpool`
--

DROP TABLE IF EXISTS `cmpool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cmpool` (
  `seqno` int NOT NULL AUTO_INCREMENT,
  `code` varchar(8) NOT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`seqno`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `code_map`
--

DROP TABLE IF EXISTS `code_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `code_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `f_src` varchar(10) NOT NULL,
  `f_code` varchar(20) NOT NULL,
  `t_src` varchar(10) NOT NULL,
  `t_code` varchar(20) NOT NULL,
  `remark` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `code_map_UNIQUE` (`f_src`,`f_code`,`t_src`,`t_code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_b`
--

DROP TABLE IF EXISTS `em_d_b`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_b` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_B_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Basic Data (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_b_lr`
--

DROP TABLE IF EXISTS `em_d_b_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_b_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_B_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_b_ma`
--

DROP TABLE IF EXISTS `em_d_b_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_b_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_B_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Moving Average (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_b_ma_lr`
--

DROP TABLE IF EXISTS `em_d_b_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_b_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_B_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Moving Average Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_f`
--

DROP TABLE IF EXISTS `em_d_f`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_f` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_F_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Basic Data (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_f_lr`
--

DROP TABLE IF EXISTS `em_d_f_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_f_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_F_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_f_ma`
--

DROP TABLE IF EXISTS `em_d_f_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_f_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_F_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Moving Average (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_f_ma_lr`
--

DROP TABLE IF EXISTS `em_d_f_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_f_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_F_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Moving Average Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_n`
--

DROP TABLE IF EXISTS `em_d_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Basic Data (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_n_lr`
--

DROP TABLE IF EXISTS `em_d_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_n_ma`
--

DROP TABLE IF EXISTS `em_d_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_d_n_ma_lr`
--

DROP TABLE IF EXISTS `em_d_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_d_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_D_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Daily Kline Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 128 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_b`
--

DROP TABLE IF EXISTS `em_m_b`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_b` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_B_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_b_lr`
--

DROP TABLE IF EXISTS `em_m_b_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_b_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_B_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_b_ma`
--

DROP TABLE IF EXISTS `em_m_b_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_b_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_B_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Moving Average (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_b_ma_lr`
--

DROP TABLE IF EXISTS `em_m_b_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_b_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_B_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Moving Average Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_f`
--

DROP TABLE IF EXISTS `em_m_f`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_f` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_F_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Basic Data (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_f_lr`
--

DROP TABLE IF EXISTS `em_m_f_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_f_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_F_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_f_ma`
--

DROP TABLE IF EXISTS `em_m_f_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_f_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_F_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Moving Average (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_f_ma_lr`
--

DROP TABLE IF EXISTS `em_m_f_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_f_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_F_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Moving Average Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_n`
--

DROP TABLE IF EXISTS `em_m_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Basic Data (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_n_lr`
--

DROP TABLE IF EXISTS `em_m_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_n_ma`
--

DROP TABLE IF EXISTS `em_m_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_m_n_ma_lr`
--

DROP TABLE IF EXISTS `em_m_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_m_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_M_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Monthly Kline Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_b`
--

DROP TABLE IF EXISTS `em_w_b`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_b` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_B_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_b_lr`
--

DROP TABLE IF EXISTS `em_w_b_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_b_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_B_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_b_ma`
--

DROP TABLE IF EXISTS `em_w_b_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_b_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_B_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Moving Average (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_b_ma_lr`
--

DROP TABLE IF EXISTS `em_w_b_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_b_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_B_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Moving Average Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_f`
--

DROP TABLE IF EXISTS `em_w_f`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_f` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_F_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Basic Data (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_f_lr`
--

DROP TABLE IF EXISTS `em_w_f_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_f_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_F_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_f_ma`
--

DROP TABLE IF EXISTS `em_w_f_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_f_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_F_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Moving Average (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_f_ma_lr`
--

DROP TABLE IF EXISTS `em_w_f_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_f_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_F_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Moving Average Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_n`
--

DROP TABLE IF EXISTS `em_w_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Basic Data (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_n_lr`
--

DROP TABLE IF EXISTS `em_w_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_n_ma`
--

DROP TABLE IF EXISTS `em_w_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `em_w_n_ma_lr`
--

DROP TABLE IF EXISTS `em_w_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `em_w_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `EM_W_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='EastMoney.com Weekly Kline Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 64 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fin_predict`
--

DROP TABLE IF EXISTS `fin_predict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_predict` (
  `code` varchar(8) NOT NULL COMMENT '股票代码',
  `year` varchar(4) NOT NULL COMMENT '年份',
  `eps_num` int DEFAULT NULL COMMENT '每股收益预测机构数',
  `eps_min` double DEFAULT NULL COMMENT '每股收益最小值',
  `eps_avg` double DEFAULT NULL COMMENT '每股收益平均值',
  `eps_max` double DEFAULT NULL COMMENT '每股收益最大值',
  `eps_ind_avg` double DEFAULT NULL COMMENT '每股收益行业平均',
  `eps_up_rt` double DEFAULT NULL COMMENT 'EPS预测上调机构占比',
  `eps_dn_rt` double DEFAULT NULL COMMENT 'EPS预测下调机构占比',
  `np_num` int DEFAULT NULL COMMENT '净利润预测机构数',
  `np_min` double DEFAULT NULL COMMENT '净利润最小值 (亿元）',
  `np_avg` double DEFAULT NULL COMMENT '净利润平均值 (亿元）',
  `np_max` double DEFAULT NULL COMMENT '净利润最大值 (亿元）',
  `np_ind_avg` double DEFAULT NULL COMMENT '净利润行业平均值 (亿元）',
  `np_up_rt` double DEFAULT NULL COMMENT '净利润预测上调机构占比',
  `np_dn_rt` double DEFAULT NULL COMMENT '净利润预测下调机构占比',
  `udate` varchar(10) DEFAULT NULL COMMENT '更新日期',
  `utime` varchar(8) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`code`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='业绩预测简表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finance`
--

DROP TABLE IF EXISTS `finance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finance` (
  `code` varchar(8) NOT NULL COMMENT '股票代码',
  `year` varchar(10) NOT NULL COMMENT '报告年度',
  `eps` double DEFAULT NULL COMMENT '基本每股收益(元)',
  `eps_yoy` double DEFAULT NULL COMMENT '基本每股收益同比增长率',
  `np` double DEFAULT NULL COMMENT '净利润(亿)',
  `np_yoy` double DEFAULT NULL COMMENT '净利润同比增长率',
  `np_adn` double DEFAULT NULL COMMENT '扣非净利润(亿)',
  `np_adn_yoy` double DEFAULT NULL COMMENT '扣非净利润同比增长率',
  `busi_cycle` float DEFAULT NULL COMMENT '营业周期(天)',
  `gr` double DEFAULT NULL COMMENT '营业总收入(亿)',
  `gr_yoy` double DEFAULT NULL COMMENT '营业总收入同比增长率',
  `navps` double DEFAULT NULL COMMENT '每股净资产(元)',
  `roe` double DEFAULT NULL COMMENT '净资产收益率',
  `roe_yoy` double DEFAULT NULL COMMENT '净资产收益率同比增长率',
  `roe_dlt` double DEFAULT NULL COMMENT '净资产收益率-摊薄',
  `dar` double DEFAULT NULL COMMENT 'Debt to Asset Ratio, 资产负债比率',
  `crps` double DEFAULT NULL COMMENT '每股资本公积金(元)',
  `udpps` double DEFAULT NULL COMMENT '每股未分配利润(元)',
  `udpps_yoy` double DEFAULT NULL COMMENT '每股未分配利润同比增长率',
  `ocfps` double DEFAULT NULL COMMENT '每股经营现金流(元)',
  `ocfps_yoy` double DEFAULT NULL COMMENT '每股经营现金流同比增长率',
  `gpm` double DEFAULT NULL COMMENT '销售毛利率',
  `npm` double DEFAULT NULL COMMENT '销售净利率',
  `itr` double DEFAULT NULL COMMENT '存货周转率(次)',
  `inv_turnover_days` float DEFAULT NULL COMMENT '存货周转天数(天)',
  `ar_turnover_days` float DEFAULT NULL COMMENT '应收账款周转天数(天)',
  `cur_ratio` float DEFAULT NULL COMMENT '流动比率',
  `quick_ratio` float DEFAULT NULL COMMENT '速动比率',
  `cons_quick_ratio` float DEFAULT NULL COMMENT '保守速动比率',
  `equity_ratio` float DEFAULT NULL COMMENT '产权比率',
  `udate` varchar(10) DEFAULT NULL COMMENT '更新日期',
  `utime` varchar(8) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`code`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='财务信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_stats`
--

DROP TABLE IF EXISTS `fs_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fs_stats` (
  `method` varchar(45) NOT NULL,
  `tab` varchar(45) NOT NULL,
  `fields` varchar(20) NOT NULL,
  `mean` double DEFAULT NULL,
  `std` double DEFAULT NULL,
  `vmax` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`method`,`tab`,`fields`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Feature Scaling Statistics';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grader_stats`
--

DROP TABLE IF EXISTS `grader_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grader_stats` (
  `grader` varchar(20) NOT NULL,
  `frame` int NOT NULL,
  `score` double NOT NULL,
  `threshold` double DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `size` int NOT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`grader`,`frame`,`score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `idxlst`
--

DROP TABLE IF EXISTS `idxlst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idxlst` (
  `src` varchar(20) NOT NULL,
  `market` varchar(10) NOT NULL DEFAULT '',
  `code` varchar(20) NOT NULL,
  `name` varchar(60) NOT NULL,
  PRIMARY KEY (`src`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='index list';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `imputed_data`
--

DROP TABLE IF EXISTS `imputed_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imputed_data` (
  `table` varchar(32) NOT NULL,
  `field` varchar(32) NOT NULL,
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `val` double NOT NULL,
  `source` varchar(45) NOT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`table`,`field`,`code`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indc_feat`
--

DROP TABLE IF EXISTS `indc_feat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indc_feat` (
  `indc` varchar(10) NOT NULL COMMENT '指标类型',
  `fid` varchar(50) NOT NULL COMMENT '特征ID(UUID)',
  `cytp` varchar(5) NOT NULL COMMENT '周期类型（D:天/W:周/M:月）',
  `bysl` varchar(2) NOT NULL COMMENT 'BY：买/SL：卖',
  `smp_num` int NOT NULL COMMENT '采样数量',
  `fd_num` int NOT NULL COMMENT '同类样本数量',
  `weight` double DEFAULT NULL COMMENT '权重',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `udate` varchar(10) NOT NULL COMMENT '更新日期',
  `utime` varchar(8) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`indc`,`cytp`,`bysl`,`smp_num`,`fid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='指标特征数据总表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indc_feat_raw`
--

DROP TABLE IF EXISTS `indc_feat_raw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indc_feat_raw` (
  `code` varchar(8) NOT NULL COMMENT '股票代码',
  `indc` varchar(10) NOT NULL COMMENT '指标类型',
  `fid` varchar(15) NOT NULL COMMENT '特征ID(周期+买卖+采样起始日期)',
  `cytp` varchar(5) NOT NULL COMMENT '周期类型（D:天/W:周/M:月）',
  `bysl` varchar(2) NOT NULL COMMENT 'BY：买/SL：卖',
  `smp_date` varchar(10) NOT NULL COMMENT '采样开始日期',
  `smp_num` int NOT NULL COMMENT '采样数量',
  `mark` double DEFAULT NULL COMMENT '标记获利/亏损幅度',
  `tspan` int DEFAULT NULL COMMENT '获利/亏损的时间跨度',
  `mpt` double DEFAULT NULL COMMENT '单位时间的获利/亏损（Mark/TSpan）',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `udate` varchar(10) NOT NULL COMMENT '更新日期',
  `utime` varchar(8) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`code`,`fid`,`indc`),
  KEY `INDEX` (`smp_num`,`cytp`,`bysl`,`indc`,`smp_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='指标特征原始数据总表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_d_n`
--

DROP TABLE IF EXISTS `index_d_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_d_n` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation(%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation(%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_d_n_lr`
--

DROP TABLE IF EXISTS `index_d_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_d_n_lr` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index Log Return (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_d_n_ma`
--

DROP TABLE IF EXISTS `index_d_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_d_n_ma` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_d_n_ma_lr`
--

DROP TABLE IF EXISTS `index_d_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_d_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_m_n`
--

DROP TABLE IF EXISTS `index_m_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_m_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_m_n_lr`
--

DROP TABLE IF EXISTS `index_m_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_m_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_m_n_ma`
--

DROP TABLE IF EXISTS `index_m_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_m_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_m_n_ma_lr`
--

DROP TABLE IF EXISTS `index_m_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_m_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_d_n`
--

DROP TABLE IF EXISTS `index_sina_d_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_d_n` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `varate` double DEFAULT NULL COMMENT 'Closing price variation(%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation(%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_d_n_lr`
--

DROP TABLE IF EXISTS `index_sina_d_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_d_n_lr` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index Log Return (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_d_n_ma`
--

DROP TABLE IF EXISTS `index_sina_d_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_d_n_ma` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_d_n_ma_lr`
--

DROP TABLE IF EXISTS `index_sina_d_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_d_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `INDEX_D_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Index Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 256 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_m_n`
--

DROP TABLE IF EXISTS `index_sina_m_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_m_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_m_n_lr`
--

DROP TABLE IF EXISTS `index_sina_m_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_m_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_m_n_ma`
--

DROP TABLE IF EXISTS `index_sina_m_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_m_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_m_n_ma_lr`
--

DROP TABLE IF EXISTS `index_sina_m_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_m_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_M_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Index Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 16 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_w_n`
--

DROP TABLE IF EXISTS `index_sina_w_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_w_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_w_n_lr`
--

DROP TABLE IF EXISTS `index_sina_w_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_w_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_w_n_ma`
--

DROP TABLE IF EXISTS `index_sina_w_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_w_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_sina_w_n_ma_lr`
--

DROP TABLE IF EXISTS `index_sina_w_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_sina_w_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_w_n`
--

DROP TABLE IF EXISTS `index_w_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_w_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_w_n_lr`
--

DROP TABLE IF EXISTS `index_w_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_w_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_w_n_ma`
--

DROP TABLE IF EXISTS `index_w_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_w_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_w_n_ma_lr`
--

DROP TABLE IF EXISTS `index_w_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `index_w_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `INDEX_W_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Index Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 32 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indicator_d`
--

DROP TABLE IF EXISTS `indicator_d`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indicator_d` (
  `Code` varchar(8) NOT NULL,
  `Date` varchar(10) NOT NULL,
  `Klid` int NOT NULL,
  `KDJ_K` double DEFAULT NULL,
  `KDJ_D` double DEFAULT NULL,
  `KDJ_J` double DEFAULT NULL,
  `MACD` double DEFAULT NULL,
  `MACD_diff` double DEFAULT NULL,
  `MACD_dea` double DEFAULT NULL,
  `RSI1` double DEFAULT NULL,
  `RSI2` double DEFAULT NULL,
  `RSI3` double DEFAULT NULL,
  `BIAS1` double DEFAULT NULL,
  `BIAS2` double DEFAULT NULL,
  `BIAS3` double DEFAULT NULL,
  `BOLL_lower` double DEFAULT NULL,
  `BOLL_lower_o` double DEFAULT NULL,
  `BOLL_lower_h` double DEFAULT NULL,
  `BOLL_lower_l` double DEFAULT NULL,
  `BOLL_lower_c` double DEFAULT NULL,
  `BOLL_mid` double DEFAULT NULL,
  `BOLL_mid_o` double DEFAULT NULL,
  `BOLL_mid_h` double DEFAULT NULL,
  `BOLL_mid_l` double DEFAULT NULL,
  `BOLL_mid_c` double DEFAULT NULL,
  `BOLL_upper` double DEFAULT NULL,
  `BOLL_upper_o` double DEFAULT NULL,
  `BOLL_upper_h` double DEFAULT NULL,
  `BOLL_upper_l` double DEFAULT NULL,
  `BOLL_upper_c` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`Code`,`Klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indicator_m`
--

DROP TABLE IF EXISTS `indicator_m`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indicator_m` (
  `Code` varchar(8) NOT NULL,
  `Date` varchar(10) NOT NULL,
  `Klid` int NOT NULL,
  `KDJ_K` double DEFAULT NULL,
  `KDJ_D` double DEFAULT NULL,
  `KDJ_J` double DEFAULT NULL,
  `MACD` double DEFAULT NULL,
  `MACD_diff` double DEFAULT NULL,
  `MACD_dea` double DEFAULT NULL,
  `RSI1` double DEFAULT NULL,
  `RSI2` double DEFAULT NULL,
  `RSI3` double DEFAULT NULL,
  `BIAS1` double DEFAULT NULL,
  `BIAS2` double DEFAULT NULL,
  `BIAS3` double DEFAULT NULL,
  `BOLL_lower` double DEFAULT NULL,
  `BOLL_lower_o` double DEFAULT NULL,
  `BOLL_lower_h` double DEFAULT NULL,
  `BOLL_lower_l` double DEFAULT NULL,
  `BOLL_lower_c` double DEFAULT NULL,
  `BOLL_mid` double DEFAULT NULL,
  `BOLL_mid_o` double DEFAULT NULL,
  `BOLL_mid_h` double DEFAULT NULL,
  `BOLL_mid_l` double DEFAULT NULL,
  `BOLL_mid_c` double DEFAULT NULL,
  `BOLL_upper` double DEFAULT NULL,
  `BOLL_upper_o` double DEFAULT NULL,
  `BOLL_upper_h` double DEFAULT NULL,
  `BOLL_upper_l` double DEFAULT NULL,
  `BOLL_upper_c` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`Code`,`Klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indicator_w`
--

DROP TABLE IF EXISTS `indicator_w`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indicator_w` (
  `Code` varchar(8) NOT NULL,
  `Date` varchar(10) NOT NULL,
  `Klid` int NOT NULL,
  `KDJ_K` double DEFAULT NULL,
  `KDJ_D` double DEFAULT NULL,
  `KDJ_J` double DEFAULT NULL,
  `MACD` double DEFAULT NULL,
  `MACD_diff` double DEFAULT NULL,
  `MACD_dea` double DEFAULT NULL,
  `RSI1` double DEFAULT NULL,
  `RSI2` double DEFAULT NULL,
  `RSI3` double DEFAULT NULL,
  `BIAS1` double DEFAULT NULL,
  `BIAS2` double DEFAULT NULL,
  `BIAS3` double DEFAULT NULL,
  `BOLL_lower` double DEFAULT NULL,
  `BOLL_lower_o` double DEFAULT NULL,
  `BOLL_lower_h` double DEFAULT NULL,
  `BOLL_lower_l` double DEFAULT NULL,
  `BOLL_lower_c` double DEFAULT NULL,
  `BOLL_mid` double DEFAULT NULL,
  `BOLL_mid_o` double DEFAULT NULL,
  `BOLL_mid_h` double DEFAULT NULL,
  `BOLL_mid_l` double DEFAULT NULL,
  `BOLL_mid_c` double DEFAULT NULL,
  `BOLL_upper` double DEFAULT NULL,
  `BOLL_upper_o` double DEFAULT NULL,
  `BOLL_upper_h` double DEFAULT NULL,
  `BOLL_upper_l` double DEFAULT NULL,
  `BOLL_upper_c` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`Code`,`Klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kdj_feat_dat`
--

DROP TABLE IF EXISTS `kdj_feat_dat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kdj_feat_dat` (
  `fid` varchar(50) NOT NULL COMMENT '特征ID',
  `seq` int NOT NULL COMMENT '序号',
  `K` double NOT NULL,
  `D` double NOT NULL,
  `J` double NOT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`fid`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='KDJ指标特征数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kdj_feat_dat_raw`
--

DROP TABLE IF EXISTS `kdj_feat_dat_raw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kdj_feat_dat_raw` (
  `code` varchar(8) NOT NULL COMMENT '股票代码',
  `fid` varchar(15) NOT NULL COMMENT '特征ID',
  `klid` int NOT NULL COMMENT '序号',
  `K` double NOT NULL,
  `D` double NOT NULL,
  `J` double NOT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`fid`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='KDJ指标特征原始数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kdjv_stats`
--

DROP TABLE IF EXISTS `kdjv_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kdjv_stats` (
  `code` varchar(8) NOT NULL COMMENT 'Stock Code',
  `dod` double DEFAULT NULL COMMENT 'Degree of Distinction',
  `sl` double DEFAULT NULL COMMENT 'Sell Low',
  `sh` double DEFAULT NULL COMMENT 'Sell High',
  `bl` double DEFAULT NULL COMMENT 'Buy Low',
  `bh` double DEFAULT NULL COMMENT 'Buy High',
  `sor` double DEFAULT NULL COMMENT 'Sell Overlap Ratio',
  `bor` double DEFAULT NULL COMMENT 'Buy Overlap Ratio',
  `scnt` int DEFAULT NULL COMMENT 'Sell Count',
  `bcnt` int DEFAULT NULL COMMENT 'Buy Count',
  `smean` double DEFAULT NULL COMMENT 'Sell Mean',
  `bmean` double DEFAULT NULL COMMENT 'Buy Mean',
  `frmdt` varchar(10) DEFAULT NULL COMMENT 'Data Date Start',
  `todt` varchar(10) DEFAULT NULL COMMENT 'Data Date End',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Update Date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Update Time',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='KDJV Scorer Performance Statistics';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_60m`
--

DROP TABLE IF EXISTS `kline_60m`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_60m` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `time` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `varate` double DEFAULT NULL COMMENT '涨跌幅(%)',
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='60分钟K线（前复权）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_b`
--

DROP TABLE IF EXISTS `kline_d_b`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_b` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `KLINE_D_B_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline (Backward Reinstate)'
/*!50100 PARTITION BY KEY (`code`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_b_lr`
--

DROP TABLE IF EXISTS `kline_d_b_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_b_lr` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `KLINE_D_B_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Log Return (Backward Reinstate)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_b_lr_tags`
--

DROP TABLE IF EXISTS `kline_d_b_lr_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_b_lr_tags` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `tags` text,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`klid`),
  KEY `KLINE_D_B_LR_TAGS_IDX1` (`code`,`date`),
  FULLTEXT KEY `KLINE_D_B_LR_TAGS_IDX2` (`tags`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Log Return (Backward Reinstate) Tags';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_b_ma`
--

DROP TABLE IF EXISTS `kline_d_b_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_b_ma` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `KLINE_D_B_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Moving Average (Backward Reinstate)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_b_ma_lr`
--

DROP TABLE IF EXISTS `kline_d_b_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_b_ma_lr` (
  `code` varchar(8) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`,`ym`),
  KEY `KLINE_D_B_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Moving Average Log Return (Backward Reinstate)'
/*!50100 PARTITION BY LINEAR HASH (`ym`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_f`
--

DROP TABLE IF EXISTS `kline_d_f`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_f` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT '涨跌幅(%)',
  `varate_h` double DEFAULT NULL COMMENT '最高价涨跌幅(%)',
  `varate_o` double DEFAULT NULL COMMENT '开盘价涨跌幅(%)',
  `varate_l` double DEFAULT NULL COMMENT '最低价涨跌幅(%)',
  `varate_rgl` double DEFAULT NULL COMMENT '除权除息之前的涨跌幅(%)，除权除息日当天为前复权涨跌幅',
  `varate_rgl_h` double DEFAULT NULL COMMENT '最高价除权除息之前的涨跌幅(%)，除权除息日当天为前复权涨跌幅',
  `varate_rgl_o` double DEFAULT NULL COMMENT '开盘价除权除息之前的涨跌幅(%)，除权除息日当天为前复权涨跌幅',
  `varate_rgl_l` double DEFAULT NULL COMMENT '最低价除权除息之前的涨跌幅(%)，除权除息日当天为前复权涨跌幅',
  `udate` varchar(10) DEFAULT NULL COMMENT '更新日期',
  `utime` varchar(8) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_F_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='日K线(前复权)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_f_lr`
--

DROP TABLE IF EXISTS `kline_d_f_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_f_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_F_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='日K线Log Return (前复权)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_f_ma`
--

DROP TABLE IF EXISTS `kline_d_f_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_f_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_F_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='日K线 MA (前复权)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_f_ma_lr`
--

DROP TABLE IF EXISTS `kline_d_f_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_f_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_F_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='日K线 MA Log Return(前复权)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_n`
--

DROP TABLE IF EXISTS `kline_d_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_n_lr`
--

DROP TABLE IF EXISTS `kline_d_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_n_ma`
--

DROP TABLE IF EXISTS `kline_d_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_d_n_ma_lr`
--

DROP TABLE IF EXISTS `kline_d_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_d_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_D_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Daily Kline Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 2048 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_b`
--

DROP TABLE IF EXISTS `kline_m_b`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_b` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_B_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_b_lr`
--

DROP TABLE IF EXISTS `kline_m_b_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_b_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_B_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_b_ma`
--

DROP TABLE IF EXISTS `kline_m_b_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_b_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_B_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Moving Average (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_b_ma_lr`
--

DROP TABLE IF EXISTS `kline_m_b_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_b_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_B_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Moving Average Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_f`
--

DROP TABLE IF EXISTS `kline_m_f`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_f` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_F_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_f_lr`
--

DROP TABLE IF EXISTS `kline_m_f_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_f_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_F_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_f_ma`
--

DROP TABLE IF EXISTS `kline_m_f_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_f_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_F_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Moving Average (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_f_ma_lr`
--

DROP TABLE IF EXISTS `kline_m_f_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_f_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_F_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Moving Average Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_n`
--

DROP TABLE IF EXISTS `kline_m_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_n_lr`
--

DROP TABLE IF EXISTS `kline_m_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_n_ma`
--

DROP TABLE IF EXISTS `kline_m_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_m_n_ma_lr`
--

DROP TABLE IF EXISTS `kline_m_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_m_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_M_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Monthly Kline Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_b`
--

DROP TABLE IF EXISTS `kline_w_b`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_b` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_B_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_b_lr`
--

DROP TABLE IF EXISTS `kline_w_b_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_b_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_B_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_b_ma`
--

DROP TABLE IF EXISTS `kline_w_b_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_b_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_B_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Moving Average (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_b_ma_lr`
--

DROP TABLE IF EXISTS `kline_w_b_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_b_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_B_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Moving Average Log Return (Backward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_f`
--

DROP TABLE IF EXISTS `kline_w_f`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_f` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_F_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_f_lr`
--

DROP TABLE IF EXISTS `kline_w_f_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_f_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_F_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_f_ma`
--

DROP TABLE IF EXISTS `kline_w_f_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_f_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_F_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Moving Average (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_f_ma_lr`
--

DROP TABLE IF EXISTS `kline_w_f_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_f_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_F_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Moving Average Log Return (Forward-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_n`
--

DROP TABLE IF EXISTS `kline_w_n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_n` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `open` double DEFAULT NULL,
  `high` double DEFAULT NULL,
  `close` double DEFAULT NULL,
  `low` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT '成交量(股)',
  `amount` double DEFAULT NULL COMMENT '成交额(元)',
  `xrate` double DEFAULT NULL COMMENT '换手率(%)',
  `varate` double DEFAULT NULL COMMENT 'Closing price variation (%)',
  `varate_h` double DEFAULT NULL COMMENT 'Highest price variation (%)',
  `varate_o` double DEFAULT NULL COMMENT 'Opening price variation(%)',
  `varate_l` double DEFAULT NULL COMMENT 'Lowest price variation(%)',
  `varate_rgl` double DEFAULT NULL,
  `varate_rgl_h` double DEFAULT NULL COMMENT 'Highest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_o` double DEFAULT NULL COMMENT 'Opening price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `varate_rgl_l` double DEFAULT NULL COMMENT 'Lowest price variation (%) before reinstatement is effective. Taking the forward-reinstated price on the date of dividend',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_N_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_n_lr`
--

DROP TABLE IF EXISTS `kline_w_n_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_n_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `amount` double DEFAULT NULL,
  `xrate` double DEFAULT NULL,
  `close` double DEFAULT NULL COMMENT 'Log Return (Close)',
  `high` double DEFAULT NULL COMMENT 'Log Return (High)',
  `high_close` double DEFAULT NULL,
  `open` double DEFAULT NULL COMMENT 'Log Return (Open)',
  `open_close` double DEFAULT NULL,
  `low` double DEFAULT NULL COMMENT 'Log Return (Low)',
  `low_close` double DEFAULT NULL,
  `volume` double DEFAULT NULL COMMENT 'Log Return for Volume',
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_N_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_n_ma`
--

DROP TABLE IF EXISTS `kline_w_n_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_n_ma` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_N_MA_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Moving Average (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kline_w_n_ma_lr`
--

DROP TABLE IF EXISTS `kline_w_n_ma_lr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kline_w_n_ma_lr` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `ma5` double DEFAULT NULL,
  `ma5_o` double DEFAULT NULL,
  `ma5_h` double DEFAULT NULL,
  `ma5_l` double DEFAULT NULL,
  `ma10` double DEFAULT NULL,
  `ma10_o` double DEFAULT NULL,
  `ma10_h` double DEFAULT NULL,
  `ma10_l` double DEFAULT NULL,
  `ma20` double DEFAULT NULL,
  `ma20_o` double DEFAULT NULL,
  `ma20_h` double DEFAULT NULL,
  `ma20_l` double DEFAULT NULL,
  `ma30` double DEFAULT NULL,
  `ma30_o` double DEFAULT NULL,
  `ma30_h` double DEFAULT NULL,
  `ma30_l` double DEFAULT NULL,
  `ma60` double DEFAULT NULL,
  `ma60_o` double DEFAULT NULL,
  `ma60_h` double DEFAULT NULL,
  `ma60_l` double DEFAULT NULL,
  `ma120` double DEFAULT NULL,
  `ma120_o` double DEFAULT NULL,
  `ma120_h` double DEFAULT NULL,
  `ma120_l` double DEFAULT NULL,
  `ma200` double DEFAULT NULL,
  `ma200_o` double DEFAULT NULL,
  `ma200_h` double DEFAULT NULL,
  `ma200_l` double DEFAULT NULL,
  `ma250` double DEFAULT NULL,
  `ma250_o` double DEFAULT NULL,
  `ma250_h` double DEFAULT NULL,
  `ma250_l` double DEFAULT NULL,
  `vol5` double DEFAULT NULL,
  `vol10` double DEFAULT NULL,
  `vol20` double DEFAULT NULL,
  `vol30` double DEFAULT NULL,
  `vol60` double DEFAULT NULL,
  `vol120` double DEFAULT NULL,
  `vol200` double DEFAULT NULL,
  `vol250` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL COMMENT 'Last update date',
  `utime` varchar(8) DEFAULT NULL COMMENT 'Last update time',
  PRIMARY KEY (`code`,`date`),
  KEY `KLINE_W_N_MA_LR_IDX1` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='Weekly Kline Moving Average Log Return (Non-Reinstated)'
/*!50100 PARTITION BY KEY (`code`,`date`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpts10`
--

DROP TABLE IF EXISTS `kpts10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpts10` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `date` varchar(10) NOT NULL,
  `score` decimal(6,0) NOT NULL,
  `sum_fall` decimal(10,3) NOT NULL,
  `rgn_rise` decimal(10,3) NOT NULL,
  `unit_rise` decimal(10,3) NOT NULL,
  `clr` double DEFAULT NULL COMMENT 'Compound Log Return',
  `rema_lr` double DEFAULT NULL COMMENT 'Reversal EMA Log Return',
  `flag` varchar(25) DEFAULT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`klid`),
  UNIQUE KEY `idx_kpts_uuid` (`uuid`),
  KEY `kpts10_idx2` (`flag`,`uuid`),
  KEY `kpts10_idx1` (`score`,`date`),
  KEY `kpts10_lr_rema` (`rema_lr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='10-days key points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpts120`
--

DROP TABLE IF EXISTS `kpts120`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpts120` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `date` varchar(10) NOT NULL,
  `score` decimal(6,0) NOT NULL,
  `sum_fall` decimal(10,3) NOT NULL,
  `rgn_rise` decimal(10,3) NOT NULL,
  `unit_rise` decimal(10,3) NOT NULL,
  `clr` double DEFAULT NULL COMMENT 'Compound Log Return',
  `rema_lr` double DEFAULT NULL COMMENT 'Reversal EMA Log Return',
  `flag` varchar(25) DEFAULT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`klid`),
  UNIQUE KEY `idx_kpts_uuid` (`uuid`),
  KEY `kpts120_idx2` (`flag`,`uuid`),
  KEY `kpts120_idx1` (`score`,`date`),
  KEY `kpts120_lr_rema` (`rema_lr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='120-days key points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpts20`
--

DROP TABLE IF EXISTS `kpts20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpts20` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `date` varchar(10) NOT NULL,
  `score` decimal(6,0) NOT NULL,
  `sum_fall` decimal(10,3) NOT NULL,
  `rgn_rise` decimal(10,3) NOT NULL,
  `unit_rise` decimal(10,3) NOT NULL,
  `clr` double DEFAULT NULL COMMENT 'Compound Log Return',
  `rema_lr` double DEFAULT NULL COMMENT 'Reversal EMA Log Return',
  `flag` varchar(25) DEFAULT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`klid`),
  UNIQUE KEY `idx_kpts_uuid` (`uuid`),
  KEY `kpts20_idx2` (`flag`,`uuid`),
  KEY `kpts20_idx1` (`score`,`date`),
  KEY `kpts20_lr_rema` (`rema_lr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='20-days key points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpts30`
--

DROP TABLE IF EXISTS `kpts30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpts30` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `date` varchar(10) NOT NULL,
  `score` decimal(6,0) NOT NULL,
  `sum_fall` decimal(10,3) NOT NULL,
  `rgn_rise` decimal(10,3) NOT NULL,
  `unit_rise` decimal(10,3) NOT NULL,
  `clr` double DEFAULT NULL COMMENT 'Compound Log Return',
  `rema_lr` double DEFAULT NULL COMMENT 'Reversal EMA Log Return',
  `flag` varchar(25) DEFAULT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`klid`),
  UNIQUE KEY `idx_kpts_uuid` (`uuid`),
  KEY `kpts30_idx2` (`flag`,`uuid`),
  KEY `kpts30_idx1` (`score`,`date`),
  KEY `kpts30_lr_rema` (`rema_lr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='30-days key points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpts5`
--

DROP TABLE IF EXISTS `kpts5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpts5` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `date` varchar(10) NOT NULL,
  `score` decimal(6,0) NOT NULL,
  `sum_fall` decimal(10,3) NOT NULL,
  `rgn_rise` decimal(10,3) NOT NULL,
  `unit_rise` decimal(10,3) NOT NULL,
  `clr` double DEFAULT NULL COMMENT 'Compound Log Return',
  `rema_lr` double DEFAULT NULL COMMENT 'Reversal EMA Log Return',
  `flag` varchar(25) DEFAULT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`klid`),
  UNIQUE KEY `idx_kpts_uuid` (`uuid`),
  KEY `kpts5_idx2` (`flag`,`uuid`),
  KEY `kpts5_idx1` (`score`,`date`),
  KEY `kpts5_lr_rema` (`rema_lr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='5-days key points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpts60`
--

DROP TABLE IF EXISTS `kpts60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpts60` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `klid` int NOT NULL,
  `date` varchar(10) NOT NULL,
  `score` decimal(6,0) NOT NULL,
  `sum_fall` decimal(10,3) NOT NULL,
  `rgn_rise` decimal(10,3) NOT NULL,
  `unit_rise` decimal(10,3) NOT NULL,
  `clr` double DEFAULT NULL COMMENT 'Compound Log Return',
  `rema_lr` double DEFAULT NULL COMMENT 'Reversal EMA Log Return',
  `flag` varchar(25) DEFAULT NULL,
  `udate` varchar(10) NOT NULL,
  `utime` varchar(8) NOT NULL,
  PRIMARY KEY (`code`,`klid`),
  UNIQUE KEY `idx_kpts_uuid` (`uuid`),
  KEY `kpts60_idx2` (`flag`,`uuid`),
  KEY `kpts60_idx1` (`score`,`date`),
  KEY `kpts60_lr_rema` (`rema_lr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='60-days key points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `params`
--

DROP TABLE IF EXISTS `params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `params` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section` varchar(45) NOT NULL,
  `param` varchar(45) NOT NULL,
  `value` varchar(512) NOT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `params_idx_01` (`section`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxy_list`
--

DROP TABLE IF EXISTS `proxy_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxy_list` (
  `source` varchar(20) NOT NULL,
  `host` varchar(15) NOT NULL,
  `port` varchar(5) NOT NULL,
  `type` varchar(10) NOT NULL,
  `loc` varchar(200) NOT NULL,
  `status` varchar(10) NOT NULL,
  `suc` int NOT NULL,
  `fail` int NOT NULL,
  `score` decimal(6,3) NOT NULL,
  `status_g` varchar(10) NOT NULL,
  `suc_g` int NOT NULL,
  `fail_g` int NOT NULL,
  `score_g` decimal(6,3) NOT NULL,
  `last_check` varchar(20) NOT NULL,
  `last_scanned` varchar(20) NOT NULL,
  PRIMARY KEY (`host`,`port`),
  KEY `last_check` (`last_check`,`status`),
  KEY `source` (`source`,`last_scanned`),
  KEY `status` (`status`,`fail`,`host`,`port`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stats` (
  `code` varchar(60) NOT NULL,
  `start` varchar(20) DEFAULT NULL,
  `end` varchar(20) DEFAULT NULL,
  `dur` decimal(12,3) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockrel`
--

DROP TABLE IF EXISTS `stockrel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stockrel` (
  `code` varchar(6) NOT NULL,
  `date` varchar(20) NOT NULL,
  `klid` int NOT NULL,
  `rcode_pos` varchar(6) DEFAULT NULL,
  `rcode_pos_hs` varchar(6) DEFAULT NULL,
  `rcode_neg` varchar(6) DEFAULT NULL,
  `rcode_neg_hs` varchar(6) DEFAULT NULL,
  `pos_corl` double DEFAULT NULL,
  `pos_corl_hs` double DEFAULT NULL,
  `neg_corl` double DEFAULT NULL,
  `neg_corl_hs` double DEFAULT NULL,
  `rcode_size` int DEFAULT NULL,
  `rcode_size_hs` int DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='relationship between stocks'
/*!50100 PARTITION BY LINEAR KEY (`code`,klid)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tradecal`
--

DROP TABLE IF EXISTS `tradecal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tradecal` (
  `index` bigint DEFAULT NULL,
  `calendarDate` date DEFAULT NULL,
  `isOpen` int DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  KEY `ix_tradecal_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_agents`
--

DROP TABLE IF EXISTS `user_agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_agents` (
  `id` int NOT NULL,
  `user_agent` varchar(512) DEFAULT NULL,
  `times_seen` int DEFAULT NULL,
  `simple_software_string` varchar(100) DEFAULT NULL,
  `software_name` varchar(45) DEFAULT NULL,
  `software_version` varchar(30) DEFAULT NULL,
  `software_type` varchar(20) DEFAULT NULL,
  `software_sub_type` varchar(20) DEFAULT NULL,
  `hardware_type` varchar(20) DEFAULT NULL,
  `first_seen_at` varchar(30) DEFAULT NULL,
  `last_seen_at` varchar(30) DEFAULT NULL,
  `updated_at` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcc_predict`
--

DROP TABLE IF EXISTS `wcc_predict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wcc_predict` (
  `code` varchar(8) NOT NULL,
  `date` varchar(20) NOT NULL,
  `ym` int GENERATED ALWAYS AS (((year(`date`) * 100) + month(`date`))) STORED NOT NULL COMMENT 'year month of the date',
  `klid` int NOT NULL,
  `t1_code` varchar(8) DEFAULT NULL,
  `t2_code` varchar(8) DEFAULT NULL,
  `t3_code` varchar(8) DEFAULT NULL,
  `t4_code` varchar(8) DEFAULT NULL,
  `t5_code` varchar(8) DEFAULT NULL,
  `t1_corl` double DEFAULT NULL,
  `t2_corl` double DEFAULT NULL,
  `t3_corl` double DEFAULT NULL,
  `t4_corl` double DEFAULT NULL,
  `t5_corl` double DEFAULT NULL,
  `b1_code` varchar(8) DEFAULT NULL,
  `b2_code` varchar(8) DEFAULT NULL,
  `b3_code` varchar(8) DEFAULT NULL,
  `b4_code` varchar(8) DEFAULT NULL,
  `b5_code` varchar(8) DEFAULT NULL,
  `b1_corl` double DEFAULT NULL,
  `b2_corl` double DEFAULT NULL,
  `b3_corl` double DEFAULT NULL,
  `b4_corl` double DEFAULT NULL,
  `b5_corl` double DEFAULT NULL,
  `rcode_size` int DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`,`ym`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED COMMENT='TopK WCC prediction value for the stocks'
/*!50100 PARTITION BY HASH (`ym`)
PARTITIONS 512 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcc_smp`
--

DROP TABLE IF EXISTS `wcc_smp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wcc_smp` (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `code` varchar(8) NOT NULL,
  `date` varchar(10) NOT NULL,
  `klid` int NOT NULL,
  `rcode` varchar(8) NOT NULL,
  `corl` double DEFAULT NULL,
  `corl_stz` double DEFAULT NULL COMMENT 'standardized correlation',
  `min_diff` double DEFAULT NULL,
  `max_diff` double DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `wcc_smp_idx_02` (`code`,`klid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED
/*!50100 PARTITION BY LINEAR HASH (`uuid`)
PARTITIONS 1024 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcc_trn`
--

DROP TABLE IF EXISTS `wcc_trn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wcc_trn` (
  `bno` int NOT NULL,
  `flag` varchar(2) NOT NULL,
  `code` varchar(8) NOT NULL,
  `date` varchar(10) NOT NULL,
  `klid` int NOT NULL,
  `rcode` varchar(8) NOT NULL,
  `corl_stz` double DEFAULT NULL COMMENT 'standardized correlation',
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  KEY `wcc_trn_idx_01` (`bno`,`flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED
/*!50100 PARTITION BY LINEAR HASH (`bno`)
PARTITIONS 8192 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worst_rec`
--

DROP TABLE IF EXISTS `worst_rec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worst_rec` (
  `model` varchar(45) NOT NULL,
  `start_time` varchar(20) NOT NULL,
  `phase` varchar(10) NOT NULL,
  `step` int NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `xentropy` double DEFAULT NULL,
  `predict` decimal(6,0) DEFAULT NULL,
  `truth` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`model`,`start_time`,`step`,`phase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xcorl_trn`
--

DROP TABLE IF EXISTS `xcorl_trn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcorl_trn` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(8) NOT NULL,
  `date` varchar(10) NOT NULL,
  `klid` int NOT NULL,
  `rcode` varchar(8) NOT NULL,
  `corl` double DEFAULT NULL,
  `flag` varchar(20) DEFAULT NULL,
  `udate` varchar(10) DEFAULT NULL,
  `utime` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`code`,`date`,`klid`,`rcode`),
  UNIQUE KEY `UNI_IDX_01` (`uuid`),
  KEY `IDX_FLAG` (`flag`,`uuid`),
  KEY `IDX_CORL` (`corl`,`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xdxr`
--

DROP TABLE IF EXISTS `xdxr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xdxr` (
  `code` varchar(6) NOT NULL COMMENT '股票代码',
  `name` varchar(10) DEFAULT NULL COMMENT '股票名称',
  `idx` int NOT NULL COMMENT '序号',
  `notice_date` varchar(10) DEFAULT NULL COMMENT '公告日期',
  `report_year` varchar(10) DEFAULT NULL COMMENT '报告期',
  `board_date` varchar(10) DEFAULT NULL COMMENT '董事会日期',
  `gms_date` varchar(10) DEFAULT NULL COMMENT '股东大会日期',
  `impl_date` varchar(10) DEFAULT NULL COMMENT '实施日期',
  `plan` varchar(300) DEFAULT NULL COMMENT '分红方案说明',
  `divi` double DEFAULT NULL COMMENT '分红金额（每10股）',
  `divi_atx` double DEFAULT NULL COMMENT '每10股现金(税后)',
  `dyr` double DEFAULT NULL COMMENT '股息率(Dividend Yield Ratio)',
  `dpr` double DEFAULT NULL COMMENT '股利支付率(Dividend Payout Ratio)',
  `divi_end_date` varchar(10) DEFAULT NULL COMMENT '分红截止日期',
  `shares_allot` double DEFAULT NULL COMMENT '每10股送红股',
  `shares_allot_date` varchar(10) DEFAULT NULL COMMENT '红股上市日',
  `shares_cvt` double DEFAULT NULL COMMENT '每10股转增股本',
  `shares_cvt_date` varchar(10) DEFAULT NULL COMMENT '转增股本上市日',
  `reg_date` varchar(10) DEFAULT NULL COMMENT '股权登记日',
  `xdxr_date` varchar(10) DEFAULT NULL COMMENT '除权除息日',
  `payout_date` varchar(10) DEFAULT NULL COMMENT '股息到帐日',
  `progress` varchar(45) DEFAULT NULL COMMENT '方案进度',
  `divi_target` varchar(45) DEFAULT NULL COMMENT '分红对象',
  `divi_amt` double DEFAULT NULL COMMENT '分红总额（亿）',
  `shares_base` bigint DEFAULT NULL COMMENT '派息股本基数',
  `end_trddate` varchar(10) DEFAULT NULL COMMENT '最后交易日',
  `xprice` varchar(1) DEFAULT NULL COMMENT '是否已更新过前复权价格信息',
  `udate` varchar(10) DEFAULT NULL COMMENT '更新日期',
  `utime` varchar(8) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`code`,`idx`),
  UNIQUE KEY `XDXR_IDX1` (`code`,`xdxr_date`,`reg_date`,`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Exclude Dividends Exclude Rights';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-09 13:30:21
