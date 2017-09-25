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
<TITLE>ȱ��ͳ�Ʒ���</TITLE>
<link rel="stylesheet" type="text/css" href="css/pub.css">
<script language="javascript" src="js/pub.js"></script>
<script type="text/javascript">

//����У��
function incompatible(thisObj,theOtherObjId){
	if(thisObj.value!=""){
		$(theOtherObjId).value="";
	}
	query();
} 
//ִ�в�ѯ����ǰ��У��
function query() {
	if ($("chart_project").value == "" && $("project_customer").value == "") {
		$("tips").innerHTML = "<font color='red'>��ѡ����Ŀ�����������ţ�</font>";
		return false;
	}else if($("chart_project").value != "" && $("project_customer").value != "") {
		$("tips").innerHTML = "<font color='red'>��Ŀ�Ͳ��Ų���ͬʱѡ��</font>";
		return false;
	}else if($("chart_data").value == ""){
		$("tips").innerHTML = "<font color='red'>��ѡ��ͳ�����ͣ�</font>";
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
		<h2 align="center">ȱ��ͳ�Ʒ���</h2>
		</td>
	</tr>
	<tr>
		<td>
		<form name="formQuery" action="defect_chart.jsp?method=analysis" method="post">
		<fieldset><legend>ͳ�Ʒ���</legend>
		<table align="center" cellpadding="1" cellspacing="0" border="0">
			<tr>
				<td nowrap="nowrap" align="right">��Ŀ����</td>
				<td>
				<%
				ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
				Map<String,String> chart_projects = productDao.queryAll();	
				%>
				<select id="chart_project" name="chart_project" size="1" onchange="incompatible(this,'project_customer')">
				<option value="" />---��ѡ��---
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
				<td nowrap="nowrap" align="right">��������</td><td>
				<%
					Map<String, String> project_customers = Const.getEnumMap().get("project_customer");
				%>
				<select id="project_customer" name="project_customer" size="1" onchange="incompatible(this,'chart_project')">
				<option value="" />---��ѡ��---
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
				<td nowrap="nowrap" align="right">ͳ������</td>
				<td>
				<%
					Map<String,String> chart_datas = Const.getEnumMap().get("chart_data");
					
				%>
				<select id="chart_data" name="chart_data" size="1" onchange="query()">
				<option value="" />---��ѡ��---
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
				<td nowrap="nowrap" align="right">չ�ַ�ʽ</td>
				<td nowrap="nowrap">
				<% 
					boolean equals2 = "2".equals(request.getParameter("showstyle")); 
				%>
				<input type="radio" name="showstyle" value="1"  onclick="query()"
							<%	if(!equals2){out.print("checked=\"checked\"");}	%>>����ͼ
				<input type="radio" name="showstyle" value="2"  onclick="query()"
							<%  if(equals2){out.print("checked=\"checked\"");}	%>>ֱ��ͼ
				</td>
				<td align="right">��С</td><td>
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
				<td align="right">��&nbsp;��&nbsp;3D</td><td>
						<% 
							boolean is3D = "yes".equals(request.getParameter("is3D")); 
						%>
				      <input type="radio" name="is3D" value="yes"  onclick="query()"
									<%	if(is3D){out.print("checked=\"checked\"");}	%>>��
						<input type="radio" name="is3D" value="no"  onclick="query()"
									<%  if(!is3D){out.print("checked=\"checked\"");}%>>��
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
							
							//����ǲ�ѯ�󷵻�
							if (yearMonth_begin != null && !"".equals(yearMonth_begin)) {

								//��ʽ��201002
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
							//����ǴӲ˵�������
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
						ʱ&nbsp;��&nbsp;��
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
						��
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
						��						
						<input type="hidden" id="yearMonth_begin" name="yearMonth_begin" value="" >
						&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="year_end" name="year_end"  size="1" onchange="query()">
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
						��		
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
						��						
						<input type="hidden" id="yearMonth_end" name="yearMonth_end" value="" />		
				</td>
				
				<td align="right" colspan="1">
				<input type="button" onclick="query()" class="btbox" value="ͳ�Ʒ���" >
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
	
	//ȡ�ò�ѯ����
	String condition_chart_project = request.getParameter("chart_project");//l3/D3...
	if(condition_chart_project==null)condition_chart_project="";
	String project_customer = request.getParameter("project_customer");//�������ţ��������ġ��̲ݡ�����
	if(project_customer==null)project_customer="";
	String chart_data = request.getParameter("chart_data");//����ȱ����
	String showstyle = request.getParameter("showstyle");//��ͼ��ʽ������ͼ��ֱ��ͼ��������
	
	//��װ��ѯ����
	ChartDefect querychart = new ChartDefect();
	querychart.setChart_data(chart_data);
	querychart.setChart_project(condition_chart_project);
	querychart.setProject_customer(project_customer);
	querychart.setYearMonth_begin(Integer.parseInt(yearMonth_begin));
	querychart.setYearMonth_end(Integer.parseInt(yearMonth_end));
	
	
	//ִ�в�ѯ
	String style = null;//ͳ�Ʒ�ʽ�����ղ���  or ������Ŀ
	if(condition_chart_project==null||"".equals(condition_chart_project)){
		style = "project_customer";
	}else{
		style = "chart_project";
	}
	ChartDefectDao dao = (ChartDefectDao)ObjectFactory.getObject(ChartDefectDao.class.getName());
	Map<String,double[]> returnMap = dao.analysis(querychart,style);
	
	//������ؽ����Ϊ�գ�����ͼ�����չ��
	if(returnMap.size()>0){
	
		//������title������  or ��Ŀ
		String rowkey = null;
		if(style.equals("project_customer")){
			rowkey = project_customers.get(project_customer);
		}else{
			rowkey = chart_projects.get(condition_chart_project);
		}	 
		
		double[] temp = returnMap.get("yearMonth");
		String [] yearmonth = new String[temp.length];
		for(int i=0;i<temp.length;i++){
			String temp2 = (temp[i]+"").substring(0,6);//��ȡ�·ݣ�201010.0	
			yearmonth[i]=temp2;
		}
		String[] columnKeys = yearmonth;	    
		
		 //���ù���������������Դ
		CategoryDataset dataset = null;
		if("O".equals(chart_data)){//���ͳ�Ƶ�����Ŀ��������
			double[][] data = {returnMap.get("seriousDefectNumber"),returnMap.get("defectNumber"),returnMap.get("defectWeightedAverage")};
			String[] rowKeys = {"�ؼ�����ȱ����","��ȱ����","ȱ��ƽ�����س̶�"};	
			dataset = DatasetUtilities.createCategoryDataset(rowKeys, columnKeys, data);
		}else{
			String[] rowKeys = {rowkey};
			double[][] data = {returnMap.get("chartData")};
			dataset = DatasetUtilities.createCategoryDataset(rowKeys, columnKeys, data);
		}	
		JFreeChart chart =null;
	     
	//---------------------����ͼ---begin--------------------     
	 if("1".equals(showstyle)){
		 
			if(is3D){//3Dչ��	
			   chart = ChartFactory.createLineChart3D(chart_datas.get(chart_data)
					+"����ͼ", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
				 true,  //����ͼ��
				true,  //�����ȵ㹤�ߣ����Ҫ��ͼƬ��ʵ��������ʱ��ʾ���ݣ�������Ϊtrue
				false);  //����URL����
			}else{//2Dչ��	
				chart = ChartFactory.createLineChart(chart_datas.get(chart_data)
						+"����ͼ", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
					 true,  //����ͼ��
					true,  //�����ȵ㹤�ߣ����Ҫ��ͼƬ��ʵ��������ʱ��ʾ���ݣ�������Ϊtrue
					false);  //����URL����
			}
			
			//ͼƬ��������
			chart.getTitle().setFont(new Font("������", Font.PLAIN, 16));

			//����������
			CategoryPlot plot = chart.getCategoryPlot();
		    chart.getLegend().setItemFont(new Font("������", Font.PLAIN, 14));//�Ժ���������������������         
			plot.getDomainAxis().setTickLabelFont(new Font("������", Font.PLAIN, 14));//�Ժ�����̶Ƚ�����������
			plot.getDomainAxis().setLabelFont(new Font("������", Font.PLAIN, 15));
			plot.getRangeAxis().setLabelFont(new Font("������", Font.PLAIN, 15));//y����Χ����
			plot.getRangeAxis().setTickLabelFont(new Font("������", Font.PLAIN, 12));//��������̶Ƚ�����������
	    
			ValueAxis rangAxis = plot.getRangeAxis();
			rangAxis.setUpperMargin(0.15);//������ߵ���ͼƬ���˵ľ���
			rangAxis.setLowerMargin(0.15);//���������ͼƬ�׶˵ľ���
			plot.setRangeAxis(rangAxis);
			plot.setForegroundAlpha(1.0f);//�������ߵ�͸����
			
		LineAndShapeRenderer render = (LineAndShapeRenderer) plot.getRenderer();
		render.setBaseShapesVisible(true); // �Ƿ���ʾ�۵�
		render.setBaseLinesVisible(true);//�Ƿ���ʾ����
		
		if("2".equals(chart_data)||"3".equals(chart_data)){//��2:�ؼ�����ȱ���ʻ���,3:Reopenȱ���ʻ��ȡ� �԰ٷֱ���ʽչ��
			NumberFormat nf = NumberFormat.getPercentInstance();   
			nf.setMinimumFractionDigits(2);// С���������λ   
			render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator("{2}",nf,nf));//�������������԰ٷֱȵ���ʽ��ʾ����
		}else{	
			render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//�����۵�����ʾ����
		}
		render.setBaseItemLabelFont(new Font("������",Font.PLAIN,14));
		render.setBaseItemLabelsVisible(true); 	 
	 }
	
	//---------------------ֱ��ͼ---begin--------------------   
	 else{
		 if(is3D){		 
			 chart = ChartFactory.createBarChart3D(chart_datas.get(chart_data)
				+"����ͼ", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
				 true,  //����ͼ��
				true,  //�����ȵ㹤�ߣ����Ҫ��ͼƬ��ʵ��������ʱ��ʾ���ݣ�������Ϊtrue
				false);  //����URL����
		 }else{
			 chart = ChartFactory.createBarChart(chart_datas.get(chart_data)
						+"����ͼ", "O".equals(chart_data)?rowkey:"", chart_datas.get(chart_data),dataset, PlotOrientation.VERTICAL,
						 true,  //����ͼ��
						true,  //�����ȵ㹤�ߣ����Ҫ��ͼƬ��ʵ��������ʱ��ʾ���ݣ�������Ϊtrue
						false);  //����URL����
		 }

			//ͼƬ��������
			chart.getTitle().setFont(new Font("������", Font.PLAIN, 16));

			//����������
			CategoryPlot plot = chart.getCategoryPlot();
		    chart.getLegend().setItemFont(new Font("������", Font.PLAIN, 14));//�Ժ���������������������         
			plot.getDomainAxis().setTickLabelFont(new Font("������", Font.PLAIN, 14));//�Ժ�����̶Ƚ�����������
			//plot.getDomainAxis().setCategoryLabelPositions(CategoryLabelPositions.UP_45);//�Ժ�����̶��������б�Ƚ�������
			plot.getDomainAxis().setLabelFont(new Font("������", Font.PLAIN, 15));
			plot.getRangeAxis().setLabelFont(new Font("������", Font.PLAIN, 15));//����������������������
			plot.getRangeAxis().setTickLabelFont(new Font("������", Font.PLAIN, 12));//��������̶Ƚ�����������
			plot.setForegroundAlpha(1.0f);//�������ӵ�͸����,1.0��ʾ��ȫ��͸��
			
			ValueAxis rangAxis = plot.getRangeAxis();
			rangAxis.setUpperMargin(0.15);//�������������ͼƬ���˵ľ���
			rangAxis.setLowerMargin(0.15);//�����������ͼƬ�׶˵ľ���
			plot.setRangeAxis(rangAxis);
			
			BarRenderer render = null;
			if(is3D){
				render = (BarRenderer3D)plot.getRenderer();
			}else{		
				render = (BarRenderer)plot.getRenderer();	
			}
			render.setMinimumBarLength(0.02);//����bar����С��ȣ��Ա�֤����ʾ��ֵ	
			render.setMaximumBarWidth(0.07); //�����
			
			if("2".equals(chart_data)||"3".equals(chart_data)){//��2:�ؼ�����ȱ���ʻ���,3:Reopenȱ���ʻ��ȡ� �԰ٷֱ���ʽչ��
				NumberFormat nf = NumberFormat.getPercentInstance();   
				nf.setMinimumFractionDigits(2);// С���������λ   
				render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator("{2}",nf,nf));//�������������԰ٷֱȵ���ʽ��ʾ����
			}else{	
				render.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//��������������ʾ����
			}
			render.setBaseItemLabelFont(new Font("������",Font.PLAIN,13));//���������ϵ����ݵ�����
			render.setBaseItemLabelsVisible(true);//����bar�������ֵ�ɼ���
			render.setItemMargin(0.1);//ÿ�·ݰ����������ʱ����������֮��ļ��
			
			//�������̫��ʱ�����ݲ�����ʾ������  
			ItemLabelPosition itemLabelPositionFallback=new ItemLabelPosition(ItemLabelAnchor.CENTER,TextAnchor.BASELINE_LEFT,TextAnchor.TOP_CENTER,0D);
			render.setPositiveItemLabelPositionFallback(itemLabelPositionFallback);
			render.setNegativeItemLabelPositionFallback(itemLabelPositionFallback);
	 } 
	//VALUE_TEXT_ANTIALIAS_OFF��ʾ�����ֵĿ���ݹر�,ʹ�õĹرտ���ݺ����御��ѡ��12��15�ŵ��������֡�
	 chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

		//��������ͼ�ڵ㡢ֱ��ͼ�������Ϻ����ʾ��Ϣ��
		StandardEntityCollection sec = new StandardEntityCollection();
		ChartRenderingInfo info = new ChartRenderingInfo(sec);
	     
		
		//д��ͼƬ�ļ�
		//String filename = ServletUtilities.saveChartAsJPEG(chart, 800, 400,info, session);
		String[] widthHeight = picSize.split("\\*");//split("*")�ᱨ������"\\"����ת��
		String filename = ServletUtilities.saveChartAsPNG(chart, Integer.parseInt(widthHeight[0]), Integer.parseInt(widthHeight[1]),info, session);//PNG��ʽ��ͼƬ��ɫ��JPEG����������ռ�ÿռ�С��png:8k,jpeg:60k��
		PrintWriter w = new PrintWriter(out);//���MAP��Ϣ 
		
	     //��ͼƬ�ȵ�������Ϣд��ͼƬmap
		ChartUtilities.writeImageMap(w, "map0", info, false);
		 //����ͼƬ��ַ
	String graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
	%>
	<P ALIGN="CENTER"><img src="<%=graphURL%>"  border="0" usemap="#map0"></P>
	<fieldset>
	<table cellpadding="1" cellspacing="0" border="1" align="center" width="100%" >
	<tr><th>ͳ������ / �·�</th>
	<%	for(int i=0;i<yearmonth.length;i++){
			out.println("<th>"+yearmonth[i]+"</th>");
	}%>	</tr>
	<%
	if("O".equals(chart_data)){//��Ŀ���������������������۱�׼
		out.println("<tr><td align=\"center\">�ؼ�����ȱ����</td>");
		double [] t_serious = returnMap.get("seriousDefectNumber");
		double [] t_total = returnMap.get("defectNumber");
		double [] t_weight = returnMap.get("defectWeightedAverage");
		for(int i=0;i<t_serious.length;i++){		
			out.print("<td>");
			out.print((int)t_serious[i]);
			out.print("</td>");
		}
		out.println("</tr>");
		out.println("<tr><td align=\"center\">��ȱ����</td>");
		for(int i=0;i<t_total.length;i++){		
			out.print("<td>");
			out.print((int)t_total[i]);
			out.print("</td>");
		}
		out.println("</tr>");
		out.println("<tr><td align=\"center\">ȱ��ƽ�����س̶�</td>");
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
		boolean showPercent = "2".equals(chart_data)||"3".equals(chart_data);//�ٷֱ���ʽչ��
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
 		out.println("document.getElementById('tips').innerHTML=\"<font color='red'>Sorry���޷��������ļ�¼��</font>\";");
 		out.print("</script>");
	}
}
	%>
	</td>
	</tr>
</table>
</BODY>
</HTML>
