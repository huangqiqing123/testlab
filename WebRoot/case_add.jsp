
<%
	//��½���
	if(Tool.isNotLogin(request)){ 
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%><html>
<head>
<title>��������ҳ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//��ʼ������
	function init() {
		document.forms[0].type.focus();
	}
	//ѡ�񸽼�ʱ��ͬ������ ����title��ֵ��
	function setTitleValue(){
		var fileValue = $('file1').value;
		$("title").value = fileValue.substring(fileValue.lastIndexOf('\\')+1);
	}
	//ִ�е���ǰ��У��
	function check_blob(){
		var value=$('file1').value;
		if(value==""){
			$("blob_check_result").innerHTML = "<font color='red'>��ʾ����ѡ�񸽼���</font>";
			return false;
		}else if(value.indexOf('.')==-1){
			$("blob_check_result").innerHTML = "<font color='red'>��ʾ����ѡ����Ч������</font>";
			return false;
		}else{
			var fileExt = value.substr(value.lastIndexOf('.')+1).toLowerCase();
			if(fileExt=='bat'||fileExt=='exe'||fileExt=='com'){
				$("blob_check_result").innerHTML = "<font color='red'>��ʾ���������ϴ�exe��bat��com�ȿ�ִ���ļ���</font>";
				return false;
			}else{
			$("blob_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
			}
		}
	}
	//���ؼ���
	function check_title() {
		if (addForm.title.value == "") {
			$("title_check_result").innerHTML = "<font color='red'>��ʾ���ؼ��ֲ���Ϊ�գ�</font>";
			return false;
		}else if(checklength("title")>100){
			$("title_check_result").innerHTML = "<font color='red'>��ʾ���ؼ���������볤����100���ֽڣ�ÿ������ռ2���ֽڣ�����ǰ�������ֽ���"+checklength("title")+"�����������룡</font>";
			return false;
		}else {
			$("title_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//�������
	function check_type() {
		if (addForm.type.value == "") {
			$("type_check_result").innerHTML = "<font color='red'>��ʾ����ѡ�����������ͣ�</font>";
			return false;
		} else {
			$("type_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//ִ�б���
	function save() {
		if (check_type()&&check_blob()&&check_title()) {
			document.addForm.action = "casedo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//ִ���ύ
	function submit() {
		if (check_type()&&check_blob()&&check_title()) {
			document.addForm.action = "casedo.do?method=add&action=submit";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body onload="init()"	background="images/skins/<%=session.getAttribute("skin") %>">
<span id="tips"></span>
<h2 align="center">���ϴ�����</h2>
<div align="right">
<input type="button" class="btbox" value="����"	onclick="save()"> 
<input type="button" class="btbox"	value="�ύ" onclick="submit()"> 
<input type="button" class="btbox" value="������һҳ"	onClick="javascript:parent.history.back(); return;"> 
</div>
<hr>
<%
	Map<String, String> case_types = Const.getEnumMap().get("case_type");
%> 
<form action="casedo.do?method=add" name="addForm"  method="post" ENCTYPE="multipart/form-data">
<table align="center" border="1" cellpadding="1" cellspacing="0" width="100%">
	<tr>
		<td align="right" nowrap="nowrap">����:</td>
		<td align="left">
		<select name="type" size="1" onblur="check_type()"	onchange="check_type()">
			<option value="" />---��ѡ��--- 
			<%
				for (Map.Entry<String, String> entry:case_types.entrySet()) {
			%>
			
			<option value="<%=entry.getKey()%>" /><%=entry.getValue()%> <%
 			}
 		%>
			
		</select> 
		<font color="red">*</font> 
		<div id="type_check_result"></div></td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">ѡ���ļ�:</td>
		<td nowrap="nowrap">
		<input type="file" name="file1" size="50" onblur="check_blob()"  onchange="check_blob();setTitleValue()">&nbsp;
		<font color="green">*��������ϴ�����20M</font>
		<div id="blob_check_result"></div>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�ؼ���:</td>
		<td nowrap="nowrap">
		<input type="text" id="title" name="title" value="" size="50" maxlength="100"  onchange="check_title()"> 
		<font color="red">*</font> <div id="title_check_result"></div>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�汾:</td>
		<td nowrap="nowrap">
		<input type="text" name="version" value="" size="50" maxlength="25" onblur="check_title()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">ժҪ:</td>
		<td><textarea id="summary" name="summary" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right" nowrap="nowrap">��ϸ����:</td>
		<td><textarea id="detail" name="detail" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">��������:</td>
		<td><textarea id="analyze" name="analyze" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�������:</td>
		<td><textarea id="solve" name="solve" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">���:</td>
		<td><textarea id="result" name="result" cols="80" rows="10"></textarea>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />