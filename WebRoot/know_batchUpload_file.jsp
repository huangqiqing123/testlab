<%
	//登陆检查
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
<title>批量上传文件</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">
var row_index=0;    
var array = new Array();
<%
	//动态构建文件类型js数组
	Map<String, String> know_types = Const.getEnumMap().get("know_type");
		for (Map.Entry<String, String> entry:know_types.entrySet()) {%>	
			array.push('<%=entry.getKey()+":"+entry.getValue()%>');
<%}%> 
/*
 * 增加一行
 */
 function  add_row()   
 {  
	if(row_index==10){
		$("tips").innerHTML = "<font color='red'>最多支持每次同时上传10份文档！</font>";
		return;
	}
    var table2 = document.getElementById("table2");
	row_index++;  
  	var new_row=table2.insertRow(table2.rows.length);  
	new_row.setAttribute("id", "row"+row_index); 

	//动态构建file选择框
	var new_col0=new_row.insertCell(0); 
	new_col0.innerHTML=(row_index)+"&nbsp;&nbsp;<input type='file' id='filename"+row_index+"' name='filename"+row_index+"' size='55' style='background-color:'>";  

	//动态构建select下拉框
	var new_col1=new_row.insertCell(1);   
	var select="类型:<select id='type"+row_index+"' name='type"+row_index+"' style='background-color:'>";
	select = select+"<option value='' />---请选择--- ";
	for(var i=0;i<array.length;i++){
		var key = array[i].split(":")[0];
		var value = array[i].split(":")[1];
		select = select+"<option value='"+key+"'/>"+value;
	}
	select = select+"</select>";
	new_col1.innerHTML=select;

	//动态构建删除按钮
    var new_col2=new_row.insertCell(2);  
    new_col2.innerHTML="&nbsp;<input type='button' value='删除' onclick=\"delete_row('row"+row_index+ "')\">";    
    document.getElementById("filename"+row_index).focus();	 
 }   
 /*
  * 删除一行
  */
 function delete_row(rname)   
 {  
	var table2 = document.getElementById("table2");
   var i;  
   i=table2.rows(rname).rowIndex;  
   table2.deleteRow(i);  
 } 
	//执行保存
	function save() {
		if(checkFile()&&checkType()){
			document.uploadForm.action = "knowdo.do?method=add&action=save&isBatchAdd=1";
			document.uploadForm.submit();
		}
	}
	//执行提交
	function submit() {
		if(checkFile()&&checkType()){
			document.uploadForm.action = "knowdo.do?method=add&action=submit&isBatchAdd=1";
			document.uploadForm.submit();
		}
	}
	//检验上传文件的合法性
	function checkFile() {	
		
		//首先获取页面中所有的 input 标签
		var allElement = document.getElementsByTagName("input");
		var files = new Array();

		//接着将所有 id 包含有 filename 的元素的 id 放入数组 files 中
		for(var i=0;i<allElement.length;i++){
			if(allElement[i].id.indexOf('filename')!=-1){
				files.push(allElement[i].id);
			}
		}
		//如果 files 数组为空，则直接返回false
		if(files.length==0){
			$("tips").innerHTML = "<font color='red'>请选择要上传的文件！</font>";
			return false;
		}
		//循环遍历files数组，对其内每一个元素进行校验。
		for(var j=0;j<files.length;j++){
			
		var value = $(files[j]).value;
		if (value == "") {
			$("tips").innerHTML = "<font color='red'>请选择要上传的文件！</font>";
			$(files[j]).style.backgroundColor = "pink";	
			return false;
		} else if (value.indexOf('.') == -1) {
			$("tips").innerHTML = "<font color='red'>文件格式不正确，请重新选择！</font>";
			$(files[j]).style.backgroundColor = "pink";	
			return false;
		}
			$(files[j]).style.backgroundColor = "lightgreen";
		}
		return true;
	}
	//文件类型的非空检查
	function checkType() {	
		
		//首先获取页面中所有的 input 标签
		var allElement = document.getElementsByTagName("select");
		var types = new Array();

		//接着将所有 id 包含有 type 的元素的 id 放入数组 files 中
		for(var i=0;i<allElement.length;i++){
			if(allElement[i].id.indexOf('type')!=-1){
				types.push(allElement[i].id);
			}
		}
		//如果 files 数组为空，则直接返回false
		if(types.length==0){
			$("tips").innerHTML = "<font color='red'>请选择文件类型！</font>";
			return false;
		}
		//循环遍历types数组，对其内每一个元素进行校验。
		for(var j=0;j<types.length;j++){
			
		var value = $(types[j]).value;
		if (value == "") {
			$("tips").innerHTML = "<font color='red'>请选择文件类型！</font>";
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
<h2 align='center'>批量上传文件</h2>
<div align="right">
<input type="button" class="btbox" value="增加一行" onclick="add_row()">
<input type="button" class="btbox" value="保存"	onclick="save()"> 
<input type="button" class="btbox"	value="提交" onclick="submit()"> 
<input type="button" class="btbox" value="返回上一页" onclick="javascript:parent.history.back(); return;"> 
</div>
<fieldset>
<legend>批量上传文件</legend>
<form  name="uploadForm"  method="post" ENCTYPE="multipart/form-data">
  	<table id="table2">
  	</table>
 </form>
</fieldset>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />