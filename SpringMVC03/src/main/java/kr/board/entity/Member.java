package kr.board.entity;

public class Member {
	// Member 객체를 설계하려고 하는데
	// 어떤 설계가 잘한 설계인지~ 요소를 체크
	// 멤버 변수 = 프로퍼티(property) = 속성 = 필드명
	
	// 1. 정보은닉을 잘했는지 --> private로 지정해 getter와 setter로만 접근할 수 있게(public 사용x)
	private String memId;
	private String memPw;
	private String memName;
	

	// 2. 멤버 변수에 데이터를 넣어주고(set) 꺼내주는(get) 메소드를 만들어야 함
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	public String getMemPw() {
		return memPw;
	}
	public void setMemPw(String memPw) {
		this.memPw = memPw;
	}
	public String getMemName() {
		return memName;
	}
	public void setMemName(String memName) {
		this.memName = memName;
	}
	
	// 3. 객체가 가지고 있는 데이터 전체를 String으로 리턴해주는 메소드
	// 디버깅 요소로 사용할 수 있음
	// System.out.print(vo.getId());
	// System.out.print(vo.toString()); --> 모든 데이터를 볼 수 있게 됨
	@Override
	public String toString() {
		return "Member [memId=" + memId + ", memPw=" + memPw + ", memName=" + memName + "]";
	}
	
	// 4. 생성자 메소드
	// 로그인을 위해서 id, pw만 담긴 생성자
	// 회원가입을 위해서 id, pw, tel, address가 담긴 생성자
	// 선택적으로 만들 수 있음
	
	
}
