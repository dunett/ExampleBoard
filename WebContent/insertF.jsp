<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.sql.*" %>
<%
	// 사용할 객체 초기화
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	String DB_IP ="localhost";
	String DB_PORT ="1521";
	String DB_SID ="DB10";
	String DB_UserID ="KIM";
	String DB_UserPW ="bluesky";
	String whereSQL = "";
	// 한글파라미터 처리
	//String searchTextUTF8 = new String(searchText.getBytes("ISO-8859-1"), "UTF-8");
	//System.out.println(searchTextUTF8);
	// 데이터베이스 커넥션 및 질의문 실행
	// 검색어 쿼리문 생성
	try {
		//Class.forName("com.mysql.jdbc.Driver");
		Class.forName("oracle.jdbc.driver.OracleDriver");  
		//conn = DriverManager.getConnection(
			//"jdbc:mysql://127.0.0.1:3306/stone", "root", "1234");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@"+DB_IP+":"+DB_PORT+":"+DB_SID+"", DB_UserID, DB_UserPW);
		// 게시물 목록을 얻는 쿼리 실행
		pstmt = conn.prepareStatement("select pname from product");
		rs = pstmt.executeQuery();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>선호도 등록</title>
<style type="text/css">
	* {font-size: 9pt;}
	p {width: 250px; text-align: right;}
	table tbody tr th {background-color: gray;}
</style>
<script type="text/javascript">
	function goUrl(url) {
		location.href=url;
	}
	function boardWriteCheck() {
		var form = document.boardWriteForm;
		return true;
	}
</script>
</head>
<body>
	<form name="boardWriteForm" action="Process.jsp" method="post" onsubmit="return boardWriteCheck();">
	<input type="hidden" name="mode" value="W" />
	<table border="1" summary="선호도 등록">
		<caption>선호도 등록</caption>
		<colgroup>
			<col width="100" />
			<col width="140" />
		</colgroup>
		<tbody>
			<tr>
				<th align="center">제품</th>
				<td><input type="text" name="PNAME"/></td>
			</tr>
			<tr>
				<th align="center">고객명</th>
				<td><input type="text" name="CNAME"/></td>
			</tr>
			<tr>
				<th align="center">선호도</th>
				<td align="center">
					<select name="FAVOR">
						<option value="2">상</option>
						<option value="1">중</option>
						<option value="0">하</option>
					</select>
				</td>
			</tr>
		</tbody>
	</table>
	<p>
		<input type="submit" value="등록" />
		<input type="button" value="취소" onclick="goUrl('Manage.jsp');" />
	</p>
	</form>
	<table border="1">
	<tr>
	<td colspan="100" align="center">등록가능한 제품,고객목록</td>
	</tr>
	<tr>
	<th align="center">제품이름</th>
	<%
		int i = 0;
		while (rs.next()) {
		i++;
	%>
	<td align="center"><%=rs.getString("PNAME") %></td>
	<%
		}
	%>
	</tr>
	<%
	pstmt2 = conn.prepareStatement("select cname from customer");
	rs2 = pstmt2.executeQuery();
	%>
	<tr>
	<th align="center">고객이름</th>
		<%
		int j = 0;
		while (rs2.next()) {
		j++;
	%>
	<td align="center"><%=rs2.getString("CNAME") %></td>
	<%
		}
	%>
	</tr>
	</table>
</body>
</html>
<%
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstmt != null) pstmt.close();
		if (rs2 != null) rs2.close();
		if (pstmt2 != null) pstmt2.close();
		if (conn != null) conn.close();
	}
%>
