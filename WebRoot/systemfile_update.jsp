<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//��������ĵ�����Ա/��������Ա������Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	
	if(!isSuperadmin&&!isDocmentAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="cn.sdfi.tools.Tool"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.systemfile.bean.SystemFile"%>
<%@page import="cn.sdfi.systemfile.dao.SystemFileDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
<head>
<title>ʵ������ϵ�ļ��޸�</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
if(addForm.code.value=="")
{
	alert("�������ļ���ţ�");
	addForm.code.focus();//��궨λ
	return false;
}
else if(isContainChineseChar('code')){
	alert("�ļ������в��ܰ��������Ļ���ȫ���ַ���");
	addForm.code.focus();
	return false;
}else if(!isExist('code')){
	alert("���ļ�����Ѵ��ڣ����������룡");
	$('code').focus();
	return false;
}else if(addForm.name.value==""){
	alert("�������ļ����ƣ�");
	addForm.name.focus();
	return false;
}
else if(addForm.controlled_number.value=="")
{
	alert("�ܿغŲ���Ϊ�գ�");
	addForm.controlled_number.focus();
	return false;
}
else if(!isNumber(addForm.controlled_number.value))
{
	alert("�ܿغű��������֣�");
	addForm.controlled_number.focus();
	return false;
}
else
{
return true;

}
}
//�������id
function isExist(which) {

	//�����ж���Ŀ����Ƿ����˸ı䣬���δ�����ı䣬���ٽ����������֤��
	if(trim($(which).value)==trim($('old_'+which).value)){
		return true;
	}	
	//����Ajax���󵽷���������֤��Ŀ����Ƿ��Ѵ���
	var req = getXmlHttpObject();
	var isAvailable = false;
	var value = trim($(which).value);
	var url = "systemfiledo.do?method=isExist&value="+value;	
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
//ִ�б���
function save(){
	if(check()&&checkmemolength('memo')){
		document.addForm.action="systemfiledo.do?method=update";
		document.addForm.submit();
	}
}

</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body background="images/skins/<%=session.getAttribute("skin") %>">
<span id="tips"></span>
<%
	String pk = request.getParameter("pk");
	SystemFileDao systemDao = (SystemFileDao)ObjectFactory.getObject(SystemFileDao.class.getName());
	SystemFile systemfile = systemDao.queryByPK(pk);
%>

<h2 align="center">�ܿ��ļ��޸�</h2>
<div align="right">
<input type="button" class="btbox" value="����" onclick="save()"  >
<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='systemfiledo.do?method=query&path=menu.jsp'">
</div>
<hr>
<form action="" name="addForm" method="post">
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				
					<tr>
						<td>
							�ļ����
						</td>
						<td>
							<input type="hidden" name="pk" value="<%=systemfile.getPk()%>">
							<input type="hidden" name="old_code" value="<%=systemfile.getCode()%>">
							<input type="text" id="code" name="code" value="<%=systemfile.getCode()%>" size="20" maxlength="12">
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td>
							�ļ�����
						</td>
						<td>
							<input type="text" name="name" value="<%=systemfile.getName()%>" size="60" maxlength="25">
							<font color="red">*</font>
					</tr>
					<tr>
						<td>
							�ܿغ�
						</td>
						<td>
							<input type="text" name="controlled_number" value="<%=systemfile.getControlledNumber()%>" size="60" maxlength="4">
							<font color="red">*</font>
					</tr>
					<tr>
						<td>
							�汾
						</td>
						<td>
							<input type="text" name="version" value="<%=systemfile.getVersion()%>" size="60" maxlength="5">
					</tr>
					<tr>
						<td>
							ҳ��
						</td>
						<td>
							<input type="text" name="pages" value="<%=systemfile.getPages()%>" size="60" maxlength="5">
					</tr>
					<tr>
						<td>
							״̬
						</td>
						<td>
						<select name="state" title="��ѡ���ļ�״̬" size="1">
						<option value="" />��ѡ��...
						<option value="��Ч" 
						<%
						if("��Ч".equals(systemfile.getState())){
							out.print("selected=\"selected\"");
						}
						%>
						/>��Ч
						<option value="�ѷ���" 
						<%
						if("�ѷ���".equals(systemfile.getState())){
							out.print("selected=\"selected\"");
						}
						%>
						/>�ѷ���					
						</select>
					</tr>
					<tr>
						<td>
							��ע
						</td>
						<td>
							<textarea id="memo" name="memo" rows="6" cols="60"><%=systemfile.getMemo()%></textarea>

							</td>
					</tr>
				</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />