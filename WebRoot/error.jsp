<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<html>
	<head>
		<title>������</title>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" >
	<div align="center">
		<a href="#" onClick="javascript:parent.history.back(); return;"><img src="images/sorry.jpg"></a>
	</div>
	<fieldset><legend>������Ϣ</legend>
	<%=request.getAttribute("error")%>
	</fieldset>
	</body>
</html>
