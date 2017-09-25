<%
	//�����жϸ��û��Ƿ��ѵ�¼
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	boolean isSuperadmin = Tool.isSuperadmin(request);
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="java.util.Iterator"%>
<jsp:directive.page import="java.util.ArrayList"/>
<jsp:directive.page import="java.util.List"/>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.product.bean.Product"%><html>
	<head>
		<title>��Ʒ��Ϣ����</title>
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
//�ж���ѡ��¼�Ƿ��ѱ����ã�ֻ��δ�����õļ�¼�ſ���ɾ����
function canDel() {
	var count = 0;
	var canDel = false;
	var temp = "";
	var obj = document.getElementsByName("pk");
	for ( var i = 0; i < obj.length; i++) {
		if (obj[i].checked == true) {
			count++;
			temp = temp + "&pk=" + obj[i].value;
		}
	}
	if (count == 0) {
			$('tips').innerHTML = "<font color='red'>��ѡ��Ҫɾ���ļ�¼!</font>";
			return canDel;
	}
	//����Ajax����
	var req = getXmlHttpObject();
	var url = "productdo.do?method=isInUse" + temp;
	req.onreadystatechange = function() {
		if (req.readyState == 4) {
			if (req.status == 200) {
				var msg = req.responseText;

				//�����ѡ���ȫ����"δ������"״̬�ļ�¼���򷵻�true����ʾ����ִ��ɾ��������
				if (msg == "ok") {
					canDel = true;
				} else {
					msg = "��¼{ " + msg + " }�Ѿ������ã�����ɾ����"
					$('tips').innerHTML = "<font color='red'>" + msg + "</font>";
				}
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return canDel;
}
//����
function add() {
	var url = "product_add.jsp";
	var returnValue = window.showModalDialog(url, null,	"scroll:yes;status:no;toolbar:no;dialogWidth:600px;dialogHeight:300px");
	//if (returnValue == "refresh") {
		//query();
	//}
}

// ִ�в�ѯ��ϸ
function detail() {
	var obj = document.getElementsByName("pk");
	if (obj != null) {
		var count = checkedNumber(obj);
		if (count != 1) {
			$('tips').innerHTML = "<font color='red'>��ѡ��һ����¼!</font>";
			return;
		}
		var temp;
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				temp=i;
				break;
			}
		}
		var returnValue = window.showModalDialog("productdo.do?method=detail&pk="+obj[temp].value, null,"scroll:yes;status:no;dialogWidth:600px;dialogHeight:300px");
		//if (returnValue == "refresh") {
			//query();
		//}
	}
}
// ִ�и��²���
function update() {
	var obj = document.getElementsByName("pk");
	if (obj != null) {
		var count = checkedNumber(obj);
		if (count != 1) {
			$('tips').innerHTML = "<font color='red'>��ѡ��һ����¼!</font>";
			return;
		}
		var temp;
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				temp=i;
				break;
			}
		}
		var returnValue = window.showModalDialog("productdo.do?method=forupdate&pk="+obj[temp].value, null,"scroll:yes;status:no;dialogWidth:600px;dialogHeight:300px");
		//if (returnValue == "refresh") {
			//query();
		//}
	}
}

// ִ��ɾ������
function del() {
	if(canDel()){
		if (confirm('ȷ��ɾ��ѡ�м�¼����¼ɾ���󽫲��ָܻ���')) {
			document.form2.action = "productdo.do?method=delete";
			document.form2.submit();
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
		query();
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
		document.formQuery.action="productdo.do?method=query&pageSize="+pageSize;
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
				��Ʒ��Ϣά��
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="����" onclick="add()" 
		<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
%>>
	<input type="button" class="btbox" value="�޸�" onclick="update()"  
	<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
%>>
	<input type="button" class="btbox" value="ɾ��" onclick="del()"  
	<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
%>>
	<input type="button" class="btbox" value="��ϸ" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
			<form name="formQuery" action="productdo.do?method=query" method="post">
			<fieldset><legend>��ѯ����</legend>
			<%
			//��ѯ����
			Product query_condition = (Product)request.getAttribute("query_condition");
			String sort=query_condition.getSort();
			String sortType=query_condition.getSortType();
			String name=query_condition.getName();
			String dept=query_condition.getDept();
			int pageSize = query_condition.getPageSize();
			
			%>
				<table align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td nowrap="nowrap" >��Ʒ����
							<input type="text" name="name"  size="20" maxlength="32" value="<%=name==null?"":name %>"  ondblclick="clear_condition(this)">
							<input type="hidden" name="sort"  value="<%=sort==null?"code":sort %>">
							<input type="hidden" name="sortType"  value="<%=sortType==null?"ASC":sortType %>">
						</td>
						<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;��������
						<select name="dept"  size="1" onchange="query()">
						<option value="" />---��ѡ��---
				<%
				Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
				for (Map.Entry<String, String> entry : project_customers.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if (dept != null&&!"".equals(dept)) {
				if (dept.toString().trim().equals(entry.getKey())) {
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
						<td align="right" nowrap="nowrap">&nbsp;&nbsp;
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
					<input type="radio"  name="pageSize" value="8" <%=pageSize==8?"checked='checked'":"" %> onclick="query()">8
					<input type="radio"  name="pageSize" value="10" <%=pageSize==10?"checked='checked'":"" %> onclick="query()">10
					<input type="radio"  name="pageSize" value="15" <%=pageSize==15?"checked='checked'":"" %> onclick="query()">15
					<input type="radio"  name="pageSize" value="20" <%=pageSize==20?"checked='checked'":"" %> onclick="query()">20
			</legend>	
				<%
					List<Product> list = (List<Product>) request.getAttribute("product_query_result");
				%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- ��ͷ��Ϣ -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th width="100" nowrap="nowrap" onclick="sort(this)" id="sortCode" ><label style="CURSOR:hand">�������<span id='sortCode_gif'></span></label></th>
						<th width="500"  onclick="sort(this)" id="name"><label style="CURSOR:hand">��Ʒ����<span id='name_gif'></span></label></th>
						<th nowrap="nowrap" onclick="sort(this)" id="dept"><label  style="CURSOR:hand">��������<span id='dept_gif'></span></label></th>
					</tr>
				<%
					Product product = null;
					for(int i=0;i<list.size();i++){
						product = (Product) list.get(i);
				%>
					
					<tr id="line<%=i %>" >
						<td align="center" id="<%=i%>" onclick="clickLine(this)">
						<%=i+1 %>
						</td>
						<td>
						<input type="checkbox" id="checkbox<%=i%>" name="pk" value="<%=product.getPk() %>" onclick="changeBgColor(this)">
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<%=product.getSortCode()%>
						</td>
						<td nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<a href="#" onclick="window.showModalDialog('productdo.do?method=detail&pk=<%=product.getPk() %>', null,'scroll:yes;status:no;dialogWidth:600px;dialogHeight:300px');">
						<%=product.getName()%>
						</a>
						</td>
						<td  nowrap="nowrap" id="<%=i%>" onclick="clickLine(this)">
						<%=project_customers.get(product.getDept())%>
						</td>
										
					</tr>

					<%
					}
					//�������һҳ�����⴦��������һҳ�ļ�¼������ÿҳ��ʾ��¼��(pageSize)�����Կո����
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
			<form name="public_info" action="productdo.do?method=query" method="post" onsubmit="false">
					<input type="hidden" name="sort" value=<%=sort%>>
					<input type="hidden" name="sortType" value=<%=sortType%>>
					<input type="hidden" name="name" value=<%=name%>>
					<input type="hidden" name="dept" value=<%=dept%>>
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
document.getElementById("<%=sort%>_gif").innerHTML="<img src='images/<%=sortType%>.gif' align='middle'>";  
</script>
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />