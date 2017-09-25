package cn.sdfi.systemfile.cmd;

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
import cn.sdfi.systemfile.bean.SystemFile;
import cn.sdfi.systemfile.dao.SystemFileDao;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;

public class SystemFileCmd{

	private SystemFileDao dao = (SystemFileDao)ObjectFactory.getObject(SystemFileDao.class.getName());
	private UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());
	private Logger log = Logger.getLogger(this.getClass());

	/*
	 * 接收Ajax请求，检验体系文件编号是否已存在。
	 */
	public String isExist() {
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		String value = request.getParameter("value");	
		try {
			PrintWriter out = response.getWriter();	
			if(dao.isExist(value)){	
				out.print("1");
			}else{
				out.print("0");
			}
		} catch (IOException e) {
			log.error("出错了!",e);
			throw new RuntimeException("出错了!",e);
		}
		return null;
	}
	/*
	 * 删除操作
	 */
	public String delete() {
		HttpServletRequest request = CommandContext.getRequest();
		String[] pks = request.getParameterValues("pk");
		String url=null;	
		dao.batchDeleteByPK(pks);
		request.setAttribute("msg", "删除 " + pks.length + " 条记录成功！");
		url = "systemfiledo.do?method=query&path=after_delete";
	
		return url;
	}

	/*
	 * 更新
	 */
	public String update() {
		
		String url = null;
		HttpServletRequest request = CommandContext.getRequest();
		SystemFile systemfile = new SystemFile();
		systemfile.setPk(request.getParameter("pk"));
		systemfile.setCode(request.getParameter("code").trim());
		systemfile.setName(request.getParameter("name").trim());
		systemfile.setMemo(request.getParameter("memo").trim());
		systemfile.setControlledNumber(request.getParameter("controlled_number").trim());
		systemfile.setPages(request.getParameter("pages").trim());
		systemfile.setState(request.getParameter("state").trim());
		systemfile.setVersion(request.getParameter("version").trim());
		dao.update(systemfile);	
		request.setAttribute("msg","档案袋信息更新成功！");
		request.setAttribute("systemfile_view", systemfile);
		url="systemfile_detail.jsp";
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
	
		HttpServletRequest request = CommandContext.getRequest();
		String pk = request.getParameter("pk");
		SystemFile systemfile = dao.queryByPK(pk);
		request.setAttribute("systemfile_view", systemfile);
		return "systemfile_detail.jsp";
	}

	/*
	 * 查询
	 */
	public String query() {
			
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则默认按照文件编码（code）排序。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String controlledNumber=request.getParameter("controlled_number");
		String state=request.getParameter("state");

		//空值处理
		if(sort==null)sort="code";	
		if(sortType==null)sortType="DESC";
		if(code==null)code="";
		if(name==null)name="";
		if(controlledNumber==null)controlledNumber="";
		if(state==null)state="";
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
		SystemFile query_condition = new SystemFile();
		query_condition.setCode(code.trim());
		query_condition.setName(name.trim());
		query_condition.setState(state.trim());
		query_condition.setControlledNumber(controlledNumber.trim());
		query_condition.setSort(sort);
		query_condition.setSortType(sortType);
		query_condition.setPageSize(Integer.parseInt(pageSize));
		
		//===============导出Excel================
		if("exportExcel".equals(request.getParameter("action"))){		
			try {
				//response.reset();
				response.setContentType("application/octet-stream;charset=UTF-8");
				response.setHeader("Content-Disposition","attachment;filename="+Tool.toUtf8String("体系文件台帐")+".xls");
				HSSFWorkbook wb = new HSSFWorkbook();
				
				//第一个标签显示档案袋信息
				HSSFSheet sheet1 = wb.createSheet("实验室项目信息");
				HSSFRow row=null;
				SystemFile temp=null;
				row=sheet1.createRow(0);
				row.createCell(0).setCellValue("文件编号");
				row.createCell(1).setCellValue("文件名称");
				row.createCell(2).setCellValue("页数");
				row.createCell(3).setCellValue("受控号");
				row.createCell(4).setCellValue("版本");
				row.createCell(5).setCellValue("状态");
				row.createCell(6).setCellValue("备注");
				
				List<SystemFile> list = dao.export(query_condition);
				for (int i = 0; i < list.size(); i++) {
					row=sheet1.createRow(i+1);
					temp=list.get(i);
					row.createCell(0).setCellValue(temp.getCode());
					row.createCell(1).setCellValue(temp.getName());
					row.createCell(2).setCellValue(temp.getPages());
					row.createCell(3).setCellValue(temp.getControlledNumber());
					row.createCell(4).setCellValue(temp.getVersion());
					row.createCell(5).setCellValue(temp.getState());
					row.createCell(6).setCellValue(temp.getMemo());		
				}	
								
				//向客户端写数据
				wb.write(response.getOutputStream());
				response.getOutputStream().flush();
				//response.getOutputStream().close();
				
				
			}catch (IOException e) {
				log.error("出错了!",e);
				throw new RuntimeException("出错了!",e);
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
		Map<String,Object> map = dao.querySystemFile(query_condition);
		List<SystemFile> list = (List<SystemFile>)map.get("list");
		
		//将查询结果放入request
		request.setAttribute("systemfile_query_result", list);
		
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
		return "systemfile_query.jsp";
	}


	/*
	 * 新增
	 */
	public String add() {
		
		HttpServletRequest request = CommandContext.getRequest();
		String url = null;
		String pk=UUIDGenerator.getRandomUUID();
		SystemFile systemfile = new SystemFile();
		systemfile.setPk(pk);
		systemfile.setCode(request.getParameter("code").trim());
		systemfile.setName(request.getParameter("name").trim());
		systemfile.setMemo(request.getParameter("memo").trim());
		systemfile.setControlledNumber(request.getParameter("controlled_number").trim());
		systemfile.setPages(request.getParameter("pages").trim());
		systemfile.setState(request.getParameter("state").trim());
		systemfile.setVersion(request.getParameter("version").trim());

		dao.save(systemfile);
		request.setAttribute("msg","增加记录["+systemfile.getCode()+","+systemfile.getName()+"]成功！");
		String forward=request.getParameter("action");
		if("continue".equals(forward)){
			url = "systemfile_add.jsp";
		}else{
			request.setAttribute("systemfile_view", systemfile);
			url="systemfile_detail.jsp";
		}
		return url;
	}
}
