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
		<title>��Ŀ��Ϣ��ϸ</title>
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
				if(isLabProject){out.print("ʵ������Ŀ��Ϣ��ϸ");}
				else{out.print("��ʵ������Ŀ��Ϣ��ϸ");}
			%>
		</h2>
				<div align="right">
				<input type="button" class="btbox" value="�޸�" 
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
				<input type="button"  class="btbox" value="ɾ��" onclick="del()" 
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
			<input type="button" class="btbox" value="�鿴����Ŀ��Ӧ�ĵ�������Ϣ" onclick="window.location.href='filecoverdo.do?method=detail&path=project_detail.jsp&file_cover_code=<%=project.getCode()%>&project_pk=<%=project.getPk()%>'"  >
			<% } %>
			<input type="button" class="btbox" value="������һҳ" onclick="javascript:parent.history.back(); return;">
			<% if(isLabProject){ %>
			<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='projectdo.do?method=query&isLabProject=1&path=project_lab_query.jsp'">
			<% }else{ %>
			<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='projectdo.do?method=query&isLabProject=0&path=project_query.jsp'">
			<% } %>
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
					<% if(isLabProject){ %>
					<tr>
						<td  align="right" nowrap="nowrap">
							��Ŀ���:
						</td>
						<td>
							<input type="text" name="code" value="<%=project.getCode() %>" size="60"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<% } %>
					<tr>
						<td  align="right" nowrap="nowrap">
							��Ŀ����:
						</td>
						<td><font color="red">
							<input type="text" name="name" value="<%=project.getName() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
							</font>
							</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							��Ŀ��ǰ״̬:
						</td>
						<td>
						<input type="text" name="state" value="<%=project_state.get(project.getState())%>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							�ͻ�����:
						</td>
						<td>
						<input type="text" name="project_customer" value="<%=project_customers.get(project.getProject_customer())%>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
					<td align="right" nowrap="nowrap">��Ŀ���:</td>
					<td>
					<input type="text" name="project_type" value="<%=project_types.get(project.getProject_type())%>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</td>
					</tr>
					
					<tr>
						<td  align="right" nowrap="nowrap">
							��Ŀ����:
						</td>
						<td>
							<input type="text" name="devmanager" value="<%=project.getDevmanager() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							���Ծ���:
						</td>
						<td>
							<input type="text" name="testmanager" value="<%=project.getTestmanager() %>" size="60"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							������Ա:
						</td>
						<td>
							<textarea  name="tester" rows="2" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=project.getTester()==null?"":project.getTester() %></textarea>
							</td>
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							��Ŀ��ʼʱ��:
						</td>
						<td>
							<input type="text" name="begintime" value="<%=project.getBegintime() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							��Ŀ����ʱ��:
						</td>
						<td>
							<input type="text" name="endtime" value="<%=project.getEndtime() %>" size="60"  style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td  align="right" nowrap="nowrap">
							���:
						</td>
						<td>
						<input type="text" name="year" value="<%=project.getYear() %>" size="12" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					
					
					<tr>
						<td  align="right" nowrap="nowrap">
							˵��:
						</td>
						<td>
							<textarea name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=project.getMemo() %></textarea>
					</tr>
				</table>		
	</body>
	<script type="text/javascript">
	function del(){	
		if (confirm('ȷ��ɾ��ѡ�м�¼����¼ɾ�����޷��ָ���')) {		
			window.location.href='projectdo.do?method=delete&isLabProject=<%=isLabProject?"1":"0"%>&pk=<%=project.getPk() %>';
		}
		}
	</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
