/*
-- Query: select * from idxlst
LIMIT 0, 2000

-- Date: 2020-02-14 15:12
*/
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','.DJI','道琼斯指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','.INX','标普500指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','.IXIC','纳斯达克综合指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','HKHSCCI','红筹指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','HKHSCEI','国企指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','hkhsi','恒生指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','HKVHSI','恒指波幅指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','ICS30','雪球中概30指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('tc','sh000001','上证指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','SH000011','基金指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','SH000300','沪深300');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('tc','sz399001','深证指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq','sz399006','创业板指');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq', 'sz399001', '深证指数');
INSERT INTO `secu`.`idxlst` (`src`,`code`,`name`) VALUES ('xq', 'sh000001', '上证指数');


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
