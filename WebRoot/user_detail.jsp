<%
	//首先判断该用户是否已登录
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	
	if(!isSuperadmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>

<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="cn.sdfi.user.bean.User"%><html>
	<head>
		<title>信息明细</title>
	<base target="_self"> <!--在通用帮助中，执行新的操作后，仍然在通用帮助中显示，而不会弹出新的窗口  -->
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
		<script type="text/javascript">

		// 执行更新操作
		function forupdate() {
			document.forms[0].action = "userdo.do?method=forupdate";
			document.forms[0].submit();
		}

		//点击关闭按钮
		function close_window() {
			window.returnValue = null;
			window.close();
		}

		//发送Ajax请求到服务器，执行删除操作。
		function del() {

			if (!confirm('确认删除选中记录？记录删除后将不能恢复！')) {		
				return;
			}
			var req = getXmlHttpObject();
			var value = $('pk').value;
			var url = "userdo.do?method=delete&pk="+value+"&path=user_detail.jsp";
			req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {		
					var msg = req.responseText;
					alert(msg);
					window.close();
				}
			}
			};
			req.open("POST", url, false);
			req.send(null);
		}
		
		//返回XMLHttpRequest对象
		function getXmlHttpObject()
		{
		  var xmlHttp=null;
		  try
		    {
		    // Firefox, Opera 8.0+, Safari
		    xmlHttp=new XMLHttpRequest();
		    }
		  catch (e)
		    {
		    // Internet Explorer
		    try
		      {
		      xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		      }
		    catch (e)
		      {
		      xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		      }
		    }
		  return xmlHttp;
		}
		</script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
 <%
 	/*
 	*如果通过include引入alert页面的话，在IE8下，再次点击【修改】时，会弹出新的窗口。
 	*补充说明：在IE6下是始终正常的。
 	*/
	Object msg = request.getAttribute("msg");
 	if (msg != null&&(!"".equals(msg.toString()))) {
 		out.println("<script type=\"text/javascript\">");
 		out.println("document.getElementById('tips').innerHTML=\"<font color='red'>"+msg+"</font>\";");
 		out.print("</script>");
 	}
 %> 
	<%
	User user = (User) request.getAttribute("user.view");
	%>
	<%
	Map<String,String> user_role = Const.getEnumMap().get("user_role");
	%>

		<div align="right" ><br>
		<input type="button" value="修改" class="btbox" onclick="forupdate()"  >
		<input type="button" value="删除" class="btbox" onclick="del()" >
		<input type="button" class="btbox" value="关闭" onclick="close_window()">
		</div>

	<fieldset>
		<legend>用户信息明细</legend>
		<form name="form1" action="" method="post">
			<input type="hidden" name="pk" value="<%=URLEncoder.encode(user.getWho(),"GBK") %>">
		</form>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							员工姓名
						</td>
						<td>
							<input type="text"  value="<%=user.getWho() %>" size="30" maxlength="10"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							登录用户名
						</td>
						<td>
							<input type="text"  value="<%=user.getUsername() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
					</tr>
					
					<tr>
						<td>
							性别
						</td>
						<td>
						<input type="text"  value="<%=user.getSex() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
						</td>
					</tr>
					<tr>
						<td>
							角色
						</td>
						<td>
				<input type="text"  value="<%=user_role.get(user.getMylevel()) %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
					</td>
					</tr>
					<tr>
						<td>
							皮肤
						</td>
						<td>
							<img src="images\\skins\\<%=user.getSkin() %>" id="skin_img" width="150" height="100" >							
					</tr>
					<tr>
						<td nowrap="nowrap">
							入职时间
						</td>
						<td>
						<input type="text"  value="<%=user.getEntry_time()==null?"":user.getEntry_time() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
					<td nowrap="nowrap" >备注</td>
					<td >
						<textarea id="memo" name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=user.getMemo()==null?"":user.getMemo() %></textarea>
					</td>
					</tr>
				</table>
				</fieldset>
	</body>
</html>

