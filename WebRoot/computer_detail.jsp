<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.computer.bean.Computer"%><html>
	<head>
		<title>设备信息明细</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
	Computer computer = (Computer) request.getAttribute("computer.view");
	%>
		<h2 align="center">
			实验室设备信息明细
		</h2>
		<div align="right">
		<input type="button" value="修改" class="btbox"
		<%
		if (!Tool.isComputerAdmin(request)&&!Tool.isSuperadmin(request)) {
			out.print("disabled=\"disabled\" ");
		}
		%>
		onclick="window.location.href='computer_update.jsp?pk=<%=computer.getPk() %>'"  >
		<input type="button" value="删除" class="btbox" onclick="del()" 
		 <%
		 if (!Tool.isComputerAdmin(request)&&!Tool.isSuperadmin(request)) {
				out.print("disabled=\"disabled\" ");
			}
			%> >
		<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
		<input type="button" value="返回首页" class="btbox" onclick="window.location.href='computerdo.do?method=query&path=menu.jsp'"  >
		</div>
		<hr>
			<table align="center" border="1" width="100%" cellpadding="0" cellspacing="0" >
				
					<tr>
						<td align="right">
							设备类型:
						</td>
						<td >
						<%
							Map<String,String> computer_type = Const.getEnumMap().get("computer_type");	
						%>
							<input type="text" name="computer_type" value="<%=computer_type.get(computer.getComputer_type()) %>" size="60" maxlength="24" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
						</td>
					</tr>
					<tr>
						<td align="right">
							设备编号:
						</td>
						<td >
							<input type="text" name="code" value="<%=computer.getCode() %>" size="60" maxlength="24" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
			
						</td>
					</tr>
					<tr>
						<td align="right">
							设备名称:
						</td>
						<td>
							<input type="text" name="name" value="<%=computer.getName() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
							
						</td>
					</tr>
					<tr>
						<td align="right">
							状态:
						</td>
						<td>
					<%
					Map<String,String> computer_status = Const.getEnumMap().get("computer_status");
					%>
						<input type="text" name="status" value="<%=computer_status.get(computer.getStatus()) %>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td align="right">
							序列号:
						</td>
						<td>
							<input type="text" name="serial_number" value="<%=computer.getSerial_number() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td align="right">
							设备型号:
						</td>
						<td>
							<input type="text" name="type"  value="<%=computer.getType() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td align="right">
							生产厂商:
						</td>
						<td>
							<input type="text" name="manufactory" value="<%=computer.getManufactory() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td align="right" nowrap="nowrap">
							设备IP:
						</td>
						<td>
						<input type="text"  name="fk_show" value="<%=computer.getIp() %>" size="60" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td align="right">
							领用人:
						</td>
						<td>
							<input type="text" name="owner" value="<%=computer.getOwner() %>" size="60" maxlength="10" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
					</tr>
					<tr>
						<td align="right">
							领用日期:
						</td>
						<td>
						<input type="text" name="begin_use_time" value="<%=computer.getBegin_use_time() %>" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td align="right">
							使用地点:
						</td>
						<td>
						<input type="text" name="use_site" value="<%=computer.getUse_site() %>" size="60" maxlength="50" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()">
						</td>
					</tr>
					<tr>
						<td align="right">
							配置:
						</td>
						<td nowrap="nowrap">
						<textarea id="configuration"  name="configuration" rows="5" cols="70" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=computer.getConfiguration() %></textarea>
						<input type="button" class="btbox" value="复制到剪贴板" onclick="copyText('configuration')" >
						</td>
					</tr>
					<tr>
						<td align="right">
							说明:
						</td>
						<td>
							<textarea  name="memo" rows="6" cols="70" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()"><%=computer.getMemo()%></textarea>

							</td>
					</tr>
				</table>			
	</body>
	<script type="text/javascript">
	function del(){
		
		if (confirm('确认删除选中记录？记录删除后将无法恢复！')) {		
		window.location.href='computerdo.do?method=delete&pk=<%=computer.getPk() %>';
		}
		}
	</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
