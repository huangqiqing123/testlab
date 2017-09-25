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
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.filecover.bean.FileCover"%>
<%@page import="cn.sdfi.filecover.dao.FileCoverDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
<head>
<title>档案袋新增页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
//初始化函数
function init() {

	document.forms[0].file_cover_type.focus();
}
//检查档案袋名称
function check_file_cover_name() {
	if (addForm.file_cover_name.value == "") {
		document.getElementById("name_check_result").innerHTML = "<font color='red'>档案袋名称不能为空！</font>";
		return false;
	} else {
		document.getElementById("name_check_result").innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//检查档案袋编码
function check_file_cover_code() {
	var code = addForm.file_cover_code.value;
	if (code == "") {
		$("code_check_result").innerHTML = "<font color='red'>档案袋编码不能为空！</font>";
		return false;
	}else if(isContainChineseChar('file_cover_code')){
		$("code_check_result").innerHTML = "<font color='red'>档案袋编码中不能包含有中文或者全角字符！</font>";
		return false;
	}else if(($('file_cover_code').value.substring(0,5)!="ISTL-")){
		$("code_check_result").innerHTML = "<font color='red'>档案袋编码必须以“ISTL-”开头！</font>";
		return false;
	}else if ($("old_file_cover_code").value == $("file_cover_code").value) {
		$("code_check_result").innerHTML = "<font color='green'>OK</font>";
		return true;
	}else {		
		return isExist();
	}
}
//检查档案袋类型
function check_file_cover_type() {
	if (addForm.file_cover_type.value == "") {
		document.getElementById("type_check_result").innerHTML = "<font color='red'>请选择档案袋类型！</font>";
		return false;
	} else {
		document.getElementById("type_check_result").innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
	function save() {
		if (check_file_cover_name() && check_file_cover_code()&& check_file_cover_type()&&checkmemolength('memo')) {
			document.addForm.action = "filecoverdo.do?method=update";
			document.addForm.submit();
		}
	}
	//发送Ajax请求到服务器，验证该编号是否已经被使用
	function isExist() {
		var flag = false;
		var req = getXmlHttpObject();
		var file_cover_code = $("file_cover_code").value;
		var url = "filecoverdo.do?method=isExist&file_cover_code="+ file_cover_code;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {

					//可以使用  req.responseText 获取返回的文本信息			
					var msg = req.responseXML.getElementsByTagName("msg")[0].childNodes[0].nodeValue;
					var div = $("code_check_result");
					if (msg == "ok") {
						div.innerHTML = "<font color='green'>OK</font>";
						flag = true;
					} else if (msg == "not_ok") {
						div.innerHTML = "<font color='red'>该档案袋编号已经被使用！</font>";
					} else {
						alert("出错了，请联系系统管理员！");
					}
				}
			}
		}
		req.open("POST", url, false);
		req.send(null);
		return flag;
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
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body onload="init()"  background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<%
	String pk = request.getParameter("pk");
	FileCoverDao fileCoverDao = (FileCoverDao)ObjectFactory.getObject(FileCoverDao.class.getName());
	FileCover filecover = fileCoverDao.queryByPK(pk);
%>

<h2 align="center">档案袋信息修改</h2>
<div align="right">
<input type="button" class="btbox" value="保存" onclick="save()"  >
<input type="button" class="btbox" value="返回上一页" onclick="javascript:parent.history.back(); return;">
<input type="button" class="btbox" value="返回首页" onclick="window.location.href='filecoverdo.do?method=query&path=menu.jsp'">
</div>
<hr>
<form action="filecoverdo.do?method=add" name="addForm" method="post">
<input type="hidden" name="privledge" value="1">
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td align="right" nowrap="nowrap">档案袋类型:</td>
		<td align="left">
		<%
			Map<String, String> file_cover_types = Const.getEnumMap().get("file_cover_type");
			boolean isNull=false;
		%>
		<select name="file_cover_type" size="1" onblur="check_file_cover_type()" onchange="check_file_cover_type()">
			<option value=""
				<%
				if (filecover.getFile_cover_type() == null || "".equals(filecover.getFile_cover_type())) {
					out.print("selected=\"selected\"");
					isNull=true;
			}%> 
			/>请选择...
			<%
				for (Entry<String, String> entry:file_cover_types.entrySet()) {
			%>
			<option value="<%=entry.getKey()%>"
				<%
				if (!isNull){
				if (filecover.getFile_cover_type().trim().equals(entry.getKey().trim())) {
						out.print("selected=\"selected\"");
					}
				}
				%> />
			<%=entry.getValue()%> 
			<% 	} %>
			
		</select>
		<font color="red">*</font>
		<span id="type_check_result"></span>
		</td>
	</tr>
	<tr>
		<td  align="right" nowrap="nowrap">档案袋编号:</td>
		<td align="left" nowrap="nowrap">
		<!-- 当属性值是disabled时，通过request.getParameter取不到值 --> 
		<input type="hidden" name="pk" value="<%=filecover.getPk()%>"> 
		<input type="text" name="file_cover_code" value="<%=filecover.getFile_cover_code()%>" size="20" maxlength="15"  onblur="check_file_cover_code()">
		<input type="hidden" id="old_file_cover_code" value="<%=filecover.getFile_cover_code()%>">
		<font color="red">*</font>
		<span id="code_check_result"></span>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">档案袋名称:</td>
		<td align="left" nowrap="nowrap">
		<input type="text" name="file_cover_name" value="<%=filecover.getFile_cover_name()%>" size="50" maxlength="25" onblur="check_file_cover_name()">
			<font color="red">*</font>
			<span id="name_check_result"></span>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">年度:</td>
		<td align="left" nowrap="nowrap">
		<select name="file_cover_year" title="请选择年度" size="1">
						<option value="">---请选择---
						<%
						for(int i=2004;i<2021;i++){
						%>
						<option value="<%=i %>" <% if((i+"").equals(filecover.getFile_cover_year())) out.print("selected=\"selected\""); %>><%=i %>
						<%
						} 
						%>
		</select>
		</td>
	</tr>

    <tr>
		<td  align="right" nowrap="nowrap">备注:</td>
		<td align="left">
			<textarea id="memo" name="memo" cols="60" rows="8" ><%=filecover.getMemo()%></textarea>
		</td>
	</tr>
</table>
</form>


</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />