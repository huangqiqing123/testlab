<%
	//���δ��¼������
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

<%@page import="java.util.List"%>
<%@page import="cn.sdfi.tools.Tool"%><jsp:include page="includes/encoding.jsp" flush="true" />
<html>
<head>
<title>Excel�ļ���Ϣ����</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">

<script language="javascript">


	//ִ�е���ǰ��У��
	function check() {
		var value = document.getElementById('file1').value;
		if (value == "") {
			alert('��ѡ��Ҫ�����excel�ļ���');
			return false;
		} else if (value.indexOf('.') == -1) {
			alert('�ļ���ʽ����ȷ��������ѡ��');
			return false;
		} else if (value.substring(value.lastIndexOf('.') + 1) != "xls" && value.substring(value.lastIndexOf('.') + 1) != "XLS") {
			alert('�ļ���ʽ����ȷ��������ļ�������xls����XLS��β����������ѡ��');
			return false;
		} else if(document.getElementById("fk").value == ""){
			alert("��ѡ���ļ����ڵ�������");
			return false;
		}else{
			return true;
		}
	}
	//ִ�е���
	function importExcel() {

		if (check()) {
			document.getElementById("path").value = "file_cover_content_import.jsp";
			document.form1.action = "doUpload.jsp";
			document.form1.submit();
		}
	}

	//��ʾͨ�ð���
	function show_help_window() {
		var url = "filecoverdo.do?method=query&path=help";
		var returnValue = window.showModalDialog(url, null,
				"scroll:yes;status:no;dialogWidth:750px;dialogHeight:520px");

		//����رհ�ť������null
		if (returnValue == null) {
			return;
		} else {
			document.getElementById("fk").value = returnValue[0];
			document.getElementById("fk_show").value = returnValue[1] + "("	+ returnValue[2] + ")";
			document.getElementById("file_cover_code").value = returnValue[1];
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
			<input type="button" class="btbox" value="����" onClick="javascript:parent.history.back(); return;">
</div>
<form name="form1" method="post" ENCTYPE="multipart/form-data">
<fieldset><legend>��ѡ��Ҫ�����excel�ļ�</legend>
<table align="center">
<tr>
<td nowrap="nowrap">��ѡ��Ҫ�����excel�ļ���</td>
<td>
<input type="file" class="btbox" name="file1" size="51"  >
<input type="hidden" id="path" name="path" value="" >
</td>
</tr>
<tr>
<td nowrap="nowrap">��ѡ���ļ����ڵ�������</td>
<td>
	<input type="text" id="fk_show" name="fk_show" value="" size="51"  readonly="readonly">
	<input type="button" class="btbox" value="ѡ��..." onclick="show_help_window()">
	<input type="hidden" id="fk" name="fk" value="" >
	<input type="hidden" id="file_cover_code" name="file_cover_code" value="" >
</td>
</tr>
</table>
</fieldset>
<br>
<fieldset><legend>˵����ÿ������ռ�����ֽڣ�</legend>
<table border="0" align="center" width="100%" >
<tr>
<td nowrap="nowrap">
<br>
1��ѡ��Ҫ�����excel�ļ�����������¸�ʽ����һ���Ǳ��⣩��<br>
2����������ݿ����Ѵ��ڱ����ͬ���ļ��������ͬ���ļ����Ḳ�ǵ��룬�����ڵ��ļ����������롣<br>
3��һ��ֻ�ܵ���ͬһ���������ڵ��ļ���<br>
4���ļ����룺�ļ����벻��Ϊ�գ����ܰ��������ĺ�ȫ���ַ������ұ����������ڵ��������뿪ͷ��������볤����20���ֽڡ�<br>
5���ļ����ƣ��ļ����Ʋ���Ϊ�գ��ļ�����������볤��80���ֽڡ�<br>
6��ҳ����ҳ��������볤��10���ֽڡ�<br>
7���汾���汾������볤��10���ֽڡ�<br>
8����ע����ע������볤��1000���ֽڡ�
<table border="1" bordercolor="blue" width="100%">
<tr>
<th>�ļ����</th><th>�ļ�����</th><th>ҳ��</th><th>�汾</th><th>��ע</th>
</tr>
<tr>
<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
</tr>
</table>
</td>
</tr>
</table>
</fieldset>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />