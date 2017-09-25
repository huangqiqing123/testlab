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
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>

<%@page import="cn.sdfi.know.bean.Know"%><html>
	<head>
		<title>我的知识库</title>
<script type="text/javascript">
	//批准
	function approve() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = 0;
			for ( var i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
				}
			}
			if (count < 1) {
				alert("请至少选择一条记录!");
				return;
			}
			document.form2.action = "knowdo.do?method=approve";
			document.form2.submit();
		}
	}
	// 撤回
	function back() {
		if(status_check('back')){	
			document.form2.action = "knowdo.do?method=back";
			document.form2.submit();
		}
	}
	//修改
	function update() {	
		var count = 0;
		var obj = document.getElementsByName("pk");
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count !=1 ) {
			$('tips').innerHTML = "<font color='red'>请选择一条记录!</font>";
		} else {
			document.form2.action = "knowdo.do?method=forupdate&path=know_of_myself.jsp";
			document.form2.submit();
		}
	}
	// 删除
	function del() {
		var count = 0;
		var obj = document.getElementsByName("pk");
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count == 0) {
			$('tips').innerHTML = "<font color='red'>请选择要删除的记录!</font>";
			return;
		} else {
			if (confirm('确认删除选中记录？文件删除后将不能恢复！')) {
				document.form2.action = "knowdo.do?method=delete&path=know_of_myself.jsp";
				document.form2.submit();
			}
		}
	}
	//判断所选记录是否是"保存"状态，只有"保存"状态的记录才可以执行"提交"操作。
	function status_check(which) {
		var count = 0;
		var canSubmit = false;
		var temp = "";
		var obj = document.getElementsByName("pk");
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
				temp = temp + "&pk=" + obj[i].value;
			}
		}
		if (count == 0) {
			if (which == "submit") {
				$('tips').innerHTML = "<font color='red'>请选择要提交的记录!</font>";
				return canSubmit;
			}
			if (which == "back") {
				$('tips').innerHTML = "<font color='red'>请选择要撤回的记录!</font>";
				return canSubmit;
			}
		}
		//发送Ajax请求
		var req = getXmlHttpObject();
		var url = null;
		if (which == "back") {
			url = "knowdo.do?method=isSubmitStatus" + temp;
		} else {
			url = "knowdo.do?method=isSaveOrRejectStatus" + temp;
		}
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;

					//如果所选择的全部是"保存或者驳回"状态的记录，则返回true，表示可以执行相应的操作。
					if (msg == "ok") {
						canSubmit = true;
					} else {
						if (which == "submit") {
							msg = "记录{ " + msg + " }不是保存、驳回状态，不能执行提交操作！"
						} else if (which == "back") {
							msg = "记录{ " + msg + " }不是待审核状态，不能执行撤回操作！"
						}else {
							alert('传入了无效的参数 which=' + which);
						}
						$('tips').innerHTML = "<font color='red'>" + msg + "</font>";
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return canSubmit;
	}
	//检查所选文件是否可以在线阅读
	function canOnLineRead(pk){
		var canOnlineRead = false;
		var req = getXmlHttpObject();
		var url = "knowdo.do?method=canOnlineRead&pk=" + pk;
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;
					if (msg == "ok") {
						canOnlineRead = true;
					} else {
						$('tips').innerHTML = "<font color='red'>Sorry，该文件暂不能在线阅读，请下载至本地后进行查看！</font>";
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return canOnlineRead;
	}
	//提交
	function submit() {
		if (status_check('submit')) {
			document.form2.action = "knowdo.do?method=submit";
			document.form2.submit();
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
		document.formQuery.action = "knowdo.do?method=query&path=know_of_myself.jsp&pageSize="+pageSize;
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
	// 在线阅读
	function onlineread() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = 0;
			var pk = null;
			var url = "online_read.jsp?path=know&pk=";
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
					url = url+obj[i].value;
					pk = obj[i].value;
				}
			}
			if (count != 1) {
				$('tips').innerHTML="<font color='red'>请选择一条记录！</font>";
				return;
			}
			if(canOnLineRead(pk)){
			window.showModalDialog(url,obj,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
		}
		}
	}
	// 双击在线阅读
	function doubleClick(pk) {	
		if(canOnLineRead(pk)){
			var url = "online_read.jsp?path=know&pk="+pk;
			window.showModalDialog(url,null,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
	}}
	//下载
	function download() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = 0;
			var pk = "online_read.jsp?pk=";
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
					pk = obj[i].value;
				}
			}
			if (count > 1) {
				$('tips').innerHTML="<font color='red'>请选择一条记录进行下载！</font>";
				return;
			}
			if (count < 1) {
				$('tips').innerHTML="<font color='red'>请选择要下载的文件！</font>";
				return;
			}
		window.location.href="knowdo.do?method=download&pk="+pk;
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="css/suggest.css">
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
<script language="javascript" src="js/suggest.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" >
	<span id="tips"></span>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
				我的知识库
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="上传" onClick="window.location.href='know_add.jsp'" >
	<input type="button" class="btbox" value="批量上传" onClick="window.location.href='know_batchUpload_file.jsp'" >
	<input type="button" class="btbox"	value="提交" onclick="submit()"> 
	<input type="button" class="btbox" value="撤回" onclick="back()" >
	<input type="button" class="btbox" value="在线阅读" onclick="onlineread()" >
	<input type="button" class="btbox" value="下载" onclick="download()" >
	<input type="button" class="btbox" value="修改" onclick="update()">
	<input type="button" class="btbox" value="删除" onclick="del()"> 
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action="knowdo.do?method=query&path=know_of_myself.jsp" method="post">
		<fieldset>
			<legend>查询条件</legend>		
	<%
 		Know query_condition = (Know) request.getAttribute("query_condition");
	%>		
	<table align="center"  cellpadding="1" cellspacing="0" border="0">
		<tr>
			<td nowrap="nowrap">关键字</td>
			<td>
				<input type="text" id="title" name="title" value="<%=query_condition.getTitle()%>" size="55" ondblclick="clear_condition(this)" onkeyup="sendRequest('know_of_myself.jsp')" onclick="hiddenSuggest()" >
			</td>
			<td>
				<input type="hidden" name="sort"  value="<%=query_condition.getSort()%>">
				<input type="hidden" name="sortType"  value="<%=query_condition.getSortType()%>">		
			</td>
		</tr>
		<tr><td></td><td>
		<IFRAME id="frame1" style="display:none;width:100%;height:24px;position:absolute;z-index:0;" frameborder="0" marginheight="0" marginwidth="0">      
        </IFRAME>  	
		<div id="suggest" style="display:none;width:100%" ></div>
		</td><td></td></tr>
		<tr>
			<td nowrap="nowrap" align="left">
			<%
			Map<String,String> know_type = Const.getEnumMap().get("know_type");
			Map<String,String> know_status = Const.getEnumMap().get("know_status");
			%>
			类&nbsp;&nbsp;&nbsp;型
			</td>
			<td>
				<select name="type" size="1" onchange="query()">
				<option value="" />---请选择---
				<%
					for (Map.Entry<String, String> entry : know_type.entrySet()) {
								
				%>
					<option value="<%=entry.getKey()%>" 
					<%
					if (query_condition.getType().equals(entry.getKey())) {
						out.print("selected=\"selected\"");
					}%>
						/>
						<%=entry.getValue()%>
						<%
							}
						%>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						状态
						<select name="status" size="1" onchange="query()">
						<option value="" />---请选择---
						<%
						for (Map.Entry<String, String> entry : know_status.entrySet()) {
								
						%>
						<option value="<%=entry.getKey()%>" 
						<%		
						if (query_condition.getStatus().equals(entry.getKey())) {
							out.print("selected=\"selected\"");
						}%>
						/>
						<%=entry.getValue()%>
						<%
							}
						%>
						</select>
						</td>			
						<td nowrap="nowrap" align="right">
						&nbsp;&nbsp;<input type="submit" value="查询" class="btbox">
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
						List<Know> list = (List<Know>) request.getAttribute("know_query_result");
						String path = application.getRealPath("/")+"WEB-INF\\file";
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%"  >
					<!-- 表头信息 -->
					<tr>
						<th width="30">&nbsp;</th>
						<th width="25"><input  type="checkbox"  onclick="selectAll(this)"></th>
						<th id="title"  onclick="sort(this)"><a style="CURSOR:hand">文件名称<span id='title_gif'></span></a></th>
						<th id="status" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">状态<span id='status_gif'></span></a></th>
						<th id="type" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">类型<span id='type_gif'></span></a></th>
						<th id="last_update_time" onclick="sort(this)" nowrap="nowrap" width="150"><a style="CURSOR:hand">最后更新时间<span id='last_update_time_gif'></span></a></th>
					</tr>
					<%
					Know view = null;
					String suffixPath = application.getRealPath("/")+"images/suffix";	
					java.io.File file = new java.io.File(suffixPath);
					java.io.File[] files = file.listFiles();
					for(int i=0;i<list.size();i++){
						view = (Know) list.get(i);
				%>
					<tr id="line<%=i %>" ondblclick="doubleClick('<%=view.getPk()%>')">
					<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=view.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)" title="点击查看明细">
						<%
							String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
		
							//该后缀在后缀库中是否存在，默认为FALSE
							boolean isExist = false;
						    for (int j = 0; j < files.length; j++) {	   
			   				if (files[j].isFile()) {
			    			if(files[j].getName().startsWith(suffix)){
			    				isExist = true;
			    				break;
			    			}
			    			}
							}
						  //如果当前文件后缀在后缀库中不存在，则显示默认图标。
							if(!isExist){
								suffix = "none";
							}
						%>
						<img src="images/suffix/<%=suffix%>.png"  border="0" align="middle"  alt="<%=view.getBlob_name() %>">
							<a href="knowdo.do?method=detail&pk=<%=view.getPk() %>">		
							<%=view.getBlob_name()%>
							</a>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							
							<%=know_status.get(view.getStatus()) %>
							
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=know_type.get(view.getType())%>
						</td>
						
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getLast_update_time()%>&nbsp;
						</td>
					</tr>
<%
					}
					//对于最后一页的特殊处理，如果最后一页的记录数不到每页显示记录数(pageSize)，则以空格填充
					if(list.size()<query_condition.getPageSize()){
						for(int k=0;k<query_condition.getPageSize() -list.size();k++){
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
			<!-- 此处form中如果不写 method="post" ，将会出错 -->
			<form name="public_info" action="knowdo.do?method=query&path=know_of_myself.jsp" method="post" >
					<input type="hidden" name="sort" value=<%=query_condition.getSort()%>>
					<input type="hidden" name="sortType" value=<%=query_condition.getSortType()%>>
					<input type="hidden" name="title" value=<%=query_condition.getTitle()%>>
					<input type="hidden" name="type" value=<%=query_condition.getType()%>>
					<input type="hidden" name="status" value=<%=query_condition.getStatus()%>>
					<input type="hidden" name="currentPage" value=<%=query_condition.getShowPage()%>>
					<input type="hidden" name="pageSize" value=<%=query_condition.getPageSize()%>>
					<input type="hidden" name="view" value="">
					<input type="hidden" name="showPage" value="">
			
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
