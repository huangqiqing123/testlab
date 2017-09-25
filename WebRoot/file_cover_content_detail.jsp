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
		<title>�ļ���Ϣ��ϸ</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>"> 
	<span id="tips"></span>
	<%
		FileCoverContent filecovercontent = (FileCoverContent) request.getAttribute("file_cover_content.view");
	
		%>
		<h2 align="center">
			�ļ���Ϣ��ϸ 
		</h2>
		<div align="right">
		<input type="button" class="btbox" value="�޸�" 
		<%
		if (!Tool.isDocmentAdmin(request)&&!Tool.isSuperadmin(request)) {
			out.print("disabled=\"disabled\" ");
		}
		%>
		onclick="window.location.href='file_cover_content_update.jsp?pk=<%=filecovercontent.getPk() %>'"  >
		<input type="button" class="btbox" value="�鿴���ļ����ڵ�������Ϣ" onClick="window.location.href='filecoverdo.do?method=detail&pk=<%=filecovercontent.getFk() %>'"  >
		<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
		<input type="button" class="btbox" value="������ҳ" onClick="window.location.href='filecovercontentdo.do?method=query'">
		</div>
		<hr>

<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td  nowrap="nowrap" align="right">�ļ����ڵ�����:</td>
		<td><input type="text"
			name="file_cover_name"
			value="<%=filecovercontent.getFile_cover_name() %>" 
			size="50"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"></td>
	</tr>
	<tr>
		<td  nowrap="nowrap" align="right">�ļ����:</td>
		<td><input type="text"
			name="file_cover_content_code"
			value="<%=filecovercontent.getFile_cover_content_code()%>" size="50"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"></td>
	</tr>
	<tr>
		<td  nowrap="nowrap" align="right">�ļ�����:</td>
		<td><input type="text"
			name="file_cover_content_name"
			value="<%=filecovercontent.getFile_cover_content_name()%>" 
			size="50"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
		</td>
	</tr>
	
	<tr>
		<td nowrap="nowrap" align="right">ҳ��:</td>
		<td><input type="text" 
			name="pages"
			value="<%=filecovercontent.getPages() %>" 
			size="50"
			maxlength="10"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�汾:</td>
		<td><input type="text" 
			name="version"
			value="<%=filecovercontent.getVersion() %>" 
			size="50"
			maxlength="10"
			style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">����:</td>
		<td id="attachment">
		<%
		String path = application.getRealPath("/")+"WEB-INF\\document";
		String filenames[] = GetFileNames.getFileNamesStartWithPrefix(path, filecovercontent.getPk());
		
		//������ļ����ڸ���
		if(filenames.length>0){
			String ext = filenames[0].substring( filenames[0].lastIndexOf(".")+1);//��ȡ�ļ���׺
			String newfilename = filecovercontent.getFile_cover_content_name()+"."+ext;//��װ�µ��ļ�����	

			String suffixPath = application.getRealPath("/")+"images/suffix";//�ļ���׺ͼ����·��
			String suffixs[] = Tool.getFileNames(suffixPath);//��ȡ���к�׺����
	
			//�ú�׺�ں�׺�����Ƿ���ڣ�Ĭ��ΪFALSE
			boolean isExist = false;
				  for (int j = 0; j < suffixs.length; j++) {	   		    
				    	if(suffixs[j].startsWith(ext)){
				    		isExist = true;
				    		break;
				    	}
			}
			if(!isExist){//�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
				ext = "none";
			}
			%>
		
		<a title="�������" style="CURSOR:hand" onclick="window.location.href='filecovercontentdo.do?method=download&pk=<%=filecovercontent.getPk() %>'">	
		<img src="images/suffix/big/<%=ext%>.png" border="0" >
		<u>
		<%=newfilename %>
		</u>&nbsp;&nbsp;&nbsp;&nbsp;
		</a>
		<%
		}else{
		%>	
		&nbsp;&nbsp;����
		<%
		}
		%>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">��ע:</td>
		<td><textarea id="" name="memo" rows="6" cols="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=filecovercontent.getMemo() %></textarea></td>
	</tr>

</table>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
