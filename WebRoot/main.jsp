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
		<title>��³�������ʵ�����ĵ�����ϵͳ</title>
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
				����������֧��ҳ��ָ
			</body>
		</noframes>

	</frameset>
	
</html>
