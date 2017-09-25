
<%
	//��½���
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.know.bean.Know"%><html>
<head>
<title>�ļ���Ϣ�޸�ҳ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//ѡ�񸽼�ʱ��ͬ������ �ؼ���title��ֵ��
	function setTitleValue(){
		var fileValue = $('file1').value;
		$("title").value = fileValue.substring(fileValue.lastIndexOf('\\')+1);
	}
	//ִ�е���ǰ��У��
	function check_blob(){
		if($('upload').style.display!='none'){//����ϴ�����Ƿ�����״̬����Ը���ִ��У�顣
				var value=$('file1').value;
				if(value==""){
					$("blob_check_result").innerHTML = "<font color='red'>��ʾ����ѡ�񸽼���</font>";
					return false;
				}else if(value.indexOf('.')==-1){
					$("blob_check_result").innerHTML = "<font color='red'>��ʾ����ѡ����Ч������</font>";
					return false;
				}else{
					var fileExt = value.substr(value.lastIndexOf('.')+1).toLowerCase();
					if(fileExt=='bat'||fileExt=='exe'||fileExt=='com'){
						$("blob_check_result").innerHTML = "<font color='red'>��ʾ���������ϴ�exe��bat��com�ȿ�ִ���ļ���</font>";
						return false;
					}else{
					$("blob_check_result").innerHTML = "<font color='green'>OK</font>";
					return true;
					}
			}
		}else{
			return true;//����ϴ���������صģ���ֱ�ӷ���true������ִ��У�顣
		}
	}
	//���ؼ���
	function check_title() {
		if (addForm.title.value == "") {
			$("title_check_result").innerHTML = "<font color='red'>��ʾ���ؼ��ֲ���Ϊ�գ�</font>";
			return false;
		}else if(checklength("title")>100){
			$("title_check_result").innerHTML = "<font color='red'>��ʾ���ؼ���������볤����100���ֽڣ�ÿ������ռ2���ֽڣ�����ǰ�������ֽ���"+checklength("title")+"�����������룡</font>";
			return false;
		}else {
			$("title_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//�������
	function check_type() {
		if (addForm.type.value == "") {
			$("type_check_result").innerHTML = "<font color='red'>��ʾ����ѡ���ļ��������ͣ�</font>";
			return false;
		} else {
			$("type_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//�����ϴ�
	function reupload(){
		$('download').style.display="none";
		$('upload').style.display="";
		$('do_upload').value="yes";//���ñ�ʶ��yes��ʾִ���ϴ�
		}
	//ȡ���ϴ�
	function cancel(){
		$('download').style.display="";
		$('upload').style.display="none";
		$('do_upload').value="no";//���ñ�ʶ��no��ʾ���ϴ�����ʹfile����������ֵ��Ҳ����ִ���ϴ�������
	}
	//ִ�б���
	function save() {
		if (check_type()&&check_blob()&&check_title()&&checkmemolength('memo')) {
			document.addForm.action = "knowdo.do?method=update&action=save";
			document.addForm.submit();
		}
	}
	//ִ���ύ
	function submit() {
		if (check_type()&&check_blob()&&check_title()&&checkmemolength('memo')) {
			document.addForm.action = "knowdo.do?method=update&action=submit";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body	background="images/skins/<%=session.getAttribute("skin") %>">
<span id="tips"></span>
<h2 align="center">�ļ���Ϣ�޸�</h2>
<div align="right">
<input type="button" class="btbox" value="����"	onclick="save()"> 
<input type="button" class="btbox"	value="�ύ" onclick="submit()"> 
<input type="button"	class="btbox" value="������һҳ"	onClick="javascript:parent.history.back(); return;"> 
</div>
<hr>
<%
	Know view = (Know)request.getAttribute("know.view");
	Map<String,String> know_types = Const.getEnumMap().get("know_type");
%>
<form action="knowdo.do?method=add" name="addForm"  method="post" ENCTYPE="multipart/form-data">
<input type="hidden" name="pk" value=<%=view.getPk() %>>
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap" align="right">����:</td>
		<td align="left">
		<select name="type" size="1" onblur="check_type()"	onchange="check_type()">
			<option value="" />---��ѡ��--- 
			<%
				for (Map.Entry<String, String> entry:know_types.entrySet()) {
			%>
			<option value="<%=entry.getKey()%>" <%
			if(entry.getKey().equals(view.getType())){
				out.print("selected=\"selected\"");
			}
			%>/><%=entry.getValue()%> 
		<%}%>
			
		</select> 
		<font color="red">*</font> 
		<div id="type_check_result"></div></td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">ѡ���ļ�:</td>
		<td nowrap="nowrap">	
		<input type="hidden" id="do_upload" name="do_upload" value="no">
		<table  id="download" style="display:''" width="100%" cellpadding="0" cellspacing="0">
		<tr><td>
		<%
		String suffixPath = application.getRealPath("/")+"images/suffix";	
		java.io.File file = new java.io.File(suffixPath);
		java.io.File[] files = file.listFiles();
		String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
	
		//�ú�׺�ں�׺�����Ƿ���ڣ�Ĭ��ΪFALSE
		boolean isExist = false;
			  for (int j = 0; j < files.length; j++) {	   
			    if (files[j].isFile()) {
			    	if(files[j].getName().startsWith(suffix)){//startsWith()���������ִ�Сд�ġ�
			    		isExist = true;
			    		break;
			    	}
			     }
		}
		if(!isExist){//�����ǰ�ļ���׺�ں�׺���в����ڣ�����ʾĬ��ͼ�ꡣ
			suffix = "none";
		}
		%>
		<a title="�������" style="CURSOR:hand" onclick="window.location.href='knowdo.do?method=download&pk=<%=view.getPk() %>'">	
		<img src="images/suffix/big/<%=suffix%>.png" border="0" align="bottom">
		<u>
		<%=view.getBlob_name() %>
		</u>
		</a>
		</td>
		<td align="right"><input type="button" class="btbox" value="�����ϴ�" onclick="reupload()" ></td>
		</tr>
		</table>
		<table  id="upload" style="display:none" width="100%" cellpadding="0" cellspacing="0"><tr><td>
		<input type='file'  id='file1' name='file1' size='50' onblur='check_blob()' value="" onchange='check_blob();setTitleValue()'>
		&nbsp;&nbsp;
		<font color='green'>*��������ϴ�����20M</font>
		<div id='blob_check_result'></div></td>
		<td align="right"><input type="button" class="btbox" value="ȡ�������ϴ�" onclick="cancel()" ></td>
		</tr>
		</table>	
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�ؼ���:</td>
		<td nowrap="nowrap">
		<input type="text" id="title" name="title" value="<%=view.getTitle() %>" size="50" maxlength="100"  onchange="check_title()"> 
		<font color="red">*</font> <div id="title_check_result"></div>
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">�汾:</td>
		<td nowrap="nowrap">
		<input type="text" name="version" value="<%=view.getVersion() %>" size="50" maxlength="25" onblur="check_title()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">ҳ��:</td>
		<td nowrap="nowrap">
		<input type="text" name="pages" value="<%=view.getPages() %>" size="50" maxlength="25" onblur="check_title()"> 
	</tr>
	<tr>
		<td nowrap="nowrap" align="right">��ע:</td>
		<td><textarea id="memo" name="memo" cols="80" rows="10"><%=view.getMemo()==null?"":view.getMemo() %></textarea>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />