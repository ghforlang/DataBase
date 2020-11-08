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