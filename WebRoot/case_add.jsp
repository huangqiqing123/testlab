
<%
	//登陆检查
	if(Tool.isNotLogin(request)){ 
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%><html>
<head>
<title>新增案例页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//初始化函数
	function init() {
		document.forms[0].type.focus();
	}
	//选择附件时，同步设置 标题title的值。
	function setTitleValue(){
		var fileValue = $('file1').value;
		$("title").value = fileValue.substring(fileValue.lastIndexOf('\\')+1);
	}
	//执行导入前的校验
	function check_blob(){
		var value=$('file1').value;
		if(value==""){
			$("blob_check_result").innerHTML = "<font color='red'>提示：请选择附件！</font>";
			return false;
		}else if(value.indexOf('.')==-1){
			$("blob_check_result").innerHTML = "<font color='red'>提示：请选择有效附件！</font>";
			return false;
		}else{
			var fileExt = value.substr(value.lastIndexOf('.')+1).toLowerCase();
			if(fileExt=='bat'||fileExt=='exe'||fileExt=='com'){
				$("blob_check_result").innerHTML = "<font color='red'>提示：不允许上传exe、bat、com等可执行文件！</font>";
				return false;
			}else{
			$("blob_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
			}
		}
	}
	//检查关键字
	function check_title() {
		if (addForm.title.value == "") {
			$("title_check_result").innerHTML = "<font color='red'>提示：关键字不能为空！</font>";
			return false;
		}else if(checklength("title")>100){
			$("title_check_result").innerHTML = "<font color='red'>提示：关键字最长可输入长度是100个字节，每个汉字占2个字节，您当前已输入字节数"+checklength("title")+"，请重新输入！</font>";
			return false;
		}else {
			$("title_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//检查类型
	function check_type() {
		if (addForm.type.value == "") {
			$("type_check_result").innerHTML = "<font color='red'>提示：请选择案例所属类型！</font>";
			return false;
		} else {
			$("type_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//执行保存
	function save() {
		if (check_type()&&check_blob()&&check_title()) {
			document.addForm.action = "casedo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//执行提交
	function submit() {
		if (check_type()&&check_blob()&&check_title()) {
			document.addForm.action = "casedo.do?method=add&action=submit";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body onload="init()"	background="images/skins/<%=session.getAttribute("skin") %>">
<span id="tips"></span>
<h2 align="center">新上传案例</h2>
<div align="right">
<input type="button" class="btbox" value="保存"	onclick="save()"> 
<input type="button" class="btbox"	value="提交" onclick="submit()"> 
<input type="button" class="btbox" value="返回上一页"	onClick="javascript:parent.history.back(); return;"> 
</div>
<hr>
<%
	Map<String, String> case_types = Const.getEnumMap().get("case_type");
%> 
<form action="casedo.do?method=add" name="addForm"  method="post" ENCTYPE="multipart/form-data">
<table align="center" border="1" cellpadding="1" cellspacing="0" width="100%">
	<tr>
		<td align="right" nowrap="nowrap">类型:</td>
		<td align="left">
		<select name="type" size="1" onblur="check_type()"	onchange="check_type()">
			<option value="" />---请选择--- 
			<%
				for (Map.Entry<String, String> entry:case_types.entrySet()) {
			%>
			
			<option value="<%=entry.getKey()%>" /><%=entry.getValue()%> <%
 			}
 		%>
			
		</select> 
		<font color="red">*</font> 
		<div id="type_check_result"></div></td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">选择文件:</td>
		<td nowrap="nowrap">
		<input type="file" name="file1" size="50" onblur="check_blob()"  onchange="check_blob();setTitleValue()">&nbsp;
		<font color="green">*最大允许上传附件20M</font>
		<div id="blob_check_result"></div>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">关键字:</td>
		<td nowrap="nowrap">
		<input type="text" id="title" name="title" value="" size="50" maxlength="100"  onchange="check_title()"> 
		<font color="red">*</font> <div id="title_check_result"></div>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">版本:</td>
		<td nowrap="nowrap">
		<input type="text" name="version" value="" size="50" maxlength="25" onblur="check_title()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">摘要:</td>
		<td><textarea id="summary" name="summary" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right" nowrap="nowrap">详细描述:</td>
		<td><textarea id="detail" name="detail" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">分析过程:</td>
		<td><textarea id="analyze" name="analyze" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">解决方案:</td>
		<td><textarea id="solve" name="solve" cols="80" rows="10"></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">结果:</td>
		<td><textarea id="result" name="result" cols="80" rows="10"></textarea>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />