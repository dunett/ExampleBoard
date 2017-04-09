<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// POST 한글 파라미터 깨짐 처리
	request.setCharacterEncoding("UTF-8");
	// 사용할 객체 초기화
	Connection conn = null;
	PreparedStatement pstmt = null;
	// 파라미터
	String mode = request.getParameter("mode");
	String PNO = request.getParameter("PNO");
	String PNAME = request.getParameter("PNAME");
	String CNO = request.getParameter("CNO");
	String CNAME = request.getParameter("CNAME");
	String FAVOR = request.getParameter("FAVOR");
	String DB_IP ="localhost";
	String DB_PORT ="1521";
	String DB_SID ="DB10";
	String DB_UserID ="KIM";
	String DB_UserPW ="bluesky";
	try {
		// 데이터베이스 객체 생성
		//Class.forName("com.mysql.jdbc.Driver");
		Class.forName("oracle.jdbc.driver.OracleDriver");  
		//conn = DriverManager.getConnection(
			//"jdbc:mysql://127.0.0.1:3306/stone", "root", "1234");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@"+DB_IP+":"+DB_PORT+":"+DB_SID+"", DB_UserID, DB_UserPW);
		// 처리 (W:등록, M:수정, D:삭제)
		if ("W".equals(mode)) {
			pstmt = conn.prepareStatement(
				"INSERT INTO COUNSEL (PNO,CNO,FAVORITE)"+
				"VALUES ((SELECT PNO FROM PRODUCT WHERE PNAME = '"+PNAME+"'),(SELECT CNO FROM CUSTOMER WHERE CNAME = '"+CNAME+"'),'"+FAVOR+"')");
			pstmt.executeUpdate();
	
			response.sendRedirect("Manage.jsp?result=1");
		} else if ("M".equals(mode)) {
			pstmt = conn.prepareStatement(
				"UPDATE COUNSEL SET FAVORITE = ? "+
				"WHERE PNO = ? AND CNO = ?");
			pstmt.setString(1, FAVOR);
			pstmt.setString(2, PNO);
			pstmt.setString(3, CNO);
			pstmt.executeUpdate();
			
			response.sendRedirect(
				"Manage.jsp?result=2");
		} else if ("D".equals(mode)) {
			pstmt = conn.prepareStatement("DELETE FROM COUNSEL WHERE PNO = ? AND CNO = ?");
			pstmt.setString(1, PNO);
			pstmt.setString(2, CNO);
			pstmt.executeUpdate();
			
			response.sendRedirect(
				"Manage.jsp?result=3");
		} else {
			response.sendRedirect("Manage.jsp");
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (pstmt != null) pstmt.close();
		if (conn != null) conn.close();
	}
%>
%>