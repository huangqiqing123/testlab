<%//��½���
	if (Tool.isNotLogin(request)) {
		request.getRequestDispatcher("no_login.jsp").forward(request,response);
		return;
}%>
<%
	//��������ĵ�����Ա/��������Ա/���Ը����ˣ�����Ȩ�����ҳ�档
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	boolean isFunctionManager = Tool.isFunctionManager(request);

	if (!isSuperadmin && !isDocmentAdmin && !isFunctionManager) {
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
<%@page import="java.util.List"%>

<%@page import="cn.sdfi.defect.bean.ChartDefect"%>
<%@page import="cn.sdfi.product.dao.ProductDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
	<head>
		<title>����������ҳ��</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript">

	//�����Ŀ
	function check_chart_project() {
		if (addForm.chart_project.value == "") {
			$("chart_project_check_result").innerHTML = "<font color='red'>��ѡ����Ŀ��</font>";
			return false;
		} else {
			$("chart_project_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//�������
	function check_yearMonth() {
		var year = addForm.year.value;
		var month = addForm.month.value;
		if (year == "") {
			$("yearMonth_check_result").innerHTML = "<font color='red'>��ѡ���꣡</font>";
			return false;
		}else if(month==""){
			$("yearMonth_check_result").innerHTML = "<font color='red'>��ѡ���£�</font>";
			return false;
		}else {
			$("yearMonth_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//������
	function check_packageNumber() {
		if (addForm.packageNumber.value == "") {
			$("packageNumber_check_result").innerHTML = "<font color='red'>�������ܰ�����</font>";
			return false;
		} else if(!isNumber(addForm.packageNumber.value)){	
			$("packageNumber_check_result").innerHTML = "<font color='red'>��������������</font>";
			return false;
		}else {
			$("packageNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//���ȱ����
	function check_defectNumber() {
		if (addForm.defectNumber.value == "") {
			$("defectNumber_check_result").innerHTML = "<font color='red'>��������ȱ������</font>";
			return false;
		} else if(!isNumber(addForm.defectNumber.value)){	
			$("defectNumber_check_result").innerHTML = "<font color='red'>��������������</font>";
			return false;
		}else {
			$("defectNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//�������ȱ����
	function check_seriousDefectNumber() {
		if (addForm.seriousDefectNumber.value == "") {
			$("seriousDefectNumber_check_result").innerHTML = "<font color='red'>����������ȱ������</font>";
			return false;
		} else if(!isNumber(addForm.seriousDefectNumber.value)){	
			$("seriousDefectNumber_check_result").innerHTML = "<font color='red'>��������������</font>";
			return false;
		}else {
			$("seriousDefectNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//���reopenȱ����
	function check_reopenNumber() {
		if (addForm.reopenNumber.value == "") {
			$("reopenNumber_check_result").innerHTML = "<font color='red'>������ȱ��Reopen������</font>";
			return false;
		} else if(!isNumber(addForm.reopenNumber.value)){	
			$("reopenNumber_check_result").innerHTML = "<font color='red'>��������������</font>";
			return false;
		}else {
			$("reopenNumber_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//��ȱ�ݼ�Ȩֵ
	function check_totalDefectWeight() {
		if (addForm.totalDefectWeight.value == "") {
			$("totalDefectWeight_check_result").innerHTML = "<font color='red'>��������ȱ�ݼ�Ȩֵ��</font>";
			return false;
		}else {
			$("totalDefectWeight_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//�ؼ�����ȱ�ݼ�Ȩֵ
	function check_totalSeriousDefectWeight() {
		if (addForm.totalSeriousDefectWeight.value == "") {
			$("totalSeriousDefectWeight_check_result").innerHTML = "<font color='red'>������ؼ�����ȱ�ݼ�Ȩֵ��</font>";
			return false;
		}else {
			$("totalSeriousDefectWeight_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//�ܴ���ʱ��
	function check_totalProcessTime() {
		if (addForm.totalProcessTime.value == "") {
			$("totalProcessTime_check_result").innerHTML = "<font color='red'>�������ܴ���ʱ����</font>";
			return false;
		} else if(!isNumber(addForm.packageNumber.value)){	
			$("totalProcessTime_check_result").innerHTML = "<font color='red'>��������������</font>";
			return false;
		}else {
			$("totalProcessTime_check_result").innerHTML = "<font color='green'>OK</font>";
			return true;
		}
	}
	//ִ�б���
	function save() {
		if (check_chart_project() && check_yearMonth()&& check_packageNumber()&&check_defectNumber()&&check_seriousDefectNumber()&&check_reopenNumber()&&check_totalProcessTime()&&check_totalDefectWeight()&&check_totalSeriousDefectWeight()) {

			$("yearMonth").value = $("year").value + $("month").value;

			//�����Ŀ�����·ݾ�δ�����ı䣬���ٽ����Ƿ��Ѵ��ڵ�У�顣
			if(($("yearMonth_old").value==$("yearMonth").value)&&($("chart_project_old").value==$("chart_project").value)){
				document.addForm.action = "defectdo.do?method=update";
				document.addForm.submit();
			}else{
				if(isAvailable()){
						document.addForm.action = "defectdo.do?method=update";
						document.addForm.submit();
					}
					}
			
		}
	}
	//����Ajax���󵽷���������֤��ǰ��Ŀ����ǰ�·ݵļ�¼�Ƿ��Ѵ��ڣ�����Ѵ��ڣ������������ӡ�
	function isAvailable() {
		var isAvailable = false;
		var req = getXmlHttpObject();
		var yearMonth = $("yearMonth").value;
		var chart_project = $("chart_project").value;
		var url = "defectdo.do?method=isExist&yearMonth="+yearMonth+"&chart_project="+chart_project;
		req.onreadystatechange = function(){
			if (req.readyState == 4) {
				if (req.status == 200) {		
					var msg = req.responseText;
					if(msg=="1"){
						isAvailable=false;
						$("tips").innerHTML = "<font color='red'>��ǰ��Ŀ"+$('yearMonth').value+"�·ݵļ�¼�Ѵ��ڣ�</font>";
					}else if(msg=="0"){
						isAvailable=true;
					}else{
						alert("��������ֵ�����쳣��");
					}		
				}
			}
		};
		//false��ʾִ��ͬ����true��ʾִ���첽��������첽�Ļ���isExist�ڻص����������õ�ֵ��������Ч��
		//��ִ���������return��䣬�Ӷ�������ݵĲ�һ�£����Դ˴�����Ϊͬ����
		req.open("POST", url, false);
		req.send(null);
		return isAvailable ;
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
<body  background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<form action="defectdo.do?method=forupdate" name="addForm" method="post">
<%
	ChartDefect view = (ChartDefect) request.getAttribute("defect.view");
	ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
	Map<String, String> chart_projects = productDao.queryAll();
%>
<h2 align="center">ȱ����Ϣ�޸�</h2>
<div align="right">
<input type="button" class="btbox" value="����"	onclick="save()"> 
<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;"> 
<input type="button" class="btbox" value="������ҳ"	onclick="window.location.href='defectdo.do?method=query&path=menu.jsp'">

<input type="hidden" id="pk" name="pk" value="<%=view.getPk() %>" >
<input type="hidden" id="yearMonth" name="yearMonth" value="" >
<input type="hidden" id="yearMonth_old" name="yearMonth_old" value="<%=view.getYearMonth() %>" >
<input type="hidden" id="chart_project_old" name="chart_project_old" value="<%=view.getChart_project() %>" >
</div>
<hr>
<table align="center" border="1" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap" width="150" align="right">��Ʒ����</td>
		<td align="left">
				<select id="chart_project" name="chart_project" size="1" onblur="check_chart_project()" onchange="check_chart_project()">
				<option value="" />---��ѡ��---
				<%
					for (Map.Entry<String, String> entry : chart_projects.entrySet()) {
				%>
				<option value="<%=entry.getKey()%>" <%
				if(entry.getKey().equals(view.getChart_project())){
					out.print("selected=\"selected\"");
				}
				 %>/>
				<%=entry.getValue()%>
				<%
					}
				%>
				</select>
		 <font color="red">*&nbsp;</font> <span id="chart_project_check_result"></span></td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">����</td>
		<td nowrap="nowrap">
		<%
							//��ʽ��201002
							String year = (view.getYearMonth() + "").substring(0, 4).trim();
							String month = (view.getYearMonth()	+ "").substring(4).trim();
							if (month.startsWith("0")) {
								month = month.substring(1);
							}
						%>
		<select id="year" name="year"  size="1" onblur="check_yearMonth()" onchange="check_yearMonth()">
						<option value="">---��---
						<%
							for (int i = 2010; i < 2021; i++) {
							%>
							<option value="<%=i%>" <%if ((i + "").equals(year))
							out.print("selected=\"selected\"");%>><%=i%>
								<%
									}
						%>
						</select>
						��
						<select id="month" name="month"  size="1" onblur="check_yearMonth()" onchange="check_yearMonth()" >
						<option value="">---��---
						<%
							for (int i = 1; i <= 12; i++) {
						%>
							<option value="<%=i < 10 ? "0" + i : i%>" <%if ((i + "").equals(month))
							out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
						<%
							}
						%>
						</select>
						��						
		 <font color="red">*&nbsp;</font>
		<span id="yearMonth_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">�ܰ���</td>
		<td nowrap="nowrap">
			<input type="text" name="packageNumber" value="<%=view.getPackageNumber() %>" size="40" maxlength="25" onblur="check_packageNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="packageNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">��ȱ����</td>
		<td nowrap="nowrap">
			<input type="text" name="defectNumber" value="<%=view.getDefectNumber() %>" size="40" maxlength="25" onblur="check_defectNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="defectNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">��ȱ�ݼ�Ȩֵ</td><% // ��ȱ�ݼ�Ȩֵ/��ȱ����=ȱ��ƽ�����س̶�  %>
		<td nowrap="nowrap">
			<input type="text" name="totalDefectWeight" value="<%=view.getTotalDefectWeight() %>" size="40" maxlength="25" onblur="check_totalDefectWeight()">
			<font color="red">*&nbsp;</font> 
			<span id="totalDefectWeight_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">ȱ��Reopen����</td>
		<td nowrap="nowrap">
			<input type="text" name="reopenNumber" value="<%=view.getReopenNumber() %>" size="40" maxlength="25" onblur="check_reopenNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="reopenNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">�ؼ�����ȱ����</td>
		<td nowrap="nowrap">
			<input type="text" name="seriousDefectNumber" value="<%=view.getSeriousDefectNumber() %>" size="40" maxlength="25" onblur="check_seriousDefectNumber()">
			<font color="red">*&nbsp;</font> 
			<span id="seriousDefectNumber_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">�ؼ�����ȱ�ݼ�Ȩֵ</td><% // �ܴ���ʱ��/�ؼ�����ȱ�ݼ�Ȩֵ=ȱ��ƽ����������  %>
		<td nowrap="nowrap">
			<input type="text" name="totalSeriousDefectWeight" value="<%=view.getTotalSeriousDefectWeight() %>" size="40" maxlength="25" onblur="check_totalSeriousDefectWeight()">
			<font color="red">*&nbsp;</font> 
			<span id="totalSeriousDefectWeight_check_result"></span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" width="150" align="right">�ܴ���ʱ��(Сʱ)</td><% //�ܴ���ʱ��/��ȱ�ݼ�Ȩֵ=ȱ��ƽ����������  %>
		<td nowrap="nowrap">
			<input type="text" name="totalProcessTime" value="<%=view.getTotalProcessTime() %>" size="40" maxlength="25" onblur="check_totalProcessTime()">
			<font color="red">*&nbsp;</font> 
			<span id="totalProcessTime_check_result"></span>
		</td>
	</tr>
	
</table>
</form>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />