<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="java.util.Iterator"%>
<jsp:directive.page import="java.util.ArrayList"/>
<jsp:directive.page import="java.util.List"/>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.systemfile.bean.SystemFile"%><html>
	<head>
		<title>�ܿ��ļ�����</title>
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
			document.form2.action = "systemfiledo.do?method=detail";
			document.form2.submit();
		}
	}
	// ִ�и��²���
	function update() {
		var obj = document.getElementsByName("pk");
		// ����ʱ,��ѡ��ļ�¼������У��
		if (obj != null) {
			var count = checkedNumber(obj);	
			
			if (count != 1) {
				alert("��ѡ��һ����¼!!");
				return;
			}

			document.form2.action = "systemfile_update.jsp";
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
			if (confirm('ȷ��ɾ��ѡ�м�¼��')) {
				document.form2.action = "systemfiledo.do?method=delete";
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
	//����Excel
	function exportExcel() { 
		document.formQuery.action = "systemfiledo.do?method=query&action=exportExcel"
		document.formQuery.submit();
		document.formQuery.action="systemfiledo.do?method=query";
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
		document.formQuery.action="systemfiledo.do?method=query&pageSize="+pageSize;
		document.formQuery.submit();
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body  background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" >
	<tr>
	<td>
			<h2 align="center">
				�ܿ��ļ�����
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="����" onClick="window.location.href='systemfile_add.jsp'" 
	<%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="�޸�" onclick="update()" <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%> >
	<input type="button" class="btbox" value="ɾ��" onclick="del()"  <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="��ϸ" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
			<form name="formQuery" action="systemfiledo.do?method=query" method="post">
			<fieldset><legend>��ѯ����</legend>
			<%
			//��ѯ����
			SystemFile query_condition = (SystemFile)request.getAttribute("query_condition");
			String sort=query_condition.getSort();
			String sortType=query_condition.getSortType();
			String code=query_condition.getCode();
			String name=query_condition.getName();
			String state=query_condition.getState();
			String controlled_number=query_condition.getControlledNumber();
			int pageSize = query_condition.getPageSize();
			
			%>
				<table align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td nowrap="nowrap" >�ļ����
							<input type="text" name="code"  size="20" maxlength="32" value="<%=code==null?"":code %>"  ondblclick="clear_condition(this)">
							<input type="hidden" name="sort"  value="<%=sort==null?"code":sort %>">
							<input type="hidden" name="sortType"  value="<%=sortType==null?"ASC":sortType %>">
						</td>
					
						<td nowrap="nowrap">�ļ�����
						<input type="text" name="name"   size="20" maxlength="50" value="<%=name==null?"":name %>"  ondblclick="clear_condition(this)">
						</td>
						<td></td>
						</tr>
					<tr>
						<td nowrap="nowrap">&nbsp;��&nbsp;��&nbsp;��&nbsp;
						<input type="text" name="controlled_number"   size="20" maxlength="50" value="<%=controlled_number==null?"":controlled_number %>"  ondblclick="clear_condition(this)">
						</td>
						<td nowrap="nowrap">״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬
						<select name="state" title="��ѡ���ļ�״̬" size="1" onchange="query()">
						<option value="" />---��ѡ��---
						<option value="��Ч" 
						<%
						if("��Ч".equals(state)){
							out.print("selected=\"selected\"");
						}
						%>
						/>��Ч
						<option value="�ѷ���" 
						<%
						if("�ѷ���".equals(state)){
							out.print("selected=\"selected\"");
						}
						%>
						/>�ѷ���					
						</select>
						</td>
						<td align="right" nowrap="nowrap">
						<input type="submit" class="btbox" value="��ѯ" >
						<input type="button" class="btbox" value="����Excel" onclick="exportExcel()"  >
						</td>
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
					<input type="radio"  name="pageSize" value="8" <%=pageSize==8?"checked='checked'":"" %> onclick="query()">8
					<input type="radio"  name="pageSize" value="10" <%=pageSize==10?"checked='checked'":"" %> onclick="query()">10
					<input type="radio"  name="pageSize" value="15" <%=pageSize==15?"checked='checked'":"" %> onclick="query()">15
					<input type="radio"  name="pageSize" value="20" <%=pageSize==20?"checked='checked'":"" %> onclick="query()">20
			</legend>	
				<%
					List<SystemFile> list = (List<SystemFile>) request.getAttribute("systemfile_query_result");
				%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th width="100" nowrap="nowrap" onclick="sort(this)" id="code" ><a style="CURSOR:hand">�ļ����<span id='code_gif'></span></a></th>
						<th width="500"  onclick="sort(this)" id="name"><a style="CURSOR:hand">�ļ�����<span id='name_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="pages"><a style="CURSOR:hand">ҳ��<span id='pages_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="version"><a style="CURSOR:hand">�汾<span id='version_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="controlled_number"><a style="CURSOR:hand">�ܿغ�<span id='controlled_number_gif'></span></a></th>
						<th nowrap="nowrap"  onclick="sort(this)" id="state"><a style="CURSOR:hand">״̬<span id='state_gif'></span></a></th>
					</tr>
				<%
					SystemFile systemfile = null;
					for(int i=0;i<list.size();i++){
						systemfile = (SystemFile) list.get(i);
				%>
					
					<tr id="line<%=i %>" >
						<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i+1 %>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=systemfile.getPk() %>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<a href="systemfiledo.do?method=detail&pk=<%=systemfile.getPk()%>">
							<%=systemfile.getCode()%>
						</a>
						</td>
						<td  nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=systemfile.getName()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=systemfile.getPages()%>&nbsp;
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=systemfile.getVersion()%>&nbsp;
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=systemfile.getControlledNumber()%>&nbsp;
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=systemfile.getState()%>&nbsp;
						</td>						
					</tr>

					<%
					}
					//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
					if(list.size()<pageSize){
						for(int k=0;k<pageSize-list.size();k++){
					%>
						<tr>
						<td align="center">
						<%=k+list.size()+1 %>
						</td>
						<td><input type="checkbox" disabled="disabled"></td>
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
			</td></tr>
			<tr><td align="center">
			<!-- �˴�form�������д method="post" ��������� -->
			<form name="public_info" action="systemfiledo.do?method=query" method="post" onsubmit="false">
					<input type="hidden" name="sort" value=<%=sort%>>
					<input type="hidden" name="sortType" value=<%=sortType%>>
					<input type="hidden" name="code" value=<%=code%>>
					<input type="hidden" name="name" value=<%=name%>>
					<input type="hidden" name="controlled_number" value=<%=controlled_number%>>
					<input type="hidden" name="state" value=<%=state%>>
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
		</td></tr>
		</table>
<script type="text/javascript">
document.getElementById("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>";  
</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />