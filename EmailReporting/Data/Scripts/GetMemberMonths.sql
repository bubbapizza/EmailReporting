CREATE TEMPORARY TABLE YearMonths (YearMonth varchar(100), isFuture bit); 
INSERT INTO YearMonths 
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL 6 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL 6 MONTH)),2,'0'))     YearMonth, 1 IsFuture;
INSERT INTO YearMonths                                                                                                                
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL 5 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL 5 MONTH)),2,'0'))     YearMonth, 1 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL 4 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL 4 MONTH)),2,'0'))     YearMonth, 1 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL 3 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL 3 MONTH)),2,'0'))     YearMonth, 1 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL 2 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL 2 MONTH)),2,'0'))     YearMonth, 1 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL 1 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL 1 MONTH)),2,'0'))     YearMonth, 1 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(CURRENT_DATE()),LPAD(MONTH(CURRENT_DATE()),2,'0'))                                                           YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -1 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -1 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -2 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -2 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -3 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -3 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -4 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -4 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -6 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -6 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -7 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -7 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -8 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -8 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -9 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -9 MONTH)),2,'0'))   YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -10 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -10 MONTH)),2,'0')) YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -11 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -11 MONTH)),2,'0')) YearMonth, 0 IsFuture;
INSERT INTO YearMonths                                                                                                                       
SELECT Concat(YEAR(DATE_ADD(CURRENT_DATE(),INTERVAL -12 MONTH)),LPAD(MONTH(DATE_ADD(CURRENT_DATE(),INTERVAL -12 MONTH)),2,'0')) YearMonth, 0 IsFuture;


CREATE TEMPORARY TABLE ActiveMemberMonths (member_num int, YearMonth varchar(100)); 
INSERT INTO ActiveMemberMonths
SELECT 
member_num,
concat(year,lpad(month,2,'0')) as YearMonth
FROM `membermonth` mm
inner join YearMonths y 
on concat(year,lpad(month,2,'0')) = y.YearMonth;


CREATE TEMPORARY TABLE ActiveMembers (member_num int); 
INSERT INTO ActiveMembers
SELECT distinct
member_num
FROM ActiveMemberMonths;

select
concat(mem.last_name, ', ', mem.first_name) as MemberName,
mon.YearMonth as YearMonth,
mon.IsFuture as IsFuture,
case when act.member_num is null then 0 else 1 end as IsActive
FROM ActiveMembers am
inner join `member` mem
on am.member_num = mem.member_num
cross join YearMonths mon
left join ActiveMemberMonths act
on mem.member_num = act.member_num and mon.YearMonth = act.YearMonth
order by concat(mem.last_name, ', ', mem.first_name), mon.YearMonth