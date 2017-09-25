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
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.List"%>
<%@page import="cn.sdfi.tools.Tool"%>
<html>
	<head>
		<title>�ļ�/��¼��Ϣ����</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	function check() {
		if (addForm.fk.value == "") {
			alert("��ѡ���ļ����ڵ�������");
			return false;
		} else if (addForm.file_cover_content_code.value == "") {
			alert("�������ļ���ţ�");
			addForm.file_cover_content_code.focus();
			return false;
		}else if(isContainChineseChar('file_cover_content_code')){
			alert("�ļ������в��ܰ��������Ļ���ȫ���ַ���");
			addForm.file_cover_content_code.focus();
			return false;
		}else if(($('file_cover_content_code').value.indexOf($('file_cover_content_code_prefix').value)==-1)){
			alert("�ļ���������������ڵ���������Ϊǰ׺��");
			addForm.file_cover_content_code.focus();
			return false;
		}else if(!isExist()){
			return false;
		}else if (addForm.file_cover_content_name.value == "") {
			alert("�������ļ����ƣ�");
			addForm.file_cover_content_name.focus();
			return false;
		}else {
			return checkmemolength('memo');

		}
	}
	//����Ajax���󵽷���������֤�ñ���Ƿ��Ѿ���ʹ��
	function isExist() {

		var flag = false;
		var req = getXmlHttpObject();
		var file_cover_content_code = $("file_cover_content_code").value;
		var url = "filecovercontentdo.do?method=isExist&file_cover_content_code="+ file_cover_content_code;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {		
					var msg = req.responseXML.getElementsByTagName("msg")[0];
					var result = msg.childNodes[0].nodeValue;
					if (result == "ok") {
						flag = true;
					} else if (result == "not_ok") {
						alert('�ļ����� '+file_cover_content_code+' �Ѵ��ڣ����������룡');
						$("file_cover_content_code").focus();
					} else {
						alert("�����ˣ�����ϵϵͳ����Ա��");
					}
				}
			}
		};
		//false��ʾִ��ͬ����true��ʾִ���첽��������첽�Ļ���isExist�ڻص����������õ�ֵ��������Ч����ִ���������return��䣬�Ӷ�������ݵĲ�һ�£����Դ˴�����Ϊͬ����
		req.open("POST", url, false);
		req.send(null);
		return flag ;
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
	//����
	function save() {
		if (check()) {
			document.addForm.action = "filecovercontentdo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//���沢����
	function goOn() {
		if (check()) {
			document.addForm.action = "filecovercontentdo.do?method=add&action=continue";
			document.addForm.submit();
		}
	}
	//����-ѡ�񵵰���-ͨ�ð���
	function show_help_window() {
		var url = "filecoverdo.do?method=query&path=help";
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:750px;dialogHeight:520px");

		if(returnValue==null){
			return;
		}
		// ����ǵ�����ǡ�ȷ����
		else{
			$("fk").value = returnValue[0];
			$("fk_show").value = returnValue[1] + "("	+ returnValue[2] + ")";
			$("file_cover_content_code").value = returnValue[1]+"-";
			$("file_cover_content_code_prefix").value = returnValue[1]+"-";
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" onload="addForm.file_cover_content_code.focus()">
	<span id="tips"></span>
			<h2 align="center">
				�ļ���Ϣ����
			</h2>
			<div align="right">
			<input type="button" class="btbox" value="����" onclick="save()" >
			<input type="button" class="btbox" value="���沢����" onclick="goOn()"  >
			<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='filecovercontentdo.do?method=query'">
			</div>
			<hr>
<form action="filecovercontentdo.do?method=add" name="addForm" method="post" ENCTYPE="multipart/form-data">
	<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td align="right" nowrap="nowrap" >�ļ����ڵ�����:</td>
		<td >
		<%
			String file_cover_content_code_prefix="";//��Ϊ�ļ���ŵ�ǰ׺
			Object fk_show=request.getAttribute("fk_show");
			Object fk=request.getAttribute("fk");
			if(fk==null)fk="";
			if(fk_show==null)fk_show="";
			if(!"".equals(fk_show)){
				file_cover_content_code_prefix=fk_show.toString().substring(0,fk_show.toString().indexOf("("))+"-";
			}
		%> 	
		<input type="text" id="fk_show" name="fk_show" value="<%=fk_show %>" size="50"  readonly="readonly">
		<input type="button" class="btbox" value="ѡ��..." onclick="show_help_window()">
		<input type="hidden" id="fk" name="fk" value="<%=fk %>" >
		<font color="red">*</font>
		</td>
	</tr>
	<tr>
		<td align="right" >�ļ�����:</td><!-- �ļ�����ֻ����Ӣ�ģ����ܰ������ĺ�ȫ�Ƿ���  -->
		<td  nowrap="nowrap">
		<input type="text"  id="file_cover_content_code" name="file_cover_content_code" value="<%=file_cover_content_code_prefix%>"	size="40" maxlength="20"> 
		<input type="hidden" id="file_cover_content_code_prefix" name="file_cover_content_code_prefix" value="<%=file_cover_content_code_prefix%>"	>
		<font color="red">* �ļ�����=�ļ����ڵ���������+��-��+���</font>
		</td>
	</tr>

	<tr>
		<td align="right" >�ļ�����:</td>
		<td >
		<input type="text" name="file_cover_content_name" value=""	size="60" maxlength="30">
		<font color="red">*</font>
		</td>
	</tr>
	<tr>
		<td align="right" >ҳ��:</td>
		<td >
		<input type="text" name="pages" value="" size="60"	maxlength="5">
		</td>
	</tr>
	<tr>
		<td align="right" >�汾:</td>
		<td >
		<input type="text" name="version" value="" size="60" maxlength="5">
		</td>
	</tr>
		<tr>
		<td align="right" >����:</td>
		<td nowrap="nowrap">
		<input type="file" name="file1" size="51" class="btbox" >&nbsp;<font color="red">��������ϴ�����10M</font>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap" >��ע:</td>
		<td >
		<textarea id="memo" name="memo" rows="6" cols="60"  onblur="checkmemolength('memo')"></textarea>
		</td>
	</tr>
</table>
</form>		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />