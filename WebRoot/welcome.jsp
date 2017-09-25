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
<title>齐鲁软件评测实验室文档管理系统</title>
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<table width="100%" height="100%">
	<tr height="40%"><!-- 显示欢迎标语 -->
		<td nowrap="nowrap">          
			<h1 align="left"><font color=blue>Welcome——</font></h1>
			<h1 align="center"><font color=blue >欢迎进入浪潮软件评测实验室文档管理系统</font></h1>
		</td>
	</tr>
	<tr height="50%"><!-- 显示flash动画 -->
	<td>
		<embed src="images/f1.swf"  width="100%" height="100%" 
			type="application/x-shockwave-flash"  
			wmode="transparent"/><!-- 设置透明显示 --> 
		</embed>
	</td>
	</tr>
	<tr height="10%"><!-- 显示版权信息 -->
	<td>
	<jsp:include page="includes/copyright.jsp" flush="true" />
	</td>
	</tr>
</table>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />