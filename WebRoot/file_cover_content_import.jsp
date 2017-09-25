<%
	//如果未登录。。。
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

<%@page import="java.util.List"%>
<%@page import="cn.sdfi.tools.Tool"%><jsp:include page="includes/encoding.jsp" flush="true" />
<html>
<head>
<title>Excel文件信息导入</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">

<script language="javascript">


	//执行导入前的校验
	function check() {
		var value = document.getElementById('file1').value;
		if (value == "") {
			alert('请选择要导入的excel文件！');
			return false;
		} else if (value.indexOf('.') == -1) {
			alert('文件格式不正确，请重新选择！');
			return false;
		} else if (value.substring(value.lastIndexOf('.') + 1) != "xls" && value.substring(value.lastIndexOf('.') + 1) != "XLS") {
			alert('文件格式不正确（导入的文件必须以xls或者XLS结尾），请重新选择！');
			return false;
		} else if(document.getElementById("fk").value == ""){
			alert("请选择文件所在档案袋！");
			return false;
		}else{
			return true;
		}
	}
	//执行导入
	function importExcel() {

		if (check()) {
			document.getElementById("path").value = "file_cover_content_import.jsp";
			document.form1.action = "doUpload.jsp";
			document.form1.submit();
		}
	}

	//显示通用帮助
	function show_help_window() {
		var url = "filecoverdo.do?method=query&path=help";
		var returnValue = window.showModalDialog(url, null,
				"scroll:yes;status:no;dialogWidth:750px;dialogHeight:520px");

		//点击关闭按钮，返回null
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
Excel文件信息导入
</h2>
<div align="right">
			<input type="button" class="btbox" value="执行导入" onclick="importExcel()">
			<input type="button" class="btbox" value="返回" onClick="javascript:parent.history.back(); return;">
</div>
<form name="form1" method="post" ENCTYPE="multipart/form-data">
<fieldset><legend>请选择要导入的excel文件</legend>
<table align="center">
<tr>
<td nowrap="nowrap">请选择要导入的excel文件：</td>
<td>
<input type="file" class="btbox" name="file1" size="51"  >
<input type="hidden" id="path" name="path" value="" >
</td>
</tr>
<tr>
<td nowrap="nowrap">请选择文件所在档案袋：</td>
<td>
	<input type="text" id="fk_show" name="fk_show" value="" size="51"  readonly="readonly">
	<input type="button" class="btbox" value="选择..." onclick="show_help_window()">
	<input type="hidden" id="fk" name="fk" value="" >
	<input type="hidden" id="file_cover_code" name="file_cover_code" value="" >
</td>
</tr>
</table>
</fieldset>
<br>
<fieldset><legend>说明（每个汉字占两个字节）</legend>
<table border="0" align="center" width="100%" >
<tr>
<td nowrap="nowrap">
<br>
1、选择要导入的excel文件必须符合如下格式（第一行是标题）：<br>
2、如果在数据库中已存在编号相同的文件，编号相同的文件不会覆盖导入，不存在的文件会正常导入。<br>
3、一次只能导入同一个档案袋内的文件。<br>
4、文件编码：文件编码不能为空；不能包含有中文和全角字符；并且必须以其所在档案袋编码开头；最长可输入长度是20个字节。<br>
5、文件名称：文件名称不能为空；文件名称最长可输入长度80个字节。<br>
6、页数：页数最长可输入长度10个字节。<br>
7、版本：版本最长可输入长度10个字节。<br>
8、备注：备注最长可输入长度1000个字节。
<table border="1" bordercolor="blue" width="100%">
<tr>
<th>文件编号</th><th>文件名称</th><th>页数</th><th>版本</th><th>备注</th>
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