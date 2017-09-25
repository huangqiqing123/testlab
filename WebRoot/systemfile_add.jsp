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
<%@page import="cn.sdfi.tools.Tool"%><html>
	<head>
		<title>受控文件新增页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
if(addForm.code.value=="")
{
	alert("请输入文件编号！");
	addForm.code.focus();//光标定位
	return false;
}
else if(isContainChineseChar('code')){
	alert("文件编码中不能包含有中文或者全角字符！");
	addForm.code.focus();
	return false;
}else if(!isExist('code')){
	alert("该设备编号已存在，请重新输入！");
	addForm.code.focus();
	return false;
}else if(addForm.name.value=="")
{
	alert("请输入文件名称！");
	addForm.name.focus();
	return false;
}
else if(addForm.controlled_number.value=="")
{
	alert("受控号不能为空！");
	addForm.controlled_number.focus();
	return false;
}
else if(!isNumber(addForm.controlled_number.value))
{
	alert("受控号必须是数字！");
	addForm.controlled_number.focus();
	return false;
}
else
{
return true;

}
}
//接收组件id
function isExist(which) {

	//发送Ajax请求到服务器，验证项目编号是否已存在
	var req = getXmlHttpObject();
	var isAvailable = false;
	var value = trim($(which).value);
	var url = "systemfiledo.do?method=isExist&value="+value;	
	req.onreadystatechange = function(){
		if (req.readyState == 4) {
			if (req.status == 200) {		
				var msg = req.responseText;
				if(msg=="1"){//"1"表示该项目编号已经被使用
					isAvailable=false;
				}else if(msg=="0"){
					isAvailable=true;
				}else{
					alert("解析返回值出现异常！");
				}		
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return isAvailable ;
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
//执行保存
function save(){
	if(check()&&checkmemolength('memo')){
		document.addForm.action="systemfiledo.do?method=add&action=save";
		document.addForm.submit();
	}
}
//执行保存并继续
function goOn(){
	if(check()&&checkmemolength('memo')){
		document.addForm.action="systemfiledo.do?method=add&action=continue";
		document.addForm.submit();
	}
}
</script>
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>"  >
	<span id="tips"></span>
			<h2 align="center">
				受控文件增加
			</h2>
			<div align="right">
			
			<input type="button" class="btbox" value="保存" onclick="save()" >
			<input type="button" class="btbox" value="保存并继续" onclick="goOn()"  >
			<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='systemfiledo.do?method=query&path=menu.jsp'">
		</div>
			<hr>
			<form action="systemfiledo.do?method=add" name="addForm" method="post">
				<table align="center" border="1" width="100%" >
				
					<tr>
						<td nowrap="nowrap">
							文件编号
						</td>
						<td>
							<input type="text" id = "code" name="code" value="ISTL-T" size="20" maxlength="12">
							<font color="red">*&nbsp;体系文件编号必须以ISTL-T开头，如:ISTL-T001</font>
						</td>
					</tr>
					<tr>
						<td>
							文件名称
						</td>
						<td>
							<input type="text" name="name" value="" size="60" maxlength="25">
							<font color="red">*</font>
					</tr>
					<tr>
						<td>
							受控号
						</td>
						<td>
							<input type="text" name="controlled_number" value="" size="60" maxlength="4">
							<font color="red">*</font>
					</tr>
					<tr>
						<td>
							版本
						</td>
						<td>
							<input type="text" name="version" value="" size="60" maxlength="5">
					</tr>
					<tr>
						<td>
							页数
						</td>
						<td>
							<input type="text" name="pages" value="" size="12" maxlength="5">
					</tr>
					<tr>
						<td>
							状态
						</td>
						<td>
						<select name="state" title="请选择状态" size="1">
						<option value="">请选择...
						<option value="有效">有效
						<option value="已废弃">已废弃
						</select>
					</tr>
					<tr>
						<td>
							备注
						</td>
						<td>
							<textarea id="memo" name="memo" rows="6" cols="60"></textarea>
							</td>
					</tr>
				</table>
			</form>
	
		
	</body>
</html>
	<jsp:include page="includes/alert.jsp" flush="true" />