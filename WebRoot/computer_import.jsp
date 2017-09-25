<%
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

<%@page import="java.util.List"%>

<%@page import="cn.sdfi.tools.Tool"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<html>
<head>
<title>Excel�ļ���Ϣ����</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">

<script language="javascript">

	//ִ�е���ǰ��У��
	function check(){
		var value=document.getElementById('file1').value;
		if(value==""){
			alert('��ѡ��Ҫ�����excel�ļ���');
			return false;
		}else if(value.indexOf('.')==-1){
			alert('�ļ���ʽ����ȷ��������ѡ��');
			return false;
		}else if(value.substring(value.lastIndexOf('.')+1)!="xls"&&value.substring(value.lastIndexOf('.')+1)!="XLS"){
			alert('�ļ���ʽ����ȷ��������ļ�������xls����XLS��β����������ѡ��');
			return false;
		}else{
			return true;
		}
	}

	//ִ�е���
	function importExcel() {
		if(check()){
		document.getElementById("path").value="computer_import.jsp";
		document.form1.action = "doUpload.jsp";
		document.form1.submit();
	}
}
</script>
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>" >
<span id="tips"></span>
<h2 align="center">
Excel�ļ���Ϣ����
</h2>
<div align="right">
			<input type="button" class="btbox" value="ִ�е���" onclick="importExcel()">
			<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
			</div>
<fieldset><legend>��ѡ��Ҫ�����excel�ļ�</legend>
<div align="center">
<form name="form1" method="post" ENCTYPE="multipart/form-data">
<input type="file" name="file1" size="51" class="btbox">
<input type="hidden" id="path" name="path" value="" >
</form>
</div>
</fieldset>
<br>
<fieldset><legend>˵����ÿ������ռ�����ֽڣ�</legend>
<br>
01��ѡ��Ҫ�����excel�ļ�����������¸�ʽ����һ���Ǳ��⣬�ӵڶ��п�ʼִ�е��룩��<br>
02����������ݿ����Ѵ��ڱ����ͬ���ļ��������ͬ���ļ����Ḳ�ǵ��룬�����ڵ��ļ����������롣<br>
03���ļ�������"xls"����"XLS"��β��<br>
04���豸���ͣ��豸���Ͳ���Ϊ�գ�Ŀǰ��������ʵ�����豸���͡�����豸��2�֡�<br>
05���豸���룺�豸���벻��Ϊ�գ��Ϊ15���ֽڣ����Ҳ��ܰ������ĺ�ȫ���ַ���<br>
06���豸���ƣ��豸���Ʋ���Ϊ�գ������Ϊ30���ֽڡ�<br>
07�����кţ����к�������볤����50���ֽڡ�<br>
08���豸�ͺţ��豸�ͺ�������볤����50���ֽڡ�<br>
09���������̣���������������볤����100���ֽڡ�<br>
10���������ڣ��������������Ϊ�գ��������4λ�꣬2λ�µĸ�ʽ���磺<font color="red">201002</font><br>
11�������ˣ��豸������������볤����20���ֽڡ�<br>
12���豸ʹ�õص㣺�豸ʹ�õص�������볤����200���ֽڡ�<br>
13��״̬���豸״̬����Ϊ�գ�Ŀǰ�����������á��͡��ѱ��ϡ�2�֡�<br>
14���豸���ã��豸����������볤����200���ֽڡ�<br>
15����ע����ע��Ϣ������볤����1000���ֽڡ�
<table border="1" bordercolor="blue" width="100%">
<tr>
<th>�豸����</th><th>�豸���</th><th>�豸����</th><th>���к�</th><th>�ͺ�</th><th>��������</th><th>��������</th><th>������</th><th>ʹ�õص�</th><th>״̬</th><th>����</th><th>��ע</th>
</tr>
<tr>
<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
</tr>
</table>
</fieldset>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />