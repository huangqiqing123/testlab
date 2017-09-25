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
<title>�����޸�</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//���ԭ����
	function check_old_password() {
		if (userform.password_old.value == "") {
			$("password_old_check_result").innerHTML = "<font color='red'>������ԭ���룡</font>";
			return false;
		} else {
			return isCorrect();
		}
	}
	//���������
	function check_new_password() {
		if (userform.password1.value == "") {
			$("password1_check_result").innerHTML = "<font color='red'>�����������룡</font>";
			return false;
		} else {
			$("password1_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//���������2
	function check_new_password2() {
		if (userform.password2.value == "") {
			$("password2_check_result").innerHTML = "<font color='red'>���ٴ����������룡</font>";
			return false;
		}else if(userform.password1.value != userform.password2.value){
			$("password2_check_result").innerHTML = "<font color='red'>�����������벻һ�£�</font>";
			return false;
		}else {
			$("password2_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//����Ajax���󵽷���������֤ԭ�����Ƿ���ȷ
	function isCorrect() {
		var flag = false;
		var req = getXmlHttpObject();
		var password_old = toMD5Str($("password_old").value);
		var url = "userdo.do?method=isCorrect&password_old="+ password_old;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {
					//����ʹ��  req.responseText ��ȡ���ص��ı���Ϣ			
					var msg = req.responseText;
					var div = $("password_old_check_result");
					if (msg == "ok") {
						div.innerHTML = "<font color='green'>OK</font>";
						flag = true;
					} else if (msg == "not_ok") {
						div.innerHTML = "<font color='red'>�������ԭ���벻��ȷ�����������룡</font>";
					}else{
						alert("�����ˣ�");
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return flag;
	}
	//����XMLHttpRequest����
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
	//ִ�б���
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
<h2 align="center">�����޸�</h2>
<div align="right">
<input type="button" value="����" class="btbox" onclick="save()"  >
<input type="button" value="����" class="btbox" onclick="window.location.href='welcome.jsp'"  >
</div>
<hr>
<form action="" name="userform" method="post">
<table  align="center" width="100%" cellpadding="1" cellspacing="0" border="1">
	<tr>
		<td nowrap="nowrap" width="150" align="right" >ԭ����</td>
		<td  nowrap="nowrap">
		<input type="password" id="password_old" name="password_old" value="" size="50" maxlength="15" onblur="check_old_password()">
		<font color="red">*</font>
		<span id="password_old_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150"  align="right" >������</td>
		<td  nowrap="nowrap">
		<input type="password" id="password1" name="password1" value="" size="50" maxlength="15" onblur="check_new_password()">
		<font color="red">*</font>
		<span id="password1_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150"  align="right" >���ٴ�����</td>
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
˵����<br>
1��������󳤶�Ϊ15λ��<br>
</div>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />