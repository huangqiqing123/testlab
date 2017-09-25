<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Calendar"%>
<%@page import="cn.sdfi.tools.Tool"%><html>
	<head>
		<title>超链接列表</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css" />
		<link rel="StyleSheet" type="text/css" href="css/dtree.css" />
		<script language="javascript" src="js/pub.js"></script>
		<script type="text/javascript" src="js/dtree.js"></script>
		
	<script type="text/javascript">
	function startTime() {
		showdate();
		var today = new Date();
		var h = today.getHours();
		var m = today.getMinutes();
		var s = today.getSeconds();
		m = checkTime(m);
		s = checkTime(s);
		document.getElementById('time').innerHTML = h + ":" + m + ":" + s;
	}

	function checkTime(i) {
		if (i < 10) {
			i = "0" + i
		}
		return i
	}
	
	function showdate() {
		var now = new Date();
		var year = now.getYear();
		var month = now.getMonth() + 1;
		var date = now.getDate();
		var day = now.getDay();
		if (day == 0) {
			day = "日";
		} else if (day == 1) {
			day = "一";
		} else if (day == 2) {
			day = "二";
		} else if (day == 3) {
			day = "三";
		} else if (day == 4) {
			day = "四";
		} else if (day == 5) {
			day = "五";
		} else {
			day = "六";
		}
		var dateValue = year + "年" + month + "月" + date + "日 星期" + day + " ";
		document.getElementById('date').innerHTML = dateValue;
	}
	function setStatus(){
		window.status="<%=session.getAttribute("username")%>，你好！欢迎进入齐鲁软件评测实验室文档管理系统！";
		}
</SCRIPT>
<script for="window" event="onbeforeunload"> 
//关闭窗口，则执行注销。
    if(document.body.clientWidth-event.clientX< 170&&event.clientY< 0||event.altKey){
		 	window.location.href='userdo.do?method=logout&path=closeIE';alert('谢谢使用！');
    }
</script>
	</head>
	<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"
	onload="setInterval('startTime()',500);setStatus()"	
	background="images/skins/<%=session.getAttribute("skin") %>"  
	>
	<table align="center" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td align="center" nowrap="nowrap">
		<fieldset style="height:30">
		<div  id="date" align="center" style="font-size:13px;color:black;border:2" ></div>
		<div id="time" align="center" style="font-size:13px;color:black;border:2"></div>
		</fieldset>
		<fieldset style="height:30">
			<font size='2'>当前用户</font>[<font size=2 color="red"><%=session.getAttribute("username")%></font> ]
		</fieldset>
		<fieldset style="height:30">
			[<font size='2'><a href="userdo.do?method=logout" target="_parent">安全退出</a></font>]
		</fieldset>
		</td>
	</tr>
	</table><br>
<fieldset>
<legend align="center">
<a href="javascript: f.openAll();"><font color=blue><u>展开</u></font></a>
&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="javascript: f.closeAll();"><font color=blue><u>收起</u></font></a>
</legend>
<div class="dtree">
<script type="text/javascript">
var f = new dTree('f');

f.add(0,-1,'');//根节点

f.add(1,0,'<font color=blue>项目管理</font>');//(节点id、上级节点id、显示名称、跳转的url、提示信息title、target、合并时图标,展开式图标, true/false默认是否展开当前节点)
f.add(1.1,1,'实验室项目管理','projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp','','show');
f.add(1.2,1,'非实验室项目管理','projectdo.do?method=query&isLabProject=0&path=project_query.jsp','','show');

f.add(2,0,'<font color=blue>文档管理</font>');
f.add(2.1,2,'档案袋信息管理','filecoverdo.do?method=query&path=menu.jsp','','show');
f.add(2.2,2,'文件信息管理','filecovercontentdo.do?method=query','','show');
f.add(2.3,2,'受控文件管理','systemfiledo.do?method=query&path=menu.jsp','','show');

f.add(3,0,'<font color=blue>知识库管理</font>');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(3.1,3,'部门知识库','knowdo.do?method=query&path=know_dept_query_admin.jsp','','show');
<% }else{%>
f.add(3.2,3,'部门知识库','knowdo.do?method=query&path=know_dept_query_user.jsp','','show');
<% }%>
f.add(3.3,3,'我的知识库','knowdo.do?method=query&path=know_of_myself.jsp','','show');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(3.4,3,'待审核文件','knowdo.do?method=query&path=know_submit_query.jsp','','show');
f.add(3.5,3,'待转换文件','know_need_convert_to_swf.jsp','','show');
<% }%>

f.add(4,0,'<font color=blue>案例库管理</font>');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(4.1,4,'部门案例库','casedo.do?method=query&path=case_dept_query_admin.jsp','','show');
<% }else{%>
f.add(4.2,4,'部门案例库','casedo.do?method=query&path=case_dept_query_user.jsp','','show');
<% }%>
f.add(4.3,4,'我的案例库','casedo.do?method=query&path=case_of_myself.jsp','','show');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(4.4,4,'待审核文件','casedo.do?method=query&path=case_submit_query.jsp','','show');
f.add(4.5,4,'待转换文件','case_need_convert_to_swf.jsp','','show');
<% }%>

f.add(5,0,'<font color=blue>设备管理</font>');
f.add(5.1,5,'实验室设备管理','computerdo.do?method=query&path=menu.jsp','','show');

f.add(9,0,'<font color=blue>统计分析</font>');
f.add(9.1,9,'缺陷统计分析','defect_chart.jsp','','show');
f.add(9.2,9,'缺陷数据维护','defectdo.do?method=query&path=menu.jsp','','show');
f.add(9.3,9,'产品信息维护','productdo.do?method=query','','show');

<% if(Tool.isSuperadmin(request)){ %>
f.add(6,0,'<font color=blue>系统管理</font>');
f.add(6.1,6,'用户信息维护','userdo.do?method=query&path=menu.jsp','','show');
f.add(6.2,6,'冗余数据检查','system_data_check.jsp','','show');
f.add(6.3,6,'查看系统日志','system_log_view.jsp','','show');
f.add(6.4,6,'在线审计','auditdo.do?method=query','','show');
<% }%>

f.add(7,0,'<font color=blue>辅助功能</font>');
f.add(7.4,7,'查看在线用户','showOnLineUsers.jsp','','show');
f.add(7.5,7,'修改密码','changePassword.jsp','','show');
f.add(7.6,7,'切换皮肤','change_skin.jsp','','show');

f.add(10,0,'实用小工具','tool.jsp','','show');
document.write(f);
</script>
</div>
</fieldset>	
	</body>
</html>
