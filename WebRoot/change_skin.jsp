<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.GetPicNames"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.tools.Tool"%><html>
	<head>
		<title>切换皮肤</title>
	<script type="text/javascript">
	
	function ok(skin) {
		window.returnValue = skin;
		window.close();
	}
</script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
	String from = request.getParameter("from");
	
	//切换皮肤
	if(!"user_add.jsp".equals(from)){
	%>
			<h2 align="center" >
			<font color="blue">
				请选择你喜欢的皮肤
			</font>
			</h2>
	<hr>
	<% } %>
<% 
// 获取 指定 目录下的所有以 jpg 或  gif 结尾的图片名称
String SKIN_PIC_PATH = application.getRealPath("/")+"images\\skins";
String picNames[]=new GetPicNames().getPicNamesEndsWithJpg(SKIN_PIC_PATH);

//切换皮肤
if(!"user_add.jsp".equals(from)){
for(int i=0;i<picNames.length;i++){
%>
	<a href="userdo.do?method=changeskin&skin=<%=picNames[i] %>" target="_parent">
	<IMG SRC="images/skins/<%=picNames[i] %>" WIDTH="120" HEIGHT="100" BORDER=0 ALT="请选择、、、">
	</a>
<%}}
//选择皮肤通用帮助
else {
	for(int i=0;i<picNames.length;i++){%>
	
	<a href="#">
	<IMG SRC="images/skins/<%=picNames[i] %>" WIDTH="120" HEIGHT="100" BORDER=0 onclick="ok('<%=picNames[i]%>')" ALT="请选择、、、">
	</a>

<%}}%>

	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />