<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />

<%@page import="cn.sdfi.tools.Tool"%><html>
<head>
<title>密码修改</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//检查原密码
	function check_old_password() {
		if (userform.password_old.value == "") {
			$("password_old_check_result").innerHTML = "<font color='red'>请输入原密码！</font>";
			return false;
		} else {
			return isCorrect();
		}
	}
	//检查新密码
	function check_new_password() {
		if (userform.password1.value == "") {
			$("password1_check_result").innerHTML = "<font color='red'>请输入新密码！</font>";
			return false;
		} else {
			$("password1_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//检查新密码2
	function check_new_password2() {
		if (userform.password2.value == "") {
			$("password2_check_result").innerHTML = "<font color='red'>请再次输入新密码！</font>";
			return false;
		}else if(userform.password1.value != userform.password2.value){
			$("password2_check_result").innerHTML = "<font color='red'>两次密码输入不一致！</font>";
			return false;
		}else {
			$("password2_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//发送Ajax请求到服务器，验证原密码是否正确
	function isCorrect() {
		var flag = false;
		var req = getXmlHttpObject();
		var password_old = toMD5Str($("password_old").value);
		var url = "userdo.do?method=isCorrect&password_old="+ password_old;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {
					//可以使用  req.responseText 获取返回的文本信息			
					var msg = req.responseText;
					var div = $("password_old_check_result");
					if (msg == "ok") {
						div.innerHTML = "<font color='green'>OK</font>";
						flag = true;
					} else if (msg == "not_ok") {
						div.innerHTML = "<font color='red'>你输入的原密码不正确，请重新输入！</font>";
					}else{
						alert("出错了！");
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return flag;
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
	//执行保存
	function save() {
		if (check_old_password()&&check_new_password()&&check_new_password2()) {
			$('password_old').value=toMD5Str($('password_old').value);
			$('password1').value=toMD5Str($('password1').value);
			$('password2').value=toMD5Str($('password2').value);
			document.userform.action = "userdo.do?method=changePassword";
			document.userform.submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
<script language="javascript" src="js/md5.js"></script>
</head>
<body background="images/skins/<%=session.getAttribute("skin") %>">
<span id="tips"></span>
<h2 align="center">密码修改</h2>
<div align="right">
<input type="button" value="保存" class="btbox" onclick="save()"  >
<input type="button" value="返回" class="btbox" onclick="window.location.href='welcome.jsp'"  >
</div>
<hr>
<form action="" name="userform" method="post">
<table  align="center" width="100%" cellpadding="1" cellspacing="0" border="1">
	<tr>
		<td nowrap="nowrap" width="150" align="right" >原密码</td>
		<td  nowrap="nowrap">
		<input type="password" id="password_old" name="password_old" value="" size="50" maxlength="15" onblur="check_old_password()">
		<font color="red">*</font>
		<span id="password_old_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150"  align="right" >新密码</td>
		<td  nowrap="nowrap">
		<input type="password" id="password1" name="password1" value="" size="50" maxlength="15" onblur="check_new_password()">
		<font color="red">*</font>
		<span id="password1_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150"  align="right" >请再次输入</td>
		<td  nowrap="nowrap">
		<input type="password" id="password2" name="password2" value="" size="50" maxlength="15" onblur="check_new_password2()">
		<font color="red">*</font>
		<span id="password2_check_result"></span>
		</td>
	</tr>
</table>
</form>
<hr>
<div align="left" >
说明：<br>
1、密码最大长度为15位。<br>
</div>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />