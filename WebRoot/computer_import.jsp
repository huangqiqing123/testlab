<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
//如果不是设备管理员，也不是超级管理员，则无权进入该页面。
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
<title>Excel文件信息导入</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">

<script language="javascript">

	//执行导入前的校验
	function check(){
		var value=document.getElementById('file1').value;
		if(value==""){
			alert('请选择要导入的excel文件！');
			return false;
		}else if(value.indexOf('.')==-1){
			alert('文件格式不正确，请重新选择！');
			return false;
		}else if(value.substring(value.lastIndexOf('.')+1)!="xls"&&value.substring(value.lastIndexOf('.')+1)!="XLS"){
			alert('文件格式不正确（导入的文件必须以xls或者XLS结尾），请重新选择！');
			return false;
		}else{
			return true;
		}
	}

	//执行导入
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
Excel文件信息导入
</h2>
<div align="right">
			<input type="button" class="btbox" value="执行导入" onclick="importExcel()">
			<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
			</div>
<fieldset><legend>请选择要导入的excel文件</legend>
<div align="center">
<form name="form1" method="post" ENCTYPE="multipart/form-data">
<input type="file" name="file1" size="51" class="btbox">
<input type="hidden" id="path" name="path" value="" >
</form>
</div>
</fieldset>
<br>
<fieldset><legend>说明（每个汉字占两个字节）</legend>
<br>
01、选择要导入的excel文件必须符合如下格式（第一行是标题，从第二行开始执行导入）：<br>
02、如果在数据库中已存在编号相同的文件，编号相同的文件不会覆盖导入，不存在的文件会正常导入。<br>
03、文件必须以"xls"或者"XLS"结尾。<br>
04、设备类型：设备类型不能为空，目前共包括“实验室设备”和“外借设备”2种。<br>
05、设备编码：设备编码不能为空，最长为15个字节，并且不能包含中文和全角字符。<br>
06、设备名称：设备名称不能为空，并且最长为30个字节。<br>
07、序列号：序列号最长可输入长度是50个字节。<br>
08、设备型号：设备型号最长可输入长度是50个字节。<br>
09、生产厂商：生产厂商最长可输入长度是100个字节。<br>
10、领用日期：领用日期如果不为空，则必须是4位年，2位月的格式，如：<font color="red">201002</font><br>
11、领用人：设备领用人最长可输入长度是20个字节。<br>
12、设备使用地点：设备使用地点最长可输入长度是200个字节。<br>
13、状态：设备状态不能为空，目前共包括“可用”和“已报废”2种。<br>
14、设备配置：设备配置最长可输入长度是200个字节。<br>
15、备注：备注信息最长可输入长度是1000个字节。
<table border="1" bordercolor="blue" width="100%">
<tr>
<th>设备类型</th><th>设备编号</th><th>设备名称</th><th>序列号</th><th>型号</th><th>生产厂商</th><th>领用日期</th><th>领用人</th><th>使用地点</th><th>状态</th><th>配置</th><th>备注</th>
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