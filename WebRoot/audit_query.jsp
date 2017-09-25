<%
	//�����жϸ��û��Ƿ��ѵ�¼
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//������ǳ�������Ա������Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	
	if(!isSuperadmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.List"%>

<%@page import="cn.sdfi.audit.bean.Audit"%><html>
<head>
<TITLE>�������</TITLE>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" type="text/javascript" src="js/ShowCalendar.js"></script>
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">

//ִ�в�ѯ����ǰ��У��
function query() {
		var pageSize;
		var radios = document.getElementsByName("pageSize");
		for ( var i = 0; i < radios.length; i++) {
			if (radios[i].checked==true) {
				pageSize = radios[i].value;
				break;
			}
		}
		document.formQuery.action = "auditdo.do?method=query&pageSize="+pageSize;
		document.formQuery.submit();
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
//ִ��ɾ������
function del() {
	var obj = document.getElementsByName("pk");

	if (obj != null) {
		var count = 0;
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count < 1) {
			$("tips").innerHTML = "<font color='red'>��ѡ��Ҫɾ���ļ�¼��</font>";
			return;
		}
		if (confirm('ȷ��ɾ��ѡ�м�¼����ѡ��¼ɾ���󽫲��ָܻ���')) {
			document.form2.action = "auditdo.do?method=delete";
			document.form2.submit();
		}
	}
}
//ִ��ɾ������
function delAll() {
		if (confirm('ȷ�������Ʊ��ò������ָܻ���')) {
			document.form2.action = "auditdo.do?method=deleteAll";
			document.form2.submit();
		}
}
</script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin")%>" >
	<span id="tips"></span>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
			�������
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="ɾ��ѡ�м�¼" onclick="del()"> 
	<input type="button" class="btbox" value="�����Ʊ�" onclick="delAll()"> 
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action="auditdo.do?method=query"  method="post">
		<fieldset>
			<legend>��ѯ����</legend>
	<%
		Audit query_condition = (Audit) request.getAttribute("query_condition");
	%>
		<table align="center" cellpadding="1" cellspacing="1" border="0">
			<tr>
				<td colspan="2">
						ʱ��	<input name="accessTimeBegin" type="text" id="accessTimeBegin" readonly="readonly" value="<%=query_condition.getAccessTimeBegin() %>" onfocus="showDateTime()"/>
						<input type="button" class="btbox" value="-��-" onclick="clear_condition($('accessTimeBegin'))">
						&nbsp;&nbsp;&nbsp;&nbsp;������&nbsp;&nbsp;&nbsp;&nbsp;
						<input name="accessTimeEnd" type="text" id="accessTimeEnd" readonly="readonly" value="<%=query_condition.getAccessTimeEnd() %>" onfocus="showDateTime()"/>
						<input type="button" class="btbox" value="-��-" onclick="clear_condition($('accessTimeEnd'))">
						<input type="hidden" name="sort"  value="<%=query_condition.getSort()%>">
						<input type="hidden" name="sortType"  value="<%=query_condition.getSortType()%>">
				</td>			
			</tr>
			<tr>
				<td  nowrap="nowrap" >
				�û�&nbsp;&nbsp;<input type="text" name="username" size="20" maxlength="50"	value="<%=query_condition.getUsername() == null ? "" : query_condition.getUsername()%>"  ondblclick="clear_condition(this)">
				</td>
				<td  nowrap="nowrap" align="right">
				URL<input type="text" name="url" size="35" maxlength="50"	value="<%=query_condition.getUrl() == null ? "" : query_condition.getUrl()%>"  ondblclick="clear_condition(this)"></td>	
				<td colspan="1" align="right">
				&nbsp;&nbsp;<input type="button" onclick="query()" class="btbox" value="��ѯ" ></td>
			</tr>
		</table>
		</fieldset>
			</form>
			</td></tr>
			<tr><td >
			<form name="form2" method="post">	
			<fieldset>
		<legend>
					ÿҳ��ʾ��¼��
					<input type="radio"  name="pageSize" value="8" <%=query_condition.getPageSize() == 8 ? "checked='checked'":""%> onclick="query()">8
					<input type="radio"  name="pageSize" value="10" <%=query_condition.getPageSize() == 10 ? "checked='checked'":""%> onclick="query()">10
					<input type="radio"  name="pageSize" value="15" <%=query_condition.getPageSize() == 15 ? "checked='checked'":""%> onclick="query()">15
					<input type="radio"  name="pageSize" value="20" <%=query_condition.getPageSize() == 20 ? "checked='checked'":""%> onclick="query()">20
		</legend>					
				<%
					List<Audit> list = (List<Audit>) request.getAttribute("audit_query_result");
				%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%"  >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th>&nbsp;</th>
						<th align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th id="accessTime" nowrap="nowrap"   onclick="sort(this)"><a style="CURSOR:hand">ʱ��<span id='accessTime_gif'></span></a></th>
						<th id="username" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">�û�<span id='username_gif'></span></a></th>
						<th id="ip" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">IP<span id='ip_gif'></span></a></th>
						<th id="URL" onclick="sort(this)" ><a style="CURSOR:hand">URL<span id='URL_gif'></span></a></th>
					</tr>
					<%
						Audit view = null;
						for (int i = 0; i < list.size(); i++) {
							view = (Audit) list.get(i);
					%>
					<tr id="line<%=i%>" >
					<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=view.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getAccessTime()%>	
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<%
						if(view.getUsername()==null||"".equals(view.getUsername())||"null".equals(view.getUsername())){
						%>	
						&nbsp;
						<%} else{%>
						<%=view.getUsername() %>
						<%}%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<%
						if(view.getIp()==null||"".equals(view.getIp())||"null".equals(view.getIp())){
						%>	
						&nbsp;
						<%} else{%>
						<%=view.getIp() %>
						<%}%>
						</td>
						<td id="<%=i%>">	
							<textarea  
								rows="1" cols="70" 
								readonly="readonly" 
								onfocus="this.rows=6;" 
								onblur="this.rows=1;"
								style="color:blue;background-color:#DFE8F6;font-family:Arial"><%=view.getUrl() %></textarea>	
						</td>
					</tr>

					<%
						}
						//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
						if (list.size() < query_condition.getPageSize()) {
							for (int k = 0; k < query_condition.getPageSize() - list.size(); k++) {
					%>
						<tr>
						<td align="center"><%=k + list.size() + 1%></td>
						<td><input type="checkbox" disabled="disabled"></td>
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
			</td></tr>
			<tr><td align="center">
			<!-- �˴�form�������д method="post" ��������� -->
			<form name="public_info" action="auditdo.do?method=query" method="post" >
					<input type="hidden" name="sort" value="<%=query_condition.getSort()%>">
					<input type="hidden" name="sortType" value="<%=query_condition.getSortType()%>">
					<input type="hidden" name="accessTimeBegin" value="<%=query_condition.getAccessTimeBegin()%>">
					<input type="hidden" name="accessTimeEnd" value="<%=query_condition.getAccessTimeEnd()%>">
					<input type="hidden" name="username" value="<%=query_condition.getUsername()%>">
					<input type="hidden" name="url" value="<%=query_condition.getUrl()%>">
					<input type="hidden" name="currentPage" value="<%=query_condition.getShowPage()%>">
					<input type="hidden" name="pageSize" value="<%=query_condition.getPageSize()%>">
					<input type="hidden" name="view" value="">
					<input type="hidden" name="showPage" value="">
			
		<font size=2> ����[<font color="red"><%=query_condition.getPageCount()%>
		</font>]ҳ��ÿҳ��ʾ[<font color="red"><%=query_condition.getPageSize()%></font>]����¼, ����[<font color="red"><%=query_condition.getRecordCount()%>
		</font>]����¼����ǰ��ʾ��[<font color="red"><%=query_condition.getShowPage()%>
		</font>]ҳ
		<br>
		<a href="#" onclick="submit_public_info_form(this)" id="1">��һҳ</a>
		<a href="#" onclick="submit_public_info_form(this)" id="2">��һҳ</a>
		<a href="#" onclick="submit_public_info_form(this)" id="3">��һҳ</a>
		<a href="#" onclick="submit_public_info_form(this)" id="4">���һҳ</a>&nbsp;&nbsp;
		<input type="text" size="3" maxlength="6" name="temp" value="<%=query_condition.getShowPage()%>"> 
		<input type="hidden" id="pageCount" name="pageCount" value="<%=query_condition.getPageCount()%>"> 
		<input type="button" value="Go" onclick="checkPageNumber()"> </font>
		</form>
		</td></tr>
		</table>
		<script type="text/javascript">
			document.getElementById("<%=query_condition.getSort()%>_gif").innerHTML="<img src='images/<%=query_condition.getSortType()%>.gif' align='middle'>";  
		</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />			