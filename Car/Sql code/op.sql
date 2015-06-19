use car;
insert into staffs values('admin','admin','admin','boss');
insert into users values('zsf','123456','张三丰','zsf@qq.com','','',0);


insert into carsinfo values('哈弗H6','长城', 0, 0, 0);
insert into carsinfo values('途观','大众', 0, 0, 0);
insert into carsinfo values('绅宝D70','北汽', 0, 0, 0);
insert into carsinfo values('奔腾B90','奔腾', 0, 0, 0);
insert into carsinfo values('福克斯','福特', 0, 0, 0);

insert into cars values('1','福克斯',100,100000, 120, 0, 'wait');

insert into orders values('2','1','zsf', 0);

update users set Blacklabel = 0, name = "zhang" where uid = 'zsf';
 
