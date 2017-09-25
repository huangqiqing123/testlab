<%//�����жϸ��û��Ƿ��ѵ�¼
			if (Tool.isNotLogin(request)) {
				request.getRequestDispatcher("no_login.jsp").forward(request,
						response);
				return;
			}%>
<%
	//������ǳ�������Ա������Ȩ�����ҳ�档
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
<title>ϵͳ�������ݼ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<h2 align="center">ϵͳ�������ݼ��</h2>
<div align="right">
<input type="button" value="һ���޸�" class="btbox" onclick="window.location.href='system_data_check.jsp?action=repair'">
<input type="button" value="���¼��" class="btbox" onclick="window.location='system_data_check.jsp'">
</div>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<%

	String action = request.getParameter("action");
	//Ӧ�õ������·��
	String root_path = application.getRealPath("/");

	//���������Ķ���swf�ļ�����λ��
	String swf_path = root_path + "swf\\";

	//֪ʶ��Ͱ������ļ�����λ��
	String file_path = root_path + "WEB-INF\\file\\";

	//���������ļ���������λ��
	String document_path = root_path + "WEB-INF\\document\\";

	//����excelʱ���ϴ���excel�ļ���ʱ���ڵ�
	String temp_path = root_path + "WEB-INF\\temp\\";

	/*
	 *�������ݼ�����
	 *1��file·���µ��ļ���������֪ʶ����߰�������ƥ��ļ�¼������Ҳ���������Ϊ�������ݡ�
	 *2��swf·���µ��ļ���������֪ʶ����߰�������ƥ��ļ�¼������Ҳ���������Ϊ�������ݡ�
	 *3��temp ·����Ӧ�ò������κ��ļ���������Ϊ�������ݡ�
	 *4�� document·���µ��ļ���������file_cover_content���ݿ�����ҵ���Ӧ��¼��������Ϊ�������ݡ�
	 */
	 
	//�ֱ��ȡ֪ʶ�⡢�����⡢���������ļ������ݿ��е������ļ���
	CaseDao caseDao = (CaseDao)ObjectFactory.getObject(CaseDao.class.getName());
	KnowDao knowDao = (KnowDao)ObjectFactory.getObject(KnowDao.class.getName());
	FileCoverContentDao contentDao = (FileCoverContentDao)ObjectFactory.getObject(FileCoverContentDao.class.getName());
	List<String> caseList = caseDao.getAllPks();
	List<String> knowList = knowDao.getAllPks();
	List<String> contentList = contentDao.getAllPks();

	//------1------���file·�����ļ�������-----------------------
	String[] filenames = Tool.getFileNames(file_path);
	
	//badData���ڴ����������
	List<String> badData = new ArrayList<String>();
	for (int i = 0; i < filenames.length; i++) {
		boolean isBad = true;
		
		//��һ�ּ�飬��֪ʶ����Ѱ��ƥ���¼
		for (int j = 0; j < knowList.size(); j++) {
			if(filenames[i].startsWith(knowList.get(j))){
				isBad = false;
				break;
			}
		}
		//�����֪ʶ�����Ҳ���ƥ��ļ�¼��������ڰ�������Ѱ��
		if(isBad){		
			for (int k = 0; k< caseList.size(); k++) {
					if(filenames[i].startsWith(caseList.get(k))){
						isBad = false;
						break;
					}	
				}	
			//�����֪ʶ��Ͱ������ж��Ҳ���ƥ��ļ�¼������Ϊ�������ݣ�����badData�����С�
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
	out.println(file_path+"&nbsp;&nbsp;·����<b><font color='green'>��������������</font></b>��");
}else{
	//�����ִ���޸�����
	if("repair".equals(action)){
		out.println(file_path+"&nbsp;&nbsp;·�������������޸�������£�");
		for(int k=0;k<badData.size();k++){
			out.println("<br>");
			File badFile = new File(file_path+badData.get(k));		
			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+badData.get(k)+"&nbsp;&nbsp;<font color='green'>�ɹ�ɾ����</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+badData.get(k)+"&nbsp;&nbsp;<font color='red'>�������ڱ�ʹ�ã�ɾ��ʧ�ܣ�</font>");
			}
		}
	}else{		
		out.println(file_path+"&nbsp;&nbsp;·����<b><font color='red'>������������</font></b>�������������£�");
		for(int k=0;k<badData.size();k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+badData.get(k));
		}
	}
}
%>
</fieldset>
<%
//---2---------���swf·�����ļ�������-----------------------
String[] swf_file_names = Tool.getFileNames(swf_path); 
List<String> badData2 = new ArrayList<String>();
for (int i = 0; i < swf_file_names.length; i++) {
	boolean isBad = true;
	
	//��һ�ּ�飬��֪ʶ����Ѱ��ƥ���¼
	for (int j = 0; j < knowList.size(); j++) {
		if(swf_file_names[i].startsWith(knowList.get(j))){
			isBad = false;
			break;
		}
	}
	//�����֪ʶ�����Ҳ���ƥ��ļ�¼��������ڰ�������Ѱ��
	if(isBad){		
		for (int k = 0; k< caseList.size(); k++) {
				if(swf_file_names[i].startsWith(caseList.get(k))){
					isBad = false;
					break;
				}	
			}	
		//�����֪ʶ��Ͱ������ж��Ҳ���ƥ��ļ�¼������Ϊ�������ݣ�����badData2�����С�
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
	out.println(swf_path+"&nbsp;&nbsp;·����<b><font color='green'>��������������</font></b>��");
}else{
	//�����ִ���޸�����
	if("repair".equals(action)){
		out.println(swf_path+"&nbsp;&nbsp;·�������������޸�������£�");
		for(int k=0;k<badData2.size();k++){
			out.println("<br>");
			File badFile = new File(swf_path+badData2.get(k));

			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+badData2.get(k)+"&nbsp;&nbsp;<font color='green'>�ɹ�ɾ����</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+badData2.get(k)+"&nbsp;&nbsp;<font color='red'>�������ڱ�ʹ�ã�ɾ��ʧ�ܣ�</font>");
			}
		}
	}else{	
		out.println(swf_path+"&nbsp;&nbsp;·����<b><font color='red'>������������</font></b>�������������£�");
		for(int k=0;k<badData2.size();k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+badData2.get(k));
	}
	}
}
%>
</fieldset>
<%
//-----3-------���document·�����ļ�������-----------------------
String[] content_file_names = Tool.getFileNames(document_path);
List<String> badData3 = new ArrayList<String>();
for (int i = 0; i < content_file_names.length; i++) {
	boolean isBad = true;
	
	//��file_cover_content���ݿ����Ѱ��ƥ���¼
	for (int j = 0; j < contentList.size(); j++) {
		if(content_file_names[i].startsWith(contentList.get(j))){
			isBad = false;
			break;
		}
	}
	//����Ҳ���ƥ��ļ�¼������Ϊ�������ݣ�����badData3�����С�
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
	out.println(document_path+"&nbsp;&nbsp;·����<b><font color='green'>��������������</font></b>��");
}else{
	//�����ִ���޸�����
	if("repair".equals(action)){
		out.println(document_path+"&nbsp;&nbsp;·�������������޸�������£�");
		for(int k=0;k<badData3.size();k++){
			out.println("<br>");
			File badFile = new File(document_path+badData3.get(k));
			
			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+badData3.get(k)+"&nbsp;&nbsp;<font color='green'>�ɹ�ɾ����</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+badData3.get(k)+"&nbsp;&nbsp;<font color='red'>�������ڱ�ʹ�ã�ɾ��ʧ�ܣ�</font>");
			}
		}
	}else{	
		out.println(document_path+"&nbsp;&nbsp;·����<b><font color='red'>������������</font></b>�������������£�");
		for(int k=0;k<badData3.size();k++){
			out.println("<br>");
			out.println((k+1)+"&nbsp;&nbsp;"+badData3.get(k));
	}
	}
}
%>
</fieldset>
<%
//----4--------���temp·�����ļ�������-----------------------
/*
*��������£�temp·���²������κ��ļ���������ڣ�����Ϊ�������ݡ�
*temp·����������ʱ���excel�ļ��ģ�ִ�е�������󣬱���Զ�ɾ����
*/
String[] temp_files = Tool.getFileNames(temp_path);
%>
<br>
<fieldset><legend><%=temp_path %></legend>
<br>
<%

if(temp_files.length<1){
	out.println(temp_path+"&nbsp;&nbsp;·����<b><font color='green'>��������������</font></b>��");
}else{
	//�����ִ���޸�����
	if("repair".equals(action)){
		out.println(temp_path+"&nbsp;&nbsp;·�������������޸�������£�");
		for(int k=0;k<temp_files.length;k++){
			out.println("<br>");
			File badFile = new File(temp_path+temp_files[k]);

			if(badFile.delete()){			
				out.println((k+1)+"&nbsp;&nbsp;"+temp_files[k]+"&nbsp;&nbsp;<font color='green'>�ɹ�ɾ����</font>");
			}else{
				out.println((k+1)+"&nbsp;&nbsp;"+temp_files[k]+"&nbsp;&nbsp;<font color='red'>�������ڱ�ʹ�ã�ɾ��ʧ�ܣ�</font>");
			}
		}
	}else{	
		out.println(temp_path+"&nbsp;&nbsp;·����<b><font color='red'>������������</font></b>�������������£�");
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
