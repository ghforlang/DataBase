-- 登陆 输入密码
-- mysql -h localhost -u root -p

-- 切换到 test库
USE test;

-- 查看当前使用的数据库
SELECT database();

-- 查看当前连接有哪些数据库
SHOW databases ;

-- 查看当前库有哪些表
SHOW TABLES;

-- 查看简单描述表结构
DESC user;
-- 查看user表的建表语句
SHOW CREATE TABLE user;
SHOW CREATE TABLE user \G;
-- 复制表结构
CREATE TABLE user1 LIKE  user;
-- 复制表数据
INSERT INTO TABLE user1 SELECT * FROM user;
-- 查看test库user表中列的注释信息
SELECT * FROM information_schema.columns
WHERE table_schema= 'test'
AND table_name ='user';

-- 查看test库user表执行列信息
SELECT column_name as '列',column_type as '类型',column_comment as '注释'
FROM information_schema.columns
WHERE table_schema = 'test'
AND table_name = 'user';

-- 查看表注释
SELECT table_name as '表名',table_comment as  '注释'
FROM information_schema.tables
WHERE table_schema = 'test'
  AND table_name = 'user';

-- 更新表结构
ALTER TABLE user ADD INDEX `idx_name`(`name`) COMMENT '名称索引';
ALTER TABLE user ADD COLUMN `age` int(10) UNSIGNED NOT NULL COMMENT '年龄';

-- 获取表的write锁定 MyISAM；
LOCK TABLE `user` write;
-- 解锁
UNLOCK TABLES;
-- 获取表的read锁定 MyISAM
LOCK TABLE  `user` read;
-- 与上一命令不同，相关操作只会影响到local;
LOCK TABLE `user` READ LOCAL;

-- table_locks_waited和table_locks_immediate状态变量来分析系统上的表锁定争夺
-- Table_locks_waited的值比较高，则说明存在着较严重的表级锁争用情况
show status like 'table%';

-- 可以通过检查 InnoDB_row_lock来分析行锁竞争情况
-- 如果发现锁争用比较严重，如InnoDB_row_lock_waits和InnoDB_row_lock_time_avg的值比较高
show status like 'innodb_row_lock%';

-- 查看表索引信息;
SHOW INDEX FROM user;

-- 查询连接数
SHOW PROCESSLIST ;

-- 查询执行详情
SHOW PROFILES ;
SHOW PROFILE;

-- 查看系统配置,例如查看log配置
SHOW VARIABLES LIKE 'log_%';

-- 查看事务自动提交是否开启
SELECT @@AUTOCOMMIT;
SHOW VARIABLES LIKE '%commit%';
-- 查看缓存大小
SELECT @@sort_buffer_size;
SHOW VARIABLES LIKE '%buffer_size%';

-- 关闭/开启mysql服务
-- service mysqld stop;
-- service mysqld start;



