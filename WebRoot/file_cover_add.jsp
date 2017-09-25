<%
	//��½���
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//��������ĵ�����Ա/��������Ա������Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	
	if(!isSuperadmin&&!isDocmentAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
	<%
		//����Ǵ�ʵ������Ŀ��Ϣ��ϸҳ����룬�򵵰������롢���������ơ����������ͷֱ���ݴ��ݹ�����file_cover_code��ȡ��
		String file_cover_code = request.getParameter("file_cover_code");
		String file_cover_name = "";
		String file_cover_type = "";
		if(file_cover_code!=null){
			ProjectDao dao = (ProjectDao)ObjectFactory.getObject(ProjectDao.class.getName());
			file_cover_name = dao.queryByCode(file_cover_code).getName();
			file_cover_type = "1";//1 ��ʾ������Ŀ
		}else{
			file_cover_code = "";
		}		
	%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.List"%>
<%@page import="cn.sdfi.project.dao.ProjectDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
	<head>
		<title>����������ҳ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//��ʼ������
	function init() {

		$("file_cover_type").value='<%=file_cover_type %>';
		$("file_cover_code").value='<%=file_cover_code %>';
		$("file_cover_name").value='<%=file_cover_name %>';
		$("file_cover_year").value='<%=Tool.getCurrentYear()%>';
		document.forms[0].file_cover_type.focus();
	}
	//��鵵��������
	function check_file_cover_name() {
		if (addForm.file_cover_name.value == "") {
			$("name_check_result").innerHTML = "<font color='red'>���������Ʋ���Ϊ�գ�</font>";
			return false;
		} else {
			$("name_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//��鵵��������
	function check_file_cover_code() {
		var code = addForm.file_cover_code.value;
		if (code == "") {
			$("code_check_result").innerHTML = "<font color='red'>���������벻��Ϊ�գ�</font>";
			return false;
		}else if(isContainChineseChar('file_cover_code')){
			$("code_check_result").innerHTML = "<font color='red'>�����������в��ܰ��������Ļ���ȫ���ַ���</font>";
			return false;
		}else if(($('file_cover_code').value.substring(0,5)!="ISTL-")){
			$("code_check_result").innerHTML = "<font color='red'>��������������ԡ�ISTL-����ͷ��</font>";
			return false;
		}
		else {
			var temp = isExist();
			return temp;
		}
	}
	//��鵵��������
	function check_file_cover_type() {
		if (addForm.file_cover_type.value == "") {
			$("type_check_result").innerHTML = "<font color='red'>��ѡ�񵵰������ͣ�</font>";
			return false;
		} else {
			$("type_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//ִ�б���
	function save() {
		if (check_file_cover_name() && check_file_cover_code()&& check_file_cover_type()&&checkmemolength('memo')) {
			document.addForm.action = "filecoverdo.do?method=add&action=save";
			document.addForm.submit();
		}
	}
	//ִ�б��沢����
	function goOn() {
		if (check_file_cover_name() && check_file_cover_code()&& check_file_cover_type()&&checkmemolength('memo')) {
			document.addForm.action = "filecoverdo.do?method=add&action=continue";
			document.addForm.submit();
		}
	}
	//����Ajax���󵽷���������֤�ñ���Ƿ��Ѿ���ʹ��
	function isExist() {
		var isExist = false;
		var req = getXmlHttpObject();
		var file_cover_code = $("file_cover_code").value;
		var url = "filecoverdo.do?method=isExist&file_cover_code="+ file_cover_code;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {

					//����ʹ��  req.responseText ��ȡ���ص��ı���Ϣ			
					var msg = req.responseXML.getElementsByTagName("msg")[0];
					var result = msg.childNodes[0].nodeValue;
					var div = $("code_check_result");
					if (result == "ok") {
						div.innerHTML = "<font color='green'>OK</font>";
						isExist = true;
					} else if (result == "not_ok") {
						div.innerHTML = "<font color='red'>�õ���������Ѿ���ʹ�ã�</font>";
					} else {
						alert("�����ˣ�����ϵϵͳ����Ա��");
					}
				}
			}
		};
		//false��ʾִ��ͬ����true��ʾִ���첽��������첽�Ļ���isExist�ڻص����������õ�ֵ��������Ч��
		//��ִ���������return��䣬�Ӷ�������ݵĲ�һ�£����Դ˴�����Ϊͬ����
		req.open("POST", url, false);
		req.send(null);
		return isExist ;
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
<script language="javascript" src="js/pub.js"></script>
	</head>
	<body onload="init()" background="images/skins/<%=session.getAttribute("skin") %>"  >
	<span id="tips"></span>
			<h2 align="center">
				��������Ϣ����
			</h2>
			<div align="right">
			
			<input type="button" class="btbox" value="����" onclick="save()" >
			<input type="button" class="btbox" value="���沢����" onclick="goOn()"  >
			<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
			<input type="button" class="btbox" value="������ҳ" onclick="window.location.href='filecoverdo.do?method=query&path=menu.jsp'">
			
			</div>
			<hr>
			<form action="filecoverdo.do?method=add" name="addForm" method="post">
			<input type="hidden" name="privledge" value="1">
	<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
		<tr>
		<td align="right" nowrap="nowrap">����������:</td>
		<td align="left">
		<%
			Map<String, String> file_cover_types = Const.getEnumMap().get("file_cover_type");
		%>
		<select name="file_cover_type" size="1" onblur="check_file_cover_type()" onchange="check_file_cover_type()">
			<option value="" />---��ѡ��---
			<%
				for (Map.Entry<String, String> entry:file_cover_types.entrySet()) {
			%>
			<option value="<%=entry.getKey()%>"	 />
			<%=entry.getValue()%> <%
 			}
 		%>	
		</select>
		<font color="red">*</font>
		<span id="type_check_result"></span>
		</td>
	</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							����������:
						</td>
						<td nowrap="nowrap" >
						
							<input type="text" id="file_cover_code" name="file_cover_code" value="ISTL-" size="20" maxlength="15" onblur="check_file_cover_code()">
							<font color="red">*&nbsp;
							<span id="code_check_result">����ǲ�����Ŀ����ȷ����������������Ӧ��ʵ������Ŀ���뱣��һ�£�</span>
							</font>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							����������:
						</td>
						<td nowrap="nowrap" >
							<input type="text" name="file_cover_name" value="" size="50" maxlength="25" onblur="check_file_cover_name()">
							<font color="red">*</font>
							<span id="name_check_result"></span>
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							���:
						</td>
						<td>
						<select name="file_cover_year" title="��ѡ�����" size="1">
						<option value="">---��ѡ��---
						<%
						for(int i=2004;i<2021;i++){
						%>
						<option value="<%=i %>"><%=i %>
						<%
						} 
						%>
						</select>
						</td>
					</tr>
					<tr>
					<td align="right" nowrap="nowrap">��ע:</td>
					<td><textarea id="memo" name="memo" cols="80" rows="10" ></textarea> </td>
					</tr>
				</table>
			</form>
	
		
	</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />