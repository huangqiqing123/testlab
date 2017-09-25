<%
	//首先判断该用户是否已登录
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	
	if(!isSuperadmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Properties"%><html>
<head>
<title>查看系统日志</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<h2 align="center">查看系统日志</h2>
<div align="right"><input type="button" value="刷新" class="btbox" onclick="location.reload();"></div>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<%
	//加载日志配置文件
	Properties log4j_properties = Tool.load_property_file("log4j.properties");
	//取得日志存放路径
	String log_dir = log4j_properties.getProperty("log4j.appender.A1.File");
%>
	
<fieldset>
<legend>日志文件存放路径：<%=log_dir %></legend><br>	
<div>
	<%	
	//读取配置文件
	BufferedReader br = null;
	FileReader fileReader = null;
	try {
		 fileReader = new FileReader(log_dir);
		 br= new BufferedReader(fileReader);
		 String line = "";
		 while ((line = br.readLine()) != null) {
			out.println(line);
			out.println("<br>");
		}
	} catch (FileNotFoundException e) {
		out.print("出错了，没有找到日志文件！<br>");
		out.println(e);
	} catch (IOException e) {
		out.print("出错了！<br>");
		out.println(e);
	}finally{
		if(br!=null){		
			br.close();
		}
		if(fileReader!=null){		
			fileReader.close();
		}
	}
%>
</div>
</fieldset>
<div align="right">
<input type="button" class="btbox" value="返回顶部" onclick="scroll(0,0)" >
</div>
</body>
</html>
