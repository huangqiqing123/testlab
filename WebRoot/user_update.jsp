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
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.user.bean.User"%><html>
<head>
<title>档案袋新增页面</title>
<base target="_self"> <!--在通用帮助中，执行新的操作后，仍然在通用帮助中显示，而不会弹出新的窗口  -->
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

//接收组件id
function isExist(which) {

		//发送Ajax请求到服务器，验证员工姓名、用户名是否已存在
		var req = getXmlHttpObject();
		var flag = false;
		var value = $(which).value;
		var url = "userdo.do?method=isExist&value=" + value + "&which=" + which;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;
					var array = msg.split(',');
					if (array[0] == "username") {
						var username_result = $("username_result");
						if (array[1] == "0") {
							username_result.innerHTML = "<font color='green'>OK</font>";
							flag = true;
						} else if (array[1] == "1") {
							username_result.innerHTML = "<font color='red'>该登录用户名已注册，请重新输入！</font>";
							$('username').focus();
						} else {
							alert("验证登录用户名出现异常！");
						}
					} else {
						alert("解析返回值出现异常！");
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return flag;
	}
	//返回XMLHttpRequest对象
	function getXmlHttpObject() {
		var xmlHttp = null;
		try {
			// Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
			// Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
		}
		return xmlHttp;
	}
	//检查登录用户名
	function check_username() {
		var username = document.forms[0].username.value;
		if (username == "") {
			$('username_result').innerHTML = "<font color='red'>请输入登录用户名！</font>";
			$('username').focus();
			return false;
		}else if ($("username").value == $("old_username").value) {//判断值是否发生改变
			$("username_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		} else {
			return isExist('username');
		}
	}
	//检查角色
	function check_mylevel() {
		var mylevel = document.forms[0].mylevel.value;
		if (mylevel == "") {
			$('mylevel_result').innerHTML = "<font color='red'>角色不能为空！</font>";
			return false;
		} else {
			$('mylevel_result').innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}

	//调用-选择皮肤-通用帮助
	function show_help_window() {
		var url = "change_skin.jsp?from=user_add.jsp";
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:550px;dialogHeight:550px");

		if (returnValue == null) {
			return;
		}
		// 如果是点击的是【确定】
		else {
			$('skin').value = returnValue;
			$('skin_img').src = "images\\skins\\" + returnValue;
		}
	}
	//点击关闭按钮
	function close_window() {
		window.returnValue = null;
		window.close();
	}

	//执行保存
	function save() {
		if (checkmemolength('memo') && check_username() && check_mylevel()) {
			document.forms[0].action = "userdo.do?method=update";
			document.forms[0].submit();
		}
	}
</script>
<script language="javascript" type="text/javascript" src="js/ShowCalendar.js"></script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<%	
	User user = (User)request.getAttribute("user.view");
%>
<%
	Map<String,String> user_role = Const.getEnumMap().get("user_role");
%>
<form action="" name="addForm" method="post">
<br>
<div align="right">
<input type="button" class="btbox" value="保存" onclick="save()"  >
<input type="button" class="btbox" value="关闭" onclick="close_window()">
</div>
	<fieldset>
		<legend>用户信息修改</legend><br>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							员工姓名
						</td>
						<td>
							<input type="text" id="who" name="who" value="<%=user.getWho()%>" size="30" maxlength="10"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							<font color="red">*</font>
							&nbsp;
							<span id="who_result"></span>
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							登录用户名
						</td>
						<td>
							<input type="text" id="username" name="username" value="<%=user.getUsername() %>" size="30" maxlength="10" onblur="check_username()">
							<input type="hidden" id="old_username" value="<%=user.getUsername() %>">
							<font color="red">*</font>
							&nbsp;
							<span id="username_result"></span>
					</tr>
					
					<tr>
						<td>
							是否恢复<br>初始密码
						</td>
						<td>
						<input type="radio" name="password" value="否"  checked="checked">否
						<input type="radio" name="password" value="是" >是
						&nbsp;<font color="red">*&nbsp;选择是，则将密码重置为admin，选否，则对密码不做修改。</font>
						<input type="hidden" id="old_password" name="old_password" value="<%=user.getPassword() %>">
						</td>
					</tr>
					<tr>
						<td>
							性别
						</td>
						<td>
							<input type="radio" name="sex" value="男"  
							<%
							if("男".equals(user.getSex())){
								out.print("checked=\"checked\"");
							}
							%>
							>男
							<input type="radio" name="sex" value="女" 
							<%
							if("女".equals(user.getSex())){
								out.print("checked=\"checked\"");
							}
							%>
							>女
						</td>
					</tr>
					<tr>
						<td>
							角色
						</td>
						<td>
				<select name="mylevel" size="1" onchange="check_mylevel()">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : user_role.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	
				<%
				if(user.getMylevel().equals(entry.getKey())){
					out.print("selected=\"selected\"");
				}
				%>
				/><%=entry.getValue()%>
				<%
				}
				%>
				</select>
				<font color="red">*</font>	
				&nbsp;
				<span id="mylevel_result"></span>
					</td>
					</tr>
					<tr>
						<td>
							皮肤
						</td>
						<td>
							<img src="images\\skins\\<%=user.getSkin()%>" id="skin_img" width="150" height="100" onclick="show_help_window()">
							<input type="hidden" name="skin" value="<%=user.getSkin()%>">
							<input type="button" value="选择..." onclick="show_help_window()" class="btbox">
							
					</tr>
					<tr>
						<td nowrap="nowrap">
							入职时间
						</td>
						<td>
						<input id="entry_time" name="entry_time" type="text"  readonly="readonly" value="<%=user.getEntry_time()==null?"":user.getEntry_time()%>" onfocus="showDate()"/>
						</td>
					</tr>
					<tr>
					<td nowrap="nowrap" >备注</td>
					<td >
						<textarea id="memo" name="memo" rows="6" cols="60" ><%=user.getMemo()==null?"":user.getMemo() %></textarea>
					</td>
					</tr>
				</table>
				</fieldset>
			</form>	
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />