<%@page import="kr.board.entity.Board"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
<title>순천 스인개 게시판</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="${cpath}/resources/css/index.css">
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script type="text/javascript">
  	$(document).ready(function() {
		// alert("제이쿼리 시작!");
		boardList();
  		}); // 제이쿼리 묶어주는 영역 끝!
		
		function boardList() {
		// ajax 기본 구조 만들기 : 페이지 요청을 다시 하는게 아니라
		// 서버와 통신을 해서 데이터를 가져오게 된다.
		// Rest Server
		// 데이터는 JSON 형식으로 주고 받게 된다.
		// JSON 형태 : [{key:value, key:value}, {}, {},...]
		$.ajax({
			url : "${cpath}/board",
			type : "get",
			// data : 리스트만 띄워줄거기 때문에 보내줄 데이터가 없음, 보내는 형식
			dataType : "json", // 서버가 클라이언트에게 돌려줄 데이터 형식을 적어줌, 받는 형식
			success : callBack, // 따로 함수를 만들어서 불러올 예정 (함수 이름만 기술)
			error : function() {
				alert("리스트 비동기방식 통신 실패!");
			}
		}); // ajax 끝!
		
  		}
		// 리스트 불러오는 ajax가 성공하면 실행 될 함수
		function callBack(data){
			// alert(data);
			console.log(data);
			
			var bList = "<table class='table table-hover table-bordered'>";
			bList += "<tr class='active'>";
			bList += "<td colspan='5'><small>게시글은 총 "+Object.keys(data).length+"개입니다.</small></td>";
			bList += "</tr>";
			bList += "<tr>";
			bList += "<td>번호</td>";
			bList += "<td>제목</td>";
			bList += "<td>작성자</td>";
			bList += "<td>작성일</td>";
			bList += "<td>조회수</td>";			
			bList += "</tr>";
			
			// 가져온 data에서 JSON 데이터를 반복문을 통해 만들기
			
			// 제이쿼리에서 반복하는 함수
			// $.each(데이터, 데이터를 처리할 함수)
			// function(매개변수){실행문장}을		(매개변수)=>{실행문장}으로 사용 가능
			$.each(data, (index, obj)=>{
				// console.log(index);
				bList += "<tr>";
				bList += "<td>"+ obj.idx +"</td>";
				// 제목을 누르면 글 내용이 보이게
				// a태그의 href가 요청이 아니라 자바스크립트 함수로 가게끔... 
				// 함수 사용 법
				// javascript:함수이름(보내줄 값)
				bList += "<td><a href='javascript:cview("+obj.idx+")'>"+ obj.title +"</a></td>";
				bList += "<td>"+ obj.writer +"</td>";
				bList += "<td>"+ obj.indate.split(" ")[0] +"</td>";
				bList += "<td id='count"+obj.idx+"'>"+ obj.count +"</td>";			
				bList += "</tr>";
				
				// 한 줄은 게시글 번호, 제목, 작성자, 작성일, 조회수면
				// 제목을 누르면 자세히 보기로 내용이(tr) 생긴다.
				bList += "<tr style='display:none' id='c"+obj.idx+"'>";
				bList += "<td>내용</td>";
				bList += "<td colspan='3'><textarea class='form-control' rows='3' id='nc"+obj.idx+"'>"+ obj.content +"</textarea></td>";
				// 로그인 된 아이디와 게시글 작성자, 곧 memId가 같다면 수정이 가능
				if("${loginMember.memId}" == obj.memId){
					bList += "<td><button class='btn btn-sm btn-info' onclick='goUpdate("+obj.idx+")'>수정</button>&nbsp;";
					bList += "<button class='btn btn-sm btn-warning' onclick='goDel("+obj.idx+")'>삭제</button></td>";		
				} else{
					// 로그인 한 사람의 글이 아니라면 닫기 버튼
					bList += "<td><button disabled class='btn btn-sm btn-info' onclick='goUpdate("+obj.idx+")'>수정</button>&nbsp;";
					bList += "<button class='btn btn-sm btn-danger' onclick='closeFn("+obj.idx+")'><span class='glyphicon glyphicon-remove'></span></button></td>";
				}				
				bList += "</tr>";
				
			});
			
			bList += "<tr>";
			bList += "<td colspan='5'>";
			bList += "<button class='btn btn-sm btn-info' onclick='goForm()'>글쓰기</button>";
			bList += "</td>";
			bList += "</tr>";
			bList += "</table>";

			$("#list").html(bList);
		} // callBack 함수 끝!
		
		function goForm() {
			// 글쓰기 버튼을 누르면
			// 게시판 리스트를 화면에서 없애고
			// 글쓰기 화면을 보여주기
			$("#list").css("display","none");
			$("#wform").css("display","block");			
		} // goForm 함수 끝
		
		function insertFn() {
			// title, content, writer 3개의 파라미터를 가지고 와서
			// ajax 통신을 통해서 DB에 값을 넣어줘야 한다.
			// form태그의 id에 들어가 있는 값을 직렬화 해서 가져오는 함수
			var fData = $("#frm").serialize();
			console.log(fData);
			$.ajax({
				url : "${cpath}/board",
				type : "post",
				data : fData,
				// dataType : , -- 받을게 없음~
				success : boardList, // onclick으로 쓰는 함수가 아니라서 이름만 기술한다.
				error : function(){
					alert("글쓰기 통신 실패");
				}
			}); // 글쓰기 통신하는 ajax
			
			// 글쓰기 화면을 없애고 다시 게시판 리스트를 보여주기
			$("#list").css("display","block");
			$("#wform").css("display","none");	
			
			// 글쓰기 form에 있는 내용 초기화
			// 제이쿼리에서 val()만 하면 value를 가져오는 set 역할
			// 만약에 val(값) <처럼 값을 넣어주려면, 값을 넣는 것은 set의 역할이다.
			// $("#title").val("");
			// $("#writer").val("");
			// $("#content").val("");
				
			// 초기화 2번째 방법
			// 제이쿼리 함수 중 trigger
			// click을 직접하지 않아도 알아서 click의 행동이 되게끔
			$("#reset").trigger("click");
		} // insertFn 함수 끝
		
		function cview(idx) {
			// c14, c17,... c+idx가 넘어온다.
			// 만약 지금 보이지 않는 상태이면~ display가 none이면~
			if($("#c"+idx).css("display") == "none"){
				// 내용이 열림
				// 내용이 열릴 때 조회수가 하나 올라가게끔, +1이 되게끔
				$.ajax({
					url : "${cpath}/updateCount/"+idx,
					type : "get",
					// boardList 함수를 부르면 모든 게시글을 다시 불러오니까
					// 해당 게시글만 열고 닫기해서 그 게시글의 조회수만 다시 불러오고자
					// success에 함수 직접 만들기
					success : function(vo) {
						console.log(vo);
						$("#count"+idx).text(vo.count);
					},
					error : function() {
						alert("조회수 올리기 실패!");	
					}
					
				}); // 조회수 올려주는 ajax 끝
				$("#c"+idx).css("display","table-row");
				
			} else{
				$("#c"+idx).css("display","none");
			}
			
		} // 게시글 내용 보여주는 함수 끝
		
		function goDel(idx) {
			// 출력해주는 함수 : alert, console, confirm(예, 아니오만 입력 가능함)
			// confirm을 눌러서 생긴 true/false를 조건식에 넣어가지고
			// if문은 true면 동작함
			var real = confirm("정말로 삭제하시겠습니까?");
			if(real){
				// ajax 통신에게 삭제 요청을 보내기
				$.ajax({
					url : "${cpath}/board/"+idx,
					type : "delete",
					// 만약 데이터를 보내줄거라면
					// 1. data : {"idx", idx} --> 파라미터로 보내기
					// 2. PathVariable --> url : "${cpath}/boardAjaxDelete.do/"+idx, 처럼 url 설정 뒤에 /를 붙인 후 idx를 더해준다.
					success : boardList,
					error : function() {
						alert("글쓰기 삭제 실패...")
					}
				}); // 삭제 ajax 끝
			}// if 끝
			
		}// goDel 함수 끝
		
		function goUpdate(idx) {
			var newContent = $("#nc"+idx).val();
			$.ajax({
				url : "${cpath}/board",
				type : "put",
				contentType : "application/json;charset=utf-8",
				data : JSON.stringify({"idx":idx, "content":newContent}),
				// data : {"idx":idx, "content":newContent},
				// {"idx":idx, "content":newContent}로 보내면 Board로
				// 스프링이 알아서 파라미터 수집을 한다!
				success : boardList,
				error : function() {
					alert("글쓰기 수정 실패...")
				}
				
			});
		}// goUpdate 함수 끝
		
		function closeFn(idx) {
			$("#c"+idx).css("display", "none");
		}
		
  </script>

</head>
<body>

	<div class="container">
		<h2>Spring MVC 03</h2>
		<div class="panel panel-default">
			<div class="panel-heading">
				<%-- if-else 구문으로 이용이 가능
				표현식에서 loginMember.memId는
				우리가 예전부터 사용했던 (Member)session.getAttribute("loginMember").getMemId()
				EL식에서 empty는 !=와 같은 의미이다.
				--%>
				<c:choose>
				<c:when test="${empty loginMember}">
				<form class="form-inline" action="${cpath}/Login.do" method="post">
					<div class="form-group">
						<label for="memId">아이디 :</label>
						<input type="text" class="form-control" name="memId" id="memId">
					</div>
					<div class="form-group">
						<label for="memPw">비밀번호:</label>
						<input type="password" class="form-control" name="memPw" id="memPw">
					</div>
					<button type="submit" class="btn btn-sm btn-default">로그인</button>
				</form>
				</c:when>
				
				<c:otherwise>
				<div class="form-group">
						<label for="mempw">${loginMember.memName}님 어서오세요</label>
						<a href="${cpath}/Logout.do" class="btn btn-sm btn-info">로그아웃</a>
				</div>
				</c:otherwise>
			
			<%-- 로그인을 하면 00님 환영합니다 와 로그아웃 버튼 만들기 --%>
			</c:choose>
			</div>
			
			<div class="panel-body" id="list" style="display: block">Panel Content</div>
			<div class="panel-body" id="wform" style="display: none">

				<!-- form태그의 action, method 속성을 삭제! 왜냐면 ajax로 보낼거니까~
    	form태그의 name의 값들을 자바스크립트가 받아줘야 함. 그래서 id를 부여
    	submit type을 button으로 바꿔야 함~~
     -->
				<form class="form-horizontal" id="frm">
				<input type="hidden" name="memId" value="${loginMember.memId}">
					<div class="form-group">
						<label class="control-label col-sm-2" for="title">제목:</label>
						<!-- input태그의 id와 label태그의 for와 일치 시켜준다. -->
						<div class="col-sm-10">
							<input type="text" class="form-control" name="title" id="title"
								placeholder="title">
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-2" for="content">내용:</label>
						<div class="col-sm-10">
							<textarea rows="10" class="form-control" id="content"
								name="content"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-2" for="writer">작성자:</label>
						<div class="col-sm-10">
							<input readonly type="text" class="form-control" name="writer" id="writer"
								value="${loginMember.memId}">
						</div>

					</div>
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button type="button" onclick="insertFn()"
								class="btn btn-sm btn-success">등록</button>
							<button type="reset" id="reset" class="btn btn-sm btn-info">취소</button>
							<a href="boardAjaxMain.do" type="button"
								class="btn btn-sm btn-primary">목록</a>
						</div>
					</div>
				</form>
			</div>

			<div class="panel-footer">Spring과 Bootstrap을 활용한 게시판_w.김도연</div>
		</div>
	</div>

</body>
</html>
