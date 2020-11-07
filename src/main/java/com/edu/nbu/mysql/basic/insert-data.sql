-- 传入需要插入数据的id开始值和数据量大小，函数返回结果为最终插入的条数，此值正常应该等于数据量大小。
-- id自增，循环往 t1 表添加数据。这里为了方便，id、name取同一个变量，address就为北京。
drop function if exists insert_datas1;
create function insert_datas1(in_start int(11),in_len int(11)) returns int(11)
begin
  declare cur_len int(11) default 0;
  declare cur_id int(11);
  set cur_id = in_start;

  while cur_len < in_len do
  insert into t1 values(cur_id,cur_id,'北京');
  set cur_len = cur_len + 1;
  set cur_id = cur_id + 1;
  end while;
  return cur_len;
end

-- 同样的，往 t2 表插入数据
drop function if exists insert_datas2;
create function insert_datas2(in_start int(11),in_len int(11)) returns int(11)
begin
  declare cur_len int(11) default 0;
  declare cur_id int(11);
  set cur_id = in_start;

  while cur_len < in_len do
  insert into t2 values(cur_id,cur_id,'北京');
  set cur_len = cur_len + 1;
  set cur_id = cur_id + 1;
  end while;
  return cur_len;
end
