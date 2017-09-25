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
		<title>�û���Ϣά��</title>
<script type="text/javascript">


	//����
	function add() {
		var url = "user_add.jsp";
		var returnValue = window.showModalDialog(url, null,	"scroll:yes;status:no;dialogWidth:600px;dialogHeight:550px");
		//if (returnValue == "refresh") {
			document.formQuery.action = "userdo.do?method=query";
			document.formQuery.submit();
		//}
	}
	
	// ִ�в�ѯ��ϸ
	function detail(who) {

		var url ;
		var obj = document.getElementsByName("pk");

		if (who != null) {
			url = "userdo.do?method=detail&pk=" + who;
		}
		else if (obj != null) {
				var count = checkedNumber(obj);
				if (count != 1) {
					alert("��ѡ��һ����¼!");
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
	// ִ�и��²���
	function update() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = checkedNumber(obj);
			if (count != 1) {
				alert("��ѡ��һ����¼!");
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
				document.formResult.action = "userdo.do?method=delete";
				document.formResult.submit();
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
		document.formQuery.action = "userdo.do?method=query"
		document.formQuery.submit();
	}

	//���������ݸı�ʱ����ִ�в�ѯ
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
				�û���Ϣά��
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="����" onclick="add()" >
	<input type="button" class="btbox" value="�޸�" onclick="update()"  >
	<input type="button" class="btbox" value="ɾ��" onclick="del()"  >
	<input type="button" class="btbox" value="��ϸ" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
	<form name="formQuery" action="userdo.do?method=query" method="post">
	<fieldset><legend>��ѯ����</legend>
			<%
			//��ѯ����
			Object sort=request.getAttribute("query_condition_sort");
			Object sortType=request.getAttribute("query_condition_sortType");
			Object username=request.getAttribute("query_condition_username");
			Object who=request.getAttribute("query_condition_who");
			Object sex=request.getAttribute("query_condition_sex");	
			Object mylevel=request.getAttribute("query_condition_mylevel");	
			
			//��ֵ����
			if(sort==null)sort="who";
			if(sortType==null)sortType="ASC";
			if(username==null)username="";
			if(who==null)who="";
			if(sex==null)sex="";
			if(mylevel==null)mylevel="";
			%>
				<table align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td nowrap="nowrap" >��¼�û���
							<input type="text" name="username"  size="20" maxlength="32" value="<%=username==null?"":username %>"  ondblclick="clear_condition(this)">
							<input type="hidden" name="sort"  value="<%=sort==null?"code":sort %>">
							<input type="hidden" name="sortType"  value="<%=sortType==null?"ASC":sortType %>">
						</td>
					
						<td nowrap="nowrap">Ա������
						<input type="text" name="who"   size="20" maxlength="50" value="<%=who==null?"":who %>"  ondblclick="clear_condition(this)">
						</td>
						<td></td>
						</tr>
					<tr>
						<td nowrap="nowrap">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��
						<select name="sex"  size="1" onchange="onChangeSubmit()">
						<option value="" />---��ѡ��---
						<option value="��" 
						<%
						if("��".equals(sex)){
							out.print("selected=\"selected\"");
						}
						%>
						/>��
						<option value="Ů" 
						<%
						if("Ů".equals(sex)){
							out.print("selected=\"selected\"");
						}
						%>
						/>Ů				
						</select>
						</td>
						<%
						Map<String,String> user_role = Const.getEnumMap().get("user_role");
						%>
						<td nowrap="nowrap">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ɫ
						<select name="mylevel" size="1" onchange="onChangeSubmit()">
						<option value="" />---��ѡ��---
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
						<input type="submit" class="btbox" value="��ѯ" >
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
			<legend>��ѯ���</legend>
					<%
						List<User> list = new ArrayList<User>();

						//��request��ȡ�����صļ�¼��
						if (request.getAttribute("user_query_result") != null) {
							list = (List<User>) request.getAttribute("user_query_result");
							if (list.size() < 1) {
								return;
							}
						}
					
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th width="30">&nbsp;</th>
						<th width="30" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th  nowrap="nowrap" onclick="sort(this)" id="username" ><a style="CURSOR:hand">��¼�û���<span id='username_gif'></span></a></th>
						<th  nowrap="nowrap" onclick="sort(this)" id="who"><a style="CURSOR:hand">Ա������<span id='who_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="sex"><a style="CURSOR:hand">�Ա�<span id='sex_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="mylevel"><a style="CURSOR:hand">��ɫ<span id='mylevel_gif'></span></a></th>
						<th nowrap="nowrap" onclick="sort(this)" id="entry_time"><a style="CURSOR:hand">��ְʱ��<span id='entry_time_gif'></span></a></th>
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
				//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(10)�����Կո����
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
		<!-- �˴�form�������д method="post" ��������� -->
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


		<font size=2> ����[<font color="red"><%=request.getAttribute("pageCount")%>
		</font>]ҳ��ÿҳ��ʾ[<font color="red">10</font>]����¼, ����[<font color="red"><%=request.getAttribute("recordCount")%>
		</font>]����¼����ǰ��ʾ��[<font color="red"><%=request.getAttribute("showPage")%>
		</font>]ҳ
		<br>
		<a href="#" onclick="submit_public_info_form(this)" id="1">��һҳ</a> <a
			href="#" onclick="submit_public_info_form(this)" id="2">��һҳ</a> <a
			href="#" onclick="submit_public_info_form(this)" id="3">��һҳ</a> <a
			href="#" onclick="submit_public_info_form(this)" id="4">���һҳ</a>&nbsp;&nbsp;
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