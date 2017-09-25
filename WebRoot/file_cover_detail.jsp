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
		<title>档案袋信息明细</title>
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
			档案袋信息明细
		</h2>
				<div align="right">
				<input type="button" class="btbox" value="导出Excel" 
				onClick="window.location.href='filecoverdo.do?method=detail&action=exportExcel&pk=<%=filecover.getPk()%>&file_cover_name=<%=filecover.getFile_cover_name() %>'"  >
				<input type="button" class="btbox" value="修改" 
				<%
				if (!isDocmentAdmin&&!isSuperadmin) {
					out.print("disabled=\"disabled\" ");
				}
				%>
				onClick="window.location.href='file_cover_update.jsp?pk=<%=filecover.getPk()%>'"  >
				<input type="button" class="btbox" value="删除" onclick="del()" 
				<%
				if (!isDocmentAdmin&&!isSuperadmin) {
					out.print("disabled=\"disabled\" ");
				}
			%> >
			<input type="button" class="btbox" value="返回上一页" onclick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="返回首页" onclick="window.location.href='filecoverdo.do?method=query&path=menu.jsp'">
		</div>
		<hr>
		<input type="hidden" name="pk" value="<%=filecover.getPk()%>">
					<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								档案袋编号:
							</td>
							<td colspan="3" align="left">
								<input type="text" name="file_cover_code" value="<%=filecover.getFile_cover_code()%>" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								档案袋名称:
							</td>
							<td colspan="3" align="left" >
								
								<input type="text" name="file_cover_name" value="<%=filecover.getFile_cover_name()%>" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								类型:
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
								年度:
							</td>
							<td colspan="3" align="left" >
								
								<input type="text" name="file_cover_year" value="<%=filecover.getFile_cover_year()%>" size="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							</td>
						</tr>
						<tr>
							<td colspan="1"  align="right" nowrap="nowrap">
								备注:
							</td>
							<td colspan="3" align="left" >
								<textarea name="memo" cols="80" rows="6" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=filecover.getMemo()%></textarea>
							</td>
						</tr>

			<tr>
			
				<td colspan="4" align="center">——档案袋内文件信息明细——</td>	
			
			</tr>
			<!-- 表头信息 -->
					<tr>
						<th align="center" nowrap="nowrap" >序号</th>
						<th nowrap="nowrap" align="center">文件编号</th>
						<th nowrap="nowrap" align="center">文件名称</th>
						<th align="center">操作</th>
					</tr>
					<%
						//根据档案袋主键查询出所有文件信息
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
						<a href="filecovercontentdo.do?method=detail&pk=<%=contenstlist.get(i).getPk()%>" >明细</a>	
						<%
								if (Tool.isDocmentAdmin(request)||Tool.isSuperadmin(request)) {
										out.print("<a href=javascript:if(confirm('确认删除此条记录？删除后将不能恢复！'))window.location.href='filecovercontentdo.do?method=delete&path=from_file_cover_detail_page&file_cover_pk="
														+ contenstlist.get(i).getFk()
														+ "&pk="
														+ contenstlist.get(i).getPk() + "'>删除</a>");
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

	//删除当前档案袋
	function del(){
	if(confirm('确认要删除吗？此操作不能恢复！')){	
	if (before_delete()) {
		window.location.href="filecoverdo.do?method=delete&pk=<%=filecover.getPk()%>";
			}
		}
	}
	//删除档案袋前的校验，如果存在非空档案袋，则不再执行删除操作。
	function before_delete() {	
		var canDelete = false;
		var req = getXmlHttpObject();
		var url = "filecoverdo.do?method=hasContent&pk=<%=filecover.getPk()%>";
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var msg = req.responseText;

					//如果所选择的全部是空档案袋，则返回true，表示可以执行删除操作。
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
</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />