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
		<title>�²�Ʒ����</title>
		<base target="_self"> 
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

//����Ʒ����
function check_name() {
	var name =  $('name').value;
	if (name == "") {
		$('name_result').innerHTML = "<font color='red'>�������Ʒ���ƣ�</font>";
		return false;
	}else {
		$('name_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	} 
}
//���������
function check_sortCode() {
	var sortCode = $('sortCode').value;
	if (sortCode == "") {
		$('sortCode_result').innerHTML = "<font color='red'>������������ţ�</font>";
		return false;
	}else if(!isNumber(sortCode)){
		$("sortCode_result").innerHTML="<font color='red'>���������֣�</font>";
		return false;
	} else {
		$('sortCode_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//�����������
function check_dept() {
	var dept =  $('dept').value;
	if (dept == "") {
		$('dept_result').innerHTML = "<font color='red'>��ѡ���������ţ�</font>";
		return false;
	} else {
		$('dept_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
	//����رհ�ť
	function close_window() {
		window.returnValue = null;
		window.close();
	}
	
	//ִ�б���
	function save() { 
		if (check_name()&&(check_sortCode())&&(check_dept())) {
			document.forms[0].action = "productdo.do?method=add&action=save";
			document.forms[0].submit();
		}
	}
	//ִ�б��沢����
	function goOn() {
		if (check_name()&&(check_sortCode())&&(check_dept())) {
			document.forms[0].action = "productdo.do?method=add&action=continue";
			document.forms[0].submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" onload="document.forms[0].name.focus();">
	<span id="tips"></span>
			<div align="right"><br>
			<input type="button" class="btbox" value="����" onclick="save()" >
			<input type="button" class="btbox" value="���沢����" onclick="goOn()"  >
			<input type="button" class="btbox" value="�ر�" onclick="close_window()">
		</div>
<form action="productdo.do?method=add" name="addForm" method="post">
	<fieldset>
		<legend>�²�Ʒ����</legend><br>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							��Ʒ����
						</td>
						<td>
							<input type="text" id="name" name="name" value="" size="30" maxlength="30"  onblur="check_name()">
							<font color="red">*</font>
							&nbsp;
							<span id="name_result"></span>
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							�������
						</td>
						<td>
							<input type="text" id="sortCode" name="sortCode" value="" size="30" maxlength="10" onblur="check_sortCode()">
							<font color="red">*</font>
							&nbsp;
							<span id="sortCode_result"></span>
					</tr>
					
					<tr>
						<td>
							��������
						</td>
						<td>
						<select id="dept" name="dept"  size="1" onchange="check_dept()">
						<option value="" />---��ѡ��---
				<%
				Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
				for (Map.Entry<String, String> entry : project_customers.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" />
				<%=entry.getValue()%>
				<%
				}
				%>
						</select>
						<font color="red">*</font>
							&nbsp;
							<span id="dept_result"></span>
						</td>
					</tr>
				</table>
				</fieldset>
			</form>	
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />