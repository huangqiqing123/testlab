package cn.sdfi.defect.cmd;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;

import cn.sdfi.defect.bean.ChartDefect;
import cn.sdfi.defect.dao.ChartDefectDao;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.product.dao.ProductDao;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;

public class DefectCmd{

	private Logger log = Logger.getLogger(this.getClass());
	private ChartDefectDao defectDao = (ChartDefectDao)ObjectFactory.getObject(ChartDefectDao.class.getName());
	private ProductDao productDao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());

	/*
	 * 接收Ajax请求，检验指定月份、指定项目的记录是否已经存在。
	 */
	public String isExist(HttpServletRequest request,HttpServletResponse response) {
		
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		String chart_project = request.getParameter("chart_project");	
		String yearMonth = request.getParameter("yearMonth");
		try {
			PrintWriter out = response.getWriter();	
			if(defectDao.isExist(yearMonth,chart_project)){	
				out.print("1");
			}else{
				out.print("0");
			}
		} catch (IOException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return null;
	}
	
	/*
	 * 删除操作
	 */
	public String delete() {
		HttpServletRequest request = CommandContext.getRequest();
		String[] pk = request.getParameterValues("pk");
		defectDao.batchDeleteByPK(pk);
		request.setAttribute("msg", "删除 " + pk.length + " 条记录成功！");			
		return "defectdo.do?method=query";
	}
	/*
	 * 更新
	 */
	public String update() {
		HttpServletRequest request = CommandContext.getRequest();
		String url = null;
		ChartDefect defect = new ChartDefect();
		defect.setPk(request.getParameter("pk"));
		defect.setYearMonth(Integer.parseInt(request.getParameter("yearMonth")));
		defect.setChart_project(request.getParameter("chart_project"));
		defect.setDefectNumber(Integer.parseInt(request.getParameter("defectNumber")));
		defect.setPackageNumber(Integer.parseInt(request.getParameter("packageNumber")));
		defect.setReopenNumber(Integer.parseInt(request.getParameter("reopenNumber")));
		defect.setSeriousDefectNumber(Integer.parseInt(request.getParameter("seriousDefectNumber")));
		defect.setTotalProcessTime(Float.parseFloat(request.getParameter("totalProcessTime")));
		defect.setTotalDefectWeight(Float.parseFloat(request.getParameter("totalDefectWeight")));
		defect.setTotalSeriousDefectWeight(Float.parseFloat(request.getParameter("totalSeriousDefectWeight")));//关键严重缺陷加权值

		defectDao.update(defect);
		request.setAttribute("defect.view", defectDao.queryByPK(defect.getPk()));//将更新后的记录放入request
		request.setAttribute("msg","更新成功！");
		url="defect_detail.jsp";
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
		HttpServletRequest request = CommandContext.getRequest();
		String pk =request.getParameter("pk");
		ChartDefect view = defectDao.queryByPK(pk);
		request.setAttribute("defect.view", view);
		return "defect_detail.jsp";
	}
	/*
	 * 执行更新前的查询
	 */
	public String forupdate() {
		HttpServletRequest request = CommandContext.getRequest();
		String pk =request.getParameter("pk");
		ChartDefect view = defectDao.queryByPK(pk);
		request.setAttribute("defect.view", view);
		return "defect_update.jsp";
	}

	/*
	 * 查询
	 */
	public String query() {
		HttpServletRequest request = CommandContext.getRequest();

		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则按照年月份降序。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
				
		//空值处理
		if(sort==null)sort="yearMonth";	
		if(sortType==null)sortType="DESC";
		if(pageSize==null||"".equals(pageSize)){
			pageSize=request.getSession().getAttribute("pageSize").toString();
		}else{
			//如果用户的pageSize发生改变，则同步更新session中的pageSize和数据库中的pageSize
			if(!pageSize.equals(request.getSession().getAttribute("pageSize").toString())){
				request.getSession().setAttribute("pageSize", pageSize);
				UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());
				userDao.changePageSize(CommandContext.getSession().getAttribute("username")+"", pageSize);
			}
		}
		//起始年月、项目
		String yearMonth_begin = null;
		String yearMonth_end = null;
		String chart_project = request.getParameter("chart_project");//l3/D3...
		String project_customer = request.getParameter("project_customer");//技术中心、烟草...
	
		//如果是从菜单栏进入，则默认显示当前财年4月份至当前月份的所有记录。
		//每财年的第一个月份是4月
		String path = request.getParameter("path");
		if("menu.jsp".equals(path)){
			String currentYear = Tool.getCurrentYear();
			String currentMonth = Tool.getCurrentMonth();
			if(currentMonth.length()==1){
				currentMonth="0"+currentMonth;
			}
			if(Integer.parseInt(currentMonth)<4){
				yearMonth_begin = (Integer.parseInt(currentYear)-1)+"04";
			}else{
				yearMonth_begin = currentYear+"04";
			}
			yearMonth_end = currentYear+currentMonth;
		}else{		
			yearMonth_begin = request.getParameter("yearMonth_begin");
			yearMonth_end = request.getParameter("yearMonth_end");
			
			if(yearMonth_begin==null||"".equals(yearMonth_begin))
				yearMonth_begin="0";	
			if(yearMonth_end==null||"".equals(yearMonth_end))
				yearMonth_end="0";	
		}
		if(chart_project==null)chart_project="";
		if(project_customer==null)project_customer="";
		
		// 将查询条件组合成对象
		ChartDefect query_condition = new ChartDefect();
		query_condition.setSort(sort);
		query_condition.setSortType(sortType);
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setChart_project(chart_project);
		query_condition.setProject_customer(project_customer);
		query_condition.setYearMonth_begin(Integer.parseInt(yearMonth_begin));
		query_condition.setYearMonth_end(Integer.parseInt(yearMonth_end));
		
		//分页
		int showPage =1;//showpage默认显示第1页
		
		//如果是手工输入显示第几页
		if (request.getParameter("showPage") != null&&!request.getParameter("showPage").equals("")){
			request.setAttribute("showPage",request.getParameter("showPage"));
			showPage=Integer.parseInt(request.getParameter("showPage").trim());
		
		//如果是点击翻页按钮
		}else if (request.getParameter("view")!=null&&(!(request.getParameter("view").equals("")))){

			int select=1;//1代表第一页、2代表上一页、3代表下一页、4代表最后一页，默认显示第一页
			int oldPageCount = Integer.parseInt(request.getParameter("pageCount"));
			select = Integer.parseInt(request.getParameter("view"));
			showPage = Integer.parseInt(request.getParameter("currentPage"));

			if(select==1){
				showPage = 1;
			}else if(select==2){
				if (showPage == 1) {
					showPage = 1;
				} else {
					showPage--;
				}
			}else if(select==3){
				if (showPage == oldPageCount) {
					showPage = oldPageCount;
				} else {
					showPage++;
				}
			}else if(select==4){
				showPage = oldPageCount;
			}else{
				showPage = 1;
			}
		}
		//执行查询，并将查询结果放入request中
		query_condition.setShowPage(showPage);
		Map<String,Object> map = defectDao.query(query_condition);
		List<ChartDefect> list = (List<ChartDefect>)map.get("list");
		request.setAttribute("defect_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString()); //获取查询出的总记录数
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);//总页数
		query_condition.setRecordCount(newRecordCount);
		query_condition.setPageCount(newPageCount);
		request.setAttribute("query_condition", query_condition);
	
		//如果查询结果为空
		if(newRecordCount<1){				
			request.setAttribute("msg", "Sorry，无符合条件的记录！");
		}
		return "defect_query.jsp";
	}

	/*
	 * 新增
	 */
	@Trans
	public String add() {
		String url = null;
		HttpServletRequest request = CommandContext.getRequest();
		ChartDefect defect = new ChartDefect();
		defect.setPk(UUIDGenerator.getRandomUUID());
		defect.setYearMonth(Integer.parseInt(request.getParameter("yearMonth")));
		defect.setChart_project(request.getParameter("chart_project"));
		defect.setDefectNumber(Integer.parseInt(request.getParameter("defectNumber")));
		defect.setPackageNumber(Integer.parseInt(request.getParameter("packageNumber")));
		defect.setReopenNumber(Integer.parseInt(request.getParameter("reopenNumber")));
		defect.setSeriousDefectNumber(Integer.parseInt(request.getParameter("seriousDefectNumber")));
		defect.setProject_customer(productDao.getDeptId(defect.getChart_project()));
		defect.setTotalProcessTime(Float.parseFloat(request.getParameter("totalProcessTime")));
		defect.setTotalDefectWeight(Float.parseFloat(request.getParameter("totalDefectWeight")));
		defect.setTotalSeriousDefectWeight(Float.parseFloat(request.getParameter("totalSeriousDefectWeight")));//关键严重缺陷加权值
		
		//调用dao层，执行保存。
		defectDao.save(defect);

		Map<String, String> chart_projects = productDao.queryAll();
		request.setAttribute("msg","增加记录["+defect.getYearMonth()+","+chart_projects.get(defect.getChart_project())+"]成功！");
		String forward=request.getParameter("action");
		
		if("continue".equals(forward)){
			url = "defect_add.jsp";
		}else{
			request.setAttribute("defect.view", defectDao.queryByPK(defect.getPk()));
			url="defect_detail.jsp";
		}
		return url;
	}
}
