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
		<title>受控文件管理</title>
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
			document.form2.action = "systemfiledo.do?method=detail";
			document.form2.submit();
		}
	}
	// 执行更新操作
	function update() {
		var obj = document.getElementsByName("pk");
		// 更新时,对选择的记录数进行校验
		if (obj != null) {
			var count = checkedNumber(obj);	
			
			if (count != 1) {
				alert("请选择一条记录!!");
				return;
			}

			document.form2.action = "systemfile_update.jsp";
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
				document.form2.action = "systemfiledo.do?method=delete";
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
		document.formQuery.action = "systemfiledo.do?method=query&action=exportExcel"
		document.formQuery.submit();
		document.formQuery.action="systemfiledo.do?method=query";
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
				受控文件管理
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="增加" onClick="window.location.href='systemfile_add.jsp'" 
	<%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="修改" onclick="update()" <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%> >
	<input type="button" class="btbox" value="删除" onclick="del()"  <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="明细" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
			<form name="formQuery" action="systemfiledo.do?method=query" method="post">
			<fieldset><legend>查询条件</legend>
			<%
			//查询条件
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
						<td nowrap="nowrap" >文件编号
							<input type="text" name="code"  size="20" maxlength="32" value="<%=code==null?"":code %>"  ondblclick="clear_condition(this)">
							<input type="hidden" name="sort"  value="<%=sort==null?"code":sort %>">
							<input type="hidden" name="sortType"  value="<%=sortType==null?"ASC":sortType %>">
						</td>
					
						<td nowrap="nowrap">文件名称
						<input type="text" name="name"   size="20" maxlength="50" value="<%=name==null?"":name %>"  ondblclick="clear_condition(this)">
						</td>
						<td></td>
						</tr>
					<tr>
						<td nowrap="nowrap">&nbsp;受&nbsp;控&nbsp;号&nbsp;
						<input type="text" name="controlled_number"   size="20" maxlength="50" value="<%=controlled_number==null?"":controlled_number %>"  ondblclick="clear_condition(this)">
						</td>
						<td nowrap="nowrap">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态
						<select name="state" title="请选择文件状态" size="1" onchange="query()">
						<option value="" />---请选择---
						<option value="有效" 
						<%
						if("有效".equals(state)){
							out.print("selected=\"selected\"");
						}
						%>
						/>有效
						<option value="已废弃" 
						<%
						if("已废弃".equals(state)){
							out.print("selected=\"selected\"");
						}
						%>
						/>已废弃					
						</select>
						</td>
						<td align="right" nowrap="nowrap">
						<input type="submit" class="btbox" value="查询" >
						<input type="button" class="btbox" value="导出Excel" onclick="exportExcel()"  >
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
					每页显示记录数
					<input type="radio"  name="pageSize" value="8" <%=pageSize==8?"checked='checked'":"" %> onclick="query()">8
					<input type="radio"  name="pageSize" value="10" <%=pageSize==10?"checked='checked'":"" %> onclick="query()">10
					<input type="radio"  name="pageSize" value="15" <%=pageSize==15?"checked='checked'":"" %> onclick="query()">15
					<input type="radio"  name="pageSize" value="20" <%=pageSize==20?"checked='checked'":"" %> onclick="query()">20
			</legend>	
				<%
					List<SystemFile> list = (List<SystemFile>) request.getAttribute("systemfile_query_result");
				%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- 表头信息 -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th width="100" nowrap="nowrap" onclick="sort(this)" id="code" ><a style="CURSOR:hand">文件编号<span id='code_gif'></span></a></th>
						<th width="500"  onclick="sort(this)" id="name"><a style="CURSOR:hand">文件名称<span id='name_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="pages"><a style="CURSOR:hand">页数<span id='pages_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="version"><a style="CURSOR:hand">版本<span id='version_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="controlled_number"><a style="CURSOR:hand">受控号<span id='controlled_number_gif'></span></a></th>
						<th nowrap="nowrap"  onclick="sort(this)" id="state"><a style="CURSOR:hand">状态<span id='state_gif'></span></a></th>
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
					//对于最后一页的特殊处理，如果最后一页的记录数不到每页显示记录数(pageSize)，则以空格填充
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
			<!-- 此处form中如果不写 method="post" ，将会出错 -->
			<form name="public_info" action="systemfiledo.do?method=query" method="post" onsubmit="false">
					<input type="hidden" name="sort" value=<%=sort%>>
					<input type="hidden" name="sortType" value=<%=sortType%>>
					<input type="hidden" name="code" value=<%=code%>>
					<input type="hidden" name="name" value=<%=name%>>
					<input type="hidden" name="controlled_number" value=<%=controlled_number%>>
					<input type="hidden" name="state" value=<%=state%>>
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
		</td></tr>
		</table>
<script type="text/javascript">
document.getElementById("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>";  
</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />