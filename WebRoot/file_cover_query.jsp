<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Iterator"%>
<jsp:directive.page import="java.util.ArrayList"/>
<jsp:directive.page import="java.util.List"/>
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.filecover.bean.FileCover"%><html>
	<head>
		<title>档案袋信息管理</title>
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
			document.form2.action = "filecoverdo.do?method=detail";
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

			document.form2.action = "file_cover_update.jsp";
			document.form2.submit();
		}
	}

	//删除档案袋前的校验，如果存在非空档案袋，则不再执行删除操作。
	function before_delete() {
		var count = 0;
		var canDelete = false;
		var temp = "";
		var obj = document.getElementsByName("pk");
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
				temp = temp + "&pk=" + obj[i].value;
			}
		}
		if (count = 0) {
			alert("请选择要删除的记录!");
			return canDelete;
		} 
		else
		{
			var req = getXmlHttpObject();
			var url = "filecoverdo.do?method=hasContent" + temp;
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						var msg = req.responseText;
						
						//如果所选择的全部是空档案袋，则返回true，表示可以执行删除操作。
						if(msg==""){
							canDelete=true;
						}else{
							alert(msg);
						}
					}
				}
			};
			req.open("POST", url, false);
			req.send(null);
			return canDelete;
		}

	}
	//返回XMLHttpRequest对象
	function getXmlHttpObject() {
		var xmlHttp = null;
		try {
			// Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
			// Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
		}
		return xmlHttp;
	}

	// 执行删除操作
	function del() {
		if (confirm('确认要删除吗？此操作不能恢复！')) {
			if (before_delete()) {
				document.form2.action = "filecoverdo.do?method=delete";
				document.form2.submit();
			}
		}
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
		document.formQuery.action = "filecoverdo.do?method=query&pageSize="+pageSize;
		document.formQuery.submit();
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
		document.formQuery.action = "filecoverdo.do?method=query&action=exportExcel"
		document.formQuery.submit();
		document.formQuery.action = "filecoverdo.do?method=query";
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body  background="images/skins/<%=session.getAttribute("skin")%>">
	<span id="tips"></span>
	<%
		boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
		boolean isSuperadmin = Tool.isSuperadmin(request);
		FileCover query_condition = (FileCover)request.getAttribute("query_condition");
	%>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
				档案袋信息管理
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="增加" onClick="window.location.href='file_cover_add.jsp'"  
	<%
	if (!isDocmentAdmin&&!isSuperadmin) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="修改" onclick="update()" 
	<%
	if (!isDocmentAdmin&&!isSuperadmin) {
		out.print("disabled=\"disabled\" ");
	}
	%> >
	<input type="button" class="btbox" value="删除" onclick="del()"  
	<%
	if (!isDocmentAdmin&&!isSuperadmin) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="明细" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action = "filecoverdo.do?method=query" method="post">
			<fieldset><legend>查询条件</legend>
				<table align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td nowrap="nowrap">
							<input type="hidden" name="sort"  value="<%=query_condition.getSort()%>">
							<input type="hidden" name="sortType"  value="<%=query_condition.getSortType()%>">
							编号
							<input type="text" name="file_cover_code"  size="25" maxlength="32" value="<%=query_condition.getFile_cover_code()%>" ondblclick="clear_condition(this)">
						</td>
					
						<td colspan="1" nowrap="nowrap">
						名称
						<input type="text" name="file_cover_name"   size="25" maxlength="50" value="<%=query_condition.getFile_cover_name()%>"  ondblclick="clear_condition(this)">
						</td>
						<td colspan="1"></td>
					</tr>
					<tr>
					<td nowrap="nowrap">
					<%
					Map<String,String> file_cover_types = Const.getEnumMap().get("file_cover_type");
					
					%>
						类型
						<select name="file_cover_type" size="1" onchange="query()">
						<option value="" />---请选择---
						<%
						for (Entry<String, String> entry : file_cover_types.entrySet()) {
								
						%>
						<option value="<%=entry.getKey()%>" 
						<%
						if (query_condition.getFile_cover_type().equals(entry.getKey())) {
							out.print("selected=\"selected\"");
						}%>
						/>
						<%=entry.getValue()%>
						<%
							}
						%>
						</select>
						</td>
							
						<td nowrap="nowrap">
						年度
						<select name="file_cover_year" title="请选择年度" size="1" onchange="query()">
						<option value="" />---请选择---
						<%
							for (int i = 2004; i < 2020; i++) {
						%>
						<option value="<%=i%>" 
						<%
						if (query_condition.getFile_cover_year().equals(i + "")) {
							out.print("selected=\"selected\"");
						}%>
						/>
						<%=i%>
						<%
							}
						%>
						</select>
						</td>
				
						<td colspan="1" align="right" nowrap="nowrap">
						<input type="submit" class="btbox" value="查询">
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
						<input type="radio"  name="pageSize" value="8" <%=query_condition.getPageSize()==8?"checked='checked'":"" %> onclick="query()">8
						<input type="radio"  name="pageSize" value="10" <%=query_condition.getPageSize()==10?"checked='checked'":"" %> onclick="query()">10
						<input type="radio"  name="pageSize" value="15" <%=query_condition.getPageSize()==15?"checked='checked'":"" %> onclick="query()">15
						<input type="radio"  name="pageSize" value="20" <%=query_condition.getPageSize()==20?"checked='checked'":"" %> onclick="query()">20
		</legend>	
					<%
						List<FileCover> list = (List<FileCover>) request.getAttribute("file_cover_query_result");
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" id="tableData"  title="点击列标题可以进行排序">
					<!-- 表头信息 -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th width="150"  onclick="sort(this)" id="file_cover_code" nowrap="nowrap" ><a style="CURSOR:hand">档案袋编号<span id='file_cover_code_gif'></span> </a></th>
						<th width="500"  onclick="sort(this)" id="file_cover_name"><a style="CURSOR:hand">档案袋名称<span id='file_cover_name_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="file_cover_type"><a style="CURSOR:hand">类型<span id='file_cover_type_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="file_cover_year"><a style="CURSOR:hand">年度<span id='file_cover_year_gif'></span></a></th>
					</tr>
				<%
					FileCover file_cover = null;
					for (int i = 0; i < list.size(); i++) {
						file_cover = (FileCover) list.get(i);
				%>
					
					<tr id="line<%=i %>" >
						<td align="center" id="<%=i%>" onclick="clickLine(this)" >
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=file_cover.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<a href="filecoverdo.do?method=detail&pk=<%=file_cover.getPk()%>">
							<%=file_cover.getFile_cover_code()%>
						</a>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=file_cover.getFile_cover_name()%>
						</td>
						<td id="<%=i%>" onclick="clickLine(this)" nowrap="nowrap">
							<%=file_cover_types.get(file_cover.getFile_cover_type())==null?"":file_cover_types.get(file_cover.getFile_cover_type())%>&nbsp;
						</td>
						<td id="<%=i%>" onclick="clickLine(this)">
							<%=file_cover.getFile_cover_year()%>&nbsp;
						</td>
						
					</tr>

			<%
				}
					//对于最后一页的特殊处理，如果最后一页的记录数不到每页显示记录数(pageSize)，则以空格填充
					if(list.size()<query_condition.getPageSize()){
						for(int k=0;k<query_condition.getPageSize()-list.size();k++){
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

		</table></fieldset>
			</form>
			</td></tr>
			<tr><td align="center">
			<!-- 此处form中如果不写 method="post" ，将会出错 -->
			<form name="public_info" action="filecoverdo.do?method=query" method="post" onsubmit="false">
					<input type="hidden" name="sort" value="<%=query_condition.getSort()%>">
					<input type="hidden" name="sortType" value="<%=query_condition.getSortType()%>">
					<input type="hidden" name="file_cover_code" value="<%=query_condition.getFile_cover_code()%>">
					<input type="hidden" name="file_cover_name" value="<%=query_condition.getFile_cover_name()%>">
					<input type="hidden" name="file_cover_year" value="<%=query_condition.getFile_cover_year()%>">
					<input type="hidden" name="file_cover_type" value="<%=query_condition.getFile_cover_type()%>">
					<input type="hidden" name="currentPage" value="<%=query_condition.getShowPage()%>">
					<input type="hidden" name="pageSize" value=<%=query_condition.getPageSize()%>>
					<input type="hidden" name="view" value=""><!-- 手动输入查看第几页 -->
					<input type="hidden" name="showPage" value=""><!-- 点击翻页 -->
					
			
		<font size=2> 共有[<font color="red"><%=query_condition.getPageCount()%>
		</font>]页，每页显示[<font color="red"><%=query_condition.getPageSize()%></font>]条记录, 共有[<font color="red"><%=query_condition.getRecordCount()%>
		</font>]条记录，当前显示第[<font color="red"><%=query_condition.getShowPage()%>
		</font>]页 
		<br>
		<a href="#" onclick="submit_public_info_form(this)" id="1">第一页</a>
		<a href="#" onclick="submit_public_info_form(this)" id="2">上一页</a>
		<a href="#" onclick="submit_public_info_form(this)" id="3">下一页</a>
		<a href="#" onclick="submit_public_info_form(this)" id="4">最后一页</a>&nbsp;&nbsp;
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