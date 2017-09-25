<%
	//首先判断是否已登录
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
	//然后判断是否有权限，如果不是文档管理员/超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	boolean isFunctionManager = Tool.isFunctionManager(request);
	
	if(!isSuperadmin&&!isDocmentAdmin&&!isFunctionManager){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.project.bean.Project"%>
<%@page import="cn.sdfi.project.dao.ProjectDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
<head>
<title>项目信息更改</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
	//如果是实验室项目，则需对项目编码进行校验
	if($('isLabProject').value=="1"){
		if(addForm.code.value == "") {
			alert("请输入项目编号！");
			addForm.code.focus();
			return false;
		}else if (checklength('code')!=12||($('code').value.substring(0,5)!="ISTL-")){
			alert("项目编号格式不正确，请按照编号规则进行编号，如2010年度第一个实验室项目编号是：ISTL-P201001 。");
			addForm.code.focus();
			return false;
		} else if(!isExist('code')){
			alert("该项目编号已存在，请重新输入！");
			addForm.code.focus();
			return false;
		} 
	}
	//无论是否实验室项目，下面都要进行校验
	if(addForm.state.value == "") {
			alert("请选择项目当前状态！");
			addForm.state.focus();//光标定位
			return false;
		} else if (addForm.project_customer.value == "") {
			alert("请选择客户！");
			addForm.project_customer.focus();
			return false;
		}else if (addForm.project_type.value == "") {
			alert("请选择项目类型！");
			addForm.project_type.focus();
			return false;
		}else if (addForm.name.value == "") {
			alert("请输入项目名称！");
			addForm.name.focus();
			return false;
		} else if (addForm.devmanager.value == "") {
			alert("请输入客户负责人！");
			addForm.devmanager.focus();
			return false;
		} else if (addForm.testmanager.value == "") {
			alert("请输入测试负责人！");
			addForm.testmanager.focus();
			return false;
		} else if (addForm.begintime.value == "") {
			alert("请选择项目开始时间！");
			addForm.begintime.focus();
			return false;
		} else if (addForm.year.value == "") {
			alert("请选择项目所属年度！");
			addForm.year.focus();
			return false;
		}else if (!checktesterlength('tester')) {
			return false;
		} else {
			return true;

		}
	}

//接收组件id
function isExist(which) {

	//首先判断项目编号是否发生了改变，如果未发生改变，则不再进行下面的验证。
	if($(which).value==$('old_'+which).value){
		return true;
	}
	
	//发送Ajax请求到服务器，验证项目编号是否已存在
	var req = getXmlHttpObject();
	var isAvailable = false;
	var value = $(which).value;
	var url = "projectdo.do?method=isExist&value="+value;	
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
	//初始化函数
	function init() {
		var radios = document.getElementsByName("isLabProject");
		for ( var i = 0; i < radios.length; i++) {
			if (radios[i].checked == true) {

				//如果实验室项目被选中
				if (radios[i].value == '1') {
					$('isLabProject_tip').innerHTML = "实验室项目编号规则：ISTL-P，如2010年度第一个项目的编号为：ISTL-P201001";
				}
				//如果非实验室项目被选中
				else {
				}
				break;
			}
		}
	}
	//检测测试人员长度
	function checktesterlength(id) {
		var length = checklength(id);
		if (length > 100) {
			alert("测试人员文本域最长可输入长度为100个字符，每个汉字占2个字符，您当前已输入字符数 " + length + " !");
			$("tester").focus();
			return false;
		}
		return true;
	}
	//执行保存
	function save() {
		if (check() && checkmemolength('memo')) {
			document.addForm.action = "projectdo.do?method=update";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript" type="text/javascript" src="js/ShowCalendar.js"></script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body onload="init()" background="images/skins/<%=session.getAttribute("skin") %>" >
<span id="tips"></span>
<%
	String pk = request.getParameter("pk");
	ProjectDao projectDao = (ProjectDao)ObjectFactory.getObject(ProjectDao.class.getName());
	Project project = projectDao.queryByPK(pk);
	boolean isLabProject = "1".equals(project.getIsLabProject());
%>
<%
	Map<String,String> project_state = Const.getEnumMap().get("project_state");
	Map<String,String> project_types = Const.getEnumMap().get("project_type");
	Map<String,String> project_customers = Const.getEnumMap().get("project_customer");	
%>
<form action="" name="addForm" method="post">
<h2 align="center">
<%
		if(isLabProject){out.print("实验室项目信息更新");}
		else{out.print("非实验室项目信息更新");}
%>
</h2>
<div align="right">
<input type="button" class="btbox" value="保存" onclick="save()"  >
<input type="button" class="btbox" value="返回上一页" onclick="javascript:parent.history.back(); return;">
<% if(isLabProject){ %>
<input type="button" class="btbox" value="返回首页" onClick="window.location.href='projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp'">
<% }else{ %>
<input type="button" class="btbox" value="返回首页" onClick="window.location.href='projectdo.do?method=query&isLabProject=0&path=project_query.jsp'">
<% } %>
</div>
<hr>
<!-- 是否实验室项目隐藏域 -->
<input type="hidden" name="isLabProject" value="<%=isLabProject?1:0 %>">	
<!-- 主键隐藏域 -->
<input type="hidden" name="pk" value="<%=project.getPk() %>">
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
					<% if(isLabProject){ %>
					<tr>
						<td align="right" nowrap="nowrap">
							项目编号:
						</td>
						<td nowrap="nowrap">
							<input type="hidden" id="old_code" name="old_code" value="<%=project.getCode() %>">
							<input type="text" name="code" value="<%=project.getCode() %>" size="20" maxlength="12" >
							<font color="red">*&nbsp;
							<span id="code_tip"></span></font>
						</td>
					</tr>
					<% } %>
					<tr>
						<td align="right" nowrap="nowrap">
							项目名称:
						</td>
						<td>
							<input type="text" name="name" value="<%=project.getName() %>" size="60" maxlength="25" >
							<font color="red">*</font>	
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							项目当前状态:
						</td>
						<td>
				<select name="state" size="1">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : project_state.entrySet()) {					
				%>
				<option value="<%=entry.getKey()%>"	
				<%
					if(project.getState()!=null){
					if (project.getState().trim().equals(entry.getKey().trim())) {
						out.print("selected=\"selected\"");
						}
					}
				%>
				/><%=entry.getValue()%>
				<%
				}
				%>
				</select>
				<font color="red">*</font>	
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							客户名称:
						</td>
						<td>
				<select name="project_customer" size="1">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : project_customers.entrySet()) {					
				%>
				<option value="<%=entry.getKey()%>"	
				<%
					if(project.getProject_customer()!=null){
					if (project.getProject_customer().trim().equals(entry.getKey().trim())) {
						out.print("selected=\"selected\"");
						}
					}
				%>
				/><%=entry.getValue()%>
				<%
				}
				%>
				</select>
				<font color="red">*</font>	
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							项目类别:
						</td>
						<td>
				<select name="project_type" size="1" onchange="project_type_change(this)">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : project_types.entrySet()) {					
				%>
				<option value="<%=entry.getKey()%>"	
				<%
					if(project.getProject_type()!=null){
					if (project.getProject_type().trim().equals(entry.getKey().trim())) {
						out.print("selected=\"selected\"");
						}
					}
				%>
				/><%=entry.getValue()%>
				<%
				}
				%>
				</select>
				<font color="red">*&nbsp;
				<span id="project_type_tip"></span></font>
						</td>
					</tr>
					
					<tr>
						<td align="right" nowrap="nowrap">
							项目经理:
						</td>
						<td>
							<input type="text" name="devmanager" value="<%=project.getDevmanager() %>" size="60" maxlength="10">
							<font color="red">*</font>	
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试经理:
						</td>
						<td>
							<input type="text" name="testmanager" value="<%=project.getTestmanager() %>" size="60" maxlength="10" >
							<font color="red">*</font>	
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试人员:
						</td>
						<td>
							<textarea  name="tester" rows="2" cols="60"><%=project.getTester() %></textarea>
							</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试开始时间:
						</td>
						<td>
							<input type="text" name="begintime" value="<%=project.getBegintime() %>" size="12" readonly="readonly" onfocus="showDate()">
							<input type="button" class="btbox" value="-清-" onclick="clear_condition($('begintime'))">
							<font color="red">*</font>	
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试结束时间:
						</td>
						<td>
							<input type="text" name="endtime" value="<%=project.getEndtime() %>" size="12" readonly="readonly" onfocus="showDate()" >
							<input type="button" class="btbox" value="-清-" onclick="clear_condition($('endtime'))">
					</tr>
				<tr>
						<td align="right" nowrap="nowrap">
							年度:
						</td>
						<td>
						<select name="year" title="请选择年度" size="1">
						<option value="" />请选择...
						<%
						for(int i=2004;i<2021;i++){
						%>
						<option value="<%=i %>" 
						<%
						if(project.getYear()!=null){
							if(project.getYear().toString().trim().equals(i+"")){
								out.print("selected=\"selected\"");
							}
						}
						%>
						/>
						<%=i %>
						<%
						} 
						%>
						</select>
						<font color="red">*</font>	
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							说明:
						</td>
						<td>
							<textarea id="memo" name="memo" rows="6" cols="60" ><%=project.getMemo() %></textarea>
							</td>
					</tr>
				</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />