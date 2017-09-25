<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//��������ĵ�����Ա/��������Ա������Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	
	if(!isSuperadmin&&!isDocmentAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
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
		<title>������ļ�</title>
<script type="text/javascript">
	//��׼
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
				$('tips').innerHTML="<font color='red'>��ѡ��Ҫ��׼�ļ�¼!</font>";
				return;
			}
			document.form2.action = "knowdo.do?method=approve";
			document.form2.submit();
		}
	}
	// ����
	function reject() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = 0;
			for ( var i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
				}
			}
			if (count < 1) {
				$('tips').innerHTML="<font color='red'>��ѡ��Ҫ���صļ�¼!</font>";
				return;
			}
			document.form2.action = "knowdo.do?method=reject";
			document.form2.submit();
		}
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
		document.formQuery.action = "knowdo.do?method=query&path=know_submit_query.jsp&pageSize="+pageSize;
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
	//����
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
				$('tips').innerHTML="<font color='red'>��ѡ��һ����¼�������أ�</font>";
				return;
			}
			if (count < 1) {
				$('tips').innerHTML="<font color='red'>��ѡ��Ҫ���ص��ļ���</font>";
				return;
			}
		window.location.href="knowdo.do?method=download&pk="+pk;
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<link rel="stylesheet" type="text/css" href="css/suggest.css">
<script language="javascript" src="js/pub.js"></script>
<script language="javascript" src="js/suggest.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" >
	<span id="tips"></span>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
				������ļ�
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="��׼" onClick="approve()" >
	<input type="button" class="btbox" value="����" onclick="reject()">
	<input type="button" class="btbox" value="����" onclick="download()" >
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action="knowdo.do?method=query&path=know_submit_query.jsp" method="post">
		<fieldset>
			<legend>��ѯ����</legend>		
			<%
			 	Know query_condition = (Know) request.getAttribute("query_condition");
			 %>		
				<table align="center"  cellpadding="1" cellspacing="0" border="0">
					<tr>
					<td nowrap="nowrap">�ؼ���</td>
					<td>
					<input type="text" id="title" name="title" value="<%=query_condition.getTitle()%>" size="55" ondblclick="clear_condition(this)" onkeyup="sendRequest('know_submit_query.jsp')" onclick="hiddenSuggest()" >
					</td>
					<td>
					<input type="hidden" name="sort"  value="<%=query_condition.getSort()%>">
					<input type="hidden" name="sortType"  value="<%=query_condition.getSortType()%>">		
					</td>
					</tr>
					<tr><td></td><td>
					<div id="suggest" style="display:none;width:100%" ></div>
					<IFRAME id="frame1" style="display:none;width:100%;height:24px;position:absolute;z-index:0;" frameborder="0" marginheight="0" marginwidth="0">      
       				</IFRAME>  
					</td><td></td></tr>
					<tr>
						<td nowrap="nowrap">
						�ϴ���
						</td>
						<td nowrap="nowrap">
						<input type="text" id="upload_person" name="upload_person" value="<%=query_condition.getUpload_person()%>" size="20" ondblclick="clear_condition(this)" >
					<%
						Map<String,String> know_type = Const.getEnumMap().get("know_type");			
					%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
						<select name="type" size="1" onchange="query()">
						<option value="" />---��ѡ��---
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
						</select></td><td align="right">&nbsp;&nbsp;
						<input type="submit" value="��ѯ" class="btbox" >
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
					<input type="radio"  name="pageSize" value="8" <%=query_condition.getPageSize()==8?"checked='checked'":"" %> onclick="query()">8
					<input type="radio"  name="pageSize" value="10" <%=query_condition.getPageSize()==10?"checked='checked'":"" %> onclick="query()">10
					<input type="radio"  name="pageSize" value="15" <%=query_condition.getPageSize()==15?"checked='checked'":"" %> onclick="query()">15
					<input type="radio"  name="pageSize" value="20" <%=query_condition.getPageSize()==20?"checked='checked'":"" %> onclick="query()">20
			</legend>					
					<%
						List<Know> list = (List<Know>) request.getAttribute("know_query_result");
						String path = application.getRealPath("/")+"WEB-INF\\file";
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" id="tableData"  >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th width="30">&nbsp;</th>
						<th width="25"><input  type="checkbox"  onclick="selectAll(this)"></th>
						<th id="title"  onclick="sort(this)"><a style="CURSOR:hand">�ļ�����<span id='title_gif'></span></a></th>
						<th id="type" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">����<span id='type_gif'></span></a></th>
						<th id="upload_person" onclick="sort(this)" nowrap="nowrap" ><a style="CURSOR:hand">�ϴ���<span id='upload_person_gif'></span></a></th>
						<th id="upload_time" onclick="sort(this)" nowrap="nowrap" ><a style="CURSOR:hand">�ϴ�ʱ��<span id='upload_time_gif'></span></a></th>
						<th id="last_update_time" onclick="sort(this)" nowrap="nowrap" ><a style="CURSOR:hand">������ʱ��<span id='last_update_time_gif'></span></a></th>
					</tr>
					<%
					Know view = null;
					String suffixPath = application.getRealPath("/")+"images/suffix";	
					java.io.File file = new java.io.File(suffixPath);
					java.io.File[] files = file.listFiles();
					for(int i=0;i<list.size();i++){
						view = (Know) list.get(i);
				%>
					<tr id="line<%=i %>" >
					<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=view.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td id="<%=i%>" onclick="clickLine(this)" title="����鿴��ϸ">
						<%
							String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
		
							//�ú�׺�ں�׺�����Ƿ���ڣ�Ĭ��ΪFALSE
							boolean isExist = false;
						    for (int j = 0; j < files.length; j++) {	   
			   				if (files[j].isFile()) {
			    			if(files[j].getName().startsWith(suffix)){
			    				isExist = true;
			    				break;
			    			}
			    			}
							}
						  //�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
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
							<%=know_type.get(view.getType())%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getUpload_person()%>&nbsp;
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getUpload_time()%>&nbsp;
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getLast_update_time()%>&nbsp;
						</td>			
					</tr>

					<%
					}
					//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
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
			<form name="public_info" action="knowdo.do?method=query&path=know_submit_query.jsp" method="post" >
					<input type="hidden" name="sort" value=<%=query_condition.getSort()%>>
					<input type="hidden" name="sortType" value=<%=query_condition.getSortType()%>>
					<input type="hidden" name="title" value=<%=query_condition.getTitle()%>>
					<input type="hidden" name="type" value=<%=query_condition.getType()%>>
					<input type="hidden" name="upload_person" value=<%=query_condition.getUpload_person()%>>
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
