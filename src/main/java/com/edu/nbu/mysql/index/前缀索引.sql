-- 通常情况下可以使用某个列开始的部分字符串，这样大大的节约索引空间，从而提高索引效率，但这会降低索引的选择性，
-- 索引的选择性是指不重复的索引值和数据表记录总数的比值，范围从1/#T到1之间。索引的选择性越高则查询效率越高
-- 1、查询最常见的10个first_name，并统计出现次数；
select count(*) cnt,first_name from employees group by first_name order by cnt DESC limit 10;
-- 2、查询最常见的10个firs_name前缀，长度从3开始
select count(*) cnt,left(first_name,3) from employees group  by first_name order by cnt DESC limit 10;
select count(*) cnt,left(first_name,7) from employees group  by first_name order by cnt DESC limit 10;
-- 注： 选择更接近于全列长度的前缀长度，会更接近与实际查找结果

-- 3、计算每种前缀索引长度的效果,可以参考这个结果，构建前缀索引
select count(distinct left(first_name,3)) / count(*) cnt3 ,
       count(distinct left(first_name,4)) / count(*) cnt4,
       count(distinct left(first_name,5)) / count(*) cnt5,
       count(distinct left(first_name,6)) / count(*) cnt6,
       count(distinct left(first_name,7)) / count(*) cnt7,
       count(distinct (first_name)) / count(*) cnt from employees ;
-- 执行结果：
-- +--------+--------+--------+--------+--------+--------+
-- | cnt3   | cnt4   | cnt5   | cnt6   | cnt7   | cnt    |
-- +--------+--------+--------+--------+--------+--------+
-- | 0.0022 | 0.0033 | 0.0038 | 0.0041 | 0.0042 | 0.0042 |
-- +--------+--------+--------+--------+--------+--------+
-- 这里可看到，前7个字符的离散度最接近全字符长度，所以这里可以创建长度为7的前缀索引；
-- 4、创建长度为7的前缀索引(对于类型为BLOB、TEXT、VAERCHAR类型的列，必须要使用前缀索引)
alter table employees add key(first_name(7));
-- 查看当前表索引情况
-- 5、show index from employees \G;
-- 结果：
-- *************************** 1. row ***************************
--         Table: employees
--    Non_unique: 0
--      Key_name: PRIMARY
--  Seq_in_index: 1
--  Column_name: emp_no
--    Collation: A
--  Cardinality: 299335
--     Sub_part: NULL
--       Packed: NULL
--         Null:
--   Index_type: BTREE
--      Comment:
-- Index_comment:
-- *************************** 2. row ***************************
--        Table: employees
--   Non_unique: 1
--     Key_name: first_name
-- Seq_in_index: 1
--  Column_name: first_name
--    Collation: A
--  Cardinality: 1268
--     Sub_part: 7
--       Packed: NULL
--         Null:
--   Index_type: BTREE
--      Comment:
-- Index_comment:


-- 注： 缺点：mysql无法使用前缀索引做order by 和 group by。