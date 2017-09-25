<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是文档管理员/超级管理员/功能部经理，则无权进入该页面。
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

<%@page import="cn.sdfi.tools.Const"%><html>
	<head>
		<title>项目信息新增页面</title>
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
		if (addForm.state.value == "") {
			alert("请选择项目当前状态！");
			addForm.state.focus();
			return false;
		}else if (addForm.project_customer.value == "") {
			alert("请选择客户！");
			addForm.project_customer.focus();
			return false;
		} else if (addForm.project_type.value == "") {
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
function getXmlHttpObject()
{
  var xmlHttp=null;
  try
    {
    // Firefox, Opera 8.0+, Safari
    xmlHttp=new XMLHttpRequest();
    }
  catch (e)
    {
    // Internet Explorer
    try
      {
      xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
      }
    catch (e)
      {
      xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
      }
    }
  return xmlHttp;
}
	//检测测试人员长度
	function checktesterlength(id){
		var length = checklength(id);
		if(length>100){
			alert("测试人员文本域最长可输入长度为100个字符，每个汉字占2个字符，您当前已输入字符数 "+length+" !");
			$("tester").focus();
			return false;
		}
		return true;
	}
	//执行保存
	function save() {
		if(check()&&checkmemolength('memo')){
			document.addForm.action = "projectdo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//执行保存并继续
	function goOn() {
		if(check()&&checkmemolength('memo')){
			document.addForm.action = "projectdo.do?method=add&action=continue";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript"  src="js/ShowCalendar.js"></script>
<script language="javascript" src="js/pub.js"></script>
</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" onload="addForm.state.focus();" >
	<span id="tips"></span>
<%
	boolean isLabProject = "project_lab_query.jsp".equals(request.getParameter("path"));
%>
<%
	Map<String,String> project_state = Const.getEnumMap().get("project_state");
	Map<String,String> project_types = Const.getEnumMap().get("project_type");	
	Map<String,String> project_customers = Const.getEnumMap().get("project_customer");	
%>
			<h2 align="center">
				<%
				if(isLabProject){out.print("实验室项目信息增加");}
				else{out.print("非实验室项目信息增加");}
				%>
			</h2>
			<div align="right">	
			<input type="button" class="btbox" value="保存" onclick="save()" >
			<input type="button" class="btbox" value="保存并继续" onclick="goOn()"  >
			<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
			<% if(isLabProject){ %>
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp'">
			<% }else{ %>
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='projectdo.do?method=query&isLabProject=0&path=project_query.jsp'">
			<% } %>
		</div>
			<hr>
			<form action="projectdo.do?method=add" name="addForm" method="post">
				
				<!-- 是否实验室项目隐藏域 -->
				<input type="hidden" name="isLabProject" value="<%=isLabProject?1:0 %>">								
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
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
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select><font color="red">*</font>	

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
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select><font color="red">*</font>	

							</td>
					</tr>
					<tr>
					<td align="right" nowrap="nowrap">项目类别:</td>
					<td>
				<!-- 项目类别，暂时包括功能、性能、代码审查，如果有新类别，可以直接在枚举文件中配置即可  -->
				<select name="project_type" size="1">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : project_types.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	/><%=entry.getValue()%>
				<%
				}
				%>
				</select><font color="red">*</font>	
					
					</td>
					</tr>
					<% if(isLabProject){ %>	
					<tr id="tr_code">
						<td align="right" nowrap="nowrap">
							项目编号:
						</td>
						<td nowrap="nowrap">
							<input type="text" id="code" name="code" value="<%=isLabProject?"ISTL-P":"" %>" size="20" maxlength="12" >
							<font color="red">*&nbsp;
							<%
							if(isLabProject){
								out.print("实验室项目编号（ISTL-P），如2010年度第一个实验室项目编号是：ISTL-P201001");
							}
							%>
							</font>
						</td>
					</tr>
					<% } %>
					<tr>
						<td align="right" nowrap="nowrap">
							项目名称:
						</td>
						<td>
							<input type="text" name="name" value="" size="60" maxlength="30">
							<font color="red">*</font>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							项目经理:
						</td>
						<td>
							<input type="text" name="devmanager" value="" size="60" maxlength="10">
							<font color="red">*</font>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试经理:
						</td>
						<td>
							<input type="text" name="testmanager" value="" size="60" maxlength="10">
							<font color="red">*</font>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试人员:
						</td>
						<td>
							<textarea id="tester" name="tester" rows="2" cols="60"></textarea>

							</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							年度:
						</td>
						<td>
						<% int currentYear = Integer.parseInt(Tool.getCurrentYear()); %>
						<select name="year" title="请选择年度" size="1">
						<option value="">---请选择---
						<%
						for(int i=2004;i<2021;i++){
						%>
						<option value="<%=i %>" <% if(currentYear==i)out.print("selected=\"selected\""); %>><%=i %>
						<%
						} 
						%>
						</select>
						<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							项目开始时间:
						</td>
						<td>
						<input name="begintime" type="text" id="begintime" readonly="readonly" value="" onfocus="showDate()"/>
						<input type="button" class="btbox" value="-清-" onclick="clear_condition($('begintime'))">
						<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							项目结束时间:
						</td>
						<td>
						<input name="endtime" type="text" id="endtime" readonly="readonly" value="" onfocus="showDate()" />	
						<input type="button" class="btbox" value="-清-" onclick="clear_condition($('endtime'))">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							说明:
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