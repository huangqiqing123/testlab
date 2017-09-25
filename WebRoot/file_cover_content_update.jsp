<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是文档管理员/超级管理员，则无权进入该页面。
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
		<title>文件/记录信息修改</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
if(addForm.file_cover_content_code.value=="")
{
	alert("请输入文件编号！");
	addForm.file_cover_content_code.focus();
	return false;
}else if(isContainChineseChar('file_cover_content_code')){
	alert("文件编码中不能包含有中文或者全角字符！");
	addForm.file_cover_content_code.focus();
	return false;
}else if(($('file_cover_content_code').value.indexOf($('file_cover_content_code_prefix').value)==-1)){
	alert("文件编码必须以其所在档案袋编码为前缀！");
	addForm.file_cover_content_code.focus();
	return false;
}else if(!isExist()){
	return false;
}
else if(addForm.file_cover_content_name.value=="")
{
	alert("请输入文件名称！");
	addForm.file_cover_content_name.focus();
	return false;
}else if(addForm.fk.value=="")
{
	alert("请选择文件所在档案袋名称！");
	addForm.fk.focus();
	return false;
}else{
	return checkmemolength('memo');
	}
}
//发送Ajax请求到服务器，验证该编号是否已经被使用
function isExist() {
	//首先判断文件编码是否发生了改变，如果未发生改变，则不再进行isExist()的判断。
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
					alert('该文件编码 '+file_cover_content_code+' 已存在，请重新输入！');
					$("file_cover_content_code").focus();
				} else {
					alert("出错了，请联系系统管理员！");
				}
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return flag ;
}

//返回XMLHttpRequest对象
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
//删除附件，仅在页面上删除
function deleteBlob(){
	$("attachment").innerHTML="<input type='file' class='btbox' name='file1' size='51' >&nbsp;<font color='red'>最大允许上传附件10M</font>";
}
//执行修改
function update(){
	if(check()){
		document.addForm.action="filecovercontentdo.do?method=update";
		document.addForm.submit();
	}
}
//调用-选择档案袋-通用帮助
function show_help_window() {
	var url = "filecoverdo.do?method=query&path=help";
	var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:750px;dialogHeight:550px");

	if(returnValue==null){
		return;
	}
	// 如果是点击的是【确定】
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
				文件信息修改
			</h2>
			<div align="right">
			<input type="button" class="btbox" value="保存" onclick="update()" >
			<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='filecovercontentdo.do?method=query'">
			</div>
			<hr>
		<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
		<tr>
		<td align="right" nowrap="nowrap">文件所在档案袋:</td>
		<td>
		<input type="text" id="fk_show" name="fk_show" value="<%=fk_show %>" size="55"  readonly="readonly">
		<input type="button" class="btbox" value="选择..." onclick="show_help_window()">
		<input type="hidden" id="fk" name="fk" value="<%=fk %>" >
		<font color="red">*</font>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">文件编码:</td>
		<td>
		<input type="hidden" name="pk" value="<%=content.getPk() %>">
		<input type="text" name="file_cover_content_code" value="<%=content.getFile_cover_content_code() %>" size="40" maxlength="20"> 
		<input type="hidden" id="old_file_cover_content_code"  value="<%=content.getFile_cover_content_code()%>"	>
		<input type="hidden" id="file_cover_content_code_prefix" name="file_cover_content_code_prefix" 	value="<%=fileCover.getFile_cover_code()+"-"%>"	>
		<font color="red">* 文件编码=文件所在档案袋编码+“-”+序号</font>
			</td>
	</tr>

	<tr>
		<td align="right" nowrap="nowrap">文件名称:</td>
		<td><input type="text" name="file_cover_content_name" value="<%=content.getFile_cover_content_name() %>"
			size="60" maxlength="30">
			<font color="red">*</font></td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">页数:</td>
		<td><input type="text" name="pages" value="<%=content.getPages() %>" size="60"
			maxlength="5">
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">版本:</td>
		<td><input type="text" name="version" value="<%=content.getVersion() %>" size="60"
			maxlength="5">
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">附件:</td>
		<td id="attachment">
	<%
		String path = application.getRealPath("/")+"WEB-INF\\document";
		String filenames[] = GetFileNames.getFileNamesStartWithPrefix(path, content.getPk());
		
		//如果该文件存在附件
		if(filenames.length>0){
			String ext = filenames[0].substring( filenames[0].lastIndexOf(".")+1);//获取文件后缀
			String newfilename = content.getFile_cover_content_name()+"."+ext;//组装新的文件名称	

			String suffixPath = application.getRealPath("/")+"images/suffix";//文件后缀图标存放路径
			String suffixs[] = Tool.getFileNames(suffixPath);//获取所有后缀名称
	
			//该后缀在后缀库中是否存在，默认为FALSE
			boolean isExist = false;
				  for (int j = 0; j < suffixs.length; j++) {	   		    
				    	if(suffixs[j].startsWith(ext)){
				    		isExist = true;
				    		break;
				    	}
			}
			if(!isExist){//如果当前文件后缀在后缀库中不存在，则显示默认图标。
				ext = "none";
			}
			%>	
		<a title="点击下载" style="CURSOR:hand" onclick="window.location.href='filecovercontentdo.do?method=download&pk=<%=content.getPk() %>'">	
		<img src="images/suffix/big/<%=ext%>.png" border="0" >
		<u>
		<%=newfilename %>
		</u>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" class="btbox" value="重新上传" onclick="deleteBlob()" >
		</a>
		<%
		}else{
		%>
		<input type="file" name="file1" size="51" value="" >&nbsp;<font color="red">最大允许上传附件10M</font>
		<%
		}
		%>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">备注:</td>
		<td><textarea id="memo" name="memo" rows="6" cols="60" ><%=content.getMemo() %></textarea></td>
	</tr>
</table>
</form>		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />