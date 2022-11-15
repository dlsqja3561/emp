<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 메뉴 partial jsp 페이지 사용 -->

<a href="<%=request.getContextPath()%>/index.jsp" class="menu">홈으로</a>
<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="menu">부서관리</a>
<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="menu">사원관리</a>
<a href="<%=request.getContextPath()%>/salary/salaryList.jsp" class="menu">연봉관리</a>
<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="menu">게시판관리</a>