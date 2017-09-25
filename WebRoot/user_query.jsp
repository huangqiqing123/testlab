<%
	//首先判断该用户是否已登录
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	
	if(!isSuperadmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="java.util.Iterator"%>
<jsp:directive.page import="java.util.ArrayList"/>
<jsp:directive.page import="java.util.List"/>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="cn.sdfi.user.bean.User"%><html>
	<head>
		<title>用户信息维护</title>
<script type="text/javascript">


	//新增
	function add() {
		var url = "user_add.jsp";
		var returnValue = window.showModalDialog(url, null,	"scroll:yes;status:no;dialogWidth:600px;dialogHeight:550px");
		//if (returnValue == "refresh") {
			document.formQuery.action = "userdo.do?method=query";
			document.formQuery.submit();
		//}
	}
	
	// 执行查询明细
	function detail(who) {

		var url ;
		var obj = document.getElementsByName("pk");

		if (who != null) {
			url = "userdo.do?method=detail&pk=" + who;
		}
		else if (obj != null) {
				var count = checkedNumber(obj);
				if (count != 1) {
					alert("请选择一条记录!");
					return;
				} else {
					var temp;
					for (var i = 0; i < obj.length; i++) {
						if (obj[i].checked == true) {
							temp=i;
							break;
						}
					}
					url = "userdo.do?method=detail&pk="+obj[temp].value;
				}
		}else{
			return;
		}
		var returnValue = window.showModalDialog(url, null,"scroll:yes;status:no;dialogWidth:600px;dialogHeight:550px");
		//if (returnValue == "refresh") {
			document.formQuery.action = "userdo.do?method=query";
			document.formQuery.submit();
		//}
	}
	// 执行更新操作
	function update() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = checkedNumber(obj);
			if (count != 1) {
				alert("请选择一条记录!");
				return;
			}
			var temp;
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					temp=i;
					break;
				}
			}
			var returnValue = window.showModalDialog("userdo.do?method=forupdate&pk="+obj[temp].value, null,"scroll:yes;status:no;dialogWidth:600px;dialogHeight:550px");
			//if (returnValue == "refresh") {
				document.formQuery.action = "userdo.do?method=query";
				document.formQuery.submit();
			//}
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
			if (confirm('确认删除选中记录？记录删除后将不能恢复！')) {
				document.formResult.action = "userdo.do?method=delete";
				document.formResult.submit();
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
		document.formQuery.action = "userdo.do?method=query"
		document.formQuery.submit();
	}

	//下拉框内容改变时，则执行查询
	function onChangeSubmit() {
		document.formQuery.action = "userdo.do?method=query";
		document.formQuery.submit();
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<table width="100%" height="100%"  align="center" cellpadding="0" cellspacing="0" >
	<tr>
	<td>
			<h2 align="center">
				用户信息维护
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="增加" onclick="add()" >
	<input type="button" class="btbox" value="修改" onclick="update()"  >
	<input type="button" class="btbox" value="删除" onclick="del()"  >
	<input type="button" class="btbox" value="明细" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
	<form name="formQuery" action="userdo.do?method=query" method="post">
	<fieldset><legend>查询条件</legend>
			<%
			//查询条件
			Object sort=request.getAttribute("query_condition_sort");
			Object sortType=request.getAttribute("query_condition_sortType");
			Object username=request.getAttribute("query_condition_username");
			Object who=request.getAttribute("query_condition_who");
			Object sex=request.getAttribute("query_condition_sex");	
			Object mylevel=request.getAttribute("query_condition_mylevel");	
			
			//空值处理
			if(sort==null)sort="who";
			if(sortType==null)sortType="ASC";
			if(username==null)username="";
			if(who==null)who="";
			if(sex==null)sex="";
			if(mylevel==null)mylevel="";
			%>
				<table align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td nowrap="nowrap" >登录用户名
							<input type="text" name="username"  size="20" maxlength="32" value="<%=username==null?"":username %>"  ondblclick="clear_condition(this)">
							<input type="hidden" name="sort"  value="<%=sort==null?"code":sort %>">
							<input type="hidden" name="sortType"  value="<%=sortType==null?"ASC":sortType %>">
						</td>
					
						<td nowrap="nowrap">员工姓名
						<input type="text" name="who"   size="20" maxlength="50" value="<%=who==null?"":who %>"  ondblclick="clear_condition(this)">
						</td>
						<td></td>
						</tr>
					<tr>
						<td nowrap="nowrap">性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别
						<select name="sex"  size="1" onchange="onChangeSubmit()">
						<option value="" />---请选择---
						<option value="男" 
						<%
						if("男".equals(sex)){
							out.print("selected=\"selected\"");
						}
						%>
						/>男
						<option value="女" 
						<%
						if("女".equals(sex)){
							out.print("selected=\"selected\"");
						}
						%>
						/>女				
						</select>
						</td>
						<%
						Map<String,String> user_role = Const.getEnumMap().get("user_role");
						%>
						<td nowrap="nowrap">角&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;色
						<select name="mylevel" size="1" onchange="onChangeSubmit()">
						<option value="" />---请选择---
						<%
							for (Map.Entry<String, String> entry : user_role.entrySet()) {
								
						%>
						<option value="<%=entry.getKey()%>" 
						<%
							if (mylevel != null) {
							if (mylevel.toString().equals(entry.getKey())) {
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
						<td align="right" nowrap="nowrap">
						<input type="submit" class="btbox" value="查询" >
						</td>
					</tr>
				</table>
				</fieldset>
			</form>
			</td>
			</tr>
			<tr><td >
			<form action="" name="formResult" method="post" >
			<fieldset>
			<legend>查询结果</legend>
					<%
						List<User> list = new ArrayList<User>();

						//从request中取出返回的记录，
						if (request.getAttribute("user_query_result") != null) {
							list = (List<User>) request.getAttribute("user_query_result");
							if (list.size() < 1) {
								return;
							}
						}
					
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- 表头信息 -->
					<tr>
						<th width="30">&nbsp;</th>
						<th width="30" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th  nowrap="nowrap" onclick="sort(this)" id="username" ><a style="CURSOR:hand">登录用户名<span id='username_gif'></span></a></th>
						<th  nowrap="nowrap" onclick="sort(this)" id="who"><a style="CURSOR:hand">员工姓名<span id='who_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="sex"><a style="CURSOR:hand">性别<span id='sex_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="mylevel"><a style="CURSOR:hand">角色<span id='mylevel_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="entry_time"><a style="CURSOR:hand">入职时间<span id='entry_time_gif'></span></a></th>
					</tr>
				<%
					User user = null;
					for(int i=0;i<list.size();i++){
						user = (User) list.get(i);
				%>
					
					<tr id="line<%=i %>" >
						<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i+1 %>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=URLEncoder.encode(user.getWho(),"GBK")%>" onclick="changeBgColor(this)">
						</td>
						<td width="150" nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<a href="#" onclick="detail('<%=URLEncoder.encode(user.getWho(),"GBK")%>')">
							<%=user.getUsername()%>
						</a>
						</td>
						<td  nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=user.getWho()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=user.getSex()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=user_role.get(user.getMylevel())%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=user.getEntry_time()==null?"":user.getEntry_time()%>&nbsp;
						</td>					
					</tr>
					<% } 
				//对于最后一页的特殊处理，如果最后一页的记录数不到每页显示记录数(10)，则以空格填充
				if (list.size() < 10) {
					for (int k = 0; k < 10 - list.size(); k++) {
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
			</td>
			</tr>
			<tr>
		<td align="center">
		<!-- 此处form中如果不写 method="post" ，将会出错 -->
		<form name="public_info" action="userdo.do?method=query"	method="post" onsubmit="false">
		<input type="hidden" name="sort" value=<%=sort%>> 
		<input type="hidden" name="sortType" value=<%=sortType%>> 
		<input type="hidden" name="username" value=<%=username%>>
		<input type="hidden" name="who" value=<%=who%>>
		<input type="hidden" name="sex" value=<%=sex%>> 
		<input type="hidden" name="mylevel" value=<%=mylevel%>> 
		<input type="hidden" name="currentPage"	value=<%=request.getAttribute("showPage")%>> 
		<input type="hidden" name="view" value=""> 
		<input type="hidden" name="showPage" value="">


		<font size=2> 共有[<font color="red"><%=request.getAttribute("pageCount")%>
		</font>]页，每页显示[<font color="red">10</font>]条记录, 共有[<font color="red"><%=request.getAttribute("recordCount")%>
		</font>]条记录，当前显示第[<font color="red"><%=request.getAttribute("showPage")%>
		</font>]页
		<br>
		<a href="#" onclick="submit_public_info_form(this)" id="1">第一页</a> <a
			href="#" onclick="submit_public_info_form(this)" id="2">上一页</a> <a
			href="#" onclick="submit_public_info_form(this)" id="3">下一页</a> <a
			href="#" onclick="submit_public_info_form(this)" id="4">最后一页</a>&nbsp;&nbsp;
		<input type="text" size="3" maxlength="6" name="temp" value="<%=request.getAttribute("showPage")%>"> 
		<input type="hidden" id="pageCount" name="pageCount" value="<%=request.getAttribute("pageCount")%>"> 
		<input type="button" value="Go" onclick="checkPageNumber()"> </font>
		</form>
		</td>
	</tr>
		</table>
<script type="text/javascript">
$("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>";  
</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />