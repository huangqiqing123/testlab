<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.filecover.bean.FileCover"%>
<%@page import="cn.sdfi.filecovercontent.bean.FileCoverContent"%>
<%@page import="cn.sdfi.filecovercontent.dao.FileCoverContentDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
	<head>
		<title>��������Ϣ��ϸ</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
	</head>
	<body background="images/skins/<%=session.getAttribute("skin")%>" >
	<span id="tips"></span>
	<%!
		FileCoverContentDao fileCoverContentDao = (FileCoverContentDao)ObjectFactory.getObject(FileCoverContentDao.class.getName());
	%>
	<%
		FileCover filecover = (FileCover) request.getAttribute("file_cover_view");
		boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
		boolean isSuperadmin = Tool.isSuperadmin(request);
	%>
		<h2 align="center">
			��������Ϣ��ϸ
		</h2>
				<div align="right">
				<input type="button" class="btbox" value="����Excel" 
				onClick="window.location.href='filecoverdo.do?method=detail&action=exportExcel&pk=<%=filecover.getPk()%>&file_cover_name=<%=filecover.getFile_cover_name() %>'"  >
				<input type="button" class="btbox" value="�޸�" 
				<%
				if (!isDocmentAdmin&&!isSuperadmin) {
					out.print("disabled=\"disabled\" ");
				}
				%>
				onClick="window.location.href='file_cover_update.jsp?pk=<%=filecover.getPk()%>'"  >
				<input type="button" class="btbox" value="ɾ��" onclick="del()" 
				<%
				if (!isDocmentAdmin&&!isSuperadmin) {
					out.print("disabled=\"disabled\" ");
				}
			%> >
			<input type="button" class="btbox" value="������һҳ" onclick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="������ҳ" onclick="window.location.href='filecoverdo.do?method=query&path=menu.jsp'">
		</div>
		<hr>
		<input type="hidden" name="pk" value="<%=filecover.getPk()%>">
					<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								���������:
							</td>
							<td colspan="3" align="left">
								<input type="text" name="file_cover_code" value="<%=filecover.getFile_cover_code()%>" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								����������:
							</td>
							<td colspan="3" align="left" >
								
								<input type="text" name="file_cover_name" value="<%=filecover.getFile_cover_name()%>" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								����:
							</td>
							<td colspan="3" align="left" >
		<%
			Map<String, String> file_cover_types = Const.getEnumMap().get("file_cover_type");
		%>
								<input type="text" name="file_cover_type" value="<%=file_cover_types.get(filecover.getFile_cover_type())==null?"":file_cover_types.get(filecover.getFile_cover_type())%>&nbsp;" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								���:
							</td>
							<td colspan="3" align="left" >
								
								<input type="text" name="file_cover_year" value="<%=filecover.getFile_cover_year()%>" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								��ע:
							</td>
							<td colspan="3" align="left" >
								<textarea name="memo" cols="80" rows="6" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=filecover.getMemo()%></textarea>
							</td>
						</tr>

			<tr>
			
				<td colspan="4" align="center">�������������ļ���Ϣ��ϸ����</td>	
			
			</tr>
			<!-- ��ͷ��Ϣ -->
					<tr>
						<th align="center" nowrap="nowrap" >���</th>
						<th nowrap="nowrap" align="center">�ļ����</th>
						<th nowrap="nowrap" align="center">�ļ�����</th>
						<th align="center">����</th>
					</tr>
					<%
						//���ݵ�����������ѯ�������ļ���Ϣ
						List<FileCoverContent> contenstlist = fileCoverContentDao.queryByFK(filecover.getPk());
						for (int i = 0; i < contenstlist.size(); i++) {
					%>
					<tr>
						<td align="center" nowrap="nowrap">
							<%=i + 1%>
						</td>
						<td nowrap="nowrap">
							<%=contenstlist.get(i).getFile_cover_content_code()%>
						</td>
						<td nowrap="nowrap">
							<%=contenstlist.get(i).getFile_cover_content_name()%>
						</td>
						<td width="75">
						<a href="filecovercontentdo.do?method=detail&pk=<%=contenstlist.get(i).getPk()%>" >��ϸ</a>	
						<%
								if (Tool.isDocmentAdmin(request)||Tool.isSuperadmin(request)) {
										out.print("<a href=javascript:if(confirm('ȷ��ɾ��������¼��ɾ���󽫲��ָܻ���'))window.location.href='filecovercontentdo.do?method=delete&path=from_file_cover_detail_page&file_cover_pk="
														+ contenstlist.get(i).getFk()
														+ "&pk="
														+ contenstlist.get(i).getPk() + "'>ɾ��</a>");
									}
							%>
						</td>				
					</tr>
					<%
						}
					%>
					
		</table>
	</body>
<script type="text/javascript">

	//ɾ����ǰ������
	function del(){
	if(confirm('ȷ��Ҫɾ���𣿴˲������ָܻ���')){	
	if (before_delete()) {
		window.location.href="filecoverdo.do?method=delete&pk=<%=filecover.getPk()%>";
			}
		}
	}
	//ɾ��������ǰ��У�飬������ڷǿյ�����������ִ��ɾ��������
	function before_delete() {	
		var canDelete = false;
		var req = getXmlHttpObject();
		var url = "filecoverdo.do?method=hasContent&pk=<%=filecover.getPk()%>";
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;

					//�����ѡ���ȫ���ǿյ��������򷵻�true����ʾ����ִ��ɾ��������
					if (msg == "") {
						canDelete = true;
					} else {
						alert(msg);
					}
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return canDelete;
		}
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
</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />