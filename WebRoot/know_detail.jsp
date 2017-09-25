<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.know.bean.Know"%><html>
	<head>
		<title>�ļ���Ϣ��ϸ</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
	Know view = (Know) request.getAttribute("know.view");
	Map<String,String> know_type = Const.getEnumMap().get("know_type");
	Map<String,String> know_status = Const.getEnumMap().get("know_status");
	%>
		<h2 align="center">
			�ļ���Ϣ��ϸ
		</h2>
		<div align="right">
		<%
		String path = request.getParameter("path");
		if("know_add.jsp".equals(path)){%>
			<input type="button" class="btbox" value="�����ϴ�" onClick="window.location.href='know_add.jsp'" >
		<%}%>
		<input type="button" class="btbox" value="�����Ķ�" onclick="onlineread()" >
		<input type="button" class="btbox" value="����" onclick="download()" >
		<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap" align="right">�ļ�����:</td>
		<td>		
		<%
		String suffixPath = application.getRealPath("/")+"images/suffix";	
		java.io.File file = new java.io.File(suffixPath);
		java.io.File[] files = file.listFiles();
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
		if(!isExist){//�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
			suffix = "none";
		}
		%>
		<a title="�������" style="CURSOR:hand" onclick="window.location.href='knowdo.do?method=download&pk=<%=view.getPk() %>'">	
		<img src="images/suffix/big/<%=suffix%>.png" border="0" >
		<u>
		<%=view.getBlob_name() %>
		</u>
		</a>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">����:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=know_type.get(view.getType())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">״̬:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=know_status.get(view.getStatus())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�ؼ���:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getTitle() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�汾:</td>
		<td nowrap="nowrap">
		<input type="text" name="version"  size="50" maxlength="25" 
		value="<%=view.getVersion() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">ҳ��:</td>
		<td nowrap="nowrap">
		<input type="text" name="pages"  size="50" maxlength="25" 
		value="<%=view.getPages() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�ϴ���:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_person() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�ϴ�ʱ��</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_time() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">������ʱ��:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getLast_update_time() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	
	<tr>
		<td nowrap="nowrap" align="right">��ע:</td>
		<td><textarea id="memo" name="memo" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getMemo()==null?"":view.getMemo() %></textarea>
		</td>
	</tr>
</table>
</body>
<script type="text/javascript">
//����XMLHttpRequest����
function getXmlHttpObject() {
	var xmlHttp = null;
	try {
		// Firefox, Opera 8.0+, Safari
		xmlHttp = new XMLHttpRequest();
	} catch (e) {
		// Internet Explorer
		try {
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	return xmlHttp;
}

	//�����ѡ�ļ��Ƿ���������Ķ�
	function canOnLineRead(pk) {
		var canOnlineRead = false;
		var req = getXmlHttpObject();
		var url = "knowdo.do?method=canOnlineRead&pk=" + pk;
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;
					if (msg == "ok") {
						canOnlineRead = true;
					} else {
						$('tips').innerHTML = "<font color='red'>Sorry�����ļ��ݲ��������Ķ��������������غ���в鿴��</font>";
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return canOnlineRead;
	}
	// �����Ķ�
	function onlineread() {
		var pk = '<%=view.getPk()%>';
		if(canOnLineRead(pk)){
			var url = "online_read.jsp?path=know&pk="+pk;
			window.showModalDialog(url,null,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
			}
		}
		//����
		function download() {
			window.location.href="knowdo.do?method=download&pk=<%=view.getPk()%>";
		}
		</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
