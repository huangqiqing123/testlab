<%if (Tool.isNotLogin(request)) {
				request.getRequestDispatcher("no_login.jsp").forward(request,
						response);
				return;
			}%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />

<%@page import="cn.sdfi.tools.Tool"%><html>
	<head>
	<title>在线阅读</title>
	<base target="_self"> 
<script type="text/javascript">
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin")%>" bottommargin="0" leftmargin="0" rightmargin="0" topmargin="0">
	<span id="tips"></span>
		<%
		String pk = request.getParameter("pk");
		String filepath = application.getRealPath("/")+"swf";
		java.io.File javafile = new java.io.File(filepath+"\\"+pk+".swf"); 
		if(javafile.exists()) { %>						
			<embed src="swf/<%=pk %>.swf"  width="100%" height="100%" type="application/x-shockwave-flash"  /> 
			</embed>
		<%} else{%>
		<br><br><br><br>
		<fieldset>
		<legend>提示</legend>
			<h3 align="center">Sorry，该文件暂不能在线阅读，请下载至本地后进行查看！</h3>
			<h3 align="center">
				<a style="CURSOR:hand" >	
				<u onclick="window.close()">关闭</u>
				</a>
			</h3>
		</fieldset>
		<%}%>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />			
