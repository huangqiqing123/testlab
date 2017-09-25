<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>自动跳转至用户中心进行认证</title>
</head>
<body>
	<form action="<%=request.getAttribute("uc_sso_url") %>" method="post" name="form1">
		<input type="hidden" name="RelayState" value="<%=request.getAttribute("relayState") %>">
		<input type="submit">
	</form>
</body>
<script type="text/javascript">
document.form1.submit();
</script>
</html>
