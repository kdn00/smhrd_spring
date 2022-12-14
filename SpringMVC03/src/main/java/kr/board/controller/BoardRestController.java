package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

// 전에는 POJO라는 것으 ㄹ알려주기 위해서 @Controller
// 이 컨트롤러는 json 데이터를 주고받기 위한 전문적인 컨트롤러 역할로 @RestController를 사용한다.

@RestController
public class BoardRestController {
	
	// 0) 만들어 놓은 mapper 객체를 불러온다
	// 의존성 주입(DI)
	@Autowired
	private BoardMapper mapper;
	
	// 게시판에 대한 요청을 다 board로 보내고 받고 하는데~
	// 어떤 내용을 실행할지를 구분하는 것은 요청 보내는 방식 get, post, put(update), delete
	// RESTful 규약
	
	// ajax에서 get방식으로 보내오고 있음
	// @ResponseBody를 쓰지 않아도 @RestController에 의해서 알아서 데이터를 보낸 것을 인식
	@GetMapping("/board") // /boardAjaxList.do
	public List<Board> boardAjaxList() {
		// 1) DB에서 게시판 리스트를 가져온다
		List<Board> list = mapper.boardList();
		
		// 2) 가져온 데이터를 JSON 형식으로 바꿔준다.
		// 2-1) 예전엔 dynamic 웹프로젝트여서 Gson.jar 파일을 넣어서
		//		Gson이 api가 json 형식을 처리할 수 있게 만들었음(toJson)
		// 		Maven 프로젝트였으면 pom.xml에 dependency를 넣어서 처리 가능
		// 2-2) return에다가 @ResponseBody
		// JSON 형태로 돌려주려면 pom.xml에다가 jackson 라이브러리를 추가해야 함	
		
		
		// 3) JSON 데이터를 보내준다. ajax로 보내준다.
		// jsp 이동을 하지 않는다.
		
		// return에는 1) jsp 2) redirect:/요청 3) 데이터를 넣어줄 수 있다. 
		return list;
	}
	
	
	 // post 방식의 요청
	 // 스프링이 파라미터 수집을 알아서 해오는데
	 // 넘어올 때 Board 객체의 property와
	 // 넘어오는 name값이 일치하면~
	@PostMapping("/board") // /boardAjaxInsert.do
	public void boardAjaxInsert(Board vo) {
		mapper.boardInsert(vo);
	}
	
	
	@DeleteMapping("/board/{idx}")
	public void boardAjaxDelete(@PathVariable int idx) {
		mapper.boardDelete(idx);
	}
	
	@PutMapping("/board")
	// @RequestBody로 보내줄 때는 JSON 형식으로 데이터를 받아오기 때문에 그냥 파라미터가 아님을 표시해준다.
	public void boardAjaxUpdate(@RequestBody Board vo) { // idx, content가 넘어오면 Board로 파라미터 수집
		// 1. mapper 일 시켜줘야 하는데~~
		//	  전에 만들었던 mapper.xml의 update 태그에 담긴 SQL문은 title까지 수정이었음
		//	  content만 바꿔주는 메소드를 새로 만들어야 함
		mapper.boardContentUpdate(vo);
	}
	
	
	@GetMapping("/updateCount/{idx}")
	public Board updateCount(@PathVariable int idx) {
		mapper.updateCount(idx);
		// DB에 있는 조회수를 가져와서 갱신시켜줘야하니까~~
		// 게시글 내용을 불러오는 mapper 메소드 일 시켜서 반환 받아야 함
		Board vo = mapper.boardContent(idx);
		
		return vo;
	}
	
	
	
	
}
