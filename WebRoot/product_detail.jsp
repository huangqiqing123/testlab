<%
	//首先判断该用户是否已登录
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
	boolean isSuperadmin = Tool.isSuperadmin(request);
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>

<%@page import="cn.sdfi.product.bean.Product"%><html>
	<head>
		<title>产品信息明细</title>
	<base target="_self"> <!--在通用帮助中，执行新的操作后，仍然在通用帮助中显示，而不会弹出新的窗口  -->
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
		<script type="text/javascript">

		// 执行更新操作
		function forupdate() {
			document.forms[0].action = "productdo.do?method=forupdate";
			document.forms[0].submit();
		}

		//点击关闭按钮
		function close_window() {
			window.returnValue = null;
			window.close();
		}
		//判断所选记录是否已被引用，只有未被引用的记录才可以删除。
		function canDel() {
			var canDel = false;
			var req = getXmlHttpObject();
			var url = "productdo.do?method=isInUse&pk="+$('pk').value;
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						var msg = req.responseText;

						//如果当前记录是"未被引用"状态的记录，则返回true，表示可以执行删除操作。
						if (msg == "ok") {
							canDel = true;
						} else {
							msg = "当前记录{ " + msg + " }已经被引用，不能删除！"
							$('tips').innerHTML = "<font color='red'>" + msg + "</font>";
						}
					}
				}
			};
			req.open("POST", url, false);
			req.send(null);
			return canDel;
		}
		//发送Ajax请求到服务器，执行删除操作。
		function del() {
			if(canDel()){
				if (confirm('确认删除选中记录？记录删除后将不能恢复！')) {
					var req = getXmlHttpObject();
					var value = $('pk').value;
					var url = "productdo.do?method=delete&pk="+value+"&path=product_detail.jsp";
					req.onreadystatechange = function(){
					if (req.readyState == 4) {
						if (req.status == 200) {		
							var msg = req.responseText;
							alert(msg);
							window.close();
						}
					}
					};
					req.open("POST", url, false);
					req.send(null);
				}
				}			
		}
		
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
		</script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
 <%
 	/*
 	*如果通过include引入alert页面的话，在IE8下，再次点击【修改】时，会弹出新的窗口。
 	*补充说明：在IE6下是始终正常的。
 	*/
	Object msg = request.getAttribute("msg");
 	if (msg != null&&(!"".equals(msg.toString()))) {
 		out.println("<script type=\"text/javascript\">");
 		out.println("document.getElementById('tips').innerHTML=\"<font color='red'>"+msg+"</font>\";");
 		out.print("</script>");
 	}
 %> 
	<%
	Product product = (Product) request.getAttribute("product.view");
	Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
	%>

		<div align="right" ><br>
		<input type="button" value="修改" class="btbox" onclick="forupdate()"  
		<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
		%>>
		<input type="button" value="删除" class="btbox" onclick="del()" 
		<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
		%>>
		<input type="button" class="btbox" value="关闭" onclick="close_window()">
		</div>

	<fieldset>
		<legend>产品信息明细</legend>
		<form name="form1" action="" method="post">
			<input type="hidden" name="pk" value="<%=product.getPk() %>">
		</form>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							产品名称
						</td>
						<td>
							<input type="text"  value="<%=product.getName() %>" size="30" maxlength="10"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							排序序号
						</td>
						<td>
							<input type="text"  value="<%=product.getSortCode() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
					</tr>
					
					<tr>
						<td>
							所属部门
						</td>
						<td>
						<input type="text"  value="<%=project_customers.get(product.getDept()) %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">		
						</td>
					</tr>
				</table>
				</fieldset>
	</body>
</html>

