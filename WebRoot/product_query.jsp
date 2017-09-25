<%
	//首先判断该用户是否已登录
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
		<title>产品信息管理</title>
<script type="text/javascript">

//返回XMLHttpRequest对象
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
//判断所选记录是否已被引用，只有未被引用的记录才可以删除。
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
			$('tips').innerHTML = "<font color='red'>请选择要删除的记录!</font>";
			return canDel;
	}
	//发送Ajax请求
	var req = getXmlHttpObject();
	var url = "productdo.do?method=isInUse" + temp;
	req.onreadystatechange = function() {
		if (req.readyState == 4) {
			if (req.status == 200) {
				var msg = req.responseText;

				//如果所选择的全部是"未被引用"状态的记录，则返回true，表示可以执行删除操作。
				if (msg == "ok") {
					canDel = true;
				} else {
					msg = "记录{ " + msg + " }已经被引用，不能删除！"
					$('tips').innerHTML = "<font color='red'>" + msg + "</font>";
				}
			}
		}
	};
	req.open("POST", url, false);
	req.send(null);
	return canDel;
}
//新增
function add() {
	var url = "product_add.jsp";
	var returnValue = window.showModalDialog(url, null,	"scroll:yes;status:no;toolbar:no;dialogWidth:600px;dialogHeight:300px");
	//if (returnValue == "refresh") {
		//query();
	//}
}

// 执行查询明细
function detail() {
	var obj = document.getElementsByName("pk");
	if (obj != null) {
		var count = checkedNumber(obj);
		if (count != 1) {
			$('tips').innerHTML = "<font color='red'>请选择一条记录!</font>";
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
// 执行更新操作
function update() {
	var obj = document.getElementsByName("pk");
	if (obj != null) {
		var count = checkedNumber(obj);
		if (count != 1) {
			$('tips').innerHTML = "<font color='red'>请选择一条记录!</font>";
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

// 执行删除操作
function del() {
	if(canDel()){
		if (confirm('确认删除选中记录？记录删除后将不能恢复！')) {
			document.form2.action = "productdo.do?method=delete";
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
				产品信息维护
			</h2>
	</td>
	</tr>
	<tr>
		<td align="right">
	<input type="button" class="btbox" value="增加" onclick="add()" 
		<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
%>>
	<input type="button" class="btbox" value="修改" onclick="update()"  
	<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
%>>
	<input type="button" class="btbox" value="删除" onclick="del()"  
	<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
%>>
	<input type="button" class="btbox" value="明细" onclick="detail()"  >
	</td>
	</tr>
	<tr>
	<td>
			<form name="formQuery" action="productdo.do?method=query" method="post">
			<fieldset><legend>查询条件</legend>
			<%
			//查询条件
			Product query_condition = (Product)request.getAttribute("query_condition");
			String sort=query_condition.getSort();
			String sortType=query_condition.getSortType();
			String name=query_condition.getName();
			String dept=query_condition.getDept();
			int pageSize = query_condition.getPageSize();
			
			%>
				<table align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td nowrap="nowrap" >产品名称
							<input type="text" name="name"  size="20" maxlength="32" value="<%=name==null?"":name %>"  ondblclick="clear_condition(this)">
							<input type="hidden" name="sort"  value="<%=sort==null?"code":sort %>">
							<input type="hidden" name="sortType"  value="<%=sortType==null?"ASC":sortType %>">
						</td>
						<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;所属部门
						<select name="dept"  size="1" onchange="query()">
						<option value="" />---请选择---
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
						<input type="submit" class="btbox" value="查询" >
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
					List<Product> list = (List<Product>) request.getAttribute("product_query_result");
				%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" >
					<!-- 表头信息 -->
					<tr>
						<th width="25">&nbsp;</th>
						<th width="25" align="left"><input type="checkbox"  onclick="selectAll(this)"></th>
						<th width="100" nowrap="nowrap" onclick="sort(this)" id="sortCode" ><label style="CURSOR:hand">排序序号<span id='sortCode_gif'></span></label></th>
						<th width="500"  onclick="sort(this)" id="name"><label style="CURSOR:hand">产品名称<span id='name_gif'></span></label></th>
						<th nowrap="nowrap" onclick="sort(this)" id="dept"><label  style="CURSOR:hand">所属部门<span id='dept_gif'></span></label></th>
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
			<form name="public_info" action="productdo.do?method=query" method="post" onsubmit="false">
					<input type="hidden" name="sort" value=<%=sort%>>
					<input type="hidden" name="sortType" value=<%=sortType%>>
					<input type="hidden" name="name" value=<%=name%>>
					<input type="hidden" name="dept" value=<%=dept%>>
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