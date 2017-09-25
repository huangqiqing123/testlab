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

<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.computer.bean.Computer"%><html>
<head>
<title>实验室设备信息管理</title>
<script type="text/javascript">
	
	// 执行查询明细
	function detail() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = checkedNumber(obj);
			if (count != 1) {
				alert("请选择一条记录!");
				return;
			}
			document.form2.action = "computerdo.do?method=detail";
			document.form2.submit();
		}
	}
	function update() {
		var obj = document.getElementsByName("pk");
		// 更新时,对选择的记录数进行校验
		if (obj != null) {
			var count = checkedNumber(obj);
			if (count != 1) {
				alert("请选择一条记录!");
				return;
			}
			document.form2.action = "computer_update.jsp";
			document.form2.submit();
		}
	}
	// 执行删除操作
	function del() {
		var obj = document.getElementsByName("pk");

		if (obj != null) {
			var count = checkedNumber(obj);
			if (count < 1) {
				alert("请选择要删除的记录!");
				return;
			}
			if (confirm('确认删除选中记录？')) {
				document.form2.action = "computerdo.do?method=delete";
				document.form2.submit();
			}
		}
	}
	//点击列标题可以实现排序功能
	function sort(sourceObject) {
		document.formQuery.sort.value = sourceObject.id;
		if (document.formQuery.sortType.value == "ASC") {
			document.formQuery.sortType.value = "DESC";
		} else {
			document.formQuery.sortType.value = "ASC";
		}
		 query();
	}
	//导出Excel
	function exportExcel() { 
		document.formQuery.action = "computerdo.do?method=query&action=exportExcel"
		document.formQuery.submit();
		document.formQuery.action="computerdo.do?method=query";
	} 
	//执行查询
	function query() {
		var pageSize;
		var radios = document.getElementsByName("pageSize");
		for ( var i = 0; i < radios.length; i++) {
			if (radios[i].checked==true) {
				pageSize = radios[i].value;
				break;
			}
		}
		document.formQuery.action = "computerdo.do?method=query&pageSize="+pageSize;
		document.formQuery.submit();
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
</head>
<body  background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		<h2 align="center">实验室设备信息管理</h2>
		</td>
	</tr>
	<tr>
		<td align="right">
		<input type="button" class="btbox" value="增加" onClick="window.location.href='computer_add.jsp'"
			<%
			//如果不是设备管理员，也不是超级管理员，则无权限操作。
			if (!Tool.isComputerAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}%>>
		<input type="button" class="btbox" value="从excel导入" onClick="window.location.href='computer_import.jsp'"  
		<%
		if (!Tool.isComputerAdmin(request)&&!Tool.isSuperadmin(request)) {
			out.print("disabled=\"disabled\" ");
		}
		%>>
		<input type="button" class="btbox" value="修改" onclick="update()" 
			<% 
			if (!Tool.isComputerAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}
			%>>
		<input type="button" class="btbox" value="删除" onclick="del()"
			<% 
			if (!Tool.isComputerAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}
			%>>
		<input type="button" class="btbox" value="明细" onclick="detail()">
		</td>
	</tr>
	<tr>
		<td>
		<form name="formQuery" action="computerdo.do?method=query" method="post">
		<fieldset><legend>查询条件</legend>
		<%
			//查询条件
			Computer query_condition = (Computer)request.getAttribute("query_condition");
			String sort = query_condition.getSort();
			String sortType = query_condition.getSortType();
			int pageSize = query_condition.getPageSize();
			String code = query_condition.getCode();
			String owner = query_condition.getOwner();
			String ip = query_condition.getIp();
			String status = query_condition.getStatus();
			String type =query_condition.getComputer_type();//设备类型（外借设备、实验室设备）
		%>
		<table align="center" cellpadding="1" cellspacing="0" border="0">
			<tr>
				<td nowrap="nowrap">设备编号</td>
				<td>
				<input type="hidden" name="sort"  value="<%=sort == null ? "code" : sort%>">
				<input type="hidden" name="sortType"  value="<%=sortType == null ? "ASC" : sortType%>">
				<input type="text" id="code" name="code" size="20" maxlength="10"	value="<%=code == null ? "" : code%>" ondblclick="clear_condition(this)">
				</td>
				<td nowrap="nowrap">设备IP</td>
				<td>
					<input type="text" id="ip" name="ip" size="20" maxlength="15"	value="<%=ip == null ? "" : ip%>" ondblclick="clear_condition(this)">
				</td>
				<td nowrap="nowrap">领用人</td>
				<td>
					<input type="text" id="owner" name="owner" size="20" maxlength="15"	value="<%=owner == null ? "" : owner%>" ondblclick="clear_condition(this)">
				</td>
			</tr>
			<tr>
				<td nowrap="nowrap">状态</td>
				<td>
				<%
					Map<String,String> computer_status = Const.getEnumMap().get("computer_status");
					
				%>
				<select name="status" size="1" onchange="query()">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : computer_status.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (status != null) {
				if (status.toString().trim().equals(entry.getKey())) {
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
				<td nowrap="nowrap">设备类型</td>
				<td>
				<%
					Map<String,String> computer_type = Const.getEnumMap().get("computer_type");
					
				%>
				<select name="computer_type" size="1" onchange="query()">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : computer_type.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (type != null&&!"".equals(type)) {
				if (type.toString().trim().equals(entry.getKey())) {
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
				<td colspan="2" align="right" nowrap="nowrap">
				<input type="submit" class="btbox" value="查询" >
				<input type="button" class="btbox" value="导出Excel" onclick="exportExcel()"  >
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
					每页显示记录数
					<input type="radio"  name="pageSize" value="8" <%=pageSize==8?"checked='checked'":"" %> onclick="query()">8
					<input type="radio"  name="pageSize" value="10" <%=pageSize==10?"checked='checked'":"" %> onclick="query()">10
					<input type="radio"  name="pageSize" value="15" <%=pageSize==15?"checked='checked'":"" %> onclick="query()">15
					<input type="radio"  name="pageSize" value="20" <%=pageSize==20?"checked='checked'":"" %> onclick="query()">20
			</legend>	
		<%
			List<Computer> list = (List<Computer>) request.getAttribute("computer_query_result");
		%>
		<table border="1" align="center" width="100%" cellpadding="1" cellspacing="0" >
			<!-- 表头信息 -->
			<tr>
				<th>&nbsp;</th>
				<th align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
				<th nowrap="nowrap" onclick="sort(this)" id="code"><a style="CURSOR:hand">设备编号<span id='code_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="name"><a style="CURSOR:hand">设备名称<span id='name_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="ip"><a style="CURSOR:hand">设备IP<span id='ip_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="owner"><a style="CURSOR:hand">领用人<span id='owner_gif'></span></a></th>
				<th nowrap="nowrap"  onclick="sort(this)" id="computer_type"><a style="CURSOR:hand">设备类型<span id='computer_type_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="status"><a style="CURSOR:hand">状态<span id='status_gif'></span></a></th>
				<th nowrap="nowrap" onclick="sort(this)" id="begin_use_time"><a style="CURSOR:hand">领用日期<span id='begin_use_time_gif'></span></a></th>
				<th nowrap="nowrap" >到期日期</th>
			</tr>
			<%
				Computer computer = null;
				for (int i = 0; i < list.size(); i++) {
					computer = (Computer) list.get(i);
			%>

			<tr id="line<%=i %>" >
				<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
				</td>
				<td><input type="checkbox" name="pk" id="checkbox<%=i%>" value="<%=computer.getPk()%>" onclick="changeBgColor(this)">
				</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
					<a href="computerdo.do?method=detail&pk=<%=computer.getPk()%>">
					<%=computer.getCode()%>
					</a>
				</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=computer.getName()%></td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=computer.getIp()%>&nbsp;</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=computer.getOwner()%>&nbsp;</td>
				<td  nowrap="nowrap"  id="<%=i%>" onclick="clickLine(this)" ><%=computer_type.get(computer.getComputer_type())%>&nbsp;</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=computer_status.get(computer.getStatus())%></td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%=computer.getBegin_use_time()%>&nbsp;</td>
				<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)"><%
				
				//如果是笔记本，则显示到期时间，否则不显示。
				String begin_use_time = computer.getBegin_use_time();
				if(begin_use_time!=null&&!"".equals(begin_use_time)&&computer.getName().contains("笔记本")){
					int year = Integer.valueOf(begin_use_time.substring(0,4))+3;//笔记本使用期限是3年
					String month = begin_use_time.substring(4);
					out.print(year+month);		
				}
				%>&nbsp;</td>
			</tr>

			<%
				}
				//对于最后一页的特殊处理，如果最后一页的记录数不到每页显示记录数(pageSize)，则以空格填充
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
		<td align="center"><!-- 此处form中如果不写 method="post" ，将会出错 -->
		<form name="public_info" action="computerdo.do?method=query" method="post">
		<input type="hidden" name="sort" value=<%=sort%>> 
		<input type="hidden" name="sortType" value=<%=sortType%>>
		<input type="hidden" name="code" value=<%=code%>>
		<input type="hidden" name="owner" value=<%=owner%>>
		<input type="hidden" name="computer_type" value=<%=type%>>
		<input type="hidden" name="status" value=<%=status%>>
		<input type="hidden" name="currentPage" value=<%=query_condition.getShowPage()%>>
		<input type="hidden" name="pageSize" value=<%=pageSize%>>
		<input type="hidden" name="view" value=""><!-- 手动输入查看第几页 -->
		<input type="hidden" name="showPage" value=""><!-- 点击翻页 -->

		<font size=2> 共有[<font color="red"><%=query_condition.getPageCount()%>
		</font>]页，每页显示[<font color="red"><%=pageSize%></font>]条记录, 共有[<font color="red"><%=query_condition.getRecordCount()%>
		</font>]条记录，当前显示第[<font color="red"><%=query_condition.getShowPage()%>
		</font>]页
		<br>
		<a href="#" onclick="submit_public_info_form(this)" id="1">第一页</a>
		<a href="#" onclick="submit_public_info_form(this)" id="2">上一页</a>
		<a href="#" onclick="submit_public_info_form(this)" id="3">下一页</a>
		<a href="#" onclick="submit_public_info_form(this)" id="4">最后一页</a>&nbsp;&nbsp;
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