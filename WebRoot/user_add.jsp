<%
	//�����жϸ��û��Ƿ��ѵ�¼
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//������ǳ�������Ա������Ȩ�����ҳ�档
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
		<title>�û�����</title>
		<base target="_self"> 
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

//�������id
function isExist(which) {


	//����Ajax���󵽷���������֤Ա���������û����Ƿ��Ѵ���
	var req = getXmlHttpObject();//req��Ϊȫ�ֱ�������������Ajax����ʱ�����͵�Ajax���󽫲���ִ��(IE6��)��
	var isExist = false;
	var value = $(which).value;
	var url = "userdo.do?method=isExist&value="+value+"&which="+which+"&temp="+Math.random();	
	req.onreadystatechange = function(){
		if (req.readyState == 4) {
			if (req.status == 200) {		
				var msg = req.responseText;

				//�Է��ص���Ϣ���н���(�磺��who,1��)��������who ����username
				var array = msg.split(',');
				if(array[0]=="who"){
					var who_result = $("who_result");
					if (array[1] == "0") {
						who_result.innerHTML = "<font color='green'>OK</font>";
						isExist = true;
					} else if (array[1] == "1") {
						who_result.innerHTML = "<font color='red'>��Ա��������ע�ᣬ���������룡</font>";
					}else{
						alert("��֤Ա�����������쳣��");
					}
				}else if(array[0]=="username"){
					var username_result = $("username_result");
					if (array[1] == "0") {
						username_result.innerHTML = "<font color='green'>OK</font>";
						isExist = true;
					} else if (array[1] == "1") {
						username_result.innerHTML = "<font color='red'>�õ�¼�û�����ע�ᣬ���������룡</font>";
					}else{
						alert("��֤��¼�û��������쳣��");
					}
				}else{
					alert("��������ֵ�����쳣��");
				}
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return isExist ;
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
//����¼�û���
function check_username() {
	var username =  $('username').value;
	if (username == "") {
		$('username_result').innerHTML = "<font color='red'>�������¼�û�����</font>";
		$('username').focus();
		return false;
	} else {	
		return isExist('username');
	}
}
//���Ա������
function check_who() {
	var who = $('who').value;
	if (who == "") {
		$('who_result').innerHTML = "<font color='red'>������Ա��������</font>";
		$('who').focus();
		return false;
	} else {
		return isExist('who');
	}
}
//����Ա�
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
		$('sex_result').innerHTML = "<font color='red'>�Ա���Ϊ�գ�</font>";
		return false;
	} else {
		$('sex_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//����ɫ
function check_mylevel() {
	var mylevel = document.forms[0].mylevel.value;
	if (mylevel == "") {
		$('mylevel_result').innerHTML = "<font color='red'>��Ϊ���û������ɫ��</font>";
		return false;
	} else {
		$('mylevel_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//�������
function check_password() {
	var password = document.forms[0].password.value;
	if (password == "") {
		$('password_result').innerHTML = "<font color='red'>��Ϊ���û�ָ�����룡</font>";
		return false;
	} else {
		$('password_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
	//����-ѡ��Ƥ��-ͨ�ð���
	function show_help_window() {
		var url = "change_skin.jsp?from=user_add.jsp";
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:550px;dialogHeight:550px");

		if(returnValue==null){
			return;
		}
		// ����ǵ�����ǡ�ȷ����
		else{
			$('skin').value=returnValue;
			$('skin_img').src="images\\skins\\"+returnValue;
		}
}
	//����رհ�ť
	function close_window() {
		window.returnValue = null;
		window.close();
	}
	
	//ִ�б���
	function save() { 
		if (checkmemolength('memo')&&(check_who())&&(check_username())&&(check_password())&&(check_sex())&&(check_mylevel())) {
			$('password').value=toMD5Str($('password').value);
			document.forms[0].action = "userdo.do?method=add&action=save";
			document.forms[0].submit();
		}
	}
	//ִ�б��沢����
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
			<input type="button" class="btbox" value="����" onclick="save()" >
			<input type="button" class="btbox" value="���沢����" onclick="goOn()"  >
			<input type="button" class="btbox" value="�ر�" onclick="close_window()">
		</div>
<form action="userdo.do?method=add" name="addForm" method="post">
<%
	Map<String,String> user_role = Const.getEnumMap().get("user_role");
%>
	<fieldset>
		<legend>���û�ע��</legend><br>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							Ա������
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
							��¼�û���
						</td>
						<td>
							<input type="text" id="username" name="username" value="" size="30" maxlength="10" onblur="check_username()">
							<font color="red">*</font>
							&nbsp;
							<span id="username_result"></span>
					</tr>
					
					<tr>
						<td>
							����
						</td>
						<td>
							<input type="password" id="password" name="password" value="admin" size="33" maxlength="15" onblur="check_password()">
							<font color="red">*</font>
							&nbsp;
							<span id="password_result">��ʼ����&nbsp;admin</span>
					</tr>
					<tr>
						<td>
							�Ա�
						</td>
						<td>
							<input type="radio" name="sex" value="��"  onclick="check_sex()">��
							<input type="radio" name="sex" value="Ů"  onclick="check_sex()">Ů
							<font color="red">*</font>
							&nbsp;
							<span id="sex_result"></span>
						</td>
					</tr>
					<tr>
						<td>
							��ɫ
						</td>
						<td>
				<select name="mylevel" size="1" onchange="check_mylevel()" > 
				<option value="" />---��ѡ��---
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
							Ƥ��
						</td>
						<td>
							<img src="images\\skins\\default.jpg" id="skin_img" width="150" height="100" onclick="show_help_window()">
							<input type="hidden" name="skin" value="default.jpg">
							<input type="button" value="ѡ��..." onclick="show_help_window()" class="btbox">
							
					</tr>
					<tr>
						<td nowrap="nowrap">
							��ְʱ��
						</td>
						<td>
						<input id="entry_time" name="entry_time" type="text"  readonly="readonly" value="" onfocus="showDate()"/>
						</td>
					</tr>
					<tr>
					<td nowrap="nowrap" >��ע</td>
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