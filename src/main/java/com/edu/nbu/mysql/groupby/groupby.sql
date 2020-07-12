#基本用法，分组显示单条记录
SELECT * FROM courses GROUP BY `class`;

#多列分组
SELECT * FROM courses GROUP BY `class`,`student`;

#group_concat() 函数，合并分组内信息，例如 "student -A,B,C,D,class -Chinese,Chinese,Chinese,Chinese,score - 80,60,50,32"
SELECT group_concat(student) student ,group_concat(class) `class`,group_concat(score) `score` from courses GROUP BY `class`;

#统计记录总数
SELECT COUNT(*) total ,group_concat(`class`) class,group_concat(`student`) student FROM courses group by `class`;

#聚合
SELECT SUM(score) total_socre,AVG(score) avg_score,MAX(score) max_score,MIN(score) min_score,group_concat(student) students FROM courses group by `class`;

#对分组结果二次筛选(where 是第一次筛选)
SELECT AVG(score) avg_score,group_concat(`student`) students FROM courses GROUP BY `score` HAVING  avg_score > 70;

#with rollup 在分组统计数据基础上进行相同的统计(sum,max,min,avg,count)
SELECT class,student,score,COUNT(*) FROM courses GROUP BY `class`  with rollup HAVING score > 50 ;