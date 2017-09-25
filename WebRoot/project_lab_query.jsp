<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Iterator"%>
<jsp:directive.page import="java.util.ArrayList" />
<jsp:directive.page import="java.util.List" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.project.bean.Project"%><html>
<head>
<title>ʵ������Ŀ��Ϣ����</title>
<script type="text/javascript">
	
	// ִ�в�ѯ��ϸ
	function detail() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = checkedNumber(obj);
			if (count != 1) {
				alert("��ѡ��һ����¼!");
				return;
			}
			document.form2.action = "projectdo.do?method=detail";
			document.form2.submit();
		}
	}
	function update() {
		var obj = document.getElementsByName("pk");
		// ����ʱ,��ѡ��ļ�¼������У��
		if (obj != null) {
			var count = checkedNumber(obj);
			if (count != 1) {
				alert("��ѡ��һ����¼!");
				return;
			}
			document.form2.action = "project_update.jsp";
			document.form2.submit();
		}
	}
	// ִ��ɾ������
	function del() {
		var obj = document.getElementsByName("pk");

		if (obj != null) {
			var count = checkedNumber(obj);
			if (count < 1) {
				alert("��ѡ��Ҫɾ���ļ�¼!");
				return;
			}
			if (confirm('ȷ��ɾ��ѡ�м�¼����¼ɾ���󽫲��ָܻ���')) {
				document.form2.action = "projectdo.do?method=delete&isLabProject=1";
				document.form2.submit();
			}
		}
	}
	//����б������ʵ��������
	function sort(sourceObject) {
		document.formQuery.sort.value = sourceObject.id;
		if (document.formQuery.sortType.value == "ASC") {
			document.formQuery.sortType.value = "DESC";
		} else {
			document.formQuery.sortType.value = "ASC";
		}
		 query();
	}
	//ִ�в�ѯ
	function query() {
		var pageSize;
		var radios = document.getElementsByName("pageSize");
		for ( var i = 0; i < radios.length; i++) {
			if (radios[i].checked==true) {
				pageSize = radios[i].value;
				break;
			}
		}
		document.formQuery.action = "projectdo.do?method=query&pageSize="+pageSize;
		document.formQuery.submit();
	}
	//����Excel
	function exportExcel() { 
		document.formQuery.action = "projectdo.do?method=query&action=exportExcel"
		document.formQuery.submit();
		document.formQuery.action="projectdo.do?method=query";
	} 
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
</head>
<body  background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td  align="center" >
		<h2 >ʵ������Ŀ��Ϣ����</h2>
		</td>
	</tr>
	<tr>
		<td align="right"><input type="button" class="btbox" value="����"
			onClick="window.location.href='project_add.jsp?path=project_lab_query.jsp'"
			<%
			if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}
			%>>
		<input type="button" class="btbox" value="�޸�" onclick="update()"
			<%
			if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}
			%>>
		<input type="button" class="btbox" value="ɾ��" onclick="del()"
			<%
			if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}
			%>>
		<input type="button" class="btbox" value="��ϸ" onclick="detail()">
		</td>
	</tr>
	<tr>
		<td>
		<form name="formQuery" action="projectdo.do?method=query" method="post">
		<fieldset><legend>��ѯ����</legend>
		<%
			Map<String,String> project_state = Const.getEnumMap().get("project_state");
			Map<String,String> project_types = Const.getEnumMap().get("project_type");	
			Map<String,String> project_customers = Const.getEnumMap().get("project_customer");	
		%>
		<%
			//��ѯ����
			Project query_condition = (Project)request.getAttribute("query_condition");
			String sort = query_condition.getSort();
			String sortType = query_condition.getSortType();
			int pageSize = query_condition.getPageSize();
			String code = query_condition.getCode();
			String name = query_condition.getName();
			String state = query_condition.getState();
			String project_type = query_condition.getProject_type();
			String year = query_condition.getYear();
			String project_customer = query_condition.getProject_customer();
		%>
		<table align="center" cellpadding="1" cellspacing="0">
			<tr>
				<td nowrap="nowrap">��Ŀ���</td>
				<td>
				<input type="hidden" name="sort"  value="<%=sort == null ? "code" : sort%>">
				<input type="hidden" name="sortType"  value="<%=sortType == null ? "ASC" : sortType%>">
				<input type="hidden" name="isLabProject"  value="1"><!--1��ʾʵ������Ŀ  -->
				<input type="hidden" name="path" value="project_lab_query.jsp">
				<input type="text" name="code" size="20" maxlength="32"	value="<%=code == null ? "" : code%>" ondblclick="clear_condition(this)"></td>

				<td nowrap="nowrap">��Ŀ����</td>
				<td><input type="text" name="name" size="20" maxlength="50"	value="<%=name == null ? "" : name%>" ondblclick="clear_condition(this)"></td>

				<td nowrap="nowrap">�ͻ�����</td>
				<td>
				<select name="project_customer" size="1" onchange="query()">
				<option value="" />---��ѡ��---
				<%
				for (Map.Entry<String, String> entry : project_customers.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (project_customer != null&&!"".equals(project_customer)) {
				if (project_customer.toString().trim().equals(entry.getKey())) {
					out.print("selected=\"selected\"");
				}
				}%>
				/>
				<%=entry.getValue()%>
				<%
				}
				%>
				</select>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
			<td nowrap="nowrap">��Ŀ���</td>
				<td>
				<select name="project_type" size="1" onchange="query()">
				<option value="" />---��ѡ��---
				<%
				for (Map.Entry<String, String> entry : project_types.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (project_type != null&&!"".equals(project_type)) {
				if (project_type.toString().trim().equals(entry.getKey())) {
					out.print("selected=\"selected\"");
				}
				}%>
				/>
				<%=entry.getValue()%>
				<%
				}
				%>
				</select>
				</td>
			<td nowrap="nowrap">��Ŀ״̬</td>
				<td>
				<select name="state" size="1" onchange="query()">
				<option value="" />---��ѡ��---
				<%
				for (Map.Entry<String, String> entry : project_state.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (state != null&&!"".equals(state)) {
				if (state.toString().trim().equals(entry.getKey())) {
					out.print("selected=\"selected\"");
				}
				}%>
				/>
				<%=entry.getValue()%>
				<%
				}
				%>
				</select>
				</td>
				<td nowrap="nowrap">���</td>
				<td><select name="year" title="��ѡ�����" size="1" onchange="query()">
					<option value="" />---��ѡ��---
					 <%
						for (int i = 2004; i < 2020; i++) {
					%>
					
					<option value="<%=i%>"
						<%if (year != null) {
					if (year.toString().trim().equals(i + "")) {
						out.print("selected=\"selected\"");
					}
				}%> />
					<%=i%> <%
 	}
 %>
					
				</select></td>
				<td colspan="2" align="right" nowrap="nowrap">
				<input type="submit" value="��ѯ" class="btbox" >
				<input type="button" class="btbox" value="����Excel" onclick="exportExcel()"  >
				</td>
			</tr>
		</table>
		</fieldset>
		</form>
		</td>
	</tr>
	<tr>
		<td>
		<form name="form2" method="post">
		<fieldset>
			<legend>
						ÿҳ��ʾ��¼��
						<input type="radio"  name="pageSize" value="8" <%=pageSize==8?"checked='checked'":"" %> onclick="query()">8
						<input type="radio"  name="pageSize" value="10" <%=pageSize==10?"checked='checked'":"" %> onclick="query()">10
						<input type="radio"  name="pageSize" value="15" <%=pageSize==15?"checked='checked'":"" %> onclick="query()">15
						<input type="radio"  name="pageSize" value="20" <%=pageSize==20?"checked='checked'":"" %> onclick="query()">20
			</legend>	
		<%
			List<Project> list = (List<Project>) request.getAttribute("project_query_result");
		%>
		<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
			<!-- ��ͷ��Ϣ -->
			<tr>
				<th width="25">&nbsp;</th>
				<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
				<th nowrap="nowrap" onclick="sort(this)" id="code"><a style="CURSOR:hand">��Ŀ���<span id='code_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="name"><a style="CURSOR:hand">��Ŀ����<span id='name_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="project_customer"><a style="CURSOR:hand">�ͻ�����<span id='project_customer_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="state"><a style="CURSOR:hand">��Ŀ״̬<span id='state_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="begintime"><a style="CURSOR:hand">��ʼʱ��<span id='begintime_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="endtime"><a style="CURSOR:hand">����ʱ��<span id='endtime_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="project_year"><a style="CURSOR:hand">���<span id='project_year_gif'></span></a></th>
			</tr>
			<%
				Project project = null;
				for (int i = 0; i < list.size(); i++) {
					project = (Project) list.get(i);
			%>

			<tr  id="line<%=i %>" >
				<td align="center" id="<%=i%>" onclick="clickLine(this)" ><%=i + 1%></td>
				<td><input type="checkbox" name="pk" id="checkbox<%=i%>" value="<%=project.getPk()%>" onclick="changeBgColor(this)">
				</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
					<a href="projectdo.do?method=detail&pk=<%=project.getPk()%>"><%=project.getCode()%> </a></td>
				<td  id="<%=i%>" onclick="clickLine(this)"><%=project.getName()%></td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=project_customers.get(project.getProject_customer())%></td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=project_state.get(project.getState())%></td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=project.getBegintime()%></td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=project.getEndtime()%>&nbsp;</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=project.getYear()%></td>
			</tr>

			<%
				}
				//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
				if(list.size()<pageSize){
					for(int k=0;k<pageSize-list.size();k++){
			%>
			<tr>
				<td align="center"><%=k + list.size() + 1%></td>
				<td><input type="checkbox" disabled="disabled"></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<%
				}
				}
			%>

		</table>
		</fieldset>
		</form>
		</td>
	</tr>
	<tr>
		<td align="center"><!-- �˴�form�������д method="post" ��������� -->
		<form name="public_info" action="projectdo.do?method=query"	method="post" onsubmit="false">
		<input type="hidden" name="sort" value=<%=sort%>> 
		<input type="hidden" name="sortType" value=<%=sortType%>> 
		<input type="hidden" name="isLabProject" value="1">
		<input type="hidden" name="path" value="project_lab_query.jsp">
		<input type="hidden" name="code" value=<%=code%>>
		<input type="hidden" name="name" value=<%=name%>>
		<input type="hidden" name="year" value=<%=year%>> 
		<input type="hidden" name="state" value=<%=state%>> 
		<input type="hidden" name="project_type" value=<%=project_type%>> 
		<input type="hidden" name="project_customer" value=<%=project_customer%>>
		<input type="hidden" name="currentPage" value=<%=query_condition.getShowPage()%>>
		<input type="hidden" name="pageSize" value=<%=pageSize%>>
		<input type="hidden" name="view" value=""><!-- �ֶ�����鿴�ڼ�ҳ -->
		<input type="hidden" name="showPage" value=""><!-- �����ҳ -->

		<font size=2> ����[<font color="red"><%=query_condition.getPageCount()%>
		</font>]ҳ��ÿҳ��ʾ[<font color="red"><%=pageSize%></font>]����¼, ����[<font color="red"><%=query_condition.getRecordCount()%>
		</font>]����¼����ǰ��ʾ��[<font color="red"><%=query_condition.getShowPage()%>
		</font>]ҳ
		<br>
		<a href="#" onclick="submit_public_info_form(this)" id="1">��һҳ</a>
		<a href="#" onclick="submit_public_info_form(this)" id="2">��һҳ</a>
		<a href="#" onclick="submit_public_info_form(this)" id="3">��һҳ</a>
		<a href="#" onclick="submit_public_info_form(this)" id="4">���һҳ</a>&nbsp;&nbsp;
		<input type="text" size="3" maxlength="6" name="temp" value="<%=query_condition.getShowPage()%>"> 
		<input type="hidden" id="pageCount" name="pageCount" value="<%=query_condition.getPageCount()%>"> 
		<input type="hidden" id="recordCount" name="recordCount" value="<%=query_condition.getRecordCount()%>"> 
		<input type="button" value="Go" onclick="checkPageNumber()"> </font>
		</form>
		</td>
	</tr>
</table>
<script type="text/javascript">
document.getElementById("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>";  
</script>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />