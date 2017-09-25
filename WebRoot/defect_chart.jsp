<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@page contentType="text/html;charset=GBK"%>
<%@page import="org.jfree.data.category.CategoryDataset"%>
<%@page import="org.jfree.data.general.DatasetUtilities"%>
<%@page import="org.jfree.chart.JFreeChart"%>
<%@page import="org.jfree.chart.ChartFactory"%>
<%@page import="org.jfree.chart.plot.PlotOrientation"%>
<%@page import="java.awt.Font"%>
<%@page import="org.jfree.chart.plot.CategoryPlot"%>
<%@page import="org.jfree.chart.renderer.category.LineAndShapeRenderer"%>
<%@page import="org.jfree.chart.labels.StandardCategoryItemLabelGenerator"%>
<%@page import="org.jfree.chart.entity.StandardEntityCollection"%>
<%@page import="org.jfree.chart.ChartRenderingInfo"%>
<%@page import="org.jfree.chart.servlet.ServletUtilities"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.jfree.chart.ChartUtilities"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="java.awt.RenderingHints"%>
<%@page import="java.awt.Color"%>
<%@page import="org.jfree.chart.renderer.category.BarRenderer"%>
<%@page import="java.awt.GradientPaint"%>
<%@page import="org.jfree.chart.renderer.category.BarRenderer3D"%>
<%@page import="org.jfree.chart.axis.CategoryLabelPositions"%>
<%@page import="org.jfree.chart.axis.ValueAxis"%>
<%@page import="org.jfree.chart.labels.ItemLabelPosition"%>
<%@page import="org.jfree.chart.labels.ItemLabelAnchor"%>
<%@page import="org.jfree.ui.TextAnchor"%>
<%@page import="org.jfree.chart.plot.PiePlot"%>
<%@page import="org.jfree.chart.labels.StandardPieSectionLabelGenerator"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.awt.BasicStroke"%>
<%@page import="org.jfree.util.Rotation"%>
<%@page import="org.jfree.chart.labels.StandardXYItemLabelGenerator"%>
<%@page import="cn.sdfi.product.dao.ProductDao"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.defect.bean.ChartDefect"%>
<%@page import="cn.sdfi.defect.dao.ChartDefectDao"%><HTML>
<HEAD>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<TITLE>缺陷统计分析</TITLE>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">

//互斥校验
function incompatible(thisObj,theOtherObjId){
	if(thisObj.value!=""){
		$(theOtherObjId).value="";
	}
	query();
} 
//执行查询操作前的校验
function query() {
	if ($("chart_project").value == "" && $("project_customer").value == "") {
		$("tips").innerHTML = "<font color='red'>请选择项目或者所属部门！</font>";
		return false;
	}else if($("chart_project").value != "" && $("project_customer").value != "") {
		$("tips").innerHTML = "<font color='red'>项目和部门不能同时选择！</font>";
		return false;
	}else if($("chart_data").value == ""){
		$("tips").innerHTML = "<font color='red'>请选择统计类型！</font>";
		return false;
	}else {
		$("yearMonth_begin").value = $("year_begin").value + $("month_begin").value;
		$("yearMonth_end").value = $("year_end").value + $("month_end").value;
		document.formQuery.action = "defect_chart.jsp?method=analysis";
		document.formQuery.submit();
	}
}
</script>
</HEAD>
<body  background="images/skins/<%=session.getAttribute("skin")%>">
<span id="tips"></span>
<table width="100%"  align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
		<h2 align="center">缺陷统计分析</h2>
		</td>
	</tr>
	<tr>
		<td>
		<form name="formQuery" action="defect_chart.jsp?method=analysis" method="post">
		<fieldset><legend>统计分析</legend>
		<table align="center" cellpadding="1" cellspacing="0" border="0">
			<tr>
				<td nowrap="nowrap" align="right">项目名称</td>
				<td>
				<%
				ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
				Map<String,String> chart_projects = productDao.queryAll();	
				%>
				<select id="chart_project" name="chart_project" size="1" onchange="incompatible(this,'project_customer')">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : chart_projects.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>" 
				<%
				if(entry.getKey().equals(request.getParameter("chart_project"))){out.print("selected=\"selected\"");}
				%>
				/>
				<%=entry.getValue()%>
				<%
				}
				%>
				</select>
				</td>
				<td nowrap="nowrap" align="right">所属部门</td><td>
				<%
					Map<String, String> project_customers = Const.getEnumMap().get("project_customer");
				%>
				<select id="project_customer" name="project_customer" size="1" onchange="incompatible(this,'chart_project')">
				<option value="" />---请选择---
				<%
					for (Map.Entry<String, String> entry : project_customers.entrySet()) {
				%>
				<option value="<%=entry.getKey()%>" 
				<%if (entry.getKey().equals(request.getParameter("project_customer"))) {
					out.print("selected=\"selected\"");
				}%>
				/>
				<%=entry.getValue()%>
				<%
					}
				%>
				</select>
				</td>
				<td nowrap="nowrap" align="right">统计类型</td>
				<td>
				<%
					Map<String,String> chart_datas = Const.getEnumMap().get("chart_data");
					
				%>
				<select id="chart_data" name="chart_data" size="1" onchange="query()">
				<option value="" />---请选择---
				<%
				for (Map.Entry<String, String> entry : chart_datas.entrySet()) {
								
				%>
				<option value="<%=entry.getKey()%>"
				<%
				if(entry.getKey().equals(request.getParameter("chart_data"))){out.print("selected=\"selected\"");}
				%>
				 />
				<%=entry.getValue()%>
				<%
				}
				%>
				</select>
				</td>
				</tr><tr>
				<td nowrap="nowrap" align="right">展现方式</td>
				<td nowrap="nowrap">
				<% 
					boolean equals2 = "2".equals(request.getParameter("showstyle")); 
				%>
				<input type="radio" name="showstyle" value="1"  onclick="query()"
							<%	if(!equals2){out.print("checked=\"checked\"");}	%>>折线图
				<input type="radio" name="showstyle" value="2"  onclick="query()"
							<%  if(equals2){out.print("checked=\"checked\"");}	%>>直方图
				</td>
				<td align="right">大小</td><td>
						<%
						String picSize = request.getParameter("picSize");
						%>
						<select id="picSize" name="picSize"  size="1" onchange="query()">
						<option value="800*400" 
						<% if("800*400".equals(picSize)){out.print("selected=\"selected\"");}%>>800*400
						<option value="600*300" 
						<% if("600*300".equals(picSize)||picSize==null){out.print("selected=\"selected\"");}%>>600*300
						<option value="400*200" 
						<% if("400*200".equals(picSize)){out.print("selected=\"selected\"");}%>>400*200
						</select>		
				</td>
				<td align="right">是&nbsp;否&nbsp;3D</td><td>
						<% 
							boolean is3D = "yes".equals(request.getParameter("is3D")); 
						%>
				      <input type="radio" name="is3D" value="yes"  onclick="query()"
									<%	if(is3D){out.print("checked=\"checked\"");}	%>>是
						<input type="radio" name="is3D" value="no"  onclick="query()"
									<%  if(!is3D){out.print("checked=\"checked\"");}%>>否
				 </td>
			</tr>
			<tr>
				<td colspan="6" nowrap="nowrap">
						<%
							String year_begin = null;
							String year_end = null;
							String month_begin = null;
							String month_end = null;
							String yearMonth_begin = request.getParameter("yearMonth_begin");
							String yearMonth_end = request.getParameter("yearMonth_end");
							
							//如果是查询后返回
							if (yearMonth_begin != null && !"".equals(yearMonth_begin)) {

								//格式：201002
								year_begin = yearMonth_begin.substring(0, 4).trim();
								month_begin = yearMonth_begin.substring(4).trim();
								if (month_begin.startsWith("0")) {
									month_begin = month_begin.substring(1);
								}
								year_end = yearMonth_end.substring(0, 4).trim();
								month_end = yearMonth_end.substring(4).trim();
								if (month_end.startsWith("0")) {
									month_end = month_end.substring(1);
								}
							//如果是从菜单栏进入
							}else{
								year_begin = Tool.getCurrentYear();
								month_begin = "4";
								if(Integer.parseInt(Tool.getCurrentMonth())<4){
									year_begin = (Integer.parseInt(year_begin)-1)+"";
								}
								year_end = Tool.getCurrentYear();
								month_end = Tool.getCurrentMonth();	
							}
						%>
						时&nbsp;间&nbsp;段
						<select id="year_begin" name="year_begin"  size="1" onchange="query()">
						<%
							for (int i = 2010; i < 2021; i++) {
						%>
						<option value="<%=i%>" <%
						if ((i + "").equals(year_begin))
							out.print("selected=\"selected\"");%>><%=i%>
						<%
							}
						%>
						</select>
						年
						<select id="month_begin" name="month_begin"  size="1" onchange="query()">
						<%
							for (int i = 1; i <= 12; i++) {
						%>
						<option value="<%=i < 10 ? "0" + i : i%>" <%
						if ((i + "").equals(month_begin))
							out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
						<%
							}
						%>
						</select>
						月						
						<input type="hidden" id="yearMonth_begin" name="yearMonth_begin" value="" >
						&nbsp;&nbsp;至&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="year_end" name="year_end"  size="1" onchange="query()">
						<%
							for (int i = 2010; i < 2021; i++) {
						%>
						<option value="<%=i%>" <%
						if ((i + "").equals(year_end))
							out.print("selected=\"selected\"");%>><%=i%>
						<%
							}
						%>
						</select>
						年		
						<select id="month_end" name="month_end"  size="1" onchange="query()">
						<%
							for (int i = 1; i <= 12; i++) {
						%>
						<option value="<%=i < 10 ? "0" + i : i%>" <%
						if ((i + "").equals(month_end))
							out.print("selected=\"selected\"");%>><%=i < 10 ? "0" + i : i%>
						<%
							}
						%>
						</select>
						月						
						<input type="hidden" id="yearMonth_end" name="yearMonth_end" value="" />		
				</td>
				
				<td align="right" colspan="1">
				<input type="button" onclick="query()" class="btbox" value="统计分析" >
				</td>
			</tr>		
		</table>
		</fieldset>
		</form>
		</td>
	</tr>
	<tr>
	<td>
	
<%   
if("analysis".equals(request.getParameter("method"))){
	
	//取得查询条件
	String condition_chart_project = request.getParameter("chart_project");//l3/D3...
	if(condition_chart_project==null)condition_chart_project="";
	String project_customer = request.getParameter("project_customer");//所属部门：技术中心、烟草。。。
	if(project_customer==null)project_customer="";
	String chart_data = request.getParameter("chart_data");//各种缺陷率
	String showstyle = request.getParameter("showstyle");//视图方式：趋势图、直方图。。。。
	
	//组装查询条件
	ChartDefect querychart = new ChartDefect();
	querychart.setChart_data(chart_data);
	querychart.setChart_project(condition_chart_project);
	querychart.setProject_customer(project_customer);
	querychart.setYearMonth_begin(Integer.parseInt(yearMonth_begin));
	querychart.setYearMonth_end(Integer.parseInt(yearMonth_end));
	
	
	//执行查询
	String style = null;//统计方式：按照部门  or 按照项目
	if(condition_chart_project==null||"".equals(condition_chart_project)){
		style = "project_customer";
	}else{
		style = "chart_project";
	}
	ChartDefectDao dao = (ChartDefectDao)ObjectFactory.getObject(ChartDefectDao.class.getName());
	Map<String,double[]> returnMap = dao.analysis(querychart,style);
	
	//如果返回结果不为空，则用图表进行展现
	if(returnMap.size()>0){
	
		//横坐标title，部门  or 项目
		String rowkey = null;
		if(style.equals("project_customer")){
			rowkey = project_customers.get(project_customer);
		}else{
			rowkey = chart_projects.get(condition_chart_project);
		}	 
		
		double[] temp = returnMap.get("yearMonth");
		String [] yearmonth = new String[temp.length];
		for(int i=0;i<temp.length;i++){
			String temp2 = (temp[i]+"").substring(0,6);//截取月份：201010.0	
			yearmonth[i]=temp2;
		}
		String[] columnKeys = yearmonth;	    
		
		 //调用工厂方法创建数据源
		CategoryDataset dataset = null;
		if("O".equals(chart_data)){//如果统计的是项目整体质量
			double[][] data = {returnMap.get("seriousDefectNumber"),returnMap.get("defectNumber"),returnMap.get("defectWeightedAverage")};
			String[] rowKeys = {"关键严重缺陷数","总缺陷数","缺陷平均严重程度"};	
			dataset = DatasetUtilities.createCategoryDataset(rowKeys, columnKeys, data);
		}else{
			String[] rowKeys = {rowkey};
			double[][] data = {returnMap.get("chartData")};
			dataset = DatasetUtilities.createCategoryDataset(rowKeys, columnKeys, data);
		}	
		JFreeChart chart =null;
	     
	//---------------------趋势图---begin--------------------     
	 if("1".equals(showstyle)){
		 
			if(is3D){//3D展现	
			   chart = ChartFactory.createLineChart3D(chart_datas.get(chart_data)
					+"走势图", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
				 true,  //生成图例
				true,  //生成热点工具，如果要在图片中实现鼠标放上时显示数据，须设置为true
				false);  //生成URL链接
			}else{//2D展现	
				chart = ChartFactory.createLineChart(chart_datas.get(chart_data)
						+"走势图", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
					 true,  //生成图例
					true,  //生成热点工具，如果要在图片中实现鼠标放上时显示数据，须设置为true
					false);  //生成URL链接
			}
			
			//图片标题字体
			chart.getTitle().setFont(new Font("新宋体", Font.PLAIN, 16));

			//坐标轴字体
			CategoryPlot plot = chart.getCategoryPlot();
		    chart.getLegend().setItemFont(new Font("新宋体", Font.PLAIN, 14));//对横坐标轴标题进行字体设置         
			plot.getDomainAxis().setTickLabelFont(new Font("新宋体", Font.PLAIN, 14));//对横坐标刻度进行字体设置
			plot.getDomainAxis().setLabelFont(new Font("新宋体", Font.PLAIN, 15));
			plot.getRangeAxis().setLabelFont(new Font("新宋体", Font.PLAIN, 15));//y轴外围字体
			plot.getRangeAxis().setTickLabelFont(new Font("新宋体", Font.PLAIN, 12));//对纵坐标刻度进行字体设置
	    
			ValueAxis rangAxis = plot.getRangeAxis();
			rangAxis.setUpperMargin(0.15);//设置最高点离图片顶端的距离
			rangAxis.setLowerMargin(0.15);//设置最矮点离图片底端的距离
			plot.setRangeAxis(rangAxis);
			plot.setForegroundAlpha(1.0f);//设置折线的透明度
			
		LineAndShapeRenderer render = (LineAndShapeRenderer) plot.getRenderer();
		render.setBaseShapesVisible(true); // 是否显示折点
		render.setBaseLinesVisible(true);//是否显示折线
		
		if("2".equals(chart_data)||"3".equals(chart_data)){//”2:关键严重缺陷率环比,3:Reopen缺陷率环比“ 以百分比形式展现
			NumberFormat nf = NumberFormat.getPercentInstance();   
			nf.setMinimumFractionDigits(2);// 小数点后保留几位   
			render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator("{2}",nf,nf));//设置在柱体上以百分比的形式显示数据
		}else{	
			render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//设置折点上显示数据
		}
		render.setBaseItemLabelFont(new Font("新宋体",Font.PLAIN,14));
		render.setBaseItemLabelsVisible(true); 	 
	 }
	
	//---------------------直方图---begin--------------------   
	 else{
		 if(is3D){		 
			 chart = ChartFactory.createBarChart3D(chart_datas.get(chart_data)
				+"走势图", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
				 true,  //生成图例
				true,  //生成热点工具，如果要在图片中实现鼠标放上时显示数据，须设置为true
				false);  //生成URL链接
		 }else{
			 chart = ChartFactory.createBarChart(chart_datas.get(chart_data)
						+"走势图", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
						 true,  //生成图例
						true,  //生成热点工具，如果要在图片中实现鼠标放上时显示数据，须设置为true
						false);  //生成URL链接
		 }

			//图片标题字体
			chart.getTitle().setFont(new Font("新宋体", Font.PLAIN, 16));

			//坐标轴字体
			CategoryPlot plot = chart.getCategoryPlot();
		    chart.getLegend().setItemFont(new Font("新宋体", Font.PLAIN, 14));//对横坐标轴标题进行字体设置         
			plot.getDomainAxis().setTickLabelFont(new Font("新宋体", Font.PLAIN, 14));//对横坐标刻度进行字体设置
			//plot.getDomainAxis().setCategoryLabelPositions(CategoryLabelPositions.UP_45);//对横坐标刻度字体的倾斜度进行设置
			plot.getDomainAxis().setLabelFont(new Font("新宋体", Font.PLAIN, 15));
			plot.getRangeAxis().setLabelFont(new Font("新宋体", Font.PLAIN, 15));//对纵坐标标题进行字体设置
			plot.getRangeAxis().setTickLabelFont(new Font("新宋体", Font.PLAIN, 12));//对纵坐标刻度进行字体设置
			plot.setForegroundAlpha(1.0f);//设置柱子的透明度,1.0表示完全不透明
			
			ValueAxis rangAxis = plot.getRangeAxis();
			rangAxis.setUpperMargin(0.15);//设置最高柱子离图片顶端的距离
			rangAxis.setLowerMargin(0.15);//设置最矮柱子离图片底端的距离
			plot.setRangeAxis(rangAxis);
			
			BarRenderer render = null;
			if(is3D){
				render = (BarRenderer3D)plot.getRenderer();
			}else{		
				render = (BarRenderer)plot.getRenderer();	
			}
			render.setMinimumBarLength(0.02);//设置bar的最小宽度，以保证能显示数值	
			render.setMaximumBarWidth(0.07); //最大宽度
			
			if("2".equals(chart_data)||"3".equals(chart_data)){//”2:关键严重缺陷率环比,3:Reopen缺陷率环比“ 以百分比形式展现
				NumberFormat nf = NumberFormat.getPercentInstance();   
				nf.setMinimumFractionDigits(2);// 小数点后保留几位   
				render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator("{2}",nf,nf));//设置在柱体上以百分比的形式显示数据
			}else{	
				render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//设置在柱体上显示数据
			}
			render.setBaseItemLabelFont(new Font("新宋体",Font.PLAIN,13));//设置柱子上的数据的字体
			render.setBaseItemLabelsVisible(true);//设置bar上面的数值可见。
			render.setItemMargin(0.1);//每月份包含多个柱子时，设置柱子之间的间隔
			
			//解决柱子太矮时，数据不能显示的问题  
			ItemLabelPosition itemLabelPositionFallback=new ItemLabelPosition(ItemLabelAnchor.CENTER,TextAnchor.BASELINE_LEFT,TextAnchor.TOP_CENTER,0D);
			render.setPositiveItemLabelPositionFallback(itemLabelPositionFallback);
			render.setNegativeItemLabelPositionFallback(itemLabelPositionFallback);
	 } 
	//VALUE_TEXT_ANTIALIAS_OFF表示将文字的抗锯齿关闭,使用的关闭抗锯齿后，字体尽量选择12到15号的新宋体字。
	 chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

		//设置趋势图节点、直方图，鼠标放上后的提示信息。
		StandardEntityCollection sec = new StandardEntityCollection();
		ChartRenderingInfo info = new ChartRenderingInfo(sec);
	     
		
		//写入图片文件
		//String filename = ServletUtilities.saveChartAsJPEG(chart, 800, 400,info, session);
		String[] widthHeight = picSize.split("\\*");//split("*")会报错，须用"\\"进行转义
		String filename = ServletUtilities.saveChartAsPNG(chart, Integer.parseInt(widthHeight[0]), Integer.parseInt(widthHeight[1]),info, session);//PNG格式的图片颜色较JPEG鲜亮，并且占用空间小（png:8k,jpeg:60k）
		PrintWriter w = new PrintWriter(out);//输出MAP信息 
		
	     //将图片热点链接信息写入图片map
		ChartUtilities.writeImageMap(w, "map0", info, false);
		 //保存图片地址
	String graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
	%>
	<P ALIGN="CENTER"><img src="<%=graphURL%>"  border="0" usemap="#map0"></P>
	<fieldset>
	<table cellpadding="1" cellspacing="0" border="1" align="center" width="100%" >
	<tr><th>统计类型 / 月份</th>
	<%	for(int i=0;i<yearmonth.length;i++){
			out.println("<th>"+yearmonth[i]+"</th>");
	}%>	</tr>
	<%
	if("O".equals(chart_data)){//项目整体质量，包括三个评价标准
		out.println("<tr><td align=\"center\">关键严重缺陷数</td>");
		double [] t_serious = returnMap.get("seriousDefectNumber");
		double [] t_total = returnMap.get("defectNumber");
		double [] t_weight = returnMap.get("defectWeightedAverage");
		for(int i=0;i<t_serious.length;i++){		
			out.print("<td>");
			out.print((int)t_serious[i]);
			out.print("</td>");
		}
		out.println("</tr>");
		out.println("<tr><td align=\"center\">总缺陷数</td>");
		for(int i=0;i<t_total.length;i++){		
			out.print("<td>");
			out.print((int)t_total[i]);
			out.print("</td>");
		}
		out.println("</tr>");
		out.println("<tr><td align=\"center\">缺陷平均严重程度</td>");
		for(int i=0;i<t_weight.length;i++){		
			out.print("<td>");
			out.print(Tool.format(2,t_weight[i]));
			out.print("</td>");
		}
		out.println("</tr>");
	}else{
		out.println("<tr><td align=\"center\">");
		out.println(chart_datas.get(chart_data));
		out.print("</td>");
		
		double [] t_chartData = returnMap.get("chartData");
		boolean showPercent = "2".equals(chart_data)||"3".equals(chart_data);//百分比形式展现
		for(int i=0;i<t_chartData.length;i++){		
			out.print("<td>");
			if(showPercent){			
				out.print(Tool.percentFormat(2,t_chartData[i]));
			}else{
				out.print(Tool.format(2,t_chartData[i]));
			}
			out.print("</td>");
		}
			out.println("</tr>");
	}
	%>
	</table>
	</fieldset>
	<%
	}else{
		out.println("<script type=\"text/javascript\">");
 		out.println("document.getElementById('tips').innerHTML=\"<font color='red'>Sorry，无符合条件的记录！</font>\";");
 		out.print("</script>");
	}
}
	%>
	</td>
	</tr>
</table>
</BODY>
</HTML>
