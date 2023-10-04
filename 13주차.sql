-- 트랜젝션(transaction)
begin tran -- 임시작업 : 이 이후로 rollback과 commit 전까지의 작업은 백업이 되어있음. 실수해도 됨
rollback -- 트렌젝션 마무리 : 환원 (실제 데이터에 반영하지 않음)
commit -- 트렌젝션 마무리 : 실제 데이터에 반영

--#성적 테이블 복사
select* into #성적 from 성적
select* from #성적

-- 데이터 수정
update #성적 set 이름 = '박철수' -- 모든 이름이 박철수로 바뀜
select* from #성적

update #성적 set 이름 = '박철수'
where 이름='박보검'-- 박보검만 박철수로 바꿈

--점수가 80점 이사 학생들에게 +5점씩 추가시키기
select* from #성적
where 점수<=80

update #성적 set 점수 += 5
where 점수 <= 80

--박보영 => 박지영, 95점 => 90점
update #성적 set 점수 = 90, 이름='박지영'
where 이름='박보영'

-- 김수현 점수를 송중기 점수와 같게 하시오. (서브쿼리)
update #성적 set 점수 = (select 점수 from #성적 where 이름 = '송중기')
where 이름='김수현'

-- 평균점수 이하인 학생들에게 +2점씩 추가 시키기 (서브쿼리)
select* from #성적
where 점수 <= (select avg(점수) from #성적)

update #성적 set 점수 += 2
where 점수 <= (select avg(점수) from #성적)

-- 9장 워크북
-- 1. 졸작평가 테이블을 복사하여 #졸작평가 테이블을 생성하시오
select* into #졸작평가 from 졸작평가
select* from #졸작평가

--2. #졸작평가 테이블에서 정해인 학생의 점수를 95점으로 수정하시오.
update #졸작평가 set 점수=95
where 이름='정해인'

--3. #졸작평가 테이블에서 김태희 성적을 유승호 성적과 같게 수정하시오.
update #졸작평가 set 점수=(select 점수 from #졸작평가 where 이름='유승호')
where 이름='김태희'

--4. #졸작평가 테이블에서 조이름 ‘예쁘조’학생들에게 점수 2점 추가하시오.
update #졸작평가 set 점수+=2
where 조이름='예쁘조'

-- 책테이블 복사본
select* into #책 from 책
select* from #책
select* from 출판사

-- A&B 출판사의 책을 10%할인(곱하기 0.9) 수정하시오.(join on문 이용)
select *
from 출판사 join #책
on 출판사.출판사코드=#책.출판사코드
where 출판사명='A&B출판사'

update #책 set 가격*=0.9
from 출판사 join #책
on 출판사.출판사코드=#책.출판사코드
where 출판사명='A&B출판사'

-- 제품테이블 복사본
select* into #제품 from 제품
select* from #제품
select* from 판매

-- 판매수량이 16개 이상인 제품은 10%할인(곱하기 0.9) 하시오. (서브쿼리)
select* from #제품
where 제품번호 in 
(select 제품번호
from 판매
group by 제품번호
having sum(판매수량) >= 16)

update #제품 set 가격*=0.9
where 제품번호 in (select 제품번호
from 판매
group by 제품번호
having sum(판매수량) >= 16)

-- 졸작평가 테이블, 성적 테이블 조인
-- 성적 테이블의 예쁘조 학생들에게 점수를 2점씩 추가
select* from 성적
select* from 졸작평가

select 성적.*, 졸작평가.조이름
from 성적 join 졸작평가
on 성적.학번=졸작평가.학번
where 조이름='예쁘조'

update 성적 set 성적.점수+=2
from 성적 join 졸작평가
on 성적.학번=졸작평가.학번
where 조이름='예쁘조'

-- top()
select* from 제품
select* from 판매

select top 1 * from 판매
where 판매날짜='2019/02/16'

update top(1) 판매 set 판매수량+=1
where 판매날짜='2019/02/16'

-- 대상&소스 테이블
use SampleDB
drop table if exists 대상
drop table if exists 소스 
CREATE TABLE 대상
 (사번 INT PRIMARY KEY,
 이름 VARCHAR(10) NOT NULL,
 직급 VARCHAR(10) NOT NULL,
 부서 CHAR(20) NOT NULL)
 
 INSERT INTO 대상 VALUES(1,'홍길동','부장','홍보부')
 INSERT INTO 대상 VALUES(2,'김선달','부장','인사부')
 INSERT INTO 대상 VALUES(3,'이도령','과장','홍보부')
  
 CREATE TABLE 소스
 (사번 INT PRIMARY KEY,
 이름 VARCHAR(10) NOT NULL,
 직급 VARCHAR(10) NOT NULL,
 부서 CHAR(20) NOT NULL)
 
 INSERT INTO 소스 VALUES(1,'홍길동','부장','국제마케팅부')
 INSERT INTO 소스 VALUES(3,'이도령','부장','홍보부')
 INSERT INTO 소스 VALUES(4,'성춘향','과장','영업부')

 select* from 대상
 select* from 소스

 merge 대상 -- 세미콜론으로 끝내야함
 using 소스 on 대상.사번=소스.사번

 when matched then -- 대상.사번=소스.사번이 True라면
 update set 대상.직급=소스.직급, 대상.부서=소스.부서 -- 수정

 when not matched then -- 대상.사번=소스.사번이 false라면
 insert values(소스.사번,소스.이름,소스.직급,소스.부서); -- 삽입

 -- 5. #졸작평가 테이블에서 가장 낮은 점수를 받은 학생에게  3점 추가하시오.
select min(점수)
from 졸작평가

 update 졸작평가 set 점수+=3
 where 점수 = (select min(점수) from 졸작평가)
 
 -- 6. 성적테이블에서 A반 학생 중 가장 낮은 점수를 가진 학생을 찾아 
 -- 해당 학번 학생의 점수를 졸작평가 테이블에서 2점씩 추가하시오. 
update 졸작평가 set 점수+=2
where 학번=
(select 학번 from 졸작평가 where 점수=
(select min(점수) from 성적 where 반='A'))