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
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>

<%@page import="cn.sdfi.tools.Const"%><html>
	<head>
		<title>用户增加</title>
		<base target="_self"> 
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

//接收组件id
function isExist(which) {


	//发送Ajax请求到服务器，验证员工姓名、用户名是否已存在
	var req = getXmlHttpObject();//req若为全局变量，连续发送Ajax请求时，后发送的Ajax请求将不会执行(IE6下)。
	var isExist = false;
	var value = $(which).value;
	var url = "userdo.do?method=isExist&value="+value+"&which="+which+"&temp="+Math.random();	
	req.onreadystatechange = function(){
		if (req.readyState == 4) {
			if (req.status == 200) {		
				var msg = req.responseText;

				//对返回的信息进行解析(如：“who,1”)，区分是who 还是username
				var array = msg.split(',');
				if(array[0]=="who"){
					var who_result = $("who_result");
					if (array[1] == "0") {
						who_result.innerHTML = "<font color='green'>OK</font>";
						isExist = true;
					} else if (array[1] == "1") {
						who_result.innerHTML = "<font color='red'>该员工姓名已注册，请重新输入！</font>";
					}else{
						alert("验证员工姓名出现异常！");
					}
				}else if(array[0]=="username"){
					var username_result = $("username_result");
					if (array[1] == "0") {
						username_result.innerHTML = "<font color='green'>OK</font>";
						isExist = true;
					} else if (array[1] == "1") {
						username_result.innerHTML = "<font color='red'>该登录用户名已注册，请重新输入！</font>";
					}else{
						alert("验证登录用户名出现异常！");
					}
				}else{
					alert("解析返回值出现异常！");
				}
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return isExist ;
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
//检查登录用户名
function check_username() {
	var username =  $('username').value;
	if (username == "") {
		$('username_result').innerHTML = "<font color='red'>请输入登录用户名！</font>";
		$('username').focus();
		return false;
	} else {	
		return isExist('username');
	}
}
//检查员工姓名
function check_who() {
	var who = $('who').value;
	if (who == "") {
		$('who_result').innerHTML = "<font color='red'>请输入员工姓名！</font>";
		$('who').focus();
		return false;
	} else {
		return isExist('who');
	}
}
//检查性别
function check_sex() {

	var radios = document.getElementsByName("sex");
	var noChecked = true;
		for ( var i = 0; i < radios.length; i++) {
			if (radios[i].checked==true) {
				noChecked = false;
				break;
			}
		}
	if (noChecked==true) {
		$('sex_result').innerHTML = "<font color='red'>性别不能为空！</font>";
		return false;
	} else {
		$('sex_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//检查角色
function check_mylevel() {
	var mylevel = document.forms[0].mylevel.value;
	if (mylevel == "") {
		$('mylevel_result').innerHTML = "<font color='red'>请为新用户分配角色！</font>";
		return false;
	} else {
		$('mylevel_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//检查密码
function check_password() {
	var password = document.forms[0].password.value;
	if (password == "") {
		$('password_result').innerHTML = "<font color='red'>请为新用户指定密码！</font>";
		return false;
	} else {
		$('password_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
	//调用-选择皮肤-通用帮助
	function show_help_window() {
		var url = "change_skin.jsp?from=user_add.jsp";
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:550px;dialogHeight:550px");

		if(returnValue==null){
			return;
		}
		// 如果是点击的是【确定】
		else{
			$('skin').value=returnValue;
			$('skin_img').src="images\\skins\\"+returnValue;
		}
}
	//点击关闭按钮
	function close_window() {
		window.returnValue = null;
		window.close();
	}
	
	//执行保存
	function save() { 
		if (checkmemolength('memo')&&(check_who())&&(check_username())&&(check_password())&&(check_sex())&&(check_mylevel())) {
			$('password').value=toMD5Str($('password').value);
			document.forms[0].action = "userdo.do?method=add&action=save";
			document.forms[0].submit();
		}
	}
	//执行保存并继续
	function goOn() {
		if (checkmemolength('memo')&&check_who()&&check_username()&&check_password()&&check_sex()&&check_mylevel()) {
			$('password').value=toMD5Str($('password').value);
			document.forms[0].action = "userdo.do?method=add&action=continue";
			document.forms[0].submit();
		}
	}
</script>
<script language="javascript" type="text/javascript" src="js/ShowCalendar.js"></script>
<script language="javascript" src="js/pub.js"></script>
<script language="javascript" src="js/md5.js"></script>
</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" onload="document.forms[0].who.focus();" >
	<span id="tips"></span>
			<div align="right"><br>
			<input type="button" class="btbox" value="保存" onclick="save()" >
			<input type="button" class="btbox" value="保存并继续" onclick="goOn()"  >
			<input type="button" class="btbox" value="关闭" onclick="close_window()">
		</div>
<form action="userdo.do?method=add" name="addForm" method="post">
<%
	Map<String,String> user_role = Const.getEnumMap().get("user_role");
%>
	<fieldset>
		<legend>新用户注册</legend><br>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							员工姓名
						</td>
						<td>
							<input type="text" id="who" name="who" value="" size="30" maxlength="10"  onblur="check_who()">
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
							<input type="text" id="username" name="username" value="" size="30" maxlength="10" onblur="check_username()">
							<font color="red">*</font>
							&nbsp;
							<span id="username_result"></span>
					</tr>
					
					<tr>
						<td>
							密码
						</td>
						<td>
							<input type="password" id="password" name="password" value="admin" size="33" maxlength="15" onblur="check_password()">
							<font color="red">*</font>
							&nbsp;
							<span id="password_result">初始密码&nbsp;admin</span>
					</tr>
					<tr>
						<td>
							性别
						</td>
						<td>
							<input type="radio" name="sex" value="男"  onclick="check_sex()">男
							<input type="radio" name="sex" value="女"  onclick="check_sex()">女
							<font color="red">*</font>
							&nbsp;
							<span id="sex_result"></span>
						</td>
					</tr>
					<tr>
						<td>
							角色
						</td>
						<td>
				<select name="mylevel" size="1" onchange="check_mylevel()" > 
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : user_role.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
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
							<img src="images\\skins\\default.jpg" id="skin_img" width="150" height="100" onclick="show_help_window()">
							<input type="hidden" name="skin" value="default.jpg">
							<input type="button" value="选择..." onclick="show_help_window()" class="btbox">
							
					</tr>
					<tr>
						<td nowrap="nowrap">
							入职时间
						</td>
						<td>
						<input id="entry_time" name="entry_time" type="text"  readonly="readonly" value="" onfocus="showDate()"/>
						</td>
					</tr>
					<tr>
					<td nowrap="nowrap" >备注</td>
					<td >
						<textarea id="memo" name="memo" rows="6" cols="60" ></textarea>
					</td>
					</tr>
				</table>
				</fieldset>
			</form>	
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />