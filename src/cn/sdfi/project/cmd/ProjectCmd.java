package cn.sdfi.project.cmd;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.project.bean.Project;
import cn.sdfi.project.dao.ProjectDao;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;

public class ProjectCmd{

	public ProjectDao projectDao = (ProjectDao)ObjectFactory.getObject(ProjectDao.class.getName());
	public UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());
	public Logger log = Logger.getLogger(ProjectCmd.class);

	/*
	 * 接收Ajax请求，检验项目编号是否已存在。
	 */
	public String isExist() throws IOException {
		HttpServletResponse response = CommandContext.getResponse();
		HttpServletRequest request = CommandContext.getRequest();
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		String value = request.getParameter("value");	

		PrintWriter out = response.getWriter();	
		if(projectDao.isExist(value)){	
			out.print("1");
		}else{
			out.print("0");
		}
	
		return null;
	}
	/*
	 * 删除操作
	 */
	public String delete() {
		HttpServletResponse response = CommandContext.getResponse();
		HttpServletRequest request = CommandContext.getRequest();
		String path = null;
		String url=null;
		String isLabProject = request.getParameter("isLabProject");
		
		if("1".equals(isLabProject)){
			path = "project_lab_query.jsp";
		}
		else if("0".equals(isLabProject)){
			path = "project_query.jsp";
		}else{
			throw new RuntimeException("出错了！无效的入参！");
		}
		
		String[] pks = request.getParameterValues("pk");
		projectDao.batchDeleteByPK(pks);
		
		request.setAttribute("msg", "删除 " + pks.length + " 条记录成功！");
		url="projectdo.do?method=query&isLabProject="+isLabProject+"&path="+path;
		return url;
	}

	/*
	 * 更新
	 */
	public String update() {
		HttpServletRequest request = CommandContext.getRequest();
		String url = null;
		String isLabProject = request.getParameter("isLabProject");
		
		Project project = new Project();
		project.setPk(request.getParameter("pk"));
		
		if("1".equals(isLabProject)){//非实验室项目没有项目编号		
			project.setCode(request.getParameter("code").trim());
		}
		project.setName(request.getParameter("name").trim());
		project.setDevmanager(request.getParameter("devmanager").trim());
		project.setTestmanager(request.getParameter("testmanager").trim());
		project.setBegintime(request.getParameter("begintime").trim());
		project.setEndtime(request.getParameter("endtime").trim());
		project.setMemo(request.getParameter("memo").trim());
		project.setYear(request.getParameter("year").trim());
		project.setState(request.getParameter("state"));
		project.setProject_type(request.getParameter("project_type"));
		project.setTester(request.getParameter("tester"));
		project.setIsLabProject(isLabProject);
		project.setProject_customer(request.getParameter("project_customer"));

		projectDao.update(project);

		request.setAttribute("msg","项目信息更新成功！");
		request.setAttribute("project_view", project);
		url="project_detail.jsp";
	
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
	
		HttpServletRequest request = CommandContext.getRequest();
		String pk = request.getParameter("pk");
		Project project = projectDao.queryByPK(pk);
		request.setAttribute("project_view", project);
		return "project_detail.jsp";
	}

	/*
	 * 查询
	 */
	public String query() {
		
		HttpServletResponse response = CommandContext.getResponse();
		HttpServletRequest request = CommandContext.getRequest();
		
		//如果指定了排序字段，则按照指定的字段进行排序，
		//如果未指定，则默认按照项目开始时间降序排列。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String state=request.getParameter("state");
		String project_type=request.getParameter("project_type");
		String year=request.getParameter("year");
		String isLabProject = request.getParameter("isLabProject");
		String project_customer = request.getParameter("project_customer");
		String testmanager = request.getParameter("testmanager");
		
		//从哪个页面过来的请求（project_query.jsp/project_lab_query.jsp）
		String path = request.getParameter("path");
		
		//空值处理
		if(sort==null)sort="begintime";	
		if(sortType==null)sortType="DESC";
		if(code==null)code="";
		if(name==null)name="";
		if(state==null)state="";
		if(project_type==null)project_type="";
		if(project_customer==null)project_customer="";
		if(year==null)year="";
		if(isLabProject==null)isLabProject="";
		if(testmanager==null)testmanager="";
		if(pageSize==null||"".equals(pageSize)){
			pageSize=request.getSession().getAttribute("pageSize").toString();
		}else{
			//如果用户的pageSize发生改变，则同步更新session中的pageSize和数据库中的pageSize
			if(!pageSize.equals(request.getSession().getAttribute("pageSize").toString())){
				request.getSession().setAttribute("pageSize", pageSize);
				userDao.changePageSize(CommandContext.getSession().getAttribute("username")+"", pageSize);
			}
		}	
		
		//将查询条件组合成对象
		Project query_condition=new Project();
		query_condition.setSort(sort.trim());
		query_condition.setSortType(sortType.trim());
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setCode(code.trim());
		query_condition.setName(name.trim());
		query_condition.setState(state.trim());
		query_condition.setProject_type(project_type.trim());
		query_condition.setProject_customer(project_customer.trim());
		query_condition.setYear(year.trim());
		query_condition.setIsLabProject(isLabProject.trim());
		query_condition.setTestmanager(testmanager.trim());
		
		//===============导出Excel================
		if("exportExcel".equals(request.getParameter("action"))){	

			Map<String, String> project_state = Const.getEnumMap().get("project_state");
			Map<String,String> project_types = Const.getEnumMap().get("project_type");
			Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
			try {
				response.reset();
				response.setContentType("application/octet-stream;charset=UTF-8");
				response.setHeader("Content-Disposition","attachment;filename="+Tool.toUtf8String("项目信息台帐")+".xls");
				HSSFWorkbook wb = new HSSFWorkbook();
				
				HSSFSheet sheet1 = wb.createSheet("项目信息");
				HSSFRow row=null;
				Project temp=null;
				row=sheet1.createRow(0);
				int num = 0;
				if("1".equals(isLabProject)){//非实验室项目没有项目编号			
					row.createCell(num++).setCellValue("项目编号");
				}
				row.createCell(num++).setCellValue("项目名称");
				row.createCell(num++).setCellValue("开始时间");
				row.createCell(num++).setCellValue("结束时间");
				row.createCell(num++).setCellValue("测试经理");
				row.createCell(num++).setCellValue("项目经理");
				row.createCell(num++).setCellValue("年度");
				row.createCell(num++).setCellValue("项目状态");
				row.createCell(num++).setCellValue("测试人员");
				row.createCell(num++).setCellValue("项目类别");
				row.createCell(num++).setCellValue("客户名称");
				row.createCell(num++).setCellValue("备注");
				
				List<Project> list = projectDao.export(query_condition);
				
				for (int i = 0; i < list.size(); i++) {
					row=sheet1.createRow(i+1);
					temp=list.get(i);
					num = 0;
					if("1".equals(isLabProject)){//非实验室项目没有项目编号	
						row.createCell(num++).setCellValue(temp.getCode());
					}
					row.createCell(num++).setCellValue(temp.getName());
					row.createCell(num++).setCellValue(temp.getBegintime());
					row.createCell(num++).setCellValue(temp.getEndtime());
					row.createCell(num++).setCellValue(temp.getTestmanager());
					row.createCell(num++).setCellValue(temp.getDevmanager());
					row.createCell(num++).setCellValue(temp.getYear());
					row.createCell(num++).setCellValue(project_state.get(temp.getState()).toString());
					row.createCell(num++).setCellValue(temp.getTester());
					row.createCell(num++).setCellValue(project_types.get(temp.getProject_type()).toString());
					row.createCell(num++).setCellValue(project_customers.get(temp.getProject_customer()).toString());
					row.createCell(num++).setCellValue(temp.getMemo());
				}							
				//向客户端写数据
				wb.write(response.getOutputStream());
				response.getOutputStream().flush();
				response.getOutputStream().close();			
			}catch (IOException e) {				
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}
			return null;		
		}
		//----------------导出excel操作到此结束---------------------

		//----------------如果是执行查询操作---------------------

		
		//分页
		int showPage =1;//showpage默认显示第1页
		
		//如果是手工输入显示第几页
		if (request.getParameter("showPage") != null&&!"".equals(request.getParameter("showPage"))){		
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
		//执行查询，返回Map
		query_condition.setShowPage(showPage);
		Map<String,Object> map = projectDao.queryByProject(query_condition);
		List<Project> list = (List<Project>)map.get("list");
		
		//将查询结果放入request
		request.setAttribute("project_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString());
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);
		query_condition.setRecordCount(newRecordCount); //总记录数
		query_condition.setPageCount(newPageCount);//总页数
		request.setAttribute("query_condition",query_condition);

		//如果查询结果为空
		if(newRecordCount<1){				
			request.setAttribute("msg", "Sorry，无符合条件的记录！");
		}
		return path;
	}

	/*
	 * 新增
	 */
	public String add() {
		
		HttpServletResponse response = CommandContext.getResponse();
		HttpServletRequest request = CommandContext.getRequest();
		String url = null;
		String isLabProject = request.getParameter("isLabProject");
		Project project = new Project();
		if("1".equals(isLabProject)){//非实验室项目没有项目编号		
			project.setCode(request.getParameter("code").trim());
		}
		String pk=UUIDGenerator.getRandomUUID();
		project.setPk(pk);
		project.setName(request.getParameter("name").trim());
		project.setDevmanager(request.getParameter("devmanager").trim());
		project.setTestmanager(request.getParameter("testmanager").trim());
		project.setBegintime(request.getParameter("begintime"));
		project.setEndtime(request.getParameter("endtime"));
		project.setMemo(request.getParameter("memo").trim());
		project.setYear(request.getParameter("year").trim());
		project.setState(request.getParameter("state"));
		project.setProject_type(request.getParameter("project_type"));
		project.setTester(request.getParameter("tester"));
		project.setIsLabProject(request.getParameter("isLabProject"));
		project.setProject_customer(request.getParameter("project_customer"));

		//实验室项目与非实验室项目共用同一个增加、修改、明细页面，页面显示效果根据参数 path 的值进行区分。
		String path="";
		if("1".equals(project.getIsLabProject())){
			path="project_lab_query.jsp";
		}else if("0".equals(project.getIsLabProject())){
			path="project_query.jsp";
		}else{
			log.error("出错了。。。。");
		}
		projectDao.save(project);

		request.setAttribute("msg","增加记录[项目名称："+project.getName()+"]成功！");
		String forward=request.getParameter("action");
		
		if("continue".equals(forward)){
			url = "project_add.jsp?path="+path;
		}else{
			request.setAttribute("project_view", project);
			url="project_detail.jsp";
		}
		return url;
	}
}
