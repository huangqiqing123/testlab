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
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>

<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="cn.sdfi.user.bean.User"%><html>
	<head>
		<title>��Ϣ��ϸ</title>
	<base target="_self"> <!--��ͨ�ð����У�ִ���µĲ�������Ȼ��ͨ�ð�������ʾ�������ᵯ���µĴ���  -->
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
		<script type="text/javascript">

		// ִ�и��²���
		function forupdate() {
			document.forms[0].action = "userdo.do?method=forupdate";
			document.forms[0].submit();
		}

		//����رհ�ť
		function close_window() {
			window.returnValue = null;
			window.close();
		}

		//����Ajax���󵽷�������ִ��ɾ��������
		function del() {

			if (!confirm('ȷ��ɾ��ѡ�м�¼����¼ɾ���󽫲��ָܻ���')) {		
				return;
			}
			var req = getXmlHttpObject();
			var value = $('pk').value;
			var url = "userdo.do?method=delete&pk="+value+"&path=user_detail.jsp";
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
	User user = (User) request.getAttribute("user.view");
	%>
	<%
	Map<String,String> user_role = Const.getEnumMap().get("user_role");
	%>

		<div align="right" ><br>
		<input type="button" value="�޸�" class="btbox" onclick="forupdate()"  >
		<input type="button" value="ɾ��" class="btbox" onclick="del()" >
		<input type="button" class="btbox" value="�ر�" onclick="close_window()">
		</div>

	<fieldset>
		<legend>�û���Ϣ��ϸ</legend>
		<form name="form1" action="" method="post">
			<input type="hidden" name="pk" value="<%=URLEncoder.encode(user.getWho(),"GBK") %>">
		</form>
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				<tr>
						<td>
							Ա������
						</td>
						<td>
							<input type="text"  value="<%=user.getWho() %>" size="30" maxlength="10"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
				<tr>
						<td nowrap="nowrap">
							��¼�û���
						</td>
						<td>
							<input type="text"  value="<%=user.getUsername() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
					</tr>
					
					<tr>
						<td>
							�Ա�
						</td>
						<td>
						<input type="text"  value="<%=user.getSex() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
						</td>
					</tr>
					<tr>
						<td>
							��ɫ
						</td>
						<td>
				<input type="text"  value="<%=user_role.get(user.getMylevel()) %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
					</td>
					</tr>
					<tr>
						<td>
							Ƥ��
						</td>
						<td>
							<img src="images\\skins\\<%=user.getSkin() %>" id="skin_img" width="150" height="100" >							
					</tr>
					<tr>
						<td nowrap="nowrap">
							��ְʱ��
						</td>
						<td>
						<input type="text"  value="<%=user.getEntry_time()==null?"":user.getEntry_time() %>" size="30" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
					<td nowrap="nowrap" >��ע</td>
					<td >
						<textarea id="memo" name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=user.getMemo()==null?"":user.getMemo() %></textarea>
					</td>
					</tr>
				</table>
				</fieldset>
	</body>
</html>

