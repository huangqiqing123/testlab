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
		<title>������Ϣ��ϸ</title>
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
			������Ϣ��ϸ
		</h2>
		<div align="right">
		<%
		String path = request.getParameter("path");
		if("case_add.jsp".equals(path)){%>
			<input type="button" class="btbox" value="�����ϴ�" onClick="window.location.href='case_add.jsp'" >
		<%}%>
		<input type="button" class="btbox" value="�����Ķ�" onclick="onlineread()" >
		<input type="button" class="btbox" value="����" onclick="download()" >
		<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td align="right" nowrap="nowrap">�ļ�����</td>
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
		<a title="�������" style="CURSOR:hand" onclick="window.location.href='casedo.do?method=download&pk=<%=view.getPk() %>'">	
		<img src="images/suffix/big/<%=suffix%>.png" border="0" >
		<u>
		<%=view.getBlob_name() %>
		</u>
		</a>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">����:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=case_type.get(view.getType())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">״̬:</td>
		<td align="left">
		<input type="text"   size="50" maxlength="50" 
		value="<%=case_status.get(view.getStatus())%>" 
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�ؼ���:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getTitle() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�汾:</td>
		<td nowrap="nowrap">
		<input type="text" name="version"  size="50" maxlength="25" 
		value="<%=view.getVersion() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�ϴ���:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_person() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�ϴ�ʱ��:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getUpload_time() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">������ʱ��:</td>
		<td nowrap="nowrap">
		<input type="text"   size="50" maxlength="50" 
		value="<%=view.getLast_update_time() %>"
		style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"> 
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">ժҪ:</td>
		<td><textarea id="summary" name="summary" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getSummary() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap" >��ϸ����:</td>
		<td><textarea id="detail" name="detail" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getDetail() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">��������:</td>
		<td><textarea id="analyze" name="analyze" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly" onclick="this.blur()"><%=view.getAnalyze() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">�������:</td>
		<td><textarea id="solve" name="solve" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly"  onclick="this.blur()"><%=view.getSolve() %></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">���:</td>
		<td><textarea id="result" name="result" cols="80" rows="10" 
		style="color: #6C6C6C" readonly="readonly" onclick="this.blur()"><%=view.getResult() %></textarea>
		</td>
	</tr>
</table>
</body>
	<script type="text/javascript">
		// �����Ķ�
		function onlineread() {
			var url = "online_read.jsp?path=case&pk=<%=view.getPk()%>";
			window.showModalDialog(url,null,"scroll:no;status:no;dialogWidth:830px;dialogHeight:600px;resizable:yes;Minimize:yes;Maximize:yes");
		}
		//����
		function download() {
			window.location.href="casedo.do?method=download&pk=<%=view.getPk()%>";
		}
		</script>
	
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
