<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	// 1.
	
	
	// 2.
	int rowPerPage = 5;
	int beginRow = 0;
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
	PreparedStatement stmt = conn. prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();

	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.dept = new Department();
		de.dept.deptNo = rs.getString("deptNo");
		de.fromDate = rs.getString("fromDate");
		de.toDate = rs.getString("toDate");
		list.add(de);
	}
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<table border="1">
			<tr>
				<th>empNo</th>
				<th>deptNo</th>
				<th>fromDate</th>
				<th>toDate</th>
			</tr>
			<%
				for(DeptEmp de : list) {
			%>
					<tr>
						<td><%=de.emp.empNo%></td>
						<td><%=de.dept.deptNo%></td>
						<td><%=de.fromDate%></td>
						<td><%=de.toDate%></td>
					</tr>
			<%      
				}
			%>
		</table>
	</div>
</body>
</html>