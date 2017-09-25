<%//首先判断该用户是否已登录
			if (Tool.isNotLogin(request)) {
				request.getRequestDispatcher("no_login.jsp").forward(request,
						response);
				return;
			}%>
<%
	//如果不是超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);

	if (!isSuperadmin) {
		request.getRequestDispatcher("no_privilege.jsp").forward(
				request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@page import="cn.sdfi.cases.dao.CaseDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.know.dao.KnowDao"%>
<%@page import="cn.sdfi.filecovercontent.dao.FileCoverContentDao"%><html>
<head>
<title>系统冗余数据检查</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<h2 align="center">系统冗余数据检查</h2>
<div align="right">
<input type="button" value="一键修复" class="btbox" onclick="window.location.href='system_data_check.jsp?action=repair'">
<input type="button" value="重新检查" class="btbox" onclick="window.location='system_data_check.jsp'">
</div>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<%

	String action = request.getParameter("action");
	//应用的物理根路径
	String root_path = application.getRealPath("/");

	//用于在线阅读的swf文件所在位置
	String swf_path = root_path + "swf\\";

	//知识库和案例库文件所在位置
	String file_path = root_path + "WEB-INF\\file\\";

	//档案袋内文件附件所在位置
	String document_path = root_path + "WEB-INF\\document\\";

	//导入excel时，上传的excel文件临时所在地
	String temp_path = root_path + "WEB-INF\\temp\\";

	/*
	 *冗余数据检查规则：
	 *1、file路径下的文件必须能在知识库或者案例库中匹配的记录，如果找不到，则视为冗余数据。
	 *2、swf路径下的文件必须能在知识库或者案例库中匹配的记录，如果找不到，则视为冗余数据。
	 *3、temp 路径下应该不存在任何文件，有则视为冗余数据。
	 *4、 document路径下的文件必须能在file_cover_content数据库表中找到相应记录，否则视为冗余数据。
	 */
	 
	//分别获取知识库、案例库、档案袋内文件在数据库中的主键的集合
	CaseDao caseDao = (CaseDao)ObjectFactory.getObject(CaseDao.class.getName());
	KnowDao knowDao = (KnowDao)ObjectFactory.getObject(KnowDao.class.getName());
	FileCoverContentDao contentDao = (FileCoverContentDao)ObjectFactory.getObject(FileCoverContentDao.class.getName());
	List<String> caseList = caseDao.getAllPks();
	List<String> knowList = knowDao.getAllPks();
	List<String> contentList = contentDao.getAllPks();

	//------1------检查file路径下文件的冗余-----------------------
	String[] filenames = Tool.getFileNames(file_path);
	
	//badData用于存放冗余数据
	List<String> badData = new ArrayList<String>();
	for (int i = 0; i < filenames.length; i++) {
		boolean isBad = true;
		
		//第一轮检查，在知识库中寻找匹配记录
		for (int j = 0; j < knowList.size(); j++) {
			if(filenames[i].startsWith(knowList.get(j))){
				isBad = false;
				break;
			}
		}
		//如果在知识库中找不到匹配的记录，则继续在案例库中寻找
		if(isBad){		
			for (int k = 0; k< caseList.size(); k++) {
					if(filenames[i].startsWith(caseList.get(k))){
						isBad = false;
						break;
					}	
				}	
			//如果在知识库和案例库中都找不到匹配的记录，则视为冗余数据，放入badData集合中。
			if(isBad){		
				badData.add(filenames[i]);
			}
		}	
	}
%>
	
<fieldset>
<legend><%=file_path %></legend>
<br>
<%
if(badData.size()<1){
	out.println(file_path+"&nbsp;&nbsp;路径下<b><font color='green'>不存在数据冗余</font></b>！");
}else{
	//如果是执行修复操作
	if("repair".equals(action)){
		out.println(file_path+"&nbsp;&nbsp;路径下冗余数据修复结果如下：");
		for(int k=0;k<badData.size();k++){
			out.println("<br>");
			File badFile = new File(file_path+badData.get(k));		
			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+badData.get(k)+"&nbsp;&nbsp;<font color='green'>成功删除！</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+badData.get(k)+"&nbsp;&nbsp;<font color='red'>可能正在被使用，删除失败！</font>");
			}
		}
	}else{		
		out.println(file_path+"&nbsp;&nbsp;路径下<b><font color='red'>存在数据冗余</font></b>，冗余数据如下：");
		for(int k=0;k<badData.size();k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+badData.get(k));
		}
	}
}
%>
</fieldset>
<%
//---2---------检查swf路径下文件的冗余-----------------------
String[] swf_file_names = Tool.getFileNames(swf_path); 
List<String> badData2 = new ArrayList<String>();
for (int i = 0; i < swf_file_names.length; i++) {
	boolean isBad = true;
	
	//第一轮检查，在知识库中寻找匹配记录
	for (int j = 0; j < knowList.size(); j++) {
		if(swf_file_names[i].startsWith(knowList.get(j))){
			isBad = false;
			break;
		}
	}
	//如果在知识库中找不到匹配的记录，则继续在案例库中寻找
	if(isBad){		
		for (int k = 0; k< caseList.size(); k++) {
				if(swf_file_names[i].startsWith(caseList.get(k))){
					isBad = false;
					break;
				}	
			}	
		//如果在知识库和案例库中都找不到匹配的记录，则视为冗余数据，放入badData2集合中。
		if(isBad){		
			badData2.add(swf_file_names[i]);
		}
	}	
}
%>
<br>
<fieldset><legend><%=swf_path %></legend>
<br>
<%
if(badData2.size()<1){
	out.println(swf_path+"&nbsp;&nbsp;路径下<b><font color='green'>不存在数据冗余</font></b>！");
}else{
	//如果是执行修复操作
	if("repair".equals(action)){
		out.println(swf_path+"&nbsp;&nbsp;路径下冗余数据修复结果如下：");
		for(int k=0;k<badData2.size();k++){
			out.println("<br>");
			File badFile = new File(swf_path+badData2.get(k));

			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+badData2.get(k)+"&nbsp;&nbsp;<font color='green'>成功删除！</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+badData2.get(k)+"&nbsp;&nbsp;<font color='red'>可能正在被使用，删除失败！</font>");
			}
		}
	}else{	
		out.println(swf_path+"&nbsp;&nbsp;路径下<b><font color='red'>存在数据冗余</font></b>，冗余数据如下：");
		for(int k=0;k<badData2.size();k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+badData2.get(k));
	}
	}
}
%>
</fieldset>
<%
//-----3-------检查document路径下文件的冗余-----------------------
String[] content_file_names = Tool.getFileNames(document_path);
List<String> badData3 = new ArrayList<String>();
for (int i = 0; i < content_file_names.length; i++) {
	boolean isBad = true;
	
	//在file_cover_content数据库表中寻找匹配记录
	for (int j = 0; j < contentList.size(); j++) {
		if(content_file_names[i].startsWith(contentList.get(j))){
			isBad = false;
			break;
		}
	}
	//如果找不到匹配的记录，则视为冗余数据，放入badData3集合中。
	if(isBad){		
		badData3.add(content_file_names[i]);
		}
	}
%>
<br>
<fieldset><legend><%=document_path %></legend>
<br>
<%
if(badData3.size()<1){
	out.println(document_path+"&nbsp;&nbsp;路径下<b><font color='green'>不存在数据冗余</font></b>！");
}else{
	//如果是执行修复操作
	if("repair".equals(action)){
		out.println(document_path+"&nbsp;&nbsp;路径下冗余数据修复结果如下：");
		for(int k=0;k<badData3.size();k++){
			out.println("<br>");
			File badFile = new File(document_path+badData3.get(k));
			
			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+badData3.get(k)+"&nbsp;&nbsp;<font color='green'>成功删除！</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+badData3.get(k)+"&nbsp;&nbsp;<font color='red'>可能正在被使用，删除失败！</font>");
			}
		}
	}else{	
		out.println(document_path+"&nbsp;&nbsp;路径下<b><font color='red'>存在数据冗余</font></b>，冗余数据如下：");
		for(int k=0;k<badData3.size();k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+badData3.get(k));
	}
	}
}
%>
</fieldset>
<%
//----4--------检查temp路径下文件的冗余-----------------------
/*
*正常情况下，temp路径下不存在任何文件，如果存在，则视为冗余数据。
*temp路径是用于临时存放excel文件的，执行导入操作后，便会自动删除。
*/
String[] temp_files = Tool.getFileNames(temp_path);
%>
<br>
<fieldset><legend><%=temp_path %></legend>
<br>
<%

if(temp_files.length<1){
	out.println(temp_path+"&nbsp;&nbsp;路径下<b><font color='green'>不存在数据冗余</font></b>！");
}else{
	//如果是执行修复操作
	if("repair".equals(action)){
		out.println(temp_path+"&nbsp;&nbsp;路径下冗余数据修复结果如下：");
		for(int k=0;k<temp_files.length;k++){
			out.println("<br>");
			File badFile = new File(temp_path+temp_files[k]);

			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+temp_files[k]+"&nbsp;&nbsp;<font color='green'>成功删除！</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+temp_files[k]+"&nbsp;&nbsp;<font color='red'>可能正在被使用，删除失败！</font>");
			}
		}
	}else{	
		out.println(temp_path+"&nbsp;&nbsp;路径下<b><font color='red'>存在数据冗余</font></b>，冗余数据如下：");
		for(int k=0;k<temp_files.length;k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+temp_files[k]);
	}
	}
}
%>
</fieldset>
</body>
</html>
