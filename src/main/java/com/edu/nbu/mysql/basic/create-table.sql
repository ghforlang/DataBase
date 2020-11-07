-- t1
DROP TABLE IF EXISTS `t1`;
CREATE TABLE `t1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_t1_name` (`name`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1009 DEFAULT CHARSET=utf8mb4;

INSERT INTO `t1` VALUES
                        ('1001', '张三', '北京'),
                        ('1002', '李四', '天津'),
                        ('1003', '王五', '北京'),
                        ('1004', '赵六', '河北'),
                        ('1005', '杰克', '河南'),
                        ('1006', '汤姆', '河南'),
                        ('1007', '贝尔', '上海'),
                        ('1008', '孙琪', '北京');

-- t2
DROP TABLE IF EXISTS `t2`;
CREATE TABLE `t2`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_t2_name`(`name`(191)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1014 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;


INSERT INTO `t2` VALUES (1001, '张三', '北京');
INSERT INTO `t2` VALUES (1004, '赵六', '河北');
INSERT INTO `t2` VALUES (1005, '杰克', '河南');
INSERT INTO `t2` VALUES (1007, '贝尔', '上海');
INSERT INTO `t2` VALUES (1008, '孙琪', '北京');
INSERT INTO `t2` VALUES (1009, '曹操', '魏国');
INSERT INTO `t2` VALUES (1010, '刘备', '蜀国');
INSERT INTO `t2` VALUES (1011, '孙权', '吴国');
INSERT INTO `t2` VALUES (1012, '诸葛亮', '蜀国');
INSERT INTO `t2` VALUES (1013, '典韦', '魏国');