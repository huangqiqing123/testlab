<%if (Tool.isNotLogin(request)) {
				request.getRequestDispatcher("no_login.jsp").forward(request,
						response);
				return;
			}%>
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
<%@page import="cn.sdfi.cases.bean.Case"%><html>
	<head>
		<title>�ҵİ�����</title>
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
				alert("������ѡ��һ����¼!");
				return;
			}
			document.form2.action = "casedo.do?method=approve";
			document.form2.submit();
		}
	}
	// ����
	function back() {
		if(status_check('back')){	
			document.form2.action = "casedo.do?method=back";
			document.form2.submit();
		}
	}
	//�޸�
	function update() {	
		var count = 0;
		var obj = document.getElementsByName("pk");
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count !=1 ) {
			$('tips').innerHTML = "<font color='red'>��ѡ��һ����¼!</font>";
		} else {
			document.form2.action = "casedo.do?method=forupdate&path=case_of_myself.jsp";
			document.form2.submit();
		}
	}
	// ɾ��
	function del() {
		var count = 0;
		var obj = document.getElementsByName("pk");
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
			}
		}
		if (count == 0) {
			$('tips').innerHTML = "<font color='red'>��ѡ��Ҫɾ���ļ�¼!</font>";
			return;
		} else {
			if (confirm('ȷ��ɾ��ѡ�м�¼���ļ�ɾ���󽫲��ָܻ���')) {
				document.form2.action = "casedo.do?method=delete&path=case_of_myself.jsp";
				document.form2.submit();
			}
		}
	}
	//�ж���ѡ��¼�Ƿ���"����"״̬��ֻ��"����"״̬�ļ�¼�ſ���ִ��"�ύ"������
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
				$('tips').innerHTML = "<font color='red'>��ѡ��Ҫ�ύ�ļ�¼!</font>";
				return canSubmit;
			}
			if (which == "back") {
				$('tips').innerHTML = "<font color='red'>��ѡ��Ҫ���صļ�¼!</font>";
				return canSubmit;
			}
		}
		//����Ajax����
		var req = getXmlHttpObject();
		var url = null;
		if (which == "back") {
			url = "casedo.do?method=isSubmitStatus" + temp;
		} else {
			url = "casedo.do?method=isSaveOrRejectStatus" + temp;
		}
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;

					//�����ѡ���ȫ����"������߲���"״̬�ļ�¼���򷵻�true����ʾ����ִ����Ӧ�Ĳ�����
					if (msg == "ok") {
						canSubmit = true;
					} else {
						if (which == "submit") {
							msg = "��¼{ " + msg + " }���Ǳ��桢����״̬������ִ���ύ������"
						} else if (which == "back") {
							msg = "��¼{ " + msg + " }���Ǵ����״̬������ִ�г��ز�����"
						}else {
							alert('��������Ч�Ĳ��� which=' + which);
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
	//�ύ
	function submit() {
		if (status_check('submit')) {
			document.form2.action = "casedo.do?method=submit";
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
		document.formQuery.action = "casedo.do?method=query&path=case_of_myself.jsp&pageSize="+pageSize;
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
	// �����Ķ�
	function onlineread() {
		var obj = document.getElementsByName("pk");
		if (obj != null) {
			var count = 0;
			var url = "online_read.jsp?path=case&pk=";
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked == true) {
					count++;
					url = url+obj[i].value;
				}
			}
			if (count != 1) {
				$('tips').innerHTML="<font color='red'>��ѡ��һ����¼��</font>";
				return;
			}
			window.showModalDialog(url,obj,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
		}
	}
	// ˫�������Ķ�
	function doubleClick(pk) {	
			var url = "online_read.jsp?path=case&pk="+pk;
			window.showModalDialog(url,null,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
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
		window.location.href="casedo.do?method=download&pk="+pk;
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin")%>" >
	<span id="tips"></span>
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
				�ҵİ�����
			</h2>
	</td>
	</tr>
	<tr>
	<td align="right">
	<input type="button" class="btbox" value="�ϴ�" onClick="window.location.href='case_add.jsp'" >
	<input type="button" class="btbox"	value="�ύ" onclick="submit()"> 
	<input type="button" class="btbox" value="����" onclick="back()" >
	<input type="button" class="btbox" value="�����Ķ�" onclick="onlineread()" >
	<input type="button" class="btbox" value="����" onclick="download()" >
	<input type="button" class="btbox" value="�޸�" onclick="update()">
	<input type="button" class="btbox" value="ɾ��" onclick="del()"> 
	</td>
	</tr>
	<tr>
	<td>
		<form name="formQuery" action="casedo.do?method=query&path=case_of_myself.jsp" method="post">
		<fieldset>
			<legend>��ѯ����</legend>
<%
 	Case query_condition = (Case) request.getAttribute("query_condition");
 %>
		<table align="center" title="˫���������ѯ������" cellpadding="1" cellspacing="0" border="0">
					<tr>
					<td nowrap="nowrap" colspan="2">
					�ؼ���
					<input type="text" id="title" name="title" value="<%=query_condition.getTitle()%>" size="55" ondblclick="clear_condition(this)" >
					<input type="hidden" name="sort"  value="<%=query_condition.getSort()%>">
					<input type="hidden" name="sortType"  value="<%=query_condition.getSortType()%>">
					</td>
					</tr>
					<tr>
					<td nowrap="nowrap" align="left">
					<%
						Map<String, String> case_type = Const.getEnumMap().get("case_type");
						Map<String, String> case_status = Const.getEnumMap().get("case_status");
					%>
						��&nbsp;&nbsp;&nbsp;��
						<select name="type" size="1" onchange="query()">
						<option value="" />---��ѡ��---
						<%
							for (Map.Entry<String, String> entry : case_type.entrySet()) {
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
						</select>
						</td>
						<td nowrap="nowrap" align="right">
						״̬
						<select name="status" size="1" onchange="query()">
						<option value="" />---��ѡ��---
						<%
							for (Map.Entry<String, String> entry : case_status.entrySet()) {
						%>
						<option value="<%=entry.getKey()%>" 
						<%
						if (query_condition.getStatus().equals(entry.getKey())) {
							out.print("selected=\"selected\"");
						}
						%>
						/>
						<%=entry.getValue()%>
						<%
							}
						%>
						</select>
						</td>			
						<td nowrap="nowrap" >
						&nbsp;&nbsp;&nbsp;
						<input type="submit" class="btbox" value="��ѯ" >
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
										List<Case> list = (List<Case>) request
												.getAttribute("case_query_result");
										String path = application.getRealPath("/") + "WEB-INF\\file";
									%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%"  >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th width="30">&nbsp;</th>
						<th width="25"><input  type="checkbox"  onclick="selectAll(this)"></th>
						<th id="title" width="400"   onclick="sort(this)"><a style="CURSOR:hand">�ļ�����<span id='title_gif'></span></a></th>
						<th id="status" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">״̬<span id='status_gif'></span></a></th>
						<th id="type" nowrap="nowrap" onclick="sort(this)" ><a style="CURSOR:hand">����<span id='type_gif'></span></a></th>
						<th id="last_update_time" onclick="sort(this)" nowrap="nowrap" ><a style="CURSOR:hand">������ʱ��<span id='last_update_time_gif'></span></a></th>
					</tr>
					<%
						Case view = null;
						String suffixPath = application.getRealPath("/") + "images/suffix";
						java.io.File file = new java.io.File(suffixPath);
						java.io.File[] files = file.listFiles();
						for (int i = 0; i < list.size(); i++) {
							view = (Case) list.get(i);
					%>
					<tr id="line<%=i%>" ondblclick="doubleClick('<%=view.getPk()%>')">
					<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i + 1%>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=view.getPk()%>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)" title="����鿴��ϸ">
						<a href="casedo.do?method=detail&pk=<%=view.getPk()%>" >
						<%
							String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".") + 1)).toLowerCase();

								//�ú�׺�ں�׺�����Ƿ���ڣ�Ĭ��ΪFALSE
								boolean isExist = false;
								for (int j = 0; j < files.length; j++) {
									if (files[j].isFile()) {
										if (files[j].getName().startsWith(suffix)) {
											isExist = true;
											break;
										}
									}
								}
								//�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
								if (!isExist) {
									suffix = "none";
								}
						%>
						<img src="images/suffix/<%=suffix%>.png"  border="0" align="middle"  alt="<%=view.getBlob_name()%>">
							<%=view.getBlob_name()%>
						</a>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							
							<%=case_status.get(view.getStatus())%>
							
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=case_type.get(view.getType())%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
							<%=view.getLast_update_time()%>&nbsp;
						</td>
					</tr>

					<%
						}
						//�������һҳ�����⴦����������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
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
			<!-- �˴�form�������д method="post" ��������� -->
			<form name="public_info" action="casedo.do?method=query&path=case_of_myself.jsp" method="post" >
					<input type="hidden" name="sort" value=<%=query_condition.getSort()%>>
					<input type="hidden" name="sortType" value=<%=query_condition.getSortType()%>>
					<input type="hidden" name="title" value=<%=query_condition.getTitle()%>>
					<input type="hidden" name="type" value=<%=query_condition.getType()%>>
					<input type="hidden" name="status" value=<%=query_condition.getStatus()%>>
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
	<script type="text/javascript">

	//����XMLHttpRequest����
	function getXmlHttpObject()
	{
	  var xmlHttp=null;
	  try
	    {
	    // Firefox, Opera 8.0+, Safari
	    xmlHttp=new XMLHttpRequest();
	    }
	  catch (e)
	    {
	    // Internet Explorer
	    try
	      {
	      xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
	      }
	    catch (e)
	      {
	      xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
	      }
	    }
	  return xmlHttp;
	}
	</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />			