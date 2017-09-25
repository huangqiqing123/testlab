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
<%@page import="cn.sdfi.cases.bean.Case"%><html>
	<head>
		<title>案例信息明细</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
	Case view = (Case) request.getAttribute("case.view");
	Map<String,String> case_type = Const.getEnumMap().get("case_type");
	Map<String,String> case_status = Const.getEnumMap().get("case_status");
	%>
		<h2 align="center">
			案例信息明细
		</h2>
		<div align="right">
		<%
		String path = request.getParameter("path");
		if("case_add.jsp".equals(path)){%>
			<input type="button" class="btbox" value="继续上传" onClick="window.location.href='case_add.jsp'" >
		<%}%>
		<input type="button" class="btbox" value="在线阅读" onclick="onlineread()" >
		<input type="button" class="btbox" value="下载" onclick="download()" >
		<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td align="right" nowrap="nowrap">文件名称</td>
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
		<a title="点击下载" style="CURSOR:hand" onclick="window.location.href='casedo.do?method=download&pk=<%=view.getPk() %>'">	
		<img src="images/suffix/big/<%=suffix%>.png" border="0" >
		<u>
		<%=view.getBlob_name() %>
		</u>
		</a>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">类型:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=case_type.get(view.getType())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">状态:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=case_status.get(view.getStatus())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">关键字:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getTitle() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">版本:</td>
		<td nowrap="nowrap">
		<input type="text" name="version"  size="50" maxlength="25" 
		value="<%=view.getVersion() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">上传者:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_person() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">上传时间:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_time() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">最后更新时间:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getLast_update_time() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">摘要:</td>
		<td><textarea id="summary" name="summary" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getSummary() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap" >详细描述:</td>
		<td><textarea id="detail" name="detail" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getDetail() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">分析过程:</td>
		<td><textarea id="analyze" name="analyze" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly" onclick="this.blur()"><%=view.getAnalyze() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">解决方案:</td>
		<td><textarea id="solve" name="solve" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getSolve() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">结果:</td>
		<td><textarea id="result" name="result" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly" onclick="this.blur()"><%=view.getResult() %></textarea>
		</td>
	</tr>
</table>
</body>
	<script type="text/javascript">
		// 在线阅读
		function onlineread() {
			var url = "online_read.jsp?path=case&pk=<%=view.getPk()%>";
			window.showModalDialog(url,null,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
		}
		//下载
		function download() {
			window.location.href="casedo.do?method=download&pk=<%=view.getPk()%>";
		}
		</script>
	
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
