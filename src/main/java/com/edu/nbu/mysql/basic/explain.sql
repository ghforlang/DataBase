-- 执行计划 指导优化SQL语句的执行，需要查看SQL语句的具体执行过程，以加快SQL语句的执行效率，我们就需要用到执行计划
-- 1、查看执行计划方式：
explain SELECT  * FROM employees;
-- 执行结果
-- +----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------+
-- | id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra |
-- +----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------+
-- |  1 | SIMPLE      | employees | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 299335 |   100.00 | NULL  |
-- +----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------+
-- 下面对结果里的每一个字段做详细解释
(1) id select查询的序列号，包含一组数字，表示查询中执行select子句或者操作表的顺序,mysql中的id执行顺序分三种情况：
    第一种：id相同，则执行顺序从上到下
    explain select * from dept_emp e join departments d on e.dept_no = d.dept_no join salaries sg on e.emp_no = sg.emp_no;
-- 执行结果
-- | id | select_type | table | partitions                                                                  | type  | possible_keys   | key       | key_len | ref                 | rows  | filtered | Extra       |
-- +----+-------------+-------+-----------------------------------------------------------------------------+-------+-----------------+-----------+---------+---------------------+-------+----------+-------------+
-- |  1 | SIMPLE      | d     | NULL                                                                        | index | PRIMARY         | dept_name | 42      | NULL                |     9 |   100.00 | Using index |
-- |  1 | SIMPLE      | e     | NULL                                                                        | ref   | PRIMARY,dept_no | dept_no   | 4       | employees.d.dept_no | 41446 |   100.00 | NULL        |
-- |  1 | SIMPLE      | sg    | p01,p02,p03,p04,p05,p06,p07,p08,p09,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19 | ref   | PRIMARY         | PRIMARY   | 4       | employees.e.emp_no  |     1 |   100.00 | NULL        |
-- +----+-------------+-------+-----------------------------------------------------------------------------+-------+-----------------+-----------+---------+---------------------+-------+----------+-------------+
     第二种：如果id不同，如果是子查询，id的序号会递增，id值越大优先级越高，越先被执行，例如：
    这是一个反例，这里不会用到子查询（为什么？），参照第二个例子
    explain select * from dept_emp e where e.dept_no in (select d.dept_no from departments d where d.dept_name = 'SALES');
-- 执行结果
-- +----+-------------+-------+------------+-------+-------------------+-----------+---------+-------+-------+----------+-------------+
-- | id | select_type | table | partitions | type  | possible_keys     | key       | key_len | ref   | rows  | filtered | Extra       |
-- +----+-------------+-------+------------+-------+-------------------+-----------+---------+-------+-------+----------+-------------+
-- |  1 | SIMPLE      | d     | NULL       | const | PRIMARY,dept_name | dept_name | 42      | const |     1 |   100.00 | Using index |
-- |  1 | SIMPLE      | e     | NULL       | ref   | dept_no           | dept_no   | 4       | const | 89530 |   100.00 | NULL        |
-- +----+-------------+-------+------------+-------+-------------------+-----------+---------+-------+-------+----------+-------------+
    explain select * from dept_emp e where e.dept_no = (select d.dept_no from departments d where d.dept_name = 'Sales');
-- +----+-------------+-------+------------+-------+---------------+-----------+---------+-------+-------+----------+-------------+
-- | id | select_type | table | partitions | type  | possible_keys | key       | key_len | ref   | rows  | filtered | Extra       |
-- +----+-------------+-------+------------+-------+---------------+-----------+---------+-------+-------+----------+-------------+
-- |  1 | PRIMARY     | e     | NULL       | ref   | dept_no       | dept_no   | 4       | const | 89530 |   100.00 | Using where |
-- |  2 | SUBQUERY    | d     | NULL       | const | dept_name     | dept_name | 42      | const |     1 |   100.00 | Using index |
-- +----+-------------+-------+------------+-------+---------------+-----------+---------+-------+-------+----------+-------------+
    第三种：id相同和不同的同时存在：相同的可以认为是一组，从上往下顺序执行，在所有组中，id值越大，优先级越高，越先执行
    explain select * from dept_emp e join departments d on e.dept_no = d.dept_no join salaries sg on e.emp_no = sg.emp_no  where e.dept_no = (select d.dept_no from departments d where d.dept_name = 'Sales');
-- +----+-------------+-------+-----------------------------------------------------------------------------+-------+-----------------+-----------+---------+--------------------+-------+----------+-------------+
-- | id | select_type | table | partitions                                                                  | type  | possible_keys   | key       | key_len | ref                | rows  | filtered | Extra       |
-- +----+-------------+-------+-----------------------------------------------------------------------------+-------+-----------------+-----------+---------+--------------------+-------+----------+-------------+
-- |  1 | PRIMARY     | d     | NULL                                                                        | const | PRIMARY         | PRIMARY   | 4       | const              |     1 |   100.00 | NULL        |
-- |  1 | PRIMARY     | e     | NULL                                                                        | ref   | PRIMARY,dept_no | dept_no   | 4       | const              | 89530 |   100.00 | Using where |
-- |  1 | PRIMARY     | sg    | p01,p02,p03,p04,p05,p06,p07,p08,p09,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19 | ref   | PRIMARY         | PRIMARY   | 4       | employees.e.emp_no |     1 |   100.00 | NULL        |
-- |  2 | SUBQUERY    | d     | NULL                                                                        | const | dept_name       | dept_name | 42      | const              |     1 |   100.00 | Using index |
-- +----+-------------+-------+-----------------------------------------------------------------------------+-------+-----------------+-----------+---------+--------------------+-------+----------+-------------+
（2）select_type 用于区分查询类型，主要有简单select、联合查询、自查询
    类型值：
    SIMPLE - 简单select
    explain select * from dept_emp;
+----+-------------+----------+------------+------+---------------+------+---------+------+--------+----------+-------+
| id | select_type | table    | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra |
+----+-------------+----------+------------+------+---------------+------+---------+------+--------+----------+-------+
|  1 | SIMPLE      | dept_emp | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 331570 |   100.00 | NULL  |
+----+-------------+----------+------------+------+---------------+------+---------+------+--------+----------+-------+

    PRIMARY - 外部select（outmost select），查询中包含复杂子查询，则外部select被标记为PRIMARY


    UNION - Second or later SELECT statement in a UNION
    DEPENDENT UNION - Second or later SELECT statement in a UNION, dependent on outer query
    UNION RESULT  - Result of a UNION.
    SUBQUERY - First SELECT in subquery
    DEPENDENT SUBQUERY - First SELECT in subquery, dependent on outer query
    DERIVED - Derived table
    UNCACHEABLE SUBQUERY - A subquery for which the result cannot be cached and must be re-evaluated for each row of the outer query
    UNCACHEABLE UNION - The second or later select in a UNION that belongs to an uncacheable subquery (see UNCACHEABLE SUBQUERY)