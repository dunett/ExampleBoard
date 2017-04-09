<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 사용할 객체 초기화
	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	String DB_IP ="localhost";
	String DB_PORT ="1521";
	String DB_SID ="DB10";
	String DB_UserID ="KIM";
	String DB_UserPW ="bluesky";
	String whereSQL = "";
	// 파라미터
	String searchType = request.getParameter("searchType");
	String searchText = request.getParameter("searchText");
	String result = request.getParameter("result");
	// 파라미터 초기화
	if (searchText == null) {
		searchType = "";
		searchText = "";
	}
	// 한글파라미터 처리
	//String searchTextUTF8 = new String(searchText.getBytes("ISO-8859-1"), "UTF-8");
	//System.out.println(searchTextUTF8);
	// 데이터베이스 커넥션 및 질의문 실행
	// 검색어 쿼리문 생성
	if (!"".equals(searchText)) {
		if ("ALL".equals(searchType)) {
			whereSQL = " AND PRODUCT.PNAME = '"+searchText+"' OR CUSTOMER.CNAME = '"+searchText+"'";
		} else if ("PRODUCT".equals(searchType)) {
			whereSQL = " AND PRODUCT.PNAME = '"+searchText+"'";
		} else if ("CUSTOMER".equals(searchType)) {
			whereSQL = " AND CUSTOMER.CNAME = '"+searchText+"'";
		}
	}
	try {
		//Class.forName("com.mysql.jdbc.Driver");
		Class.forName("oracle.jdbc.driver.OracleDriver");  
		//conn = DriverManager.getConnection(
			//"jdbc:mysql://127.0.0.1:3306/stone", "root", "1234");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@"+DB_IP+":"+DB_PORT+":"+DB_SID+"", DB_UserID, DB_UserPW);
		// 게시물 목록을 얻는 쿼리 실행
		String SQL ="select PRODUCT.PNAME,CUSTOMER.CNAME,FAVORITE from COUNSEL,PRODUCT,CUSTOMER where COUNSEL.PNO=PRODUCT.PNO AND COUNSEL.CNO=CUSTOMER.CNO"+whereSQL;
		pstmt = conn.prepareStatement("select PRODUCT.PNAME,PRODUCT.PNO,CUSTOMER.CNAME,CUSTOMER.CNO,FAVORITE from COUNSEL,PRODUCT,CUSTOMER where COUNSEL.PNO=PRODUCT.PNO AND COUNSEL.CNO=CUSTOMER.CNO"+whereSQL);
		rs = pstmt.executeQuery();
		pstmt2 = conn.prepareStatement("select distinct product.pname,(select count(favorite) from counsel s where favorite = 2 and s.pno=s1.pno)/(select count(favorite) from counsel s where s.pno=s1.pno)*100 as U,(select count(favorite) from counsel s where favorite = 1 and s.pno=s1.pno)/(select count(favorite) from counsel s where s.pno=s1.pno)*100 as M, (select count(favorite) from counsel s where favorite = 0 and s.pno=s1.pno)/(select count(favorite) from counsel s where s.pno=s1.pno)*100 as D from counsel s1,product where s1.PNO=product.PNO");
		rs2 = pstmt2.executeQuery();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>선호도 조회</title>
</head>
<style type="text/css">
	* {font-size: 9pt;}
	p {width: 600px; text-align: right;}
	table thead tr th {background-color: gray;}
</style>
<script type="text/javascript">
	<%-- <%if(!"".equals(result)){%>
	 window.onload = function() {
		<%if("1".equals(result)){ %>
		alert('등록되었습니다.');
		<%}else if("2".equals(result)){%>
		alert('수정되었습니다.');
		<%}else if("3".equals(result)){%>
		alert('삭제되었습니다.');
		<%}%>
	}
	<%} %> --%>
	function goUrl(url) {
		location.href=url;
	}
	function CancelCheck(url) {
		if(confirm("삭제하시겠습니까?")){
			goUrl(url);
		}
	}
	// 검색 폼 체크
	function searchCheck() {
		var form = document.searchForm;
		if (form.searchText.value == '') {
			alert('검색어를 입력하세요.');
			form.searchText.focus();
			return false;
		}
		return true;
	}
</script>
<body>
	<form name="searchForm" action="Manage.jsp" method="get" onsubmit="return searchCheck();" >
	<p>
		<select name="searchType">
			<option value="ALL" selected="selected">전체검색</option>
			<option value="PRODUCT" <%if ("PRODUCT".equals(searchType)) out.print("selected=\"selected\""); %>>제품이름</option>
			<option value="CUSTOMER" <%if ("CUSTOMER".equals(searchType)) out.print("selected=\"selected\""); %>>고객이름</option>
		</select>
		<input type="text" name="searchText" value="<%=searchText%>" />
		<input type="submit" value="검색" />
	</p>
	</form>
<table border="1" summary="선호도 조회">
		<caption>선호도 조회</caption>
		<colgroup>
			<col width="200" />
			<col width="200" />
			<col width="100" />
			<col width="100" />
		</colgroup>
		<thead>
			<tr>
				<th>제품이름</th>
				<th>고객이름</th>
				<th>선호도</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody>
			<%
				int i = 0;
				while (rs.next()) {
					i++;
			%>
			<tr>
				<td align="center"><%=rs.getString("PNAME") %></td>
				<td align="center"><%=rs.getString("CNAME") %></td>
				<td align="center">
				<%if(rs.getInt("FAVORITE")==2){%>
				상
				<%}else if(rs.getInt("FAVORITE")==1){ %>
				중
				<%}else if(rs.getInt("FAVORITE")==0){ %>
				하
				<%} %>
				</td>
				<td align="center"><input type="button" value="수정" onclick="goUrl('updateF.jsp?PNO=<%=rs.getString("PNO")%>&CNO=<%=rs.getString("CNO")%>');"><input type="button" value="삭제" onclick="CancelCheck('Process.jsp?PNO=<%=rs.getString("PNO")%>&CNO=<%=rs.getString("CNO")%>&mode=D');">
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<p>
		<input type="button" value="목록" onclick="goUrl('Manage.jsp');" />
		<input type="button" value="선호도등록" onclick="goUrl('insertF.jsp');" />
	</p>
	<table border="1">
		<caption>선호도 비율</caption>
		<colgroup>
			<col width="200" />
			<col width="133" />
			<col width="133" />
			<col width="133" />
		</colgroup>
		<thead>
			<tr>
				<th>제품이름</th>
				<th>상</th>
				<th>중</th>
				<th>하</th>
			</tr>
		</thead>
		<tbody>
			<%
				int j = 0;
				while (rs2.next()) {
					j++;
			%>
			<tr>
				<td align="center"><%=rs2.getString("PNAME") %></td>
				<td align="center"><%=rs2.getString("U") %>%</td>
				<td align="center"><%=rs2.getString("M") %>%</td>
				<td align="center"><%=rs2.getString("D") %>%</td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
</body>
</html>
<%
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (rs2 != null) rs2.close();
		if (pstmt != null) pstmt.close();
		if (pstmt2 != null) pstmt2.close();
		if (conn != null) conn.close();
	}
%>
