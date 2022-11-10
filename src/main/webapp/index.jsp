<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>index</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		ol li {
		  background: #cce5ff;
		  color: darkblue;
		  margin: 5px;
		}
	</style>
</head>
<body>
	<h1 class="alert alert-success mx-auto" style="width:50%; text-align: center">INDEX</h1>
	<ol>
		<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a></li>
		<li><a href="<%=request.getContextPath()%>/emp/empList.jsp">사원 관리</a></li>
		<li><a href="<%=request.getContextPath()%>/board/boardList.jsp">게시판 관리</a></li>
	</ol>
</body>
</html>