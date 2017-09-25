<%
	//�����жϸ��û��Ƿ��ѵ�¼
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
		<title>��Ʒ��Ϣ��ϸ</title>
	<base target="_self"> <!--��ͨ�ð����У�ִ���µĲ�������Ȼ��ͨ�ð�������ʾ�������ᵯ���µĴ���  -->
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
		<script type="text/javascript">

		// ִ�и��²���
		function forupdate() {
			document.forms[0].action = "productdo.do?method=forupdate";
			document.forms[0].submit();
		}

		//����رհ�ť
		function close_window() {
			window.returnValue = null;
			window.close();
		}
		//�ж���ѡ��¼�Ƿ��ѱ����ã�ֻ��δ�����õļ�¼�ſ���ɾ����
		function canDel() {
			var canDel = false;
			var req = getXmlHttpObject();
			var url = "productdo.do?method=isInUse&pk="+$('pk').value;
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						var msg = req.responseText;

						//�����ǰ��¼��"δ������"״̬�ļ�¼���򷵻�true����ʾ����ִ��ɾ��������
						if (msg == "ok") {
							canDel = true;
						} else {
							msg = "��ǰ��¼{ " + msg + " }�Ѿ������ã�����ɾ����"
							$('tips').innerHTML = "<font color='red'>" + msg + "</font>";
						}
					}
				}
			};
			req.open("POST", url, false);
			req.send(null);
			return canDel;
		}
		//����Ajax���󵽷�������ִ��ɾ��������
		function del() {
			if(canDel()){
				if (confirm('ȷ��ɾ��ѡ�м�¼����¼ɾ���󽫲��ָܻ���')) {
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
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
 <%
 	/*
 	*���ͨ��include����alertҳ��Ļ�����IE8�£��ٴε�����޸ġ�ʱ���ᵯ���µĴ��ڡ�
 	*����˵������IE6����ʼ�������ġ�
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
		<input type="button" value="�޸�" class="btbox" onclick="forupdate()"  
		<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
		%>>
		<input type="button" value="ɾ��" class="btbox" onclick="del()" 
		<%
		if (!isSuperadmin) {
			out.print("disabled=\"disabled\" ");
		}
		%>>
		<input type="button" class="btbox" value="�ر�" onclick="close_window()">
		</div>

	<fieldset>
		<legend>��Ʒ��Ϣ��ϸ</legend>
		<form name="form1" action="" method="post">
			<input type="hidden" name="pk" value="<%=product.getPk() %>">
		</form>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							��Ʒ����
						</td>
						<td>
							<input type="text"  value="<%=product.getName() %>" size="30" maxlength="10"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							�������
						</td>
						<td>
							<input type="text"  value="<%=product.getSortCode() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
					</tr>
					
					<tr>
						<td>
							��������
						</td>
						<td>
						<input type="text"  value="<%=project_customers.get(product.getDept()) %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">		
						</td>
					</tr>
				</table>
				</fieldset>
	</body>
</html>

