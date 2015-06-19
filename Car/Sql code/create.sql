use car;
/*user*/
create table Users(
  Uid char(10) primary key,
  Pass char(20) not null,
  Name char(10) null, 
  Mail char(20) not null,
  Phone char(15) null, Address char(30) null,
  Blacklabel bool default 1);

create table CarsInfo(
  Name char(10) primary key,
  Brand char(10) null,
  /*Life int default 7300,*/
  Popular int not null,
  Totalnum int not null,
  Availnum int not null
);

create table Cars(
  Cid char(10) primary key,
  Name char(10) not null,
  Price int not null,
  Deposit int not null,
  Speed int not null,
  Days int not null default 0,
  State char(10) not null,
  foreign key(Name) references CarsInfo(Name)
);

create table Staffs(
  Sid char(10) primary key,
  Pass char(20) not null,
  Name char(10), 
  Pos char(10)
);
  
create table Orders(
  Oid char(10) primary key,
  Cid char(10) not null,
  Uid char(10) not null,
  Days int default 1,
  Date Datetime not null default now(),
  Checked bool not null default 0,
  foreign key(Cid) references Cars(Cid),
  foreign key(Uid) references Users(Uid)
);
  
create table Records(
  Rid char(10) primary key,
  Cid char(10) not null,
  Uid char(10) not null,
  Sid char(10) not null,
  Days int not null,
  Cost int not null,
  Date Datetime not null default now(),
  foreign key(Cid) references Cars(Cid),
  foreign key(Uid) references Users(Uid),
  foreign key(Sid) references Staffs(Sid)
);
  
create table Fixlist(
  Fid char(10) primary key,
  Rid char(10) not null,
  Fix char(40),
  Cost int,
  foreign key(Rid) references Records(Rid)
);

create table Accident(
  Aid char(10),
  Rid char(10) not null,
  Acc char(40),
  foreign key(Rid) references Records(Rid)
);  
  
drop table Fixlist;
drop table accident;
drop table records;
drop table orders;
drop table cars;
drop table staffs;
drop table carsinfo;
drop table users;
