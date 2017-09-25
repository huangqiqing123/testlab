<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//��������ĵ�����Ա/��������Ա/���ܲ���������Ȩ�����ҳ�档
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
		<title>��Ŀ��Ϣ����ҳ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
function  check()
{
	//�����ʵ������Ŀ���������Ŀ�������У��
	if($('isLabProject').value=="1"){
		if(addForm.code.value == "") {
			alert("��������Ŀ��ţ�");
			addForm.code.focus();
			return false;
		}else if (checklength('code')!=12||($('code').value.substring(0,5)!="ISTL-")){
			alert("��Ŀ��Ÿ�ʽ����ȷ���밴�ձ�Ź�����б�ţ���2010��ȵ�һ��ʵ������Ŀ����ǣ�ISTL-P201001 ��");
			addForm.code.focus();
			return false;
		} else if(!isExist('code')){
			alert("����Ŀ����Ѵ��ڣ����������룡");
			addForm.code.focus();
			return false;
		} 
	}
	//�����Ƿ�ʵ������Ŀ�����涼Ҫ����У��
		if (addForm.state.value == "") {
			alert("��ѡ����Ŀ��ǰ״̬��");
			addForm.state.focus();
			return false;
		}else if (addForm.project_customer.value == "") {
			alert("��ѡ��ͻ���");
			addForm.project_customer.focus();
			return false;
		} else if (addForm.project_type.value == "") {
			alert("��ѡ����Ŀ���ͣ�");
			addForm.project_type.focus();
			return false;
		}else if (addForm.name.value == "") {
			alert("��������Ŀ���ƣ�");
			addForm.name.focus();
			return false;
		} else if (addForm.devmanager.value == "") {
			alert("������ͻ������ˣ�");
			addForm.devmanager.focus();
			return false;
		} else if (addForm.testmanager.value == "") {
			alert("��������Ը����ˣ�");
			addForm.testmanager.focus();
			return false;
		} else if (addForm.begintime.value == "") {
			alert("��ѡ����Ŀ��ʼʱ�䣡");
			addForm.begintime.focus();
			return false;
		} else if (addForm.year.value == "") {
			alert("��ѡ����Ŀ������ȣ�");
			addForm.year.focus();
			return false;
		}else if (!checktesterlength('tester')) {
			return false;
		} else {
			return true;
		}
	}

//�������id
function isExist(which) {
	//����Ajax���󵽷���������֤��Ŀ����Ƿ��Ѵ���
	var req = getXmlHttpObject();
	var isAvailable = false;
	var value = $(which).value;
	var url = "projectdo.do?method=isExist&value="+value;	
	req.onreadystatechange = function(){
		if (req.readyState == 4) {
			if (req.status == 200) {		
				var msg = req.responseText;
				if(msg=="1"){//"1"��ʾ����Ŀ����Ѿ���ʹ��
					isAvailable=false;
				}else if(msg=="0"){
					isAvailable=true;
				}else{
					alert("��������ֵ�����쳣��");
				}		
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return isAvailable ;
}
//����XMLHttpRequest����
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
	//��������Ա����
	function checktesterlength(id){
		var length = checklength(id);
		if(length>100){
			alert("������Ա�ı���������볤��Ϊ100���ַ���ÿ������ռ2���ַ�������ǰ�������ַ��� "+length+" !");
			$("tester").focus();
			return false;
		}
		return true;
	}
	//ִ�б���
	function save() {
		if(check()&&checkmemolength('memo')){
			document.addForm.action = "projectdo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//ִ�б��沢����
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
				if(isLabProject){out.print("ʵ������Ŀ��Ϣ����");}
				else{out.print("��ʵ������Ŀ��Ϣ����");}
				%>
			</h2>
			<div align="right">	
			<input type="button" class="btbox" value="����" onclick="save()" >
			<input type="button" class="btbox" value="���沢����" onclick="goOn()"  >
			<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
			<% if(isLabProject){ %>
			<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp'">
			<% }else{ %>
			<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='projectdo.do?method=query&isLabProject=0&path=project_query.jsp'">
			<% } %>
		</div>
			<hr>
			<form action="projectdo.do?method=add" name="addForm" method="post">
				
				<!-- �Ƿ�ʵ������Ŀ������ -->
				<input type="hidden" name="isLabProject" value="<%=isLabProject?1:0 %>">								
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
					<tr>
						<td align="right" nowrap="nowrap">
							��Ŀ��ǰ״̬:
						</td>
						<td>
				<select name="state" size="1">
				<option value="" />---��ѡ��---
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
							�ͻ�����:
						</td>
						<td>
				<select name="project_customer" size="1">
				<option value="" />---��ѡ��---
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
					<td align="right" nowrap="nowrap">��Ŀ���:</td>
					<td>
				<!-- ��Ŀ�����ʱ�������ܡ����ܡ�������飬���������𣬿���ֱ����ö���ļ������ü���  -->
				<select name="project_type" size="1">
				<option value="" />---��ѡ��---
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
							��Ŀ���:
						</td>
						<td nowrap="nowrap">
							<input type="text" id="code" name="code" value="<%=isLabProject?"ISTL-P":"" %>" size="20" maxlength="12" >
							<font color="red">*&nbsp;
							<%
							if(isLabProject){
								out.print("ʵ������Ŀ��ţ�ISTL-P������2010��ȵ�һ��ʵ������Ŀ����ǣ�ISTL-P201001");
							}
							%>
							</font>
						</td>
					</tr>
					<% } %>
					<tr>
						<td align="right" nowrap="nowrap">
							��Ŀ����:
						</td>
						<td>
							<input type="text" name="name" value="" size="60" maxlength="30">
							<font color="red">*</font>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							��Ŀ����:
						</td>
						<td>
							<input type="text" name="devmanager" value="" size="60" maxlength="10">
							<font color="red">*</font>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							���Ծ���:
						</td>
						<td>
							<input type="text" name="testmanager" value="" size="60" maxlength="10">
							<font color="red">*</font>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							������Ա:
						</td>
						<td>
							<textarea id="tester" name="tester" rows="2" cols="60"></textarea>

							</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							���:
						</td>
						<td>
						<% int currentYear = Integer.parseInt(Tool.getCurrentYear()); %>
						<select name="year" title="��ѡ�����" size="1">
						<option value="">---��ѡ��---
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
							��Ŀ��ʼʱ��:
						</td>
						<td>
						<input name="begintime" type="text" id="begintime" readonly="readonly" value="" onfocus="showDate()"/>
						<input type="button" class="btbox" value="-��-" onclick="clear_condition($('begintime'))">
						<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							��Ŀ����ʱ��:
						</td>
						<td>
						<input name="endtime" type="text" id="endtime" readonly="readonly" value="" onfocus="showDate()" />	
						<input type="button" class="btbox" value="-��-" onclick="clear_condition($('endtime'))">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							˵��:
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