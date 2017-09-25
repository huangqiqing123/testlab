<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是文档管理员/超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	
	if(!isSuperadmin&&!isDocmentAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Iterator"%>
<jsp:directive.page import="java.util.ArrayList"/>
<jsp:directive.page import="java.util.List"/>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.GetFileNames"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.io.File"%>
<%@page import="cn.sdfi.know.dao.KnowDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.know.bean.Know"%><html>
	<head>
		<title>待转换文件</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">

//自动转换为swf文件
function auto() {
	showTips();
	window.location.href="knowdo.do?method=autoConvert";
}
//显示提示信息
function showTips(){
	document.getElementById('tips').innerHTML="<font color='red'>转换文件可能会需要较长时间，请耐心等待。。。。。。</font>";
}
//刷新
function refresh() {
	window.location.href="know_need_convert_to_swf.jsp";
}
</script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>" >
	<span id="tips"></span>
	<table width="100%"  align="center" cellpadding="1" cellspacing="0">
	<tr>
	<td>
			<h2 align="center">
				知识库待转换文件列表
			</h2>
	</td>
	</tr>
	<tr><td align="right">
	<input type="button" value="批量转换为swf文件" class="btbox" onclick="auto()">
	<input type="button" value="刷新" class="btbox" onclick="refresh()">
	</td></tr>
			<tr><td ><fieldset><legend>待转换文件列表</legend>	
					<%
					/*
					*知识库所有审核通过的文件，如果未转换成swf格式，则在此列出。
					*/
					//应用的物理根路径
					String root_path = application.getRealPath("/");

					//用于在线阅读的swf文件所在位置
					String swf_path = root_path + "swf\\";

					//知识库和案例库文件所在位置
					String file_path = root_path + "WEB-INF\\file\\";

					KnowDao knowDao = (KnowDao)ObjectFactory.getObject(KnowDao.class.getName());
					List<Know> list = knowDao.noPageQueryByStauts("4");//4 代表审核通过，获取所有审核通过的记录	
					
					//获取所有swf文件名称
					List<String> swf_file_names = new ArrayList<String>();
					File file = new File(swf_path);
					File swf_files[] = file.listFiles();
					for(int m=0;m<swf_files.length;m++){
						if(swf_files[m].isFile()){
							swf_file_names.add(swf_files[m].getName());
						}
					}
					//待转换的文件列表
					List<Know> needConvertList = new ArrayList<Know>();
					
					for(int k=0;k<list.size();k++){
						boolean needConvert = true;
						for(int m=0;m<swf_file_names.size();m++){							
							if(swf_file_names.get(m).startsWith(list.get(k).getPk())){
								needConvert = false;
								break;
							}
						}
						if(needConvert){
							needConvertList.add(list.get(k));
						}
					}

					%>
					<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%"  >
					<tr>
						<th width="30">&nbsp;</th>
						<th >文件名称</th>
						<th >上传人</th>
						<th nowrap="nowrap" >上传时间</th>
						<th nowrap="nowrap" >最后更新时间</th>
						<th nowrap="nowrap" >操作</th>
					</tr>
					<%
					Know view = null;
					String suffixPath = application.getRealPath("/")+"images/suffix";	
					java.io.File file2 = new java.io.File(suffixPath);
					java.io.File[] files = file2.listFiles();
					for(int i=0;i<needConvertList.size();i++){
						view = needConvertList.get(i);
				%>
					<tr>
					<td align="center" >
						<%=i + 1%>
						</td>
						<td nowrap="nowrap" >
						<%
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
						  //如果当前文件后缀在后缀库中不存在，则显示默认图标。
							if(!isExist){
								suffix = "none";
							}
						%>
						<span>
						<img src="images/suffix/<%=suffix%>.png"  border="0" align="middle" alt="<%=view.getBlob_name() %>">
						<u style="CURSOR:hand" onclick="window.location.href='knowdo.do?method=download&pk=<%=view.getPk() %>'">
							<%=view.getBlob_name()%>
						</u>
						</span>
						</td>
						<td>
						<%=view.getUpload_person()%>
						</td>
						<td nowrap="nowrap" >
							<%=view.getUpload_time()%>&nbsp;
						</td>
						<td nowrap="nowrap" >
							<%=view.getLast_update_time()%>&nbsp;
						</td>
						<td>
							<input type="button" value="转换" class="btbox" onclick="showTips();window.location.href='knowdo.do?method=convertToSWFwinthSingle&suffix=<%=suffix%>&pk=<%=view.getPk() %>'">
						</td>
					</tr>
					<%} %>
				</table>
				</fieldset>		
			</td></tr>
		</table>
	</body>
</html>	
<jsp:include page="includes/alert.jsp" flush="true" />	