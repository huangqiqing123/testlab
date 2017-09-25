<%
	//�����жϸ��û��Ƿ��ѵ�¼
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//������ǳ�������Ա������Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	
	if(!isSuperadmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Properties"%><html>
<head>
<title>�鿴ϵͳ��־</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<h2 align="center">�鿴ϵͳ��־</h2>
<div align="right"><input type="button" value="ˢ��" class="btbox" onclick="location.reload();"></div>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<%
	//������־�����ļ�
	Properties log4j_properties = Tool.load_property_file("log4j.properties");
	//ȡ����־���·��
	String log_dir = log4j_properties.getProperty("log4j.appender.A1.File");
%>
	
<fieldset>
<legend>��־�ļ����·����<%=log_dir %></legend><br>	
<div>
	<%	
	//��ȡ�����ļ�
	BufferedReader br = null;
	FileReader fileReader = null;
	try {
		 fileReader = new FileReader(log_dir);
		 br= new BufferedReader(fileReader);
		 String line = "";
		 while ((line = br.readLine()) != null) {
			out.println(line);
			out.println("<br>");
		}
	} catch (FileNotFoundException e) {
		out.print("�����ˣ�û���ҵ���־�ļ���<br>");
		out.println(e);
	} catch (IOException e) {
		out.print("�����ˣ�<br>");
		out.println(e);
	}finally{
		if(br!=null){		
			br.close();
		}
		if(fileReader!=null){		
			fileReader.close();
		}
	}
%>
</div>
</fieldset>
<div align="right">
<input type="button" class="btbox" value="���ض���" onclick="scroll(0,0)" >
</div>
</body>
</html>
