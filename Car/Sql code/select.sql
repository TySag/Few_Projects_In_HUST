use car;
SELECT * FROM car.staffs;
SELECT * FROM car.users;
select * from cars;
select * from Orders;

select * from fixlist where fix=null;

select * from cars 
where price>=100 and price <=150;

select fixlist.* from fixlist, records;

select *
from carsinfo;

select *
from staffs
where sid = 'admin';

select *
from users
where uid = 'zsf';


select fixlist.Fid, records.Rid, records.Cid, records.Uid, Cars.Name,fixlist.fix, fixlist.cost 
from fixlist, records, Cars 
where fixlist.Rid = records.Rid and records.Cid = Cars.Cid;

select Accident.Aid, records.Rid, records.Cid, records.Uid, Cars.Name, Accident.acc
from Accident, records, Cars
where Accident.Rid = records.Rid and records.Cid = Cars.Cid;






