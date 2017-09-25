<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.project.bean.Project"%><html>
	<head>
		<title>项目信息明细</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
		Project project = (Project) request.getAttribute("project_view");
		boolean isLabProject = "1".equals(project.getIsLabProject());
		boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
		boolean isSuperadmin = Tool.isSuperadmin(request);
		boolean isFunctionManager = Tool.isFunctionManager(request);
	%>
	<%
		Map<String,String> project_state = Const.getEnumMap().get("project_state");
		Map<String,String> project_types = Const.getEnumMap().get("project_type");
		Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
	%>
		<h2 align="center">
			<%
				if(isLabProject){out.print("实验室项目信息明细");}
				else{out.print("非实验室项目信息明细");}
			%>
		</h2>
				<div align="right">
				<input type="button" class="btbox" value="修改" 
				<%
				if(isLabProject){
					
					if (!isDocmentAdmin&&!isSuperadmin) {
						out.print("disabled=\"disabled\" ");
					}
				}else{
					if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
						out.print("disabled=\"disabled\" ");
					}
				}
				%>
				onClick="window.location.href='project_update.jsp?pk=<%=project.getPk() %>'"  >
				<input type="button"  class="btbox" value="删除" onclick="del()" 
				<%
				if(isLabProject){
					
					if (!isDocmentAdmin&&!isSuperadmin) {
						out.print("disabled=\"disabled\" ");
					}
				}else{
					if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
						out.print("disabled=\"disabled\" ");
					}
				}
				%> >
			<% if(isLabProject){ %>
			<input type="button" class="btbox" value="查看该项目对应的档案袋信息" onclick="window.location.href='filecoverdo.do?method=detail&path=project_detail.jsp&file_cover_code=<%=project.getCode()%>&project_pk=<%=project.getPk()%>'"  >
			<% } %>
			<input type="button" class="btbox" value="返回上一页" onclick="javascript:parent.history.back(); return;">
			<% if(isLabProject){ %>
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp'">
			<% }else{ %>
			<input type="button" class="btbox" value="返回首页" onClick="window.location.href='projectdo.do?method=query&isLabProject=0&path=project_query.jsp'">
			<% } %>
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
					<% if(isLabProject){ %>
					<tr>
						<td  align="right" nowrap="nowrap">
							项目编号:
						</td>
						<td>
							<input type="text" name="code" value="<%=project.getCode() %>" size="60"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<% } %>
					<tr>
						<td  align="right" nowrap="nowrap">
							项目名称:
						</td>
						<td><font color="red">
							<input type="text" name="name" value="<%=project.getName() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
							</font>
							</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							项目当前状态:
						</td>
						<td>
						<input type="text" name="state" value="<%=project_state.get(project.getState())%>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							客户名称:
						</td>
						<td>
						<input type="text" name="project_customer" value="<%=project_customers.get(project.getProject_customer())%>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
					<td align="right" nowrap="nowrap">项目类别:</td>
					<td>
					<input type="text" name="project_type" value="<%=project_types.get(project.getProject_type())%>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</td>
					</tr>
					
					<tr>
						<td  align="right" nowrap="nowrap">
							项目经理:
						</td>
						<td>
							<input type="text" name="devmanager" value="<%=project.getDevmanager() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							测试经理:
						</td>
						<td>
							<input type="text" name="testmanager" value="<%=project.getTestmanager() %>" size="60"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							测试人员:
						</td>
						<td>
							<textarea  name="tester" rows="2" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=project.getTester()==null?"":project.getTester() %></textarea>
							</td>
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							项目开始时间:
						</td>
						<td>
							<input type="text" name="begintime" value="<%=project.getBegintime() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							项目结束时间:
						</td>
						<td>
							<input type="text" name="endtime" value="<%=project.getEndtime() %>" size="60"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							年度:
						</td>
						<td>
						<input type="text" name="year" value="<%=project.getYear() %>" size="12" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					
					
					<tr>
						<td  align="right" nowrap="nowrap">
							说明:
						</td>
						<td>
							<textarea name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=project.getMemo() %></textarea>
					</tr>
				</table>		
	</body>
	<script type="text/javascript">
	function del(){	
		if (confirm('确认删除选中记录？记录删除后将无法恢复！')) {		
			window.location.href='projectdo.do?method=delete&isLabProject=<%=isLabProject?"1":"0"%>&pk=<%=project.getPk() %>';
		}
		}
	</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
