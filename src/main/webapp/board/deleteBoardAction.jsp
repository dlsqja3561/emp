<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	
	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardNo+"<-boardNo"); // 디버깅
	System.out.println(boardPw+"<-boardPw");
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// 마리아db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	// 쿼리 입력
	String sql = "delete from board where board_no=? and board_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
		String msg = URLEncoder.encode("삭제실패 비밀번호가 틀렸습니다.","utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?msg="+msg);
		return;
	}
			
	

	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	// 3. 출력
%>