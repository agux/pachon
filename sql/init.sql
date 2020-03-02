/*
-- Query: select * from idxlst
LIMIT 0, 2000

-- Date: 2020-03-02 17:09
*/
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('tc','SH','sh000001','上证指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('tc','SZ','sz399001','深证指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','US','.DJI','道琼斯指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','US','.INX','标普500指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','US','.IXIC','纳斯达克综合指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','HK','HKHSCCI','红筹指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','HK','HKHSCEI','国企指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','HK','hkhsi','恒生指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','HK','HKVHSI','恒指波幅指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','US','ICS30','雪球中概30指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','SH','sh000001','上证指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','SH','SH000011','基金指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','SH','SH000300','沪深300');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','SZ','sz399001','深证指数');
INSERT INTO `secu`.`idxlst` (`src`,`market`,`code`,`name`) VALUES ('xq','SZ','sz399006','创业板指');


/*
-- Query: SELECT * FROM secu.code_map
LIMIT 0, 2000

-- Date: 2020-02-24 20:50
*/
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (1,'xq','.DJI','em','DJIA',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (2,'xq','.INX','em','SPX',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (3,'xq','.IXIC','em','NDX',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (4,'xq','HKHSCCI','em','HSCCI',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (5,'xq','HKHSCEI','em','HSCEI',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (6,'xq','hkhsi','em','HSI',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (7,'xq','HKVHSI','em','VHSI',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (8,'xq','sh000001','em','000001',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (9,'xq','SH000011','em','000011',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (10,'xq','SH000300','em','000300',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (11,'xq','sz399001','em','399001',NULL);
INSERT INTO `secu`.`code_map` (`id`,`f_src`,`f_code`,`t_src`,`t_code`,`remark`) VALUES (12,'xq','sz399006','em','399006',NULL);
