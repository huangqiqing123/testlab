<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%><html>
<head>
<title>��³�������ʵ�����ĵ�����ϵͳ</title>
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<table width="100%" height="100%">
	<tr height="40%"><!-- ��ʾ��ӭ���� -->
		<td nowrap="nowrap">          
			<h1 align="left"><font color=blue>Welcome����</font></h1>
			<h1 align="center"><font color=blue >��ӭ�����˳��������ʵ�����ĵ�����ϵͳ</font></h1>
		</td>
	</tr>
	<tr height="50%"><!-- ��ʾflash���� -->
	<td>
		<embed src="images/f1.swf"  width="100%" height="100%" 
			type="application/x-shockwave-flash"  
			wmode="transparent"/><!-- ����͸����ʾ --> 
		</embed>
	</td>
	</tr>
	<tr height="10%"><!-- ��ʾ��Ȩ��Ϣ -->
	<td>
	<jsp:include page="includes/copyright.jsp" flush="true" />
	</td>
	</tr>
</table>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />