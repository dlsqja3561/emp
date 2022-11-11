<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");

	System.out.println(boardNo+"<-boardNo"); // 디버깅
	System.out.println(commentNo+"<-commentNo");
	System.out.println(commentPw+"<-commentPw");
	
	
	// 2. 요청처리
		// 드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("드라이버 로딩 성공"); // 디버깅
		// 마리아db 접속
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
		// 쿼리 입력
		String sql = "delete from comment where board_no=? and comment_no=? and comment_pw=?"; // 
		// 쿼리 셋팅
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardNo);
		stmt.setInt(2, commentNo);
		stmt.setString(3, commentPw);
		// 쿼리 실행
		int row = stmt.executeUpdate();
		// 쿼리 실행 결과
		if(row == 1) {
			System.out.println("삭제성공");
			response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		} else {
			System.out.println("삭제실패");
			String msg = URLEncoder.encode("삭제실패 비밀번호가 틀렸습니다. 다시 입력해 주세요.","utf-8"); // get방식 주소창에 문자열 인코딩
			response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
		}
			

%>