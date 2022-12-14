create table board(
	idx int not null auto_increment,
	title varchar(1000) not null,
	content varchar(3000) not null,
	writer varchar(1000) not null,
	indate datetime not null default now(),
	count int not null default 0,
	primary key(idx)
);
-- 실행 키 : alt + x
-- int : 숫자형 타입
-- auto_increment : 자동으로 1씩 증가하며 들어가는 키워드
-- datetime : 날짜, 시간 넣어주는 타입
-- defualt : 따로 값을 넣어주지 않아도 초기값이 들어감
-- now() : sql 프로그램 안에서 현재 시간을 넣어주는 함수

select * from board;

-- 임의로 내용 넣기 auto_increment와 default가 있는 것 빼고
insert into board (title, content, writer)
values('스프링 게시판', '오늘 처음 써봅니다.', '김도연');

-- 회원정보 테이블
-- memId, memPw, memName

create table member(
	memId varchar(50) not null,
	memPw varchar(50) not null,
	memName varchar(50),
	primary key(memId)
);

select * from member;


insert into member values("test1", "1111", "테스터");
insert into member values("test2", "2222", "유저");
insert into member values("test3", "3333", "사용자");

-- board 테이블에 memId 컬럼 추가
alter table board add memId varchar(50);
