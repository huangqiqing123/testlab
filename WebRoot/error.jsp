<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<html>
	<head>
		<title>出错了</title>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" >
	<div align="center">
		<a href="#" onClick="javascript:parent.history.back(); return;"><img src="images/sorry.jpg"></a>
	</div>
	<fieldset><legend>错误信息</legend>
	<%=request.getAttribute("error")%>
	</fieldset>
	</body>
</html>
