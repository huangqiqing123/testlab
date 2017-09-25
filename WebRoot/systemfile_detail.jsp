<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.systemfile.bean.SystemFile"%><html>
	<head>
		<title>受控信息明细</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
		SystemFile systemfile = (SystemFile) request.getAttribute("systemfile_view");
	%>
		<h2 align="center">
			受控文件信息明细
		</h2>
				<div align="right">
				<input type="button" class="btbox" value="修改" <%
				if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
					out.print("disabled=\"disabled\" ");
				}
				%>
				onClick="window.location.href='systemfile_update.jsp?pk=<%=systemfile.getPk() %>'"  >
				<input type="button" class="btbox" value="删除" onclick="del()" 
				<%
				if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
					out.print("disabled=\"disabled\" ");
				}
			%> >
			<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='systemfiledo.do?method=query&path=menu.jsp'">
		</div>
		<hr>
		
		<form name="form2" method="post">
		<input type="hidden" name="pk" value="<%=systemfile.getPk() %>">
				<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
				
					<tr>
						<td>
							文件编号
						</td>
						<td>
							<input type="text" name="code" value="<%=systemfile.getCode() %>" size="60" maxlength="12" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td>
							文件名称
						</td>
						<td>
							<input type="text" name="name" value="<%=systemfile.getName() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td>
							受控号
						</td>
						<td>
							<input type="text" name="controlled_number" value="<%=systemfile.getControlledNumber() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td>
							版本
						</td>
						<td>
							<input type="text" name="version" value="<%=systemfile.getVersion() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td>
							页数
						</td>
						<td>
							<input type="text" name="pages" value="<%=systemfile.getPages() %>" size="12" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td>
							状态
						</td>
						<td>
							<input type="text" name="state" value="<%=systemfile.getState() %>" size="12"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					
					<tr>
						<td>
							备注
						</td>
						<td>
							<textarea name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=systemfile.getMemo() %></textarea>
					</tr>
				</table>
		</form>
					
	</body>
	<script type="text/javascript">
	function del(){	
		if (confirm('确认删除选中记录？记录删除后将无法恢复！')) {		
			window.location.href='systemfiledo.do?method=delete&pk=<%=systemfile.getPk() %>';
		}
		}
	</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
