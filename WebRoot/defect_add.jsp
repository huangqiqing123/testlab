<%//登陆检查
	if (Tool.isNotLogin(request)) {
		request.getRequestDispatcher("no_login.jsp").forward(request,response);
		return;
}%>
<%
	//如果不是文档管理员/超级管理员/测试负责人，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	boolean isFunctionManager = Tool.isFunctionManager(request);

	if (!isSuperadmin && !isDocmentAdmin && !isFunctionManager) {
		request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />

<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.List"%>


<%@page import="cn.sdfi.product.dao.ProductDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
	<head>
		<title>新增页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//初始化函数
	function init() {

		document.forms[0].chart_project.focus();
	}
	//检查项目
	function check_chart_project() {
		if (addForm.chart_project.value == "") {
			$("chart_project_check_result").innerHTML = "<font color='red'>想选择项目！</font>";
			return false;
		} else {
			$("chart_project_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//检查年月
	function check_yearMonth() {
		var year = addForm.year.value;
		var month = addForm.month.value;
		if (year == "") {
			$("yearMonth_check_result").innerHTML = "<font color='red'>请选择年！</font>";
			return false;
		}else if(month==""){
			$("yearMonth_check_result").innerHTML = "<font color='red'>请选择月！</font>";
			return false;
		}else {
			$("yearMonth_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//检查包数
	function check_packageNumber() {
		if (addForm.packageNumber.value == "") {
			$("packageNumber_check_result").innerHTML = "<font color='red'>请输入总包数！</font>";
			return false;
		} else if(!isNumber(addForm.packageNumber.value)){	
			$("packageNumber_check_result").innerHTML = "<font color='red'>请输入正整数！</font>";
			return false;
		}else {
			$("packageNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//检查缺陷数
	function check_defectNumber() {
		if (addForm.defectNumber.value == "") {
			$("defectNumber_check_result").innerHTML = "<font color='red'>请输入总缺陷数！</font>";
			return false;
		} else if(!isNumber(addForm.defectNumber.value)){	
			$("defectNumber_check_result").innerHTML = "<font color='red'>请输入正整数！</font>";
			return false;
		}else {
			$("defectNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//检查严重缺陷数
	function check_seriousDefectNumber() {
		if (addForm.seriousDefectNumber.value == "") {
			$("seriousDefectNumber_check_result").innerHTML = "<font color='red'>请输入严重缺陷数！</font>";
			return false;
		} else if(!isNumber(addForm.seriousDefectNumber.value)){	
			$("seriousDefectNumber_check_result").innerHTML = "<font color='red'>请输入正整数！</font>";
			return false;
		}else {
			$("seriousDefectNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//检查reopen缺陷数
	function check_reopenNumber() {
		if (addForm.reopenNumber.value == "") {
			$("reopenNumber_check_result").innerHTML = "<font color='red'>请输入reopen缺陷数！</font>";
			return false;
		} else if(!isNumber(addForm.reopenNumber.value)){	
			$("reopenNumber_check_result").innerHTML = "<font color='red'>请输入正整数！</font>";
			return false;
		}else {
			$("reopenNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//总缺陷加权值
	function check_totalDefectWeight() {
		if (addForm.totalDefectWeight.value == "") {
			$("totalDefectWeight_check_result").innerHTML = "<font color='red'>请输入总缺陷加权值！</font>";
			return false;
		}else {
			$("totalDefectWeight_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//关键严重缺陷加权值
	function check_totalSeriousDefectWeight() {
		if (addForm.totalSeriousDefectWeight.value == "") {
			$("totalSeriousDefectWeight_check_result").innerHTML = "<font color='red'>请输入关键严重缺陷加权值！</font>";
			return false;
		}else {
			$("totalSeriousDefectWeight_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//总处理时长
	function check_totalProcessTime() {
		if (addForm.totalProcessTime.value == "") {
			$("totalProcessTime_check_result").innerHTML = "<font color='red'>请输入总处理时长！</font>";
			return false;
		} else if(!isNumber(addForm.packageNumber.value)){	
			$("totalProcessTime_check_result").innerHTML = "<font color='red'>请输入正整数！</font>";
			return false;
		}else {
			$("totalProcessTime_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//执行保存
	function save() {
		if (check_chart_project() && check_yearMonth()&& check_packageNumber()&&check_defectNumber()&&check_seriousDefectNumber()&&check_reopenNumber()&&check_totalProcessTime()&&check_totalDefectWeight()&&check_totalSeriousDefectWeight()) {

			$("yearMonth").value = $("year").value + $("month").value;
			if(isAvailable()){
				document.addForm.action = "defectdo.do?method=add&action=save";
				document.addForm.submit();
			}
		}
	}
	//执行保存并继续
	function goOn() {

		if (check_chart_project() && check_yearMonth()&& check_packageNumber()&&check_defectNumber()&&check_seriousDefectNumber()&&check_reopenNumber()&&check_totalProcessTime()&&check_totalDefectWeight()&&check_totalSeriousDefectWeight()) {
			$("yearMonth").value = $("year").value + $("month").value;
			if(isAvailable()){
				document.addForm.action = "defectdo.do?method=add&action=continue";
				document.addForm.submit();
			}
		}
	}
	//发送Ajax请求到服务器，验证当前项目、当前月份的记录是否已存在，如果已存在，则不再允许增加。
	function isAvailable() {
		var isAvailable = false;
		var req = getXmlHttpObject();
		var yearMonth = $("yearMonth").value;
		var chart_project = $("chart_project").value;
		var url = "defectdo.do?method=isExist&yearMonth="+yearMonth+"&chart_project="+chart_project;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {		
					var msg = req.responseText;
					if(msg=="1"){
						isAvailable=false;
						$("tips").innerHTML = "<font color='red'>当前项目"+$('yearMonth').value+"月份的记录已存在！</font>";
					}else if(msg=="0"){
						isAvailable=true;
					}else{
						alert("解析返回值出现异常！");
					}		
				}
			}
		};
		//false表示执行同步，true表示执行异步，如果是异步的话，isExist在回调函数中设置的值来不及生效，
		//则执行了下面的return语句，从而造成数据的不一致，所以此处设置为同步。
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
</script>
<script language="javascript" src="js/pub.js"></script>
	</head>
<body onload="init()"
	background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<h2 align="center">新增缺陷数据</h2>
<div align="right"><input type="button" class="btbox" value="保存"	onclick="save()"> 
<input type="button" class="btbox"	value="保存并继续" onclick="goOn()"> 
<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;"> 
<input	type="button" class="btbox" value="返回首页" 	onclick="window.location.href='defectdo.do?method=query'">
</div>
<hr>
<form action="defectdo.do?method=add" name="addForm" method="post">
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap" width="150" align="right">产品名称</td>
		<td align="left">
				<%
				ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
				Map<String, String> chart_projects = productDao.queryAll();
				%>
				<select id="chart_project" name="chart_project" size="1" onblur="check_chart_project()" onchange="check_chart_project()">
				<option value="" />---请选择---
				<%
					for (Map.Entry<String, String> entry : chart_projects.entrySet()) {
				%>
				<option value="<%=entry.getKey()%>" />
				<%=entry.getValue()%>
				<%
					}
				%>
				</select>
		 <font color="red">*&nbsp;</font> <span id="chart_project_check_result"></span></td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">年月</td>
		<td nowrap="nowrap">
		<select id="year" name="year"  size="1" onblur="check_yearMonth()" onchange="check_yearMonth()">
						<option value="">---年---
						<%
							String year = Tool.getCurrentYear();
							for (int i = 2010; i < 2021; i++) {
								%>
								<option value="<%=i%>" <%if ((i + "").equals(year))
								out.print("selected=\"selected\"");%>><%=i%>
						<%
							}
						%>
						</select>
						年
						<select id="month" name="month"  size="1" onblur="check_yearMonth()" onchange="check_yearMonth()" >
						<option value="">---月---
						<%
							String month = Tool.getCurrentMonth();
							for (int i = 1; i <= 12; i++) {
								%>
								<option value="<%=i < 10 ? "0" + i : i%>" <%if ((i + "").equals(month))
								out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
							<%
								}
						%>
						</select>
						月						
						<input type="hidden" id="yearMonth" name="yearMonth" value="" >
		 <font color="red">*&nbsp;</font>
		<span id="yearMonth_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">总包数</td>
		<td nowrap="nowrap">
			<input type="text" name="packageNumber" value="" size="40" maxlength="25" onblur="check_packageNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="packageNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">总缺陷数</td>
		<td nowrap="nowrap">
			<input type="text" name="defectNumber" value="" size="40" maxlength="25" onblur="check_defectNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="defectNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">总缺陷加权值</td><% // 总缺陷加权值/总缺陷数=缺陷平均严重程度  %>
		<td nowrap="nowrap">
			<input type="text" name="totalDefectWeight" value="" size="40" maxlength="25" onblur="check_totalDefectWeight()">
			<font color="red">*&nbsp;</font> 
			<span id="totalDefectWeight_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">缺陷Reopen次数</td>
		<td nowrap="nowrap">
			<input type="text" name="reopenNumber" value="" size="40" maxlength="25" onblur="check_reopenNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="reopenNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">关键严重缺陷数</td>
		<td nowrap="nowrap">
			<input type="text" name="seriousDefectNumber" value="" size="40" maxlength="25" onblur="check_seriousDefectNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="seriousDefectNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">关键严重缺陷加权值</td><% // 总处理时长/关键严重缺陷加权值=缺陷平均处理周期  %>
		<td nowrap="nowrap">
			<input type="text" name="totalSeriousDefectWeight" value="" size="40" maxlength="25" onblur="check_totalSeriousDefectWeight()">
			<font color="red">*&nbsp;</font> 
			<span id="totalSeriousDefectWeight_check_result"></span>
		</td>
	</tr>
	
	<tr>
		<td nowrap="nowrap" width="150" align="right">总处理时长(小时)</td><% //总处理时长/总缺陷加权值=缺陷平均处理周期  %>
		<td nowrap="nowrap">
			<input type="text" name="totalProcessTime" value="" size="40" maxlength="25" onblur="check_totalProcessTime()">
			<font color="red">*&nbsp;</font> 
			<span id="totalProcessTime_check_result"></span>
		</td>
	</tr>
	
</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />