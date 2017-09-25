<%
	//首先判断该用户是否已登录
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	
	if(!isSuperadmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>

<%@page import="cn.sdfi.product.bean.Product"%><html>
	<head>
		<title>产品信息修改</title>
		<base target="_self"> 
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

//检查产品名称
function check_name() {
	var name =  $('name').value;
	if (name == "") {
		$('name_result').innerHTML = "<font color='red'>请输入产品名称！</font>";
		return false;
	}else {
		$('name_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	} 
}
//检查排序编号
function check_sortCode() {
	var sortCode = $('sortCode').value;
	if (sortCode == "") {
		$('sortCode_result').innerHTML = "<font color='red'>请输入排序序号！</font>";
		return false;
	}else if(!isNumber(sortCode)){
		$("sortCode_result").innerHTML="<font color='red'>请输入数字！</font>";
		return false;
	} else {
		$('sortCode_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
//检查所属部门
function check_dept() {
	var dept =  $('dept').value;
	if (dept == "") {
		$('dept_result').innerHTML = "<font color='red'>请选择所属部门！</font>";
		return false;
	} else {
		$('dept_result').innerHTML = "<font color='green'>OK</font>";
		return true;
	}
}
	//点击关闭按钮
	function close_window() {
		window.returnValue = null;
		window.close();
	}
	
	//执行保存
	function save() { 
		if (check_name()&&(check_sortCode())&&(check_dept())) {
			document.forms[0].action = "productdo.do?method=update";
			document.forms[0].submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<%
	Product product = (Product) request.getAttribute("product.view");
	Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
%>
	<body background="images/skins/<%=session.getAttribute("skin") %>" onload="document.forms[0].name.focus();">
	<span id="tips"></span>
			<div align="right"><br>
			<input type="button" class="btbox" value="保存" onclick="save()" >
			<input type="button" class="btbox" value="关闭" onclick="close_window()">
		</div>
<form action="productdo.do?method=add" name="addForm" method="post">
	<fieldset>
		<legend>新产品增加</legend><br>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							产品名称
						</td>
						<td>
						    <input type="hidden" id="pk" name="pk" value="<%=product.getPk() %>">
							<input type="text" id="name" name="name" value="<%=product.getName() %>" size="30" maxlength="30"  onblur="check_name()">
							<font color="red">*</font>
							&nbsp;
							<span id="name_result"></span>
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							排序序号
						</td>
						<td>
							<input type="text" id="sortCode" name="sortCode" value="<%=product.getSortCode() %>" size="30" maxlength="10" onblur="check_sortCode()">
							<font color="red">*</font>
							&nbsp;
							<span id="sortCode_result"></span>
					</tr>
					
					<tr>
						<td>
							所属部门
						</td>
						<td>
						<select id="dept" name="dept"  size="1" onchange="check_dept()">
						<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : project_customers.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (product.getDept() != null&&!"".equals(product.getDept())) {
				if (product.getDept().toString().trim().equals(entry.getKey())) {
					out.print("selected=\"selected\"");
				}
				}%>
				/>
				<%=entry.getValue()%>
				<%
				}
				%>
						</select>
						<font color="red">*</font>
							&nbsp;
							<span id="dept_result"></span>
						</td>
					</tr>
				</table>
				</fieldset>
			</form>	
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />