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
<html>
	<head>
		<title>文件/记录信息增加</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	function check() {
		if (addForm.fk.value == "") {
			alert("请选择文件所在档案袋！");
			return false;
		} else if (addForm.file_cover_content_code.value == "") {
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
		}else if (addForm.file_cover_content_name.value == "") {
			alert("请输入文件名称！");
			addForm.file_cover_content_name.focus();
			return false;
		}else {
			return checkmemolength('memo');

		}
	}
	//发送Ajax请求到服务器，验证该编号是否已经被使用
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
						alert('文件编码 '+file_cover_content_code+' 已存在，请重新输入！');
						$("file_cover_content_code").focus();
					} else {
						alert("出错了，请联系系统管理员！");
					}
				}
			}
		};
		//false表示执行同步，true表示执行异步，如果是异步的话，isExist在回调函数中设置的值来不及生效，则执行了下面的return语句，从而造成数据的不一致，所以此处设置为同步。
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
	//保存
	function save() {
		if (check()) {
			document.addForm.action = "filecovercontentdo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//保存并继续
	function goOn() {
		if (check()) {
			document.addForm.action = "filecovercontentdo.do?method=add&action=continue";
			document.addForm.submit();
		}
	}
	//调用-选择档案袋-通用帮助
	function show_help_window() {
		var url = "filecoverdo.do?method=query&path=help";
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:750px;dialogHeight:520px");

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
			<h2 align="center">
				文件信息增加
			</h2>
			<div align="right">
			<input type="button" class="btbox" value="保存" onclick="save()" >
			<input type="button" class="btbox" value="保存并继续" onclick="goOn()"  >
			<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='filecovercontentdo.do?method=query'">
			</div>
			<hr>
<form action="filecovercontentdo.do?method=add" name="addForm" method="post" ENCTYPE="multipart/form-data">
	<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td align="right" nowrap="nowrap" >文件所在档案袋:</td>
		<td >
		<%
			String file_cover_content_code_prefix="";//作为文件编号的前缀
			Object fk_show=request.getAttribute("fk_show");
			Object fk=request.getAttribute("fk");
			if(fk==null)fk="";
			if(fk_show==null)fk_show="";
			if(!"".equals(fk_show)){
				file_cover_content_code_prefix=fk_show.toString().substring(0,fk_show.toString().indexOf("("))+"-";
			}
		%> 	
		<input type="text" id="fk_show" name="fk_show" value="<%=fk_show %>" size="50"  readonly="readonly">
		<input type="button" class="btbox" value="选择..." onclick="show_help_window()">
		<input type="hidden" id="fk" name="fk" value="<%=fk %>" >
		<font color="red">*</font>
		</td>
	</tr>
	<tr>
		<td align="right" >文件编码:</td><!-- 文件编码只能是英文，不能包含中文和全角符号  -->
		<td  nowrap="nowrap">
		<input type="text"  id="file_cover_content_code" name="file_cover_content_code" value="<%=file_cover_content_code_prefix%>"	size="40" maxlength="20"> 
		<input type="hidden" id="file_cover_content_code_prefix" name="file_cover_content_code_prefix" value="<%=file_cover_content_code_prefix%>"	>
		<font color="red">* 文件编码=文件所在档案袋编码+“-”+序号</font>
		</td>
	</tr>

	<tr>
		<td align="right" >文件名称:</td>
		<td >
		<input type="text" name="file_cover_content_name" value=""	size="60" maxlength="30">
		<font color="red">*</font>
		</td>
	</tr>
	<tr>
		<td align="right" >页数:</td>
		<td >
		<input type="text" name="pages" value="" size="60"	maxlength="5">
		</td>
	</tr>
	<tr>
		<td align="right" >版本:</td>
		<td >
		<input type="text" name="version" value="" size="60" maxlength="5">
		</td>
	</tr>
		<tr>
		<td align="right" >附件:</td>
		<td nowrap="nowrap">
		<input type="file" name="file1" size="51" class="btbox" >&nbsp;<font color="red">最大允许上传附件10M</font>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap" >备注:</td>
		<td >
		<textarea id="memo" name="memo" rows="6" cols="60"  onblur="checkmemolength('memo')"></textarea>
		</td>
	</tr>
</table>
</form>		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />