<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}

boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
boolean isSuperadmin = Tool.isSuperadmin(request);
boolean isFunctionManager = Tool.isFunctionManager(request);
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@page import="org.jfree.chart.JFreeChart"%>
<%@page import="org.jfree.chart.ChartFactory"%>
<%@page import="java.awt.Font"%>
<%@page import="org.jfree.chart.plot.PiePlot"%>
<%@page import="java.awt.BasicStroke"%>
<%@page import="java.awt.Color"%>
<%@page import="org.jfree.util.Rotation"%>
<%@page import="org.jfree.chart.labels.StandardPieSectionLabelGenerator"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.awt.RenderingHints"%>
<%@page import="org.jfree.chart.entity.StandardEntityCollection"%>
<%@page import="org.jfree.chart.ChartRenderingInfo"%>
<%@page import="org.jfree.chart.servlet.ServletUtilities"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.jfree.chart.ChartUtilities"%>
<%@page import="org.jfree.chart.urls.StandardPieURLGenerator"%>
<%@page import="cn.sdfi.defect.bean.ChartDefect"%>
<%@page import="cn.sdfi.product.dao.ProductDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%><html>
	<head>
		<title>ȱ����Ϣ��ϸ</title>
		<link rel="stylesheet" type="text/css" href="css/pub.css">
		<script language="javascript" src="js/pub.js"></script>
	</head>
	<body background="images/skins/<%=session.getAttribute("skin") %>">
	<span id="tips"></span>
	<%
		ChartDefect view = (ChartDefect) request.getAttribute("defect.view");
		ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
		Map<String, String> chart_projects = productDao.queryAll();
		Map<String, String> project_customers = Const.getEnumMap().get("project_customer");
	%>
		<h2 align="center">
			<%=chart_projects.get(view.getChart_project()) %>&nbsp;<%=view.getYearMonth() %>�·�ȱ����Ϣ��ϸ
		</h2>
		<div align="right">
		<input type="button" class="btbox" value="�޸�" onclick="window.location.href='defectdo.do?method=forupdate&pk=<%=view.getPk() %>'" 
		<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
		%>>
		<input type="button" class="btbox" value="ɾ��" onclick="del()"
		<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
		%>>
		<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
		<input type="button" class="btbox" value="������ҳ" onclick="window.location.href='defectdo.do?method=query&path=menu.jsp'">
		</div>
		<hr>
<table align="center" border="1" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap"  >��Ʒ����</td>
		<td align="left">
			<input type="text"  value="<%=chart_projects.get(view.getChart_project()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	
		<td nowrap="nowrap"  >��������</td>
		<td align="left">
			<input type="text"  value="<%=project_customers.get(view.getProject_customer()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap"  >�ܰ���</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getPackageNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
		<td nowrap="nowrap"  >�ؼ�����ȱ����</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getSeriousDefectNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>		
	</tr>
	<tr>
		<td nowrap="nowrap"  >��ȱ����</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getDefectNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >�ؼ�����ȱ�ݼ�Ȩֵ</td>
		<td nowrap="nowrap">
		<input type="text"  value="<%=view.getTotalSeriousDefectWeight() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap"  >ȱ��Reopen����</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getReopenNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >��ȱ�ݼ�Ȩֵ</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getTotalDefectWeight() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap"  >�ܴ���ʱ��(Сʱ)</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getTotalProcessTime() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
		<td nowrap="nowrap"  >ȱ��ƽ�����س̶�</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getDefectWeightedAverage() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
	</tr>
	<tr>
	<td nowrap="nowrap"  >��ȱ����</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getPackageDefectRate() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >ȱ��ƽ����������(Сʱ)</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getProcessTime() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
	</tr>
	<tr>	
		<td nowrap="nowrap"  >Reopenȱ��ռ��</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=Tool.percentFormat(2,view.getReopenDefectRate()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >�ؼ�����ȱ��ռ��</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=Tool.percentFormat(2,view.getSeriousDefectRate()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
	<td colspan="2">
	<%
	 //����PieDataSet 
	 DefaultPieDataset pie_dataset = new DefaultPieDataset();
	 pie_dataset.setValue("Reopenȱ����",view.getReopenNumber());
	 pie_dataset.setValue("����",view.getDefectNumber()-view.getReopenNumber());
	 JFreeChart chart = ChartFactory.createPieChart3D(
			"Reopenȱ����ռ��ͼ", // ͼ�����
			pie_dataset,//���ݼ�
			 true, // �Ƿ���ʾͼ��
			 true,// �趨�Ƿ���ʾͼ������  
			 true // �趨�Ƿ���������   
			 );
	//ͼƬ��������
	chart.getTitle().setFont(new Font("������", Font.PLAIN, 16));
	
	//ͨ����ͼ���������ñ�״ͼ��Ч��   
	PiePlot plot = (PiePlot) chart.getPlot();//�õ���ͼ������  
	plot.setLabelFont(new Font("����", Font.PLAIN, 12)); // ͼƬ�ϵ����ֵ�����   
	plot.setCircular(false);//Ĭ��ΪԲ�Σ������ڻ���3DЧ��ͼʱ������ΪFalse   
	plot.setOutlineStroke(new BasicStroke(1));//�߿��ϸ   
	plot.setOutlinePaint(Color.GRAY);//�߿���ɫ   
	plot.setStartAngle(150);// ���õ�һ���� �Ŀ�ʼλ��   
	plot.setDirection(Rotation.ANTICLOCKWISE);//���û��Ʒ���Ϊ��ʱ��   
	String unitSytle = "{0}={1}({2})"; //��ʽ: A����=35(15.98%)   
	plot.setLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle,NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// ������ǩ��ʾ��ʽ   
	plot.setLegendLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle, NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// ͼ����ʾ��ʽ   
	
	//URLDecoder.decode("%E5%85%B3%E9%94%AE%E4%B8%A5%E9%87%8D%E7%BC%BA%E9%99%B7%E6%95%B0&amp;id=0","utf-8");
	plot.setURLGenerator(new StandardPieURLGenerator("welcome.jsp","name","id"));// �趨���������� 
	
	//VALUE_TEXT_ANTIALIAS_OFF��ʾ�����ֵĿ���ݹر�,ʹ�õĹرտ���ݺ����御��ѡ��12��15�ŵ��������֡�
	chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

	//��������ͼ�ڵ㡢ֱ��ͼ����ͼ�������Ϻ����ʾ��Ϣ��
	StandardEntityCollection sec = new StandardEntityCollection();
	ChartRenderingInfo info = new ChartRenderingInfo(sec);     
		
	//д��ͼƬ�ļ�
	String filename = ServletUtilities.saveChartAsPNG(chart, 395, 250,info, session);//PNG��ʽ��ͼƬ��ɫ��JPEG����������ռ�ÿռ�С��png:8k,jpeg:60k��
	PrintWriter w = new PrintWriter(out);//���MAP��Ϣ 
		
	//��ͼƬ�ȵ�������Ϣд��ͼƬmap
	ChartUtilities.writeImageMap(w, "map0", info, false);
 	//����ͼƬ��ַ
	String graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
	%>
		<img src="<%=graphURL%>"  border="0" usemap="#map0">
	</td>
	<td colspan="2">
	<%
	 //����PieDataSet
	 DefaultPieDataset pie_dataset2 = new DefaultPieDataset();
	 pie_dataset2.setValue("�ؼ�����ȱ����",view.getSeriousDefectNumber());
	 pie_dataset2.setValue("����",view.getDefectNumber()-view.getSeriousDefectNumber());
	 JFreeChart chart2 = ChartFactory.createPieChart3D(
			"�ؼ�����ȱ����ռ��ͼ", // ͼ�����
			pie_dataset2,//���ݼ�
			 true, // �Ƿ���ʾͼ��
			 true,// �趨�Ƿ���ʾͼ������  
			 true // �趨�Ƿ���������   
			 );
	//ͼƬ��������
	chart2.getTitle().setFont(new Font("������", Font.PLAIN, 16));
	
	//ͨ����ͼ���������ñ�״ͼ��Ч��   
	PiePlot plot2 = (PiePlot) chart2.getPlot();//�õ���ͼ������  
	plot2.setLabelFont(new Font("����", Font.PLAIN, 12)); // ͼƬ�ϵ����ֵ�����   
	plot2.setCircular(false);//Ĭ��ΪԲ�Σ������ڻ���3DЧ��ͼʱ������ΪFalse   
	plot2.setOutlineStroke(new BasicStroke(1));//�߿��ϸ   
	plot2.setOutlinePaint(Color.GRAY);//�߿���ɫ   
	plot2.setStartAngle(150);// ���õ�һ���� �Ŀ�ʼλ��   
	plot2.setDirection(Rotation.ANTICLOCKWISE);//���û��Ʒ���Ϊ��ʱ��   
	String unitSytle2 = "{0}={1}({2})"; //��ʽ: A����=35(15.98%)   
	plot2.setLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle2,NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// ������ǩ��ʾ��ʽ   
	plot2.setLegendLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle2, NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// ͼ����ʾ��ʽ   
	
	//URLDecoder.decode("%E5%85%B3%E9%94%AE%E4%B8%A5%E9%87%8D%E7%BC%BA%E9%99%B7%E6%95%B0&amp;id=0","utf-8");
	plot2.setURLGenerator(new StandardPieURLGenerator("welcome.jsp","name","id"));// �趨���������� 
	
	
	//VALUE_TEXT_ANTIALIAS_OFF��ʾ�����ֵĿ���ݹر�,ʹ�õĹرտ���ݺ����御��ѡ��12��15�ŵ��������֡�
	chart2.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

	//��������ͼ�ڵ㡢ֱ��ͼ����ͼ�������Ϻ����ʾ��Ϣ��
	StandardEntityCollection sec2 = new StandardEntityCollection();
	ChartRenderingInfo info2 = new ChartRenderingInfo(sec2);     
		
	//д��ͼƬ�ļ�
	String filename2 = ServletUtilities.saveChartAsPNG(chart2, 395, 250,info2, session);//PNG��ʽ��ͼƬ��ɫ��JPEG����������ռ�ÿռ�С��png:8k,jpeg:60k��
	PrintWriter w2 = new PrintWriter(out);//���MAP��Ϣ 
		
	//��ͼƬ�ȵ�������Ϣд��ͼƬmap
	ChartUtilities.writeImageMap(w2, "map1", info2, false);
 	//����ͼƬ��ַ
	String graphURL2 = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename2;
	%>
		<img src="<%=graphURL2%>"  border="0" usemap="#map1">
	</td>
	</tr>
</table>
</body>
<script type="text/javascript">
function del(){//ɾ����ǰȱ����Ϣ
if(confirm('ȷ��Ҫɾ���𣿴˲������ָܻ���')){
	window.location.href='defectdo.do?method=delete&pk=<%=view.getPk() %>';
	}
}
</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
