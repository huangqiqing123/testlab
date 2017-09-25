<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="test1" prefix="test1"%>
<jsp:include page="../includes/encoding.jsp" flush="true" />

<html>
	<head>
		<title>测试标签</title>
	</head>
	<body>
	<test1:hello times="2" test1="1111111111111" >
	<br>我是body里面的内容
	</test1:hello>
	我是end标签下面的内容
	</body>
</html>
