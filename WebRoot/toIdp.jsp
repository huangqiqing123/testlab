<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�Զ���ת���û����Ľ�����֤</title>
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
