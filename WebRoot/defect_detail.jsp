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
		<title>缺陷信息明细</title>
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
			<%=chart_projects.get(view.getChart_project()) %>&nbsp;<%=view.getYearMonth() %>月份缺陷信息明细
		</h2>
		<div align="right">
		<input type="button" class="btbox" value="修改" onclick="window.location.href='defectdo.do?method=forupdate&pk=<%=view.getPk() %>'" 
		<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
		%>>
		<input type="button" class="btbox" value="删除" onclick="del()"
		<%
			if (!isDocmentAdmin&&!isSuperadmin&&!isFunctionManager) {
				out.print("disabled=\"disabled\" ");
			}
		%>>
		<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
		<input type="button" class="btbox" value="返回首页" onclick="window.location.href='defectdo.do?method=query&path=menu.jsp'">
		</div>
		<hr>
<table align="center" border="1" cellpadding="1" cellspacing="0">
	<tr>
		<td nowrap="nowrap"  >产品名称</td>
		<td align="left">
			<input type="text"  value="<%=chart_projects.get(view.getChart_project()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	
		<td nowrap="nowrap"  >所属部门</td>
		<td align="left">
			<input type="text"  value="<%=project_customers.get(view.getProject_customer()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap"  >总包数</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getPackageNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
		<td nowrap="nowrap"  >关键严重缺陷数</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getSeriousDefectNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>		
	</tr>
	<tr>
		<td nowrap="nowrap"  >总缺陷数</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getDefectNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >关键严重缺陷加权值</td>
		<td nowrap="nowrap">
		<input type="text"  value="<%=view.getTotalSeriousDefectWeight() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap"  >缺陷Reopen次数</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getReopenNumber() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >总缺陷加权值</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getTotalDefectWeight() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap"  >总处理时长(小时)</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getTotalProcessTime() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
		<td nowrap="nowrap"  >缺陷平均严重程度</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getDefectWeightedAverage() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
	</tr>
	<tr>
	<td nowrap="nowrap"  >包缺陷率</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getPackageDefectRate() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >缺陷平均处理周期(小时)</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=view.getProcessTime() %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>	
	</tr>
	<tr>	
		<td nowrap="nowrap"  >Reopen缺陷占比</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=Tool.percentFormat(2,view.getReopenDefectRate()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
		<td nowrap="nowrap"  >关键严重缺陷占比</td>
		<td nowrap="nowrap">
			<input type="text"  value="<%=Tool.percentFormat(2,view.getSeriousDefectRate()) %>" size="30" style="color: #6C6C6C" readonly="readonly" onmouseover="this.title=this.value" onclick="this.blur()" >
		</td>
	</tr>
	<tr>
	<td colspan="2">
	<%
	 //构建PieDataSet 
	 DefaultPieDataset pie_dataset = new DefaultPieDataset();
	 pie_dataset.setValue("Reopen缺陷数",view.getReopenNumber());
	 pie_dataset.setValue("其他",view.getDefectNumber()-view.getReopenNumber());
	 JFreeChart chart = ChartFactory.createPieChart3D(
			"Reopen缺陷数占比图", // 图表标题
			pie_dataset,//数据集
			 true, // 是否显示图例
			 true,// 设定是否显示图例名称  
			 true // 设定是否生成链接   
			 );
	//图片标题字体
	chart.getTitle().setFont(new Font("新宋体", Font.PLAIN, 16));
	
	//通过绘图区对象设置饼状图的效果   
	PiePlot plot = (PiePlot) chart.getPlot();//得到绘图区对象  
	plot.setLabelFont(new Font("宋体", Font.PLAIN, 12)); // 图片上的文字的字体   
	plot.setCircular(false);//默认为圆形，建议在绘制3D效果图时将其设为False   
	plot.setOutlineStroke(new BasicStroke(1));//边框粗细   
	plot.setOutlinePaint(Color.GRAY);//边框颜色   
	plot.setStartAngle(150);// 设置第一部分 的开始位置   
	plot.setDirection(Rotation.ANTICLOCKWISE);//设置绘制方向为逆时针   
	String unitSytle = "{0}={1}({2})"; //样式: A部分=35(15.98%)   
	plot.setLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle,NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// 引出标签显示样式   
	plot.setLegendLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle, NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// 图例显示样式   
	
	//URLDecoder.decode("%E5%85%B3%E9%94%AE%E4%B8%A5%E9%87%8D%E7%BC%BA%E9%99%B7%E6%95%B0&amp;id=0","utf-8");
	plot.setURLGenerator(new StandardPieURLGenerator("welcome.jsp","name","id"));// 设定热区超链接 
	
	//VALUE_TEXT_ANTIALIAS_OFF表示将文字的抗锯齿关闭,使用的关闭抗锯齿后，字体尽量选择12到15号的新宋体字。
	chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

	//设置趋势图节点、直方图、饼图，鼠标放上后的提示信息。
	StandardEntityCollection sec = new StandardEntityCollection();
	ChartRenderingInfo info = new ChartRenderingInfo(sec);     
		
	//写入图片文件
	String filename = ServletUtilities.saveChartAsPNG(chart, 395, 250,info, session);//PNG格式的图片颜色较JPEG鲜亮，并且占用空间小（png:8k,jpeg:60k）
	PrintWriter w = new PrintWriter(out);//输出MAP信息 
		
	//将图片热点链接信息写入图片map
	ChartUtilities.writeImageMap(w, "map0", info, false);
 	//保存图片地址
	String graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
	%>
		<img src="<%=graphURL%>"  border="0" usemap="#map0">
	</td>
	<td colspan="2">
	<%
	 //构建PieDataSet
	 DefaultPieDataset pie_dataset2 = new DefaultPieDataset();
	 pie_dataset2.setValue("关键严重缺陷数",view.getSeriousDefectNumber());
	 pie_dataset2.setValue("其他",view.getDefectNumber()-view.getSeriousDefectNumber());
	 JFreeChart chart2 = ChartFactory.createPieChart3D(
			"关键严重缺陷数占比图", // 图表标题
			pie_dataset2,//数据集
			 true, // 是否显示图例
			 true,// 设定是否显示图例名称  
			 true // 设定是否生成链接   
			 );
	//图片标题字体
	chart2.getTitle().setFont(new Font("新宋体", Font.PLAIN, 16));
	
	//通过绘图区对象设置饼状图的效果   
	PiePlot plot2 = (PiePlot) chart2.getPlot();//得到绘图区对象  
	plot2.setLabelFont(new Font("宋体", Font.PLAIN, 12)); // 图片上的文字的字体   
	plot2.setCircular(false);//默认为圆形，建议在绘制3D效果图时将其设为False   
	plot2.setOutlineStroke(new BasicStroke(1));//边框粗细   
	plot2.setOutlinePaint(Color.GRAY);//边框颜色   
	plot2.setStartAngle(150);// 设置第一部分 的开始位置   
	plot2.setDirection(Rotation.ANTICLOCKWISE);//设置绘制方向为逆时针   
	String unitSytle2 = "{0}={1}({2})"; //样式: A部分=35(15.98%)   
	plot2.setLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle2,NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// 引出标签显示样式   
	plot2.setLegendLabelGenerator(new StandardPieSectionLabelGenerator(unitSytle2, NumberFormat.getNumberInstance(), new DecimalFormat("0.00%")));// 图例显示样式   
	
	//URLDecoder.decode("%E5%85%B3%E9%94%AE%E4%B8%A5%E9%87%8D%E7%BC%BA%E9%99%B7%E6%95%B0&amp;id=0","utf-8");
	plot2.setURLGenerator(new StandardPieURLGenerator("welcome.jsp","name","id"));// 设定热区超链接 
	
	
	//VALUE_TEXT_ANTIALIAS_OFF表示将文字的抗锯齿关闭,使用的关闭抗锯齿后，字体尽量选择12到15号的新宋体字。
	chart2.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

	//设置趋势图节点、直方图、饼图，鼠标放上后的提示信息。
	StandardEntityCollection sec2 = new StandardEntityCollection();
	ChartRenderingInfo info2 = new ChartRenderingInfo(sec2);     
		
	//写入图片文件
	String filename2 = ServletUtilities.saveChartAsPNG(chart2, 395, 250,info2, session);//PNG格式的图片颜色较JPEG鲜亮，并且占用空间小（png:8k,jpeg:60k）
	PrintWriter w2 = new PrintWriter(out);//输出MAP信息 
		
	//将图片热点链接信息写入图片map
	ChartUtilities.writeImageMap(w2, "map1", info2, false);
 	//保存图片地址
	String graphURL2 = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename2;
	%>
		<img src="<%=graphURL2%>"  border="0" usemap="#map1">
	</td>
	</tr>
</table>
</body>
<script type="text/javascript">
function del(){//删除当前缺陷信息
if(confirm('确认要删除吗？此操作不能恢复！')){
	window.location.href='defectdo.do?method=delete&pk=<%=view.getPk() %>';
	}
}
</script>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />
