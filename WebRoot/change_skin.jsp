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
		<title>�л�Ƥ��</title>
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
	
	//�л�Ƥ��
	if(!"user_add.jsp".equals(from)){
	%>
			<h2 align="center" >
			<font color="blue">
				��ѡ����ϲ����Ƥ��
			</font>
			</h2>
	<hr>
	<% } %>
<% 
// ��ȡ ָ�� Ŀ¼�µ������� jpg ��  gif ��β��ͼƬ����
String SKIN_PIC_PATH = application.getRealPath("/")+"images\\skins";
String picNames[]=new GetPicNames().getPicNamesEndsWithJpg(SKIN_PIC_PATH);

//�л�Ƥ��
if(!"user_add.jsp".equals(from)){
for(int i=0;i<picNames.length;i++){
%>
	<a href="userdo.do?method=changeskin&skin=<%=picNames[i] %>" target="_parent">
	<IMG SRC="images/skins/<%=picNames[i] %>" WIDTH="120" HEIGHT="100" BORDER=0 ALT="��ѡ�񡢡���">
	</a>
<%}}
//ѡ��Ƥ��ͨ�ð���
else {
	for(int i=0;i<picNames.length;i++){%>
	
	<a href="#">
	<IMG SRC="images/skins/<%=picNames[i] %>" WIDTH="120" HEIGHT="100" BORDER=0 onclick="ok('<%=picNames[i]%>')" ALT="��ѡ�񡢡���">
	</a>

<%}}%>

	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />