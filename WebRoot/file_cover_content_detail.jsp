<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.GetFileNames"%>
<%@page import="java.io.File"%>
<%@page import="cn.sdfi.filecovercontent.bean.FileCoverContent"%><html>
	<head>
		<title>文件信息明细</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>"> 
	<span id="tips"></span>
	<%
		FileCoverContent filecovercontent = (FileCoverContent) request.getAttribute("file_cover_content.view");
	
		%>
		<h2 align="center">
			文件信息明细 
		</h2>
		<div align="right">
		<input type="button" class="btbox" value="修改" 
		<%
		if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
			out.print("disabled=\"disabled\" ");
		}
		%>
		onclick="window.location.href='file_cover_content_update.jsp?pk=<%=filecovercontent.getPk() %>'"  >
		<input type="button" class="btbox" value="查看该文件所在档案袋信息" onClick="window.location.href='filecoverdo.do?method=detail&pk=<%=filecovercontent.getFk() %>'"  >
		<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
		<input type="button" class="btbox" value="返回首页" onClick="window.location.href='filecovercontentdo.do?method=query'">
		</div>
		<hr>

<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td  nowrap="nowrap" align="right">文件所在档案袋:</td>
		<td><input type="text"
			name="file_cover_name"
			value="<%=filecovercontent.getFile_cover_name() %>" 
			size="50"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"></td>
	</tr>
	<tr>
		<td  nowrap="nowrap" align="right">文件编号:</td>
		<td><input type="text"
			name="file_cover_content_code"
			value="<%=filecovercontent.getFile_cover_content_code()%>" size="50"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"></td>
	</tr>
	<tr>
		<td  nowrap="nowrap" align="right">文件名称:</td>
		<td><input type="text"
			name="file_cover_content_name"
			value="<%=filecovercontent.getFile_cover_content_name()%>" 
			size="50"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
		</td>
	</tr>
	
	<tr>
		<td nowrap="nowrap" align="right">页数:</td>
		<td><input type="text" 
			name="pages"
			value="<%=filecovercontent.getPages() %>" 
			size="50"
			maxlength="10"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">版本:</td>
		<td><input type="text" 
			name="version"
			value="<%=filecovercontent.getVersion() %>" 
			size="50"
			maxlength="10"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">附件:</td>
		<td id="attachment">
		<%
		String path = application.getRealPath("/")+"WEB-INF\\document";
		String filenames[] = GetFileNames.getFileNamesStartWithPrefix(path, filecovercontent.getPk());
		
		//如果该文件存在附件
		if(filenames.length>0){
			String ext = filenames[0].substring( filenames[0].lastIndexOf(".")+1);//获取文件后缀
			String newfilename = filecovercontent.getFile_cover_content_name()+"."+ext;//组装新的文件名称	

			String suffixPath = application.getRealPath("/")+"images/suffix";//文件后缀图标存放路径
			String suffixs[] = Tool.getFileNames(suffixPath);//获取所有后缀名称
	
			//该后缀在后缀库中是否存在，默认为FALSE
			boolean isExist = false;
				  for (int j = 0; j < suffixs.length; j++) {	   		    
				    	if(suffixs[j].startsWith(ext)){
				    		isExist = true;
				    		break;
				    	}
			}
			if(!isExist){//如果当前文件后缀在后缀库中不存在，则显示默认图标。
				ext = "none";
			}
			%>
		
		<a title="点击下载" style="CURSOR:hand" onclick="window.location.href='filecovercontentdo.do?method=download&pk=<%=filecovercontent.getPk() %>'">	
		<img src="images/suffix/big/<%=ext%>.png" border="0" >
		<u>
		<%=newfilename %>
		</u>&nbsp;&nbsp;&nbsp;&nbsp;
		</a>
		<%
		}else{
		%>	
		&nbsp;&nbsp;暂无
		<%
		}
		%>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">备注:</td>
		<td><textarea id="" name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=filecovercontent.getMemo() %></textarea></td>
	</tr>

</table>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
