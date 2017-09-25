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
		<title>�������б�</title>
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
			day = "��";
		} else if (day == 1) {
			day = "һ";
		} else if (day == 2) {
			day = "��";
		} else if (day == 3) {
			day = "��";
		} else if (day == 4) {
			day = "��";
		} else if (day == 5) {
			day = "��";
		} else {
			day = "��";
		}
		var dateValue = year + "��" + month + "��" + date + "�� ����" + day + " ";
		document.getElementById('date').innerHTML = dateValue;
	}
	function setStatus(){
		window.status="<%=session.getAttribute("username")%>����ã���ӭ������³�������ʵ�����ĵ�����ϵͳ��";
		}
</SCRIPT>
<script for="window" event="onbeforeunload"> 
//�رմ��ڣ���ִ��ע����
    if(document.body.clientWidth-event.clientX< 170&&event.clientY< 0||event.altKey){
		 	window.location.href='userdo.do?method=logout&path=closeIE';alert('ллʹ�ã�');
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
			<font size='2'>��ǰ�û�</font>[<font size=2 color="red"><%=session.getAttribute("username")%></font> ]
		</fieldset>
		<fieldset style="height:30">
			[<font size='2'><a href="userdo.do?method=logout" target="_parent">��ȫ�˳�</a></font>]
		</fieldset>
		</td>
	</tr>
	</table><br>
<fieldset>
<legend align="center">
<a href="javascript: f.openAll();"><font color=blue><u>չ��</u></font></a>
&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="javascript: f.closeAll();"><font color=blue><u>����</u></font></a>
</legend>
<div class="dtree">
<script type="text/javascript">
var f = new dTree('f');

f.add(0,-1,'');//���ڵ�

f.add(1,0,'<font color=blue>��Ŀ����</font>');//(�ڵ�id���ϼ��ڵ�id����ʾ���ơ���ת��url����ʾ��Ϣtitle��target���ϲ�ʱͼ��,չ��ʽͼ��, true/falseĬ���Ƿ�չ����ǰ�ڵ�)
f.add(1.1,1,'ʵ������Ŀ����','projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp','','show');
f.add(1.2,1,'��ʵ������Ŀ����','projectdo.do?method=query&isLabProject=0&path=project_query.jsp','','show');

f.add(2,0,'<font color=blue>�ĵ�����</font>');
f.add(2.1,2,'��������Ϣ����','filecoverdo.do?method=query&path=menu.jsp','','show');
f.add(2.2,2,'�ļ���Ϣ����','filecovercontentdo.do?method=query','','show');
f.add(2.3,2,'�ܿ��ļ�����','systemfiledo.do?method=query&path=menu.jsp','','show');

f.add(3,0,'<font color=blue>֪ʶ�����</font>');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(3.1,3,'����֪ʶ��','knowdo.do?method=query&path=know_dept_query_admin.jsp','','show');
<% }else{%>
f.add(3.2,3,'����֪ʶ��','knowdo.do?method=query&path=know_dept_query_user.jsp','','show');
<% }%>
f.add(3.3,3,'�ҵ�֪ʶ��','knowdo.do?method=query&path=know_of_myself.jsp','','show');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(3.4,3,'������ļ�','knowdo.do?method=query&path=know_submit_query.jsp','','show');
f.add(3.5,3,'��ת���ļ�','know_need_convert_to_swf.jsp','','show');
<% }%>

f.add(4,0,'<font color=blue>���������</font>');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(4.1,4,'���Ű�����','casedo.do?method=query&path=case_dept_query_admin.jsp','','show');
<% }else{%>
f.add(4.2,4,'���Ű�����','casedo.do?method=query&path=case_dept_query_user.jsp','','show');
<% }%>
f.add(4.3,4,'�ҵİ�����','casedo.do?method=query&path=case_of_myself.jsp','','show');
<% if(Tool.isSuperadmin(request)||Tool.isDocmentAdmin(request)){ %>
f.add(4.4,4,'������ļ�','casedo.do?method=query&path=case_submit_query.jsp','','show');
f.add(4.5,4,'��ת���ļ�','case_need_convert_to_swf.jsp','','show');
<% }%>

f.add(5,0,'<font color=blue>�豸����</font>');
f.add(5.1,5,'ʵ�����豸����','computerdo.do?method=query&path=menu.jsp','','show');

f.add(9,0,'<font color=blue>ͳ�Ʒ���</font>');
f.add(9.1,9,'ȱ��ͳ�Ʒ���','defect_chart.jsp','','show');
f.add(9.2,9,'ȱ������ά��','defectdo.do?method=query&path=menu.jsp','','show');
f.add(9.3,9,'��Ʒ��Ϣά��','productdo.do?method=query','','show');

<% if(Tool.isSuperadmin(request)){ %>
f.add(6,0,'<font color=blue>ϵͳ����</font>');
f.add(6.1,6,'�û���Ϣά��','userdo.do?method=query&path=menu.jsp','','show');
f.add(6.2,6,'�������ݼ��','system_data_check.jsp','','show');
f.add(6.3,6,'�鿴ϵͳ��־','system_log_view.jsp','','show');
f.add(6.4,6,'�������','auditdo.do?method=query','','show');
<% }%>

f.add(7,0,'<font color=blue>��������</font>');
f.add(7.4,7,'�鿴�����û�','showOnLineUsers.jsp','','show');
f.add(7.5,7,'�޸�����','changePassword.jsp','','show');
f.add(7.6,7,'�л�Ƥ��','change_skin.jsp','','show');

f.add(10,0,'ʵ��С����','tool.jsp','','show');
document.write(f);
</script>
</div>
</fieldset>	
	</body>
</html>
