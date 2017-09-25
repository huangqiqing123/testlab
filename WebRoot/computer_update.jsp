<%
	//如果没有登陆
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
//如果不是设备管理员，也不是超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isComputerAdmin = Tool.isComputerAdmin(request);
	if(!isSuperadmin&&!isComputerAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.computer.dao.ComputerDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.computer.bean.Computer"%><html>
<head>
<title>档案袋新增页面</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">
	function check() {
		if (addForm.computer_type.value == "") {

			alert("请选择设备类型！");
			addForm.computer_type.focus();//光标定位
			return false;
		} else if($('code').value==""){
			alert("请输入设备编号！");
			$('code').focus();//光标定位
			return false;
		}else if(isContainChineseChar('code')){
			alert("设备编号中不能包含有中文和全角字符！");
			$('code').focus();//光标定位
			return false;
		} else if(!isExist('code')){
			alert("该设备编号已存在，请重新输入！");
			addForm.code.focus();
			return false;
		}else if (addForm.name.value == "") {
			alert("请输入设备名称！");
			addForm.name.focus();
			return false;
		} else if (addForm.status.value == "") {
			alert("请选择设备状态！");
			addForm.status.focus();
			return false;
		} else if ($("month").value == "" && $("year").value != "") {
			alert("请选择月份！");
			$("month").focus();
			return false;
		} else if ($("year").value == ""&& $("month").value != "") {
			alert("请选择年份！");
			$("year").focus();
			return false;
		} else if (!checkmemolength('memo') || !checkconflength('conf')) {
			return false;
		} else {
			return true;
		}
	}
	//接收组件id
	function isExist(which) {

		//首先判断项目编号是否发生了改变，如果未发生改变，则不再进行下面的验证。
		if(trim($(which).value)==trim($('old_'+which).value)){
			return true;
		}	
		//发送Ajax请求到服务器，验证项目编号是否已存在
		var req = getXmlHttpObject();
		var isAvailable = false;
		var value = trim($(which).value);
		var url = "computerdo.do?method=isExist&value="+value;	
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {		
					var msg = req.responseText;
					if(msg=="1"){//"1"表示该项目编号已经被使用
						isAvailable=false;
					}else if(msg=="0"){
						isAvailable=true;
					}else{
						alert("解析返回值出现异常！");
					}		
				}
			}
		};
		req.open("POST", url, false);
		req.send(null);
		return isAvailable ;
	}
		//返回XMLHttpRequest对象
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
	//检测配置的长度
	function checkconflength(id) {
		var length = checklength(id);
		if (length > 200) {
			alert("配置文本域最长可输入长度为200个字符，每个汉字占2个字符，您当前已输入字符数 " + length + " !");
			$("conf").focus();
			return false;
		}
		return true;
	}
	//执行保存
	function save() {
		if (check()) {
			$("begin_use_time").value = document.getElementById("year").value+$("month").value;
			document.addForm.action = "computerdo.do?method=update";
			document.addForm.submit();
		}
	}
</script>
<script language="javascript" src="js/pub.js"></script>
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<%
	String pk = request.getParameter("pk");
	ComputerDao computerDao = (ComputerDao)ObjectFactory.getObject(ComputerDao.class.getName());
	Computer computer = computerDao.queryByPK(pk);
%>

<form action="" name="addForm" method="post">
<h2 align="center">实验室设备信息修改</h2>
<div align="right">
<input type="button" class="btbox" value="保存" onclick="save()"  >
<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
<input type="button" value="返回首页" class="btbox" onclick="window.location.href='computerdo.do?method=query&path=menu.jsp'"  >
</div>
<hr>
<table align="center" border="1" width="100%" cellpadding="0" cellspacing="0" >

					<tr>
						<td align="right">
							设备类型:
						</td>
						<td>
				<%
				Map<String,String> computer_type = Const.getEnumMap().get("computer_type");	
				%>
				<select name="computer_type" size="1">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : computer_type.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"	
				<%
					if(computer.getComputer_type()!=null){
					if (computer.getComputer_type().trim().equals(entry.getKey().trim())) {
						out.print("selected=\"selected\"");
						}
					}
				%> />
				<%=entry.getValue()%>
				<%
				}
				%>
				</select><font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							设备编号:
						</td>
						<td >
							<input type="hidden" name="pk" value="<%=computer.getPk()%>">
							<input type="hidden" name="old_code" value="<%=computer.getCode()%>">
							<input type="text" id="code" name="code" value="<%=computer.getCode()%>" size="60" maxlength="15" >
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							设备名称:
						</td>
						<td>
							<input type="text" name="name" value="<%=computer.getName()%>" size="60" maxlength="15" >
							<font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							状态:
						</td>
						<td>
		<%
			Map<String, String> computer_status = Const.getEnumMap().get("computer_status");
		%>
		<select name="status" size="1">
			<option value="" />---请选择---
			<%
				for (Map.Entry<String, String> entry : computer_status.entrySet()) {
			%>
			<option value="<%=entry.getKey()%>"
				<%
					if (computer.getStatus().trim().equals(entry.getKey().trim())) {
						out.print("selected=\"selected\"");
					}
				%> />
			<%=entry.getValue()%> 
<%
 	}
 %>
			
		</select><font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							序列号:
						</td>
						<td>
							<input type="text" name="serial_number" value="<%=computer.getSerial_number()%>" size="60" maxlength="25" >
					</tr>
					<tr>
						<td align="right">
							设备型号:
						</td>
						<td>
							<input type="text" name="type"  value="<%=computer.getType()%>" size="60" maxlength="25" >
					</tr>
					<tr>
						<td align="right">
							生产厂商:
						</td>
						<td>
							<input type="text" name="manufactory" value="<%=computer.getManufactory()%>" size="60" maxlength="50" >
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							设备IP:
						</td>
						<td>
						<input type="text" name="ip" value="<%=computer.getIp() %>" size="60" maxlength="32">
						</td>
					</tr>
					<tr>
						<td align="right">
							领用人:
						</td>
						<td>
							<input type="text" name="owner" value="<%=computer.getOwner()%>" size="60" maxlength="10" >
					</tr>
					<tr>
						<td align="right">
							领用日期:
						</td>
						<td>
						<%
							String year = null;
							String month = null;
							String begin_use_time = computer.getBegin_use_time();
							if (begin_use_time != null && !"".equals(begin_use_time)) {

								//格式：201002
								year = begin_use_time.substring(0, 4).trim();
								month = begin_use_time.substring(4).trim();
								if (month.startsWith("0")) {
									month = month.substring(1);
								}
							}
						%>
						<select id="year" name="year"  size="1" >
						<option value="">年...
						<%
							for (int i = 2004; i < 2021; i++) {
						%>
						<option value="<%=i%>" <%
						if ((i + "").equals(year))
							out.print("selected=\"selected\"");%>><%=i%>
						<%
							}
						%>
						</select>
						年
						<select id="month" name="month"  size="1" >
						<option value="">月...
						<%
							for (int i = 1; i <= 12; i++) {
						%>
						<option value="<%=i < 10 ? "0" + i : i%>" <%
						if ((i + "").equals(month))
							out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
						<%
							}
						%>
						</select>
						月						
						<input type="hidden" id="begin_use_time" name="begin_use_time" value="" >
						</td>
					</tr>
					<tr>
						<td align="right">
							使用地点:
						</td>
						<td>
						<input type="text" name="use_site" value="<%=computer.getUse_site()%>" size="60" maxlength="100" >
						</td>
					</tr>
					<tr>
						<td align="right">
							配置:
						</td>
						<td>
						<textarea id="conf" name="configuration" rows="5" cols="70" ><%=computer.getConfiguration() %></textarea>
						</td>
					</tr>
					<tr>
						<td align="right">
							说明:
						</td>
						<td>
							<textarea id="memo" name="memo" rows="6" cols="70" ><%=computer.getMemo()%></textarea>

							</td>
					</tr>
</table>
</form>


</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />