<%
	//如果没有登陆
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
<jsp:include page="includes/encoding.jsp" flush="true" />

<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%><html>
	<head>
		<title>实验室设备新增页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
if(addForm.computer_type.value==""){

	alert("请选择设备类型！");
	addForm.computer_type.focus();//光标定位
	return false;
}	
else if($('code').value=="")
{
	alert("请输入设备编号！");
	$('code').focus();//光标定位
	return false;
}
else if(isContainChineseChar('code'))
{
	alert("设备编号中不能包含有中文和全角字符！");
	$('code').focus();//光标定位
	return false;
} else if(!isExist('code')){
	alert("该设备编号已存在，请重新输入！");
	addForm.code.focus();
	return false;
}else if(addForm.name.value=="")
{
	alert("请输入设备名称！");
	addForm.name.focus();
	return false;
}
else if(addForm.status.value=="")
{
	alert("请选择设备状态！");
	addForm.status.focus();
	return false;
}
else if($("month").value==""&&$("year").value!="")
{
	alert("请选择月份！");
	$("month").focus();
	return false;
}
else if($("year").value==""&&$("month").value!="")
{
	alert("请选择年份！");
	$("year").focus();
	return false;
}
else if(!checkmemolength('memo')||!checkconflength('conf'))
{
	return false;
}else{
	return true;
}
}
//接收组件id
function isExist(which) {

	//发送Ajax请求到服务器，验证项目编号是否已存在
	var req = getXmlHttpObject();
	var isAvailable = false;
	var value = trim($(which).value);
	var url = "computerdo.do?method=isExist&value="+value;	
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
//检测配置的长度
function checkconflength(id){
	var length = checklength(id);
	if(length>200){
		alert("配置文本域最长可输入长度为200个字符，每个汉字占2个字符，您当前已输入字符数 "+length+" !");
		$("conf").focus();
		return false;
	}
	return true;
}
//执行保存
function save(){
	if(check()){
		$("begin_use_time").value=$("year").value+$("month").value;
		document.addForm.action="computerdo.do?method=add&action=save";
		document.addForm.submit();
	}
}
//保存并继续
function goOn(){
	if(check()){
		$("begin_use_time").value=$("year").value+$("month").value;
		document.addForm.action="computerdo.do?method=add&action=continue";
		document.addForm.submit();
	}
}
</script>
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>"  >
	<span id="tips"></span>
			<h2 align="center">
				新增实验室设备
			</h2>
			<div align="right">
			
			<input type="button" value="保存" class="btbox" onclick="save()" >
			<input type="button" value="保存并继续" class="btbox" onclick="goOn()"  >
			<input type="button" value="返回上一页" class="btbox" onClick="javascript:parent.history.back(); return;">
			<input type="button" value="返回首页" class="btbox" onclick="window.location.href='computerdo.do?method=query&path=menu.jsp'"  >
		</div>
			<hr>
			<form action="computerdo.do?method=add" name="addForm" method="post">
				<table align="center" border="1" width="100%" cellpadding="0" cellspacing="0">
				<tr>
						<td align="right">
							设备类型:
						</td>
						<td>
				<%
				Map<String,String> computer_type = Const.getEnumMap().get("computer_type");	
				%>
				<select name="computer_type" size="1">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : computer_type.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select><font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							设备编号:
						</td>
						<td >
							<input type="text" id="code" name="code" value="" size="60" maxlength="15">
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							设备名称:
						</td>
						<td>
							<input type="text" name="name" value="" size="60" maxlength="15">
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							状态:
						</td>
						<td>
				<%
				Map<String,String> computer_status = Const.getEnumMap().get("computer_status");	
				%>
				<select name="status" size="1">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : computer_status.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select>
				<font color="red">*</font>
						</td>
					</tr>
					
					<tr>
						<td align="right">
							序列号:
						</td>
						<td>
							<input type="text" name="serial_number" value="" size="60" maxlength="25">
					</tr>
					<tr>
						<td align="right">
							设备型号:
						</td>
						<td>
							<input type="text" name="type" value="" size="60" maxlength="25">
					</tr>
					<tr>
						<td align="right">
							生产厂商:
						</td>
						<td>
							<input type="text" name="manufactory" value="" size="60" maxlength="50">
					</tr>
					<tr>
						<td align="right">
							设备IP:
						</td>
						<td>
						<input type="text" name="ip" value="" size="60" maxlength="32">
						</td>
					</tr>
					<tr>
						<td align="right">
							领用人:
						</td>
						<td>
							<input type="text" name="owner" value="" size="60" maxlength="10">
						</td>	
					</tr>
					<tr>
						<td align="right">
							领用日期:
						</td>
						<td>
						<select id="year" name="year"  size="1" >
						<option value="">年...
						<%
						for(int i=2004;i<2021;i++){
						%>
						<option value="<%=i %>"><%=i %>
						<%
						} 
						%>
						</select>
						年
						<select id="month" name="month"  size="1" >
						<option value="">月...
						<%
						for(int i=1;i<=12;i++){
						%>
						<option value="<%=i<10?"0"+i:i %>"><%=i<10?"0"+i:i %>
						<%
						} 
						%>
						</select>
						月
						<input type="hidden" id="begin_use_time" name="begin_use_time" value="" >
						</td>
					</tr>
					<tr>
						<td align="right">
							使用地点:
						</td>
						<td>
						<input type="text" name="use_site" value="" size="60" maxlength="100">
						</td>
					</tr>
					<tr>
						<td align="right">
							配置:
						</td>
						<td>
						<textarea  id='conf' name="configuration" rows="5" cols="70" ></textarea>
						
						</td>
					</tr>
					<tr>
						<td align="right">
							说明:
						</td>
		<td>
		<textarea id='memo' name="memo" rows="6" cols="70" ></textarea>
		 </td>
					</tr>
				</table>
			</form>		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />