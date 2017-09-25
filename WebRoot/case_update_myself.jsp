
<%
	//登陆检查
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
<%@page import="cn.sdfi.cases.bean.Case"%><html>
<head>
<title>案例信息修改页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//选择附件时，同步设置 标题title的值。
	function setTitleValue(){
		var fileValue = $('file1').value;
		$("title").value = fileValue.substring(fileValue.lastIndexOf('\\')+1);
	}
	//执行导入前的校验
	function check_blob(){
		if($('upload').style.display!='none'){//如果上传组件是非隐藏状态，则对附件执行校验。
				var value=$('file1').value;
				if(value==""){
					$("blob_check_result").innerHTML = "<font color='red'>提示：请选择附件！</font>";
					return false;
				}else if(value.indexOf('.')==-1){
					$("blob_check_result").innerHTML = "<font color='red'>提示：请选择有效附件！</font>";
					return false;
				}else{
					var fileExt = value.substr(value.lastIndexOf('.')+1).toLowerCase();
					if(fileExt=='bat'||fileExt=='exe'||fileExt=='com'){
						$("blob_check_result").innerHTML = "<font color='red'>提示：不允许上传exe、bat、com等可执行文件！</font>";
						return false;
					}else{
					$("blob_check_result").innerHTML = "<font color='green'>OK</font>";
					return true;
					}
			}
		}else{
			return true;//如果上传组件是隐藏的，则直接返回true，不再执行校验。
		}
	}
	//检查标题
	function check_title() {
		if (addForm.title.value == "") {
			$("title_check_result").innerHTML = "<font color='red'>提示：标题不能为空！</font>";
			return false;
		}else if(checklength("title")>50){
			$("title_check_result").innerHTML = "<font color='red'>提示：标题最长可输入长度是50个字节，每个汉字占2个字节，您当前已输入字节数"+checklength("title")+"，请重新输入！</font>";
			return false;
		}else {
			$("title_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	
	//检查类型
	function check_type() {
		if (addForm.type.value == "") {
			$("type_check_result").innerHTML = "<font color='red'>提示：请选择案例所属类型！</font>";
			return false;
		} else {
			$("type_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//重新上传
	function reupload(){
		$('download').style.display="none";
		$('upload').style.display="";
		$('do_upload').value="yes";//设置标识，yes表示执行上传
		}
	//取消上传
	function cancel(){
		$('download').style.display="";
		$('upload').style.display="none";
		$('do_upload').value="no";//设置标识，no表示不上传，即使file输入域中有值，也不会执行上传操作。
	}
	//执行保存
	function save() {
		if (check_type()&&check_blob()&&check_title()) {
			document.addForm.action = "casedo.do?method=update&action=save";
			document.addForm.submit();
		}
	}
	//执行提交
	function submit() {
		if (check_type()&&check_blob()&&check_title()) {
			document.addForm.action = "casedo.do?method=update&action=submit";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body	background="images/skins/<%=session.getAttribute("skin") %>">
<span id="tips"></span>
<h2 align="center">案例信息修改</h2>
<div align="right">
<input type="button" class="btbox" value="保存"	onclick="save()"> 
<input type="button" class="btbox"	value="提交" onclick="submit()"> 
<input type="button"	class="btbox" value="返回上一页"	onClick="javascript:parent.history.back(); return;"> 
</div>
<hr>
<%
	Case view = (Case) request.getAttribute("case.view");
	Map<String,String> case_types = Const.getEnumMap().get("case_type");
%>
<form action="casedo.do?method=add" name="addForm"  method="post" ENCTYPE="multipart/form-data">
<input type="hidden" name="pk" value=<%=view.getPk() %>>
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td>类型</td>
		<td align="left">
		<select name="type" size="1" onblur="check_type()"	onchange="check_type()">
			<option value="" />---请选择--- 
			<%
				for (Map.Entry<String, String> entry:case_types.entrySet()) {
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
		<td>附件</td>
		<td nowrap="nowrap">	
		<input type="hidden" id="do_upload" name="do_upload" value="no">
		<table  id="download" style="display:''" width="100%" cellpadding="0" cellspacing="0"><tr><td>
		<%
		String suffixPath = application.getRealPath("/")+"images/suffix";	
		java.io.File file = new java.io.File(suffixPath);
		java.io.File[] files = file.listFiles();
		String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
	
		//该后缀在后缀库中是否存在，默认为FALSE
		boolean isExist = false;
			  for (int j = 0; j < files.length; j++) {	   
			    if (files[j].isFile()) {
			    	if(files[j].getName().startsWith(suffix)){//startsWith()方法是区分大小写的。
			    		isExist = true;
			    		break;
			    	}
			     }
		}
		if(!isExist){//如果当前文件后缀在后缀库中不存在，则显示默认图标。
			suffix = "none";
		}
		%>
		<a title="点击下载" style="CURSOR:hand" onclick="window.location.href='casedo.do?method=download&pk=<%=view.getPk() %>'">	
		<img src="images/suffix/big/<%=suffix%>.png" border="0" align="bottom">
		<u>
		<%=view.getBlob_name() %>
		</u>
		</a>
		</td>
		<td align="right"><input type="button" class="btbox" value="重新上传" onclick="reupload()" ></td>
		</tr>
		</table>
		<table  id="upload" style="display:none" width="100%" cellpadding="0" cellspacing="0"><tr><td>
		<input type='file'  id='file1' name='file1' size='50' onblur='check_blob()' value="" onchange='check_blob();setTitleValue()'>
		&nbsp;&nbsp;
		<font color='green'>*最大允许上传附件20M</font>
		<div id='blob_check_result'></div></td>
		<td align="right"><input type="button" class="btbox" value="取消重新上传" onclick="cancel()" ></td>
		</tr>
		</table>	
		</td>
	</tr>
	<tr>
		<td>标题</td>
		<td nowrap="nowrap">
		<input type="text" id="title" name="title" value="<%=view.getTitle() %>" size="50" maxlength="50"  onchange="check_title()"> 
		<font color="red">*</font> <div id="title_check_result"></div>
	</tr>
	<tr>
		<td>版本</td>
		<td nowrap="nowrap">
		<input type="text" name="version" value="<%=view.getVersion() %>" size="50" maxlength="25" onblur="check_title()"> 
	</tr>
	<tr>
		<td>摘要</td>
		<td><textarea id="summary" name="summary" cols="80" rows="10"><%=view.getSummary() %></textarea>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" >详细描述</td>
		<td><textarea id="detail" name="detail" cols="80" rows="10"><%=view.getDetail() %></textarea>
		</td>
	</tr>
	<tr>
		<td>分析过程</td>
		<td><textarea id="analyze" name="analyze" cols="80" rows="10"><%=view.getAnalyze() %></textarea>
		</td>
	</tr>
	<tr>
		<td>解决方案</td>
		<td><textarea id="solve" name="solve" cols="80" rows="10"><%=view.getSolve() %></textarea>
		</td>
	</tr>
	<tr>
		<td>结果</td>
		<td><textarea id="result" name="result" cols="80" rows="10"><%=view.getResult() %></textarea>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />