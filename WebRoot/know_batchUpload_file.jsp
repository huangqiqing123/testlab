<%
	//��½���
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.Map"%>

<html>
<head>
<title>�����ϴ��ļ�</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">
var row_index=0;    
var array = new Array();
<%
	//��̬�����ļ�����js����
	Map<String, String> know_types = Const.getEnumMap().get("know_type");
		for (Map.Entry<String, String> entry:know_types.entrySet()) {%>	
			array.push('<%=entry.getKey()+":"+entry.getValue()%>');
<%}%> 
/*
 * ����һ��
 */
 function  add_row()   
 {  
	if(row_index==10){
		$("tips").innerHTML = "<font color='red'>���֧��ÿ��ͬʱ�ϴ�10���ĵ���</font>";
		return;
	}
    var table2 = document.getElementById("table2");
	row_index++;  
  	var new_row=table2.insertRow(table2.rows.length);  
	new_row.setAttribute("id", "row"+row_index); 

	//��̬����fileѡ���
	var new_col0=new_row.insertCell(0); 
	new_col0.innerHTML=(row_index)+"&nbsp;&nbsp;<input type='file' id='filename"+row_index+"' name='filename"+row_index+"' size='55' style='background-color:'>";  

	//��̬����select������
	var new_col1=new_row.insertCell(1);   
	var select="����:<select id='type"+row_index+"' name='type"+row_index+"' style='background-color:'>";
	select = select+"<option value='' />---��ѡ��--- ";
	for(var i=0;i<array.length;i++){
		var key = array[i].split(":")[0];
		var value = array[i].split(":")[1];
		select = select+"<option value='"+key+"'/>"+value;
	}
	select = select+"</select>";
	new_col1.innerHTML=select;

	//��̬����ɾ����ť
    var new_col2=new_row.insertCell(2);  
    new_col2.innerHTML="&nbsp;<input type='button' value='ɾ��' onclick=\"delete_row('row"+row_index+ "')\">";    
    document.getElementById("filename"+row_index).focus();	 
 }   
 /*
  * ɾ��һ��
  */
 function delete_row(rname)   
 {  
	var table2 = document.getElementById("table2");
   var i;  
   i=table2.rows(rname).rowIndex;  
   table2.deleteRow(i);  
 } 
	//ִ�б���
	function save() {
		if(checkFile()&&checkType()){
			document.uploadForm.action = "knowdo.do?method=add&action=save&isBatchAdd=1";
			document.uploadForm.submit();
		}
	}
	//ִ���ύ
	function submit() {
		if(checkFile()&&checkType()){
			document.uploadForm.action = "knowdo.do?method=add&action=submit&isBatchAdd=1";
			document.uploadForm.submit();
		}
	}
	//�����ϴ��ļ��ĺϷ���
	function checkFile() {	
		
		//���Ȼ�ȡҳ�������е� input ��ǩ
		var allElement = document.getElementsByTagName("input");
		var files = new Array();

		//���Ž����� id ������ filename ��Ԫ�ص� id �������� files ��
		for(var i=0;i<allElement.length;i++){
			if(allElement[i].id.indexOf('filename')!=-1){
				files.push(allElement[i].id);
			}
		}
		//��� files ����Ϊ�գ���ֱ�ӷ���false
		if(files.length==0){
			$("tips").innerHTML = "<font color='red'>��ѡ��Ҫ�ϴ����ļ���</font>";
			return false;
		}
		//ѭ������files���飬������ÿһ��Ԫ�ؽ���У�顣
		for(var j=0;j<files.length;j++){
			
		var value = $(files[j]).value;
		if (value == "") {
			$("tips").innerHTML = "<font color='red'>��ѡ��Ҫ�ϴ����ļ���</font>";
			$(files[j]).style.backgroundColor = "pink";	
			return false;
		} else if (value.indexOf('.') == -1) {
			$("tips").innerHTML = "<font color='red'>�ļ���ʽ����ȷ��������ѡ��</font>";
			$(files[j]).style.backgroundColor = "pink";	
			return false;
		}
			$(files[j]).style.backgroundColor = "lightgreen";
		}
		return true;
	}
	//�ļ����͵ķǿռ��
	function checkType() {	
		
		//���Ȼ�ȡҳ�������е� input ��ǩ
		var allElement = document.getElementsByTagName("select");
		var types = new Array();

		//���Ž����� id ������ type ��Ԫ�ص� id �������� files ��
		for(var i=0;i<allElement.length;i++){
			if(allElement[i].id.indexOf('type')!=-1){
				types.push(allElement[i].id);
			}
		}
		//��� files ����Ϊ�գ���ֱ�ӷ���false
		if(types.length==0){
			$("tips").innerHTML = "<font color='red'>��ѡ���ļ����ͣ�</font>";
			return false;
		}
		//ѭ������types���飬������ÿһ��Ԫ�ؽ���У�顣
		for(var j=0;j<types.length;j++){
			
		var value = $(types[j]).value;
		if (value == "") {
			$("tips").innerHTML = "<font color='red'>��ѡ���ļ����ͣ�</font>";
			$(types[j]).style.backgroundColor = "pink";	
			return false;
			} 
		$(types[j]).style.backgroundColor = "lightgreen";
		}
		return true;
	}
</script>
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>" >
<br>
<span id="tips"></span>
<h2 align='center'>�����ϴ��ļ�</h2>
<div align="right">
<input type="button" class="btbox" value="����һ��" onclick="add_row()">
<input type="button" class="btbox" value="����"	onclick="save()"> 
<input type="button" class="btbox"	value="�ύ" onclick="submit()"> 
<input type="button" class="btbox" value="������һҳ" onclick="javascript:parent.history.back(); return;"> 
</div>
<fieldset>
<legend>�����ϴ��ļ�</legend>
<form  name="uploadForm"  method="post" ENCTYPE="multipart/form-data">
  	<table id="table2">
  	</table>
 </form>
</fieldset>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />