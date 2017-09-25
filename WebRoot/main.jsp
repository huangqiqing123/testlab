<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%><html>
	<head>
		<title>齐鲁软件评测实验室文档管理系统</title>
	</head>
	<frameset id="main"  cols="190,9,*" border="0" style="margin-left: 0;margin-right: 0">
		<frame id="left" name="left" src="menu.jsp" scrolling="auto"  >
		<frame id="middle" name="middle"  src="includes/middle.jsp"  noresize="noresize" scrolling="no"/>  
		<frame src="	
		<%
		Object path=request.getParameter("path");
		if("changeSkin".equals(path)){
			out.print("change_skin.jsp");
		}else{
			out.print("welcome.jsp");
		}
		%>
		" scrolling="auto" name="show">
		<noframes>
			<body>
				你的浏览器不支持页面分割！
			</body>
		</noframes>

	</frameset>
	
</html>
