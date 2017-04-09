<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<html>
<head>
<title></title>
<%@ page import="java.sql.*" %>
<%
Class.forName("oracle.jdbc.driver.OracleDriver");  
Connection conn = null;

String DB_IP ="localhost";
String DB_PORT ="1521";
String DB_SID ="DB10";
String DB_UserID ="KIM";
String DB_UserPW ="bluesky";
Statement  stmt          = null;
ResultSet  rs            = null;
String     sql           = ""; 
%>
</head>
<body>
<%
try {
 conn = DriverManager.getConnection("jdbc:oracle:thin:@"+DB_IP+":"+DB_PORT+":"+DB_SID+"", DB_UserID, DB_UserPW);
    stmt = conn.createStatement();
    sql = " select sysdate "
        +" from dual ";
   //out.println("<br>[SQL_01]===[ "+sql+" ]<br>");
   rs = stmt.executeQuery(sql);
   while(rs.next())
   {
    out.println("<br>sysdate=====["+rs.getString("sysdate")+"]");
   }
   rs.close();
}catch(SQLException e){
    out.println(e);
    e.printStackTrace();
} finally{
    try{
        if(rs!=null){ try{rs.close();}catch(Exception e){} }
        if(stmt!=null){ try{stmt.close();}catch(Exception e){} }
        if(conn != null){ try{conn.close();} catch(Exception ex){}}
    }catch(Exception e){}
}
%>
</body>
</html>

