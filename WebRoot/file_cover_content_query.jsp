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
		<title>�ļ���Ϣ����</title>
<script type="text/javascript">
	// ִ�в�ѯ��ϸ
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
				alert("��ѡ��һ����¼!");
				return;
			}
			document.form2.action = "filecovercontentdo.do?method=detail";
			document.form2.submit();
		}
	}
	function update() {
		var obj = document.getElementsByName("pk");
		// ����ʱ,��ѡ��ļ�¼������У��
		if (obj != null) {
			var count = 0;
			for (i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
				}
			}
			if (count != 1) {
				alert("��ѡ��һ����¼!");
				return;
			}

			document.form2.action = "file_cover_content_update.jsp";
			document.form2.submit();
		}
	}
	// ִ��ɾ������
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
				alert("��ѡ��Ҫɾ���ļ�¼!!");
				return;
			}
			if (confirm('ȷ��ɾ��ѡ�м�¼���ļ�ɾ���󽫲��ָܻ���')) {
				document.form2.action = "filecovercontentdo.do?method=delete";
				document.form2.submit();
			}
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
		document.formQuery.action = "filecovercontentdo.do?method=query&pageSize="+pageSize;
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
	//����Excel
	function exportExcel() { 
		if ($('recordCount').value > 65535) {
			alert("һ�������ɵ���65534�м�¼����ǰ���������ļ�¼��Ϊ"+$('recordCount').value+"!");
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
				�ļ���Ϣ����
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="����" onClick="window.location.href='file_cover_content_add.jsp'"  <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="��excel����" onClick="window.location.href='file_cover_content_import.jsp'"  <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="�޸�" onclick="update()" <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>>
	<input type="button" class="btbox" value="ɾ��" onclick="del()" <%
	if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
		out.print("disabled=\"disabled\" ");
	}
	%>> 
	<input type="button" class="btbox" value="��ϸ" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action = "filecovercontentdo.do?method=query" method="post">
		<fieldset>
			<legend>��ѯ����</legend>		
		<%
			//��ѯ����
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
					��&nbsp;��&nbsp;��&nbsp;&nbsp;
					<input type="text" id="fk_show" name="fk_show" value="<%=fk_show%>" size="50"  ondblclick="clear_condition_fk()"   readonly="readonly">
					<input type="hidden" id="condition_fk" name="fk" value="<%=fk%>" ><!-- ������-��������� -->
					<input type="button" class="btbox" value="ѡ��..." onclick="show_help_window()">
					</td>
					</tr>
					<tr>
						<td nowrap="nowrap">
							�ļ����
							<input type="text" id="condition_code" name="file_cover_content_code" size="25" maxlength="32" value="<%=code %>"  ondblclick="clear_condition(this)" >
							<input type="hidden" name="sort"  value="<%=sort == null ? "code" : sort%>">
							<input type="hidden" name="sortType"  value="<%=sortType == null ? "ASC" : sortType%>">
						</td>
						<td></td>
					
						<td nowrap="nowrap">
						�ļ�����
						<input type="text" id="condition_name" name="file_cover_content_name" size="25" maxlength="50" value="<%=name %>"  ondblclick="clear_condition(this)">
						</td>
						<td></td>
						<td nowrap="nowrap">
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
						List<FileCoverContent> list = (List<FileCoverContent>) request.getAttribute("file_cover_content_query_result");
						String path = application.getRealPath("/")+"WEB-INF\\document";
					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" id="tableData"  >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th id="file_cover_content_code" onclick="sort(this)" nowrap="nowrap" width="120"><a style="CURSOR:hand">�ļ����<span id='file_cover_content_code_gif'></span></a></th>
						<th id="file_cover_content_name" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">�ļ�����<span id='file_cover_content_name_gif'></span></a></th>
						<th id="version" onclick="sort(this)" nowrap="nowrap" ><a style="CURSOR:hand">�汾<span id='version_gif'></span></a></th>
						<th id="pages" onclick="sort(this)" nowrap="nowrap"><a style="CURSOR:hand">ҳ��<span id='pages_gif'></span></a></th>
						<th align="center">����</th>
					</tr>
					<%
					String suffixPath = application.getRealPath("/")+"images/suffix";//�ļ���׺ͼ����·��
					String suffixs[] = Tool.getFileNames(suffixPath);//��ȡ���к�׺����
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
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)" title="�����ſ��Բ鿴��ϸ">
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
		
		//������ļ����ڸ���
		if(filenames.length>0){
			
			//�ú�׺�ں�׺�����Ƿ���ڣ�Ĭ��ΪFALSE
			String ext = filenames[0].substring( filenames[0].lastIndexOf(".")+1);//��ȡ�ļ���׺
			boolean isExist = false;
			for(int j=0;j<suffixs.length;j++){
				    if (suffixs[j].startsWith(ext)) {
				    		isExist = true;
				    		break;
				     }
			}//�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
			if(!isExist){
				ext = "none";
			}	
			String newfilename = file_cover_content.getFile_cover_content_name()+"."+ext;//��װ�µ��ļ�����	
		%>		
		<u title="<%=newfilename %>" style="CURSOR:hand" onclick="window.location.href='filecovercontentdo.do?method=download&pk=<%=file_cover_content.getPk() %>'"><img src="images/suffix/<%=ext%>.png" border="0" ></u>
		<%
		}else{ out.println("��"); }%>
						</td>
					</tr>

					<%
					}
					//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
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
			<!-- �˴�form�������д method="post" ��������� -->
			<form name="public_info" action="filecovercontentdo.do?method=query" method="post" >
					<input type="hidden" name="sort" value=<%=sort%>>
					<input type="hidden" name="fk" value=<%=fk%>>
					<input type="hidden" name="fk_show" value=<%=fk_show%>>
					<input type="hidden" name="sortType" value=<%=sortType%>>
					<input type="hidden" name="file_cover_content_code" value=<%=code%>>
					<input type="hidden" name="file_cover_content_name" value=<%=name%>>
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

		//����б�ͷ��������ʱ�������ͷͬ���޸�
		document.getElementById("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>"; 

		//��ʾͨ�ð���
		function show_help_window() { 
			var url = "filecoverdo.do?method=query&path=help";
			var obj = new Object();
			var returnValue = window.showModalDialog(url,obj,"scroll:yes;status:no;dialogWidth:750px;dialogHeight:520px");
			
			//����رհ�ť������null
			if (returnValue == null) {
				return;
			}
			else// ����ǵ�����ǡ�ȷ����
			{
			document.getElementById("fk").value=returnValue[0];
			document.getElementById("fk_show").value=returnValue[1]+"("+returnValue[2]+")";
			query();
			}
	}  
		
		//˫���������ѯ����
		function clear_condition_fk(){
			document.getElementById("condition_fk").value="";
			document.getElementById("fk_show").value="";
			}
		</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />			
