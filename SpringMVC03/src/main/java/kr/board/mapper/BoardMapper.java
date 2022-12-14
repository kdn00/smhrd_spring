package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import kr.board.entity.Board;
import kr.board.entity.Member;

// 우리가 알고 있는 DAO와 같은 일을 하는 것을 알려주는 주성
// @Repository
// 0. Mapper는 인터페이스 파일로 만든다.
@Mapper
public interface BoardMapper {
	// 자바 코드와 SQL문을 따로 관리
	// 이 둘을 이어주는 연결의 의미로 Mapper라는 의미가 강해져서 dao보다 mapper라는 표현을 사용
	
	// DAO에서도 join, login... 메소드 만들기
	// dao에서는 SqlSessionFactory 만들어서 Connection 풀을 유지하고 있었음
	// DB 연결은 스프링에서 알아서 만들어주고 있기 때문에 굳이 만들 필요가 없다
	// 스프링에서는 별도의 xml 파일에서 DB 커넥션을 이루고 있다.
	
	// Controller에 있는 메소드와 이름을 일치시킨다
	// 1. BoardController의 메소드와 이름을 일치시켜 만든다.
	// select의 결과물로 xml에서 resultType과 같은 반환 타입으로 메소드 리턴 타입을 만들어줘야 한다.
	public List<Board> boardList();
		// SQL문은 어디에? XML에 만든다.
		// 쿼리 연결을 위해서는 MyBatis 이용
		// 메소드 안에 적을 내용이 없어요~~ --> 추상 메소드
		// 인터페이스에서는 구현부가 없이 끝났었다~~
		// 그러면 BoardMapper는 class가 아니라 interface로 만들어야 한다!
	
	public void boardInsert(Board vo);

	public Board boardContent(int idx);

	public void boardUpdate(Board vo);
	
	// @Delete("SQL문") -> 절대절대 mapper.xml에서 또 만들지 않아야함.
	// 어노테이션으로 sql문 관리하면 xml이 필요하지 않게 된다.
	public void boardDelete(int idx);
	
	@Update("update board set content=#{content} where idx=#{idx}")
	public void boardContentUpdate(Board vo);
	
	@Update("update board set count=count+1 where idx=#{idx}")
	public void updateCount(int idx);

	public Member memberLogin(Member mvo);

}
