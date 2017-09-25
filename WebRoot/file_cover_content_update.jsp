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
<%@page import="cn.sdfi.tools.GetFileNames"%>
<%@page import="cn.sdfi.filecovercontent.bean.FileCoverContent"%>
<%@page import="cn.sdfi.filecovercontent.dao.FileCoverContentDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.filecover.dao.FileCoverDao"%>
<%@page import="cn.sdfi.filecover.bean.FileCover"%><html>
	<head>
		<title>�ļ�/��¼��Ϣ�޸�</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
if(addForm.file_cover_content_code.value=="")
{
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
}
else if(addForm.file_cover_content_name.value=="")
{
	alert("�������ļ����ƣ�");
	addForm.file_cover_content_name.focus();
	return false;
}else if(addForm.fk.value=="")
{
	alert("��ѡ���ļ����ڵ��������ƣ�");
	addForm.fk.focus();
	return false;
}else{
	return checkmemolength('memo');
	}
}
//����Ajax���󵽷���������֤�ñ���Ƿ��Ѿ���ʹ��
function isExist() {
	//�����ж��ļ������Ƿ����˸ı䣬���δ�����ı䣬���ٽ���isExist()���жϡ�
	if($('file_cover_content_code').value==$('old_file_cover_content_code').value){
		return true;
	}
	var req = getXmlHttpObject();
	var flag = false;
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
					alert('���ļ����� '+file_cover_content_code+' �Ѵ��ڣ����������룡');
					$("file_cover_content_code").focus();
				} else {
					alert("�����ˣ�����ϵϵͳ����Ա��");
				}
			}
		}
	};
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
//ɾ������������ҳ����ɾ��
function deleteBlob(){
	$("attachment").innerHTML="<input type='file' class='btbox' name='file1' size='51' >&nbsp;<font color='red'>��������ϴ�����10M</font>";
}
//ִ���޸�
function update(){
	if(check()){
		document.addForm.action="filecovercontentdo.do?method=update";
		document.addForm.submit();
	}
}
//����-ѡ�񵵰���-ͨ�ð���
function show_help_window() {
	var url = "filecoverdo.do?method=query&path=help";
	var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:750px;dialogHeight:550px");

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
	<form action="filecovercontentdo.do?method=update" name="addForm" method="post" ENCTYPE="multipart/form-data">
	<%
	String pk = request.getParameter("pk");
	
	FileCoverContentDao fileCoverContentDao = (FileCoverContentDao)ObjectFactory.getObject(FileCoverContentDao.class.getName());
	FileCoverDao fileCoverDao = (FileCoverDao)ObjectFactory.getObject(FileCoverDao.class.getName());
	
	FileCoverContent content = fileCoverContentDao.queryByPK(pk);
	Object fk=content.getFk();
	FileCover fileCover = fileCoverDao.queryByPK(fk.toString());
	String fk_show=fileCover.getFile_cover_code()+"("+fileCover.getFile_cover_name()+")";
	%>

			<h2 align="center">
				�ļ���Ϣ�޸�
			</h2>
			<div align="right">
			<input type="button" class="btbox" value="����" onclick="update()" >
			<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='filecovercontentdo.do?method=query'">
			</div>
			<hr>
		<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
		<tr>
		<td align="right" nowrap="nowrap">�ļ����ڵ�����:</td>
		<td>
		<input type="text" id="fk_show" name="fk_show" value="<%=fk_show %>" size="55"  readonly="readonly">
		<input type="button" class="btbox" value="ѡ��..." onclick="show_help_window()">
		<input type="hidden" id="fk" name="fk" value="<%=fk %>" >
		<font color="red">*</font>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�ļ�����:</td>
		<td>
		<input type="hidden" name="pk" value="<%=content.getPk() %>">
		<input type="text" name="file_cover_content_code" value="<%=content.getFile_cover_content_code() %>" size="40" maxlength="20"> 
		<input type="hidden" id="old_file_cover_content_code"  value="<%=content.getFile_cover_content_code()%>"	>
		<input type="hidden" id="file_cover_content_code_prefix" name="file_cover_content_code_prefix" 	value="<%=fileCover.getFile_cover_code()+"-"%>"	>
		<font color="red">* �ļ�����=�ļ����ڵ���������+��-��+���</font>
			</td>
	</tr>

	<tr>
		<td align="right" nowrap="nowrap">�ļ�����:</td>
		<td><input type="text" name="file_cover_content_name" value="<%=content.getFile_cover_content_name() %>"
			size="60" maxlength="30">
			<font color="red">*</font></td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">ҳ��:</td>
		<td><input type="text" name="pages" value="<%=content.getPages() %>" size="60"
			maxlength="5">
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�汾:</td>
		<td><input type="text" name="version" value="<%=content.getVersion() %>" size="60"
			maxlength="5">
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">����:</td>
		<td id="attachment">
	<%
		String path = application.getRealPath("/")+"WEB-INF\\document";
		String filenames[] = GetFileNames.getFileNamesStartWithPrefix(path, content.getPk());
		
		//������ļ����ڸ���
		if(filenames.length>0){
			String ext = filenames[0].substring( filenames[0].lastIndexOf(".")+1);//��ȡ�ļ���׺
			String newfilename = content.getFile_cover_content_name()+"."+ext;//��װ�µ��ļ�����	

			String suffixPath = application.getRealPath("/")+"images/suffix";//�ļ���׺ͼ����·��
			String suffixs[] = Tool.getFileNames(suffixPath);//��ȡ���к�׺����
	
			//�ú�׺�ں�׺�����Ƿ���ڣ�Ĭ��ΪFALSE
			boolean isExist = false;
				  for (int j = 0; j < suffixs.length; j++) {	   		    
				    	if(suffixs[j].startsWith(ext)){
				    		isExist = true;
				    		break;
				    	}
			}
			if(!isExist){//�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
				ext = "none";
			}
			%>	
		<a title="�������" style="CURSOR:hand" onclick="window.location.href='filecovercontentdo.do?method=download&pk=<%=content.getPk() %>'">	
		<img src="images/suffix/big/<%=ext%>.png" border="0" >
		<u>
		<%=newfilename %>
		</u>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" class="btbox" value="�����ϴ�" onclick="deleteBlob()" >
		</a>
		<%
		}else{
		%>
		<input type="file" name="file1" size="51" value="" >&nbsp;<font color="red">��������ϴ�����10M</font>
		<%
		}
		%>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">��ע:</td>
		<td><textarea id="memo" name="memo" rows="6" cols="60" ><%=content.getMemo() %></textarea></td>
	</tr>
</table>
</form>		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />