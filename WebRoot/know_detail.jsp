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
		<title>文件信息明细</title>
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
			文件信息明细
		</h2>
		<div align="right">
		<%
		String path = request.getParameter("path");
		if("know_add.jsp".equals(path)){%>
			<input type="button" class="btbox" value="继续上传" onClick="window.location.href='know_add.jsp'" >
		<%}%>
		<input type="button" class="btbox" value="在线阅读" onclick="onlineread()" >
		<input type="button" class="btbox" value="下载" onclick="download()" >
		<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap" align="right">文件名称:</td>
		<td>		
		<%
		String suffixPath = application.getRealPath("/")+"images/suffix";	
		java.io.File file = new java.io.File(suffixPath);
		java.io.File[] files = file.listFiles();
		String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
	
		//该后缀在后缀库中是否存在，默认为FALSE
		boolean isExist = false;
			  for (int j = 0; j < files.length; j++) {	   
			    if (files[j].isFile()) {
			    	if(files[j].getName().startsWith(suffix)){
			    		isExist = true;
			    		break;
			    	}
			     }
		}
		if(!isExist){//如果当前文件后缀在后缀库中不存在，则显示默认图标。
			suffix = "none";
		}
		%>
		<a title="点击下载" style="CURSOR:hand" onclick="window.location.href='knowdo.do?method=download&pk=<%=view.getPk() %>'">	
		<img src="images/suffix/big/<%=suffix%>.png" border="0" >
		<u>
		<%=view.getBlob_name() %>
		</u>
		</a>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">类型:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=know_type.get(view.getType())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">状态:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=know_status.get(view.getStatus())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">关键字:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getTitle() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">版本:</td>
		<td nowrap="nowrap">
		<input type="text" name="version"  size="50" maxlength="25" 
		value="<%=view.getVersion() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">页数:</td>
		<td nowrap="nowrap">
		<input type="text" name="pages"  size="50" maxlength="25" 
		value="<%=view.getPages() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">上传者:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_person() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">上传时间</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_time() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">最后更新时间:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getLast_update_time() %>"
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"> 
	</tr>
	
	<tr>
		<td nowrap="nowrap" align="right">备注:</td>
		<td><textarea id="memo" name="memo" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getMemo()==null?"":view.getMemo() %></textarea>
		</td>
	</tr>
</table>
</body>
<script type="text/javascript">
//返回XMLHttpRequest对象
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

	//检查所选文件是否可以在线阅读
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
						$('tips').innerHTML = "<font color='red'>Sorry，该文件暂不能在线阅读，请下载至本地后进行查看！</font>";
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return canOnlineRead;
	}
	// 在线阅读
	function onlineread() {
		var pk = '<%=view.getPk()%>';
		if(canOnLineRead(pk)){
			var url = "online_read.jsp?path=know&pk="+pk;
			window.showModalDialog(url,null,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
			}
		}
		//下载
		function download() {
			window.location.href="knowdo.do?method=download&pk=<%=view.getPk()%>";
		}
		</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
