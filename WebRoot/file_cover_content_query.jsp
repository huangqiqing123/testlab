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
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.GetFileNames"%>

<%@page import="cn.sdfi.filecovercontent.bean.FileCoverContent"%><html>
	<head>
		<title>文件信息管理</title>
<script type="text/javascript">
	// 执行查询明细
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
				alert("请选择一条记录!");
				return;
			}
			document.form2.action = "filecovercontentdo.do?method=detail";
			document.form2.submit();
		}
	}
	function update() {
		var obj = document.getElementsByName("pk");
		// 更新时,对选择的记录数进行校验
		if (obj != null) {
			var count = 0;
			for (i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
				}
			}
			if (count != 1) {
				alert("请选择一条记录!");
				return;
			}

			document.form2.action = "file_cover_content_update.jsp";
			document.form2.submit();
		}
	}
	// 执行删除操作
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
				alert("请选择要删除的记录!!");
				return;
			}
			if (confirm('确认删除选中记录？文件删除后将不能恢复！')) {
				document.form2.action = "filecovercontentdo.do?method=delete";
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
		document.formQuery.action = "filecovercontentdo.do?method=query&pageSize="+pageSize;
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
		if ($('recordCount').value > 65535) {
			alert("一次性最大可导出65534行记录，当前符合条件的记录数为"+$('recordCount').value+"!");
		} else {
			document.formQuery.action = "filecovercontentdo.do?method=query&action=exportExcel"
			document.formQuery.submit();
			document.formQuery.action = "filecovercontentdo.do?method=query";
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" >
	<span id="tips"></span>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
				文件信息管理
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="增加" onClick="window.location.href='file_cover_content_add.jsp'"  <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="从excel导入" onClick="window.location.href='file_cover_content_import.jsp'"  <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="修改" onclick="update()" <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="删除" onclick="del()" <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>> 
	<input type="button" class="btbox" value="明细" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action = "filecovercontentdo.do?method=query" method="post">
		<fieldset>
			<legend>查询条件</legend>		
		<%
			//查询条件
			FileCoverContent query_condition = (FileCoverContent)request.getAttribute("query_condition");
			String sort = query_condition.getSort();
			String sortType = query_condition.getSortType();
			int pageSize = query_condition.getPageSize();
			String code = query_condition.getFile_cover_content_code();
			String name = query_condition.getFile_cover_content_name();
			String fk = query_condition.getFk();
			Object fk_show = request.getAttribute("fk_show");			
			%>
				<table align="center"  cellpadding="1" cellspacing="0">
					<tr>
					<td nowrap="nowrap" colspan="3">
					档&nbsp;案&nbsp;袋&nbsp;&nbsp;
					<input type="text" id="fk_show" name="fk_show" value="<%=fk_show%>" size="50"  ondblclick="clear_condition_fk()"   readonly="readonly">
					<input type="hidden" id="condition_fk" name="fk" value="<%=fk%>" ><!-- 隐藏域-档案袋编号 -->
					<input type="button" class="btbox" value="选择..." onclick="show_help_window()">
					</td>
					</tr>
					<tr>
						<td nowrap="nowrap">
							文件编号
							<input type="text" id="condition_code" name="file_cover_content_code" size="25" maxlength="32" value="<%=code %>"  ondblclick="clear_condition(this)" >
							<input type="hidden" name="sort"  value="<%=sort == null ? "code" : sort%>">
							<input type="hidden" name="sortType"  value="<%=sortType == null ? "ASC" : sortType%>">
						</td>
						<td></td>
					
						<td nowrap="nowrap">
						文件名称
						<input type="text" id="condition_name" name="file_cover_content_name" size="25" maxlength="50" value="<%=name %>"  ondblclick="clear_condition(this)">
						</td>
						<td></td>
						<td nowrap="nowrap">
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
						List<FileCoverContent> list = (List<FileCoverContent>) request.getAttribute("file_cover_content_query_result");
						String path = application.getRealPath("/")+"WEB-INF\\document";
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" id="tableData"  >
					<!-- 表头信息 -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th id="file_cover_content_code" onclick="sort(this)" nowrap="nowrap" width="120"><a style="CURSOR:hand">文件编号<span id='file_cover_content_code_gif'></span></a></th>
						<th id="file_cover_content_name" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">文件名称<span id='file_cover_content_name_gif'></span></a></th>
						<th id="version" onclick="sort(this)" nowrap="nowrap" ><a style="CURSOR:hand">版本<span id='version_gif'></span></a></th>
						<th id="pages" onclick="sort(this)" nowrap="nowrap"><a style="CURSOR:hand">页数<span id='pages_gif'></span></a></th>
						<th align="center">附件</th>
					</tr>
					<%
					String suffixPath = application.getRealPath("/")+"images/suffix";//文件后缀图标存放路径
					String suffixs[] = Tool.getFileNames(suffixPath);//获取所有后缀名称
					FileCoverContent file_cover_content = null;
					for(int i=0;i<list.size();i++){
						file_cover_content = (FileCoverContent) list.get(i);
				%>
					<tr id="line<%=i %>" >
					<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=file_cover_content.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)" title="点击编号可以查看明细">
						<a href="filecovercontentdo.do?method=detail&pk=<%=file_cover_content.getPk() %>">
							<%=file_cover_content.getFile_cover_content_code()%>
							</a>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=file_cover_content.getFile_cover_content_name()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							
							<%=file_cover_content.getVersion() %>&nbsp;
							
						</td>
							<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=file_cover_content.getPages()%>&nbsp;
						</td>
						<td nowrap="nowrap" align="center">
						<%
		String filenames[] = GetFileNames.getFileNamesStartWithPrefix(path, file_cover_content.getPk());	
		
		//如果该文件存在附件
		if(filenames.length>0){
			
			//该后缀在后缀库中是否存在，默认为FALSE
			String ext = filenames[0].substring( filenames[0].lastIndexOf(".")+1);//获取文件后缀
			boolean isExist = false;
			for(int j=0;j<suffixs.length;j++){
				    if (suffixs[j].startsWith(ext)) {
				    		isExist = true;
				    		break;
				     }
			}//如果当前文件后缀在后缀库中不存在，则显示默认图标。
			if(!isExist){
				ext = "none";
			}	
			String newfilename = file_cover_content.getFile_cover_content_name()+"."+ext;//组装新的文件名称	
		%>		
		<u title="<%=newfilename %>" style="CURSOR:hand" onclick="window.location.href='filecovercontentdo.do?method=download&pk=<%=file_cover_content.getPk() %>'"><img src="images/suffix/<%=ext%>.png" border="0" ></u>
		<%
		}else{ out.println("无"); }%>
						</td>
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
			<form name="public_info" action="filecovercontentdo.do?method=query" method="post" >
					<input type="hidden" name="sort" value=<%=sort%>>
					<input type="hidden" name="fk" value=<%=fk%>>
					<input type="hidden" name="fk_show" value=<%=fk_show%>>
					<input type="hidden" name="sortType" value=<%=sortType%>>
					<input type="hidden" name="file_cover_content_code" value=<%=code%>>
					<input type="hidden" name="file_cover_content_name" value=<%=name%>>
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

		//点击列表头进行排序时，方向箭头同步修改
		document.getElementById("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>"; 

		//显示通用帮助
		function show_help_window() { 
			var url = "filecoverdo.do?method=query&path=help";
			var obj = new Object();
			var returnValue = window.showModalDialog(url,obj,"scroll:yes;status:no;dialogWidth:750px;dialogHeight:520px");
			
			//点击关闭按钮，返回null
			if (returnValue == null) {
				return;
			}
			else// 如果是点击的是【确定】
			{
			document.getElementById("fk").value=returnValue[0];
			document.getElementById("fk_show").value=returnValue[1]+"("+returnValue[2]+")";
			query();
			}
	}  
		
		//双击则清除查询条件
		function clear_condition_fk(){
			document.getElementById("condition_fk").value="";
			document.getElementById("fk_show").value="";
			}
		</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />			
