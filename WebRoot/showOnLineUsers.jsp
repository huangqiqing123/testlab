<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="cn.sdfi.user.bean.User"%><html>
<head>
<title>在线用户信息查看</title> 
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<body background="images/skins/<%=session.getAttribute("skin") %>">
<div align=center>
<%
User user = null;
Map<String,User> map=Const.getOnlineUserMap();
if(map==null){
	out.print("<h2>没有在线用户</h2>");
	return;
}
%>
当前在线用户信息如下
<br>
共【<font color=red><%=map.size() %></font>】人
<div align="right">
<img src="images/boy.gif" height="20" width="20">男&nbsp;&nbsp;
<img src="images/girl.gif" height="20" width="20">女&nbsp;&nbsp;
<input type="button" class="btbox" value="刷新" onclick="window.location.href='showOnLineUsers.jsp'">
</div>
<fieldset><legend>在线用户</legend>
<table align="center" width="100%" cellpadding="1" cellspacing="0">
<tr>
<th align="center">序号</th><th align="center">用户名</th><th align="center">员工姓名</th><th align="center">性别</th><th align="center">登陆IP</th><th align="center">上线时间</th>
<% 
if(Tool.isSuperadmin(request)){
	out.print("<th width=\"50\" nowrap=\"nowrap\">操作</th>");
}
%>
</tr>
<%
int num=1;
Set set=map.keySet();
Iterator iter=set.iterator();
while(iter.hasNext()){
user=(User)map.get(iter.next());
%>
	<tr>
	<td align="center">
	<%=num++%>
	</td>
	<td align="center"><%=user.getUsername() %></td>
	<td align="center"><%=user.getWho() %></td>
	<td align="center">
	<%
	if(user.getSex().indexOf("男")>=0){
	%>
	<img src="images/boy.gif" height="20" width="20">
	<% }else{ %>
	<img src="images/girl.gif" height="20" width="20">
	<%}	%>
	</td>
	<td align="center"><%=user.getIp() %></td>
	<td align="center"><%=user.getLoginTime() %></td>
	<% 
if(Tool.isSuperadmin(request)){
	out.print("<td align=\"center\"><a href='userdo.do?method=outSession&username=");
	out.print(URLEncoder.encode(user.getUsername(),"GBK"));
	out.print("'>[断开]</a>");
}
%>	
	</tr>
	<%
    }
    %>
</table>
</fieldset>
</div>
</body>
</html>