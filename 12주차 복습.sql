select* into #책
from 책
where 가격 < 12000

select* from #책

alter table #책
drop column 출판사코드, 출간날짜

select* from #책

alter table #책
add 출판사 char(20) default '배화출판사'

select* from #책

drop table #책