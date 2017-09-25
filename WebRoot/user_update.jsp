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
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.user.bean.User"%><html>
<head>
<title>����������ҳ��</title>
<base target="_self"> <!--��ͨ�ð����У�ִ���µĲ�������Ȼ��ͨ�ð�������ʾ�������ᵯ���µĴ���  -->
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

//�������id
function isExist(which) {

		//����Ajax���󵽷���������֤Ա���������û����Ƿ��Ѵ���
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
							username_result.innerHTML = "<font color='red'>�õ�¼�û�����ע�ᣬ���������룡</font>";
							$('username').focus();
						} else {
							alert("��֤��¼�û��������쳣��");
						}
					} else {
						alert("��������ֵ�����쳣��");
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return flag;
	}
	//����XMLHttpRequest����
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
	//����¼�û���
	function check_username() {
		var username = document.forms[0].username.value;
		if (username == "") {
			$('username_result').innerHTML = "<font color='red'>�������¼�û�����</font>";
			$('username').focus();
			return false;
		}else if ($("username").value == $("old_username").value) {//�ж�ֵ�Ƿ����ı�
			$("username_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		} else {
			return isExist('username');
		}
	}
	//����ɫ
	function check_mylevel() {
		var mylevel = document.forms[0].mylevel.value;
		if (mylevel == "") {
			$('mylevel_result').innerHTML = "<font color='red'>��ɫ����Ϊ�գ�</font>";
			return false;
		} else {
			$('mylevel_result').innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}

	//����-ѡ��Ƥ��-ͨ�ð���
	function show_help_window() {
		var url = "change_skin.jsp?from=user_add.jsp";
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:550px;dialogHeight:550px");

		if (returnValue == null) {
			return;
		}
		// ����ǵ�����ǡ�ȷ����
		else {
			$('skin').value = returnValue;
			$('skin_img').src = "images\\skins\\" + returnValue;
		}
	}
	//����رհ�ť
	function close_window() {
		window.returnValue = null;
		window.close();
	}

	//ִ�б���
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
<input type="button" class="btbox" value="����" onclick="save()"  >
<input type="button" class="btbox" value="�ر�" onclick="close_window()">
</div>
	<fieldset>
		<legend>�û���Ϣ�޸�</legend><br>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							Ա������
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
							��¼�û���
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
							�Ƿ�ָ�<br>��ʼ����
						</td>
						<td>
						<input type="radio" name="password" value="��"  checked="checked">��
						<input type="radio" name="password" value="��" >��
						&nbsp;<font color="red">*&nbsp;ѡ���ǣ�����������Ϊadmin��ѡ��������벻���޸ġ�</font>
						<input type="hidden" id="old_password" name="old_password" value="<%=user.getPassword() %>">
						</td>
					</tr>
					<tr>
						<td>
							�Ա�
						</td>
						<td>
							<input type="radio" name="sex" value="��"  
							<%
							if("��".equals(user.getSex())){
								out.print("checked=\"checked\"");
							}
							%>
							>��
							<input type="radio" name="sex" value="Ů" 
							<%
							if("Ů".equals(user.getSex())){
								out.print("checked=\"checked\"");
							}
							%>
							>Ů
						</td>
					</tr>
					<tr>
						<td>
							��ɫ
						</td>
						<td>
				<select name="mylevel" size="1" onchange="check_mylevel()">
				<option value="" />---��ѡ��---
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
							Ƥ��
						</td>
						<td>
							<img src="images\\skins\\<%=user.getSkin()%>" id="skin_img" width="150" height="100" onclick="show_help_window()">
							<input type="hidden" name="skin" value="<%=user.getSkin()%>">
							<input type="button" value="ѡ��..." onclick="show_help_window()" class="btbox">
							
					</tr>
					<tr>
						<td nowrap="nowrap">
							��ְʱ��
						</td>
						<td>
						<input id="entry_time" name="entry_time" type="text"  readonly="readonly" value="<%=user.getEntry_time()==null?"":user.getEntry_time()%>" onfocus="showDate()"/>
						</td>
					</tr>
					<tr>
					<td nowrap="nowrap" >��ע</td>
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