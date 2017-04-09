<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 사용할 객체 초기화
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String DB_IP ="localhost";
	String DB_PORT ="1521";
	String DB_SID ="DB10";
	String DB_UserID ="KIM";
	String DB_UserPW ="bluesky";
	String whereSQL = "";
	// 파라미터
	String PNO = request.getParameter("PNO");
	String CNO = request.getParameter("CNO");
	whereSQL = " AND PRODUCT.PNO = '"+PNO+"' AND CUSTOMER.CNO = '"+CNO+"'";
	// 한글파라미터 처리
	//String searchTextUTF8 = new String(searchText.getBytes("ISO-8859-1"), "UTF-8");
	//System.out.println(searchTextUTF8);
	// 데이터베이스 커넥션 및 질의문 실행
	try {
		//Class.forName("com.mysql.jdbc.Driver");
		Class.forName("oracle.jdbc.driver.OracleDriver");  
		//conn = DriverManager.getConnection(
			//"jdbc:mysql://127.0.0.1:3306/stone", "root", "1234");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@"+DB_IP+":"+DB_PORT+":"+DB_SID+"", DB_UserID, DB_UserPW);
		// 게시물 목록을 얻는 쿼리 실행
		pstmt = conn.prepareStatement("select PRODUCT.PNAME,PRODUCT.PNO,CUSTOMER.CNAME,CUSTOMER.CNO,FAVORITE from COUNSEL,PRODUCT,CUSTOMER where COUNSEL.PNO=PRODUCT.PNO AND COUNSEL.CNO=CUSTOMER.CNO"+whereSQL);
		rs = pstmt.executeQuery();
		rs.next();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
	<input type="hidden" name="mode" value="M" />
	<input type="hidden" name="PNO" value="<%=rs.getString("PNO")%>" />
	<input type="hidden" name="CNO" value="<%=rs.getString("CNO")%>" />
	<table border="1" summary="선호도 수정">
		<caption>선호도 수정</caption>
		<colgroup>
			<col width="100" />
			<col width="140" />
		</colgroup>
		<tbody>
			<tr>
				<th align="center">제품</th>
				<td><input type="text" disabled="disabled" value="<%=rs.getString("PNAME") %>" style="text-align: center;"/></td>
			</tr>
			<tr>
				<th align="center">고객명</th>
				<td> <input type="text" disabled="disabled" value="<%=rs.getString("CNAME") %>" style="text-align: center;"/></td>
			</tr>
			<tr>
				<th align="center">선호도</th>
				<td align="center"><select name="FAVOR">
				<option value="2" <%if (rs.getInt("FAVORITE")==2) out.print("selected=\"selected\""); %>>상</option>
				<option value="1" <%if (rs.getInt("FAVORITE")==1) out.print("selected=\"selected\""); %>>중</option>
				<option value="0" <%if (rs.getInt("FAVORITE")==0) out.print("selected=\"selected\""); %>>하</option>
				</select></td>
			</tr>
		</tbody>
	</table>
	<p>
		<input type="submit" value="수정" onclick="goUrl('Process.jsp');"/>
		<input type="button" value="취소" onclick="goUrl('Manage.jsp');" />
	</p>
	</form>
</body>
</html>
<%
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstmt != null) pstmt.close();
		if (conn != null) conn.close();
	}
%>
