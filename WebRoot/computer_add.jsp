<%
	//���û�е�½
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
//��������豸����Ա��Ҳ���ǳ�������Ա������Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isComputerAdmin = Tool.isComputerAdmin(request);
	if(!isSuperadmin&&!isComputerAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />

<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%><html>
	<head>
		<title>ʵ�����豸����ҳ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
if(addForm.computer_type.value==""){

	alert("��ѡ���豸���ͣ�");
	addForm.computer_type.focus();//��궨λ
	return false;
}	
else if($('code').value=="")
{
	alert("�������豸��ţ�");
	$('code').focus();//��궨λ
	return false;
}
else if(isContainChineseChar('code'))
{
	alert("�豸����в��ܰ��������ĺ�ȫ���ַ���");
	$('code').focus();//��궨λ
	return false;
} else if(!isExist('code')){
	alert("���豸����Ѵ��ڣ����������룡");
	addForm.code.focus();
	return false;
}else if(addForm.name.value=="")
{
	alert("�������豸���ƣ�");
	addForm.name.focus();
	return false;
}
else if(addForm.status.value=="")
{
	alert("��ѡ���豸״̬��");
	addForm.status.focus();
	return false;
}
else if($("month").value==""&&$("year").value!="")
{
	alert("��ѡ���·ݣ�");
	$("month").focus();
	return false;
}
else if($("year").value==""&&$("month").value!="")
{
	alert("��ѡ����ݣ�");
	$("year").focus();
	return false;
}
else if(!checkmemolength('memo')||!checkconflength('conf'))
{
	return false;
}else{
	return true;
}
}
//�������id
function isExist(which) {

	//����Ajax���󵽷���������֤��Ŀ����Ƿ��Ѵ���
	var req = getXmlHttpObject();
	var isAvailable = false;
	var value = trim($(which).value);
	var url = "computerdo.do?method=isExist&value="+value;	
	req.onreadystatechange = function(){
		if (req.readyState == 4) {
			if (req.status == 200) {		
				var msg = req.responseText;
				if(msg=="1"){//"1"��ʾ����Ŀ����Ѿ���ʹ��
					isAvailable=false;
				}else if(msg=="0"){
					isAvailable=true;
				}else{
					alert("��������ֵ�����쳣��");
				}		
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return isAvailable ;
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
//������õĳ���
function checkconflength(id){
	var length = checklength(id);
	if(length>200){
		alert("�����ı���������볤��Ϊ200���ַ���ÿ������ռ2���ַ�������ǰ�������ַ��� "+length+" !");
		$("conf").focus();
		return false;
	}
	return true;
}
//ִ�б���
function save(){
	if(check()){
		$("begin_use_time").value=$("year").value+$("month").value;
		document.addForm.action="computerdo.do?method=add&action=save";
		document.addForm.submit();
	}
}
//���沢����
function goOn(){
	if(check()){
		$("begin_use_time").value=$("year").value+$("month").value;
		document.addForm.action="computerdo.do?method=add&action=continue";
		document.addForm.submit();
	}
}
</script>
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>"  >
	<span id="tips"></span>
			<h2 align="center">
				����ʵ�����豸
			</h2>
			<div align="right">
			
			<input type="button" value="����" class="btbox" onclick="save()" >
			<input type="button" value="���沢����" class="btbox" onclick="goOn()"  >
			<input type="button" value="������һҳ" class="btbox" onClick="javascript:parent.history.back(); return;">
			<input type="button" value="������ҳ" class="btbox" onclick="window.location.href='computerdo.do?method=query&path=menu.jsp'"  >
		</div>
			<hr>
			<form action="computerdo.do?method=add" name="addForm" method="post">
				<table align="center" border="1" width="100%" cellpadding="0" cellspacing="0">
				<tr>
						<td align="right">
							�豸����:
						</td>
						<td>
				<%
				Map<String,String> computer_type = Const.getEnumMap().get("computer_type");	
				%>
				<select name="computer_type" size="1">
				<option value="" />---��ѡ��---
				<%
				for (Map.Entry<String, String> entry : computer_type.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select><font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							�豸���:
						</td>
						<td >
							<input type="text" id="code" name="code" value="" size="60" maxlength="15">
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							�豸����:
						</td>
						<td>
							<input type="text" name="name" value="" size="60" maxlength="15">
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							״̬:
						</td>
						<td>
				<%
				Map<String,String> computer_status = Const.getEnumMap().get("computer_status");	
				%>
				<select name="status" size="1">
				<option value="" />---��ѡ��---
				<%
				for (Map.Entry<String, String> entry : computer_status.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select>
				<font color="red">*</font>
						</td>
					</tr>
					
					<tr>
						<td align="right">
							���к�:
						</td>
						<td>
							<input type="text" name="serial_number" value="" size="60" maxlength="25">
					</tr>
					<tr>
						<td align="right">
							�豸�ͺ�:
						</td>
						<td>
							<input type="text" name="type" value="" size="60" maxlength="25">
					</tr>
					<tr>
						<td align="right">
							��������:
						</td>
						<td>
							<input type="text" name="manufactory" value="" size="60" maxlength="50">
					</tr>
					<tr>
						<td align="right">
							�豸IP:
						</td>
						<td>
						<input type="text" name="ip" value="" size="60" maxlength="32">
						</td>
					</tr>
					<tr>
						<td align="right">
							������:
						</td>
						<td>
							<input type="text" name="owner" value="" size="60" maxlength="10">
						</td>	
					</tr>
					<tr>
						<td align="right">
							��������:
						</td>
						<td>
						<select id="year" name="year"  size="1" >
						<option value="">��...
						<%
						for(int i=2004;i<2021;i++){
						%>
						<option value="<%=i %>"><%=i %>
						<%
						} 
						%>
						</select>
						��
						<select id="month" name="month"  size="1" >
						<option value="">��...
						<%
						for(int i=1;i<=12;i++){
						%>
						<option value="<%=i<10?"0"+i:i %>"><%=i<10?"0"+i:i %>
						<%
						} 
						%>
						</select>
						��
						<input type="hidden" id="begin_use_time" name="begin_use_time" value="" >
						</td>
					</tr>
					<tr>
						<td align="right">
							ʹ�õص�:
						</td>
						<td>
						<input type="text" name="use_site" value="" size="60" maxlength="100">
						</td>
					</tr>
					<tr>
						<td align="right">
							����:
						</td>
						<td>
						<textarea  id='conf' name="configuration" rows="5" cols="70" ></textarea>
						
						</td>
					</tr>
					<tr>
						<td align="right">
							˵��:
						</td>
		<td>
		<textarea id='memo' name="memo" rows="6" cols="70" ></textarea>
		 </td>
					</tr>
				</table>
			</form>		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />