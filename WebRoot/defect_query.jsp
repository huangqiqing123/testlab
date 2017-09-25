<%
if (Tool.isNotLogin(request)) {
	request.getRequestDispatcher("no_login.jsp").forward(request,response);
	return;
}
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isFunctionManager = Tool.isFunctionManager(request);
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.List"%>

<%@page import="cn.sdfi.defect.bean.ChartDefect"%>
<%@page import="cn.sdfi.product.dao.ProductDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
<head>
<TITLE>ȱ��ͳ�Ʒ���</TITLE>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" type="text/javascript" src="js/ShowCalendar.js"></script>
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">

//����У��
function incompatible(thisObj,theOtherObjId){
	if(thisObj.value!=""){
		$(theOtherObjId).value="";
	}
	query();
} 
//ִ�в�ѯ����ǰ��У��
function query() {
	if($("chart_project").value != "" && $("project_customer").value != "") {
		$("tips").innerHTML = "<font color='red'>��Ŀ�Ͳ��Ų���ͬʱѡ��</font>";
		return false;
	}else if($("year_begin").value==""&&$("month_begin").value!=""){
		$("tips").innerHTML = "<font color='red'>��ѡ����ʼ��ݣ�</font>";
		return false;
	}else if($("month_begin").value==""&&$("year_begin").value!=""){
		$("tips").innerHTML = "<font color='red'>��ѡ����ʼ�·ݣ�</font>";
		return false;
	}else if($("year_end").value==""&&$("month_end").value!=""){
		$("tips").innerHTML = "<font color='red'>��ѡ����ֹ��ݣ�</font>";
		return false;
	}else if($("month_end").value==""&&$("year_end").value!=""){
		$("tips").innerHTML = "<font color='red'>��ѡ����ֹ�·ݣ�</font>";
		return false;
	}else {
		var pageSize;
		var radios = document.getElementsByName("pageSize");
		for ( var i = 0; i < radios.length; i++) {
			if (radios[i].checked==true) {
				pageSize = radios[i].value;
				break;
			}
		}
		$("yearMonth_begin").value = $("year_begin").value + $("month_begin").value;
		$("yearMonth_end").value = $("year_end").value + $("month_end").value;
		document.formQuery.action = "defectdo.do?method=query&pageSize="+pageSize;
		document.formQuery.submit();
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
			document.form2.action = "defectdo.do?method=delete";
			document.form2.submit();
		}
	}
}
//ִ�в�ѯ��ϸ
function detail() {
	var obj = document.getElementsByName("pk");

	if (obj != null) {
		var count = 0;
		for (i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count != 1) {
			$("tips").innerHTML = "<font color='red'>��ѡ��һ����¼��</font>";
			return;
		}
		document.form2.action = "defectdo.do?method=detail";
		document.form2.submit();
	}
}
//�����޸�ҳ��
function update() {
	var obj = document.getElementsByName("pk");
	if (obj != null) {
		var count = 0;
		for (i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count != 1) {
			$("tips").innerHTML = "<font color='red'>��ѡ��һ����¼��</font>";
			return;
		}

		document.form2.action = "defectdo.do?method=forupdate";
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
			ȱ������ά��
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="����" onClick="window.location.href='defect_add.jsp'" 
	<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
	%>>
	<input type="button" class="btbox" value="�޸�" onclick="update()"
	<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
	%>>
	<input type="button" class="btbox" value="ɾ��" onclick="del()"
	<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
	%>> 
	<input type="button" class="btbox" value="��ϸ" onclick="detail()" >
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action="defectdo.do?method=query"  method="post">
		<fieldset>
			<legend>��ѯ����</legend>
<%
	ChartDefect query_condition = (ChartDefect) request.getAttribute("query_condition");
%>
		<table align="center" cellpadding="1" cellspacing="1" border="0">
			<tr>
				<td colspan="2">
						<%
							//��ʽ��201002
							String year_begin = null;
							String month_begin = null;
							if(query_condition.getYearMonth_begin()!=0){
								year_begin = (query_condition.getYearMonth_begin() + "").substring(0, 4).trim();
								month_begin = (query_condition.getYearMonth_begin()	+ "").substring(4).trim();
							if (month_begin.startsWith("0")) {
								month_begin = month_begin.substring(1);
							}
							}
						%>
						ʱ��	<select id="year_begin" name="year_begin"  size="1" onchange="query()">
						<option value="">---��---
						<%
							for (int i = 2010; i < 2021; i++) {
						%>
						<option value="<%=i%>" <%if ((i + "").equals(year_begin))
					out.print("selected=\"selected\"");%>><%=i%>
						<%
							}
						%>
						</select>
						��
						<select id="month_begin" name="month_begin"  size="1" onchange="query()">
						<option value="">---��---
						<%
							for (int i = 1; i <= 12; i++) {
						%>
						<option value="<%=i < 10 ? "0" + i : i%>" <%if ((i + "").equals(month_begin))
					out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
						<%
							}
						%>
						</select>
						��						
						<input type="hidden" id="yearMonth_begin" name="yearMonth_begin" value="" >
						&nbsp;&nbsp;&nbsp;&nbsp;������&nbsp;&nbsp;&nbsp;&nbsp;
						<%
						//��ʽ��201002
						String year_end = null;
						String month_end = null;
							if(query_condition.getYearMonth_end()!=0){
								year_end = (query_condition.getYearMonth_end() + "").substring(0, 4).trim();
								month_end = (query_condition.getYearMonth_end() + "").substring(4).trim();
								if (month_end.startsWith("0")) {
									month_end = month_end.substring(1);
								}
							}
						%>			
						<select id="year_end" name="year_end"  size="1" onchange="query()">
						<option value="">---��---
						<%
							for (int i = 2010; i < 2021; i++) {
						%>
						<option value="<%=i%>" <%if ((i + "").equals(year_end))
					out.print("selected=\"selected\"");%>><%=i%>
						<%
							}
						%>
						</select>
						��
						<select id="month_end" name="month_end"  size="1" onchange="query()">
						<option value="">---��---
						<%
							for (int i = 1; i <= 12; i++) {
						%>
						<option value="<%=i < 10 ? "0" + i : i%>" <%if ((i + "").equals(month_end))
					out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
						<%
							}
						%>
						</select>
						��						
						<input type="hidden" id="yearMonth_end" name="yearMonth_end" value="" >				
				</td>
				
			</tr>
			<tr>
				<td>��Ŀ
				<%
					ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
					Map<String, String> chart_projects = productDao.queryAll();
				%>
				<select id="chart_project" name="chart_project" size="1" onchange="incompatible(this,'project_customer')">
				<option value="" />---��ѡ��---
				<%
					for (Map.Entry<String, String> entry : chart_projects.entrySet()) {
				%>
				<option value="<%=entry.getKey()%>" 
				<%if (entry.getKey().equals(query_condition.getChart_project())) {
					out.print("selected=\"selected\"");
				}%>
				/>
				<%=entry.getValue()%>
				<%
					}
				%>
				</select>
				<!-- �����򣬵����������ʱ�� -->
				<input type="hidden" name="sort"  value="<%=query_condition.getSort()%>">
				<input type="hidden" name="sortType"  value="<%=query_condition.getSortType()%>">
				</td>
				<td align="right">��������
				<%
					Map<String, String> project_customers = Const.getEnumMap().get("project_customer");
				%>
				<select id="project_customer" name="project_customer" size="1" onchange="incompatible(this,'chart_project')">
				<option value="" />---��ѡ��---
				<%
					for (Map.Entry<String, String> entry : project_customers.entrySet()) {
				%>
				<option value="<%=entry.getKey()%>" 
				<%if (entry.getKey().equals(query_condition.getProject_customer())) {
					out.print("selected=\"selected\"");
				}%>
				/>
				<%=entry.getValue()%>
				<%
					}
				%>
				</select>
				</td>
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
					List<ChartDefect> list = (List<ChartDefect>) request.getAttribute("defect_query_result");
				%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th>&nbsp;</th>
						<th><input  type="checkbox"  onclick="selectAll(this)"></th>
						<th id="yearMonth" nowrap="nowrap"   onclick="sort(this)"><a style="CURSOR:hand">�·�<span id='yearMonth_gif'></span></a></th>
						<th id="chart_project" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">��Ŀ<span id='chart_project_gif'></span></a></th>
						<th id="project_customer" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">��������<span id='project_customer_gif'></span></a></th>
						<th id="packageNumber" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">����<span id='packageNumber_gif'></span></a></th>
						<th id="defectNumber" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">��ȱ����<span id='defectNumber_gif'></span></a></th>
						<th id="totalDefectWeight"  onclick="sort(this)" ><a style="CURSOR:hand">��ȱ�ݼ�Ȩ<span id='totalDefectWeight_gif'></span></a></th>
						<th id="reopenNumber" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">reopen����<span id='reopenNumber_gif'></span></a></th>
						<th id="seriousDefectNumber" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">����ȱ����<span id='seriousDefectNumber_gif'></span></a></th>
						<th id="totalSeriousDefectWeight"  onclick="sort(this)" ><a style="CURSOR:hand">����ȱ�ݼ�Ȩ<span id='totalSeriousDefectWeight_gif'></span></a></th>
						<th id="totalProcessTime"  onclick="sort(this)" ><a style="CURSOR:hand">�ܴ���ʱ��<span id='totalProcessTime_gif'></span></a></th>
					</tr>
					<%
						ChartDefect view = null;
						for (int i = 0; i < list.size(); i++) {
							view = (ChartDefect) list.get(i);
					%>
					<tr id="line<%=i%>" >
					<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=view.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<a href="defectdo.do?method=detail&pk=<%=view.getPk()%>" >
							<%=view.getYearMonth()%>
						</a>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">				
							<%=chart_projects.get(view.getChart_project())%>	
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">				
							<%=project_customers.get(view.getProject_customer())%>	
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getPackageNumber()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getDefectNumber()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getTotalDefectWeight()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getReopenNumber()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getSeriousDefectNumber()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getTotalSeriousDefectWeight()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getTotalProcessTime()%>
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
			<form name="public_info" action="defectdo.do?method=query" method="post" >
					<input type="hidden" name="sort" value=<%=query_condition.getSort()%>>
					<input type="hidden" name="sortType" value=<%=query_condition.getSortType()%>>
					<input type="hidden" name="chart_project" value=<%=query_condition.getChart_project()%>>
					<input type="hidden" name="project_customer" value=<%=query_condition.getProject_customer()%>>
					<input type="hidden" name="yearMonth_begin" value=<%=query_condition.getYearMonth_begin()%>>
					<input type="hidden" name="yearMonth_end" value=<%=query_condition.getYearMonth_end()%>>
					<input type="hidden" name="currentPage" value=<%=query_condition.getShowPage()%>>
					<input type="hidden" name="pageSize" value=<%=query_condition.getPageSize()%>>
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