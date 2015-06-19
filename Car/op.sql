use car;
insert into staffs values('admin','admin','admin','boss');
insert into users values('zsf','123456','张三丰','zsf@qq.com','','',0);


insert into carsinfo values('哈弗H6','长城', 0, 0, 0);
insert into carsinfo values('途观','大众', 0, 0, 0);
insert into carsinfo values('绅宝D70','北汽', 0, 0, 0);
insert into carsinfo values('奔腾B90','奔腾', 0, 0, 0);
insert into carsinfo values('福克斯','福特', 0, 0, 0);

insert into cars values('1','福克斯',100,100000, 120, 0, 'wait');
insert into cars values('2','途观',120,120000, 135, 0, 'wait');
insert into cars values('3','奔腾B90',150,150000, 160, 0, 'wait');
insert into cars values('4','福克斯',130,130000, 140, 0, 'wait');
insert into cars values('5','奔腾B90',170,170000, 200, 0, 'wait');
insert into cars values('6','绅宝D70',80,80000, 70, 0, 'wait');
insert into cars values('7','哈弗H6',70,60000, 60, 0, 'wait');

insert into orders values('2','1','zsf', 0);

update users set Blacklabel = 0, name = "zhang" where uid = 'zsf';
 
