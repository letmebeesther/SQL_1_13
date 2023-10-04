-- Ʈ������(transaction)
begin tran -- �ӽ��۾� : �� ���ķ� rollback�� commit �������� �۾��� ����� �Ǿ�����. �Ǽ��ص� ��
rollback -- Ʈ������ ������ : ȯ�� (���� �����Ϳ� �ݿ����� ����)
commit -- Ʈ������ ������ : ���� �����Ϳ� �ݿ�

--#���� ���̺� ����
select* into #���� from ����
select* from #����

-- ������ ����
update #���� set �̸� = '��ö��' -- ��� �̸��� ��ö���� �ٲ�
select* from #����

update #���� set �̸� = '��ö��'
where �̸�='�ں���'-- �ں��˸� ��ö���� �ٲ�

--������ 80�� �̻� �л��鿡�� +5���� �߰���Ű��
select* from #����
where ����<=80

update #���� set ���� += 5
where ���� <= 80

--�ں��� => ������, 95�� => 90��
update #���� set ���� = 90, �̸�='������'
where �̸�='�ں���'

-- ����� ������ ���߱� ������ ���� �Ͻÿ�. (��������)
update #���� set ���� = (select ���� from #���� where �̸� = '���߱�')
where �̸�='�����'

-- ������� ������ �л��鿡�� +2���� �߰� ��Ű�� (��������)
select* from #����
where ���� <= (select avg(����) from #����)

update #���� set ���� += 2
where ���� <= (select avg(����) from #����)

-- 9�� ��ũ��
-- 1. ������ ���̺��� �����Ͽ� #������ ���̺��� �����Ͻÿ�
select* into #������ from ������
select* from #������

--2. #������ ���̺��� ������ �л��� ������ 95������ �����Ͻÿ�.
update #������ set ����=95
where �̸�='������'

--3. #������ ���̺��� ������ ������ ����ȣ ������ ���� �����Ͻÿ�.
update #������ set ����=(select ���� from #������ where �̸�='����ȣ')
where �̸�='������'

--4. #������ ���̺��� ���̸� �����������л��鿡�� ���� 2�� �߰��Ͻÿ�.
update #������ set ����+=2
where ���̸�='������'

-- å���̺� ���纻
select* into #å from å
select* from #å
select* from ���ǻ�

-- A&B ���ǻ��� å�� 10%����(���ϱ� 0.9) �����Ͻÿ�.(join on�� �̿�)
select *
from ���ǻ� join #å
on ���ǻ�.���ǻ��ڵ�=#å.���ǻ��ڵ�
where ���ǻ��='A&B���ǻ�'

update #å set ����*=0.9
from ���ǻ� join #å
on ���ǻ�.���ǻ��ڵ�=#å.���ǻ��ڵ�
where ���ǻ��='A&B���ǻ�'

-- ��ǰ���̺� ���纻
select* into #��ǰ from ��ǰ
select* from #��ǰ
select* from �Ǹ�

-- �Ǹż����� 16�� �̻��� ��ǰ�� 10%����(���ϱ� 0.9) �Ͻÿ�. (��������)
select* from #��ǰ
where ��ǰ��ȣ in 
(select ��ǰ��ȣ
from �Ǹ�
group by ��ǰ��ȣ
having sum(�Ǹż���) >= 16)

update #��ǰ set ����*=0.9
where ��ǰ��ȣ in (select ��ǰ��ȣ
from �Ǹ�
group by ��ǰ��ȣ
having sum(�Ǹż���) >= 16)

-- ������ ���̺�, ���� ���̺� ����
-- ���� ���̺��� ������ �л��鿡�� ������ 2���� �߰�
select* from ����
select* from ������

select ����.*, ������.���̸�
from ���� join ������
on ����.�й�=������.�й�
where ���̸�='������'

update ���� set ����.����+=2
from ���� join ������
on ����.�й�=������.�й�
where ���̸�='������'

-- top()
select* from ��ǰ
select* from �Ǹ�

select top 1 * from �Ǹ�
where �Ǹų�¥='2019/02/16'

update top(1) �Ǹ� set �Ǹż���+=1
where �Ǹų�¥='2019/02/16'

-- ���&�ҽ� ���̺�
use SampleDB
drop table if exists ���
drop table if exists �ҽ� 
CREATE TABLE ���
 (��� INT PRIMARY KEY,
 �̸� VARCHAR(10) NOT NULL,
 ���� VARCHAR(10) NOT NULL,
 �μ� CHAR(20) NOT NULL)
 
 INSERT INTO ��� VALUES(1,'ȫ�浿','����','ȫ����')
 INSERT INTO ��� VALUES(2,'�輱��','����','�λ��')
 INSERT INTO ��� VALUES(3,'�̵���','����','ȫ����')
  
 CREATE TABLE �ҽ�
 (��� INT PRIMARY KEY,
 �̸� VARCHAR(10) NOT NULL,
 ���� VARCHAR(10) NOT NULL,
 �μ� CHAR(20) NOT NULL)
 
 INSERT INTO �ҽ� VALUES(1,'ȫ�浿','����','���������ú�')
 INSERT INTO �ҽ� VALUES(3,'�̵���','����','ȫ����')
 INSERT INTO �ҽ� VALUES(4,'������','����','������')

 select* from ���
 select* from �ҽ�

 merge ��� -- �����ݷ����� ��������
 using �ҽ� on ���.���=�ҽ�.���

 when matched then -- ���.���=�ҽ�.����� True���
 update set ���.����=�ҽ�.����, ���.�μ�=�ҽ�.�μ� -- ����

 when not matched then -- ���.���=�ҽ�.����� false���
 insert values(�ҽ�.���,�ҽ�.�̸�,�ҽ�.����,�ҽ�.�μ�); -- ����

 -- 5. #������ ���̺��� ���� ���� ������ ���� �л�����  3�� �߰��Ͻÿ�.
select min(����)
from ������

 update ������ set ����+=3
 where ���� = (select min(����) from ������)
 
 -- 6. �������̺��� A�� �л� �� ���� ���� ������ ���� �л��� ã�� 
 -- �ش� �й� �л��� ������ ������ ���̺��� 2���� �߰��Ͻÿ�. 
update ������ set ����+=2
where �й�=
(select �й� from ������ where ����=
(select min(����) from ���� where ��='A'))