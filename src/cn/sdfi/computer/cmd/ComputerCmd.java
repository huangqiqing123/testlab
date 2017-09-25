package cn.sdfi.computer.cmd;

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

import cn.sdfi.computer.bean.Computer;
import cn.sdfi.computer.dao.ComputerDao;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;

public class ComputerCmd{

	private ComputerDao dao = (ComputerDao)ObjectFactory.getObject(ComputerDao.class.getName());
	private Logger log = Logger.getLogger(this.getClass());

	/*
	 * 接收Ajax请求，检验设备编号是否已存在。
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
			log.error("出错了！", e);
			throw new RuntimeException("出错了！", e);
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
		dao.batchDeleteByPk(pks);
		
		url="computerdo.do?method=query&path=after_delete";
		request.setAttribute("msg", "删除 " + pks.length + " 条记录成功！");
		
		return url;
	}

	/*
	 * 更新
	 */
	private String update() {
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		String url = null;
		Computer computer = new Computer();
		computer.setPk(request.getParameter("pk"));
		computer.setComputer_type(request.getParameter("computer_type"));
		computer.setCode(request.getParameter("code").trim());
		computer.setName(request.getParameter("name").trim());
		
		String begin_use_time = request.getParameter("begin_use_time");
		computer.setBegin_use_time(begin_use_time==null?"":begin_use_time.trim());
		
		String configuration = request.getParameter("configuration");
		computer.setConfiguration(configuration==null?"":configuration.trim());
		
		String ip = request.getParameter("ip");
		computer.setIp(ip==null?"":ip.trim());
		
		String manufactory = request.getParameter("manufactory");
		computer.setManufactory(manufactory==null?"":manufactory);
		
		String owner = request.getParameter("owner");
		computer.setOwner(owner==null?"":owner);
		
		String serial_number = request.getParameter("serial_number");
		computer.setSerial_number(serial_number);
		
		String status = request.getParameter("status");
		computer.setStatus(status==null?"":status);
		
		String type = request.getParameter("type");
		computer.setType(type==null?"":type);
		
		String use_site = request.getParameter("use_site");
		computer.setUse_site(use_site==null?"":use_site);
		
		String memo = request.getParameter("memo");
		computer.setMemo(memo==null?"":memo);

		dao.update(computer);
		
		request.setAttribute("msg","更新成功！");
		request.setAttribute("computer.view", computer);
		url="computer_detail.jsp";
		
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
		HttpServletRequest request = CommandContext.getRequest();
	
		String pk = request.getParameter("pk");
		Computer computer = dao.queryByPK(pk);
		request.setAttribute("computer.view", computer);
		return "computer_detail.jsp";
	}

	/*
	 * 查询
	 */
	public String query() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		//查询条件：设备编号、领用人、ip、状态(有效、已报废)、设备类型（实验室设备、外借设备）
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则默认按照设备编码（code）排序。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String code=request.getParameter("code");
		String owner=request.getParameter("owner");
		String status=request.getParameter("status");
		String computer_type=request.getParameter("computer_type");
		String ip = request.getParameter("ip");//查询条件IP
		
		//空值处理
		if(sort==null)sort="code";	
		if(sortType==null)sortType="ASC";
		if(code==null)code="";
		if(owner==null)owner="";
		if(ip==null)ip="";
		if(status==null)status="";
		if(computer_type==null)computer_type="";
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
		//将查询条件组合成对象
		Computer query_condition = new Computer();
		query_condition.setSort(sort.trim());
		query_condition.setSortType(sortType.trim());
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setCode(code.trim());
		query_condition.setOwner(owner.trim());
		query_condition.setStatus(status.trim());
		query_condition.setComputer_type(computer_type.trim());
		query_condition.setIp(ip.trim());
		
		//===============导出Excel================
		if("exportExcel".equals(request.getParameter("action"))){	
			
			Map<String, String> computer_status = Const.getEnumMap().get("computer_status");
			Map<String, String> computer_types = Const.getEnumMap().get("computer_type");
			try {
				//response.reset();
				response.setContentType("application/octet-stream;charset=UTF-8");
				response.setHeader("Content-Disposition","attachment;filename="+Tool.toUtf8String("实验室设备信息台帐")+".xls");
				HSSFWorkbook wb = new HSSFWorkbook();
				
				//第一个标签显示档案袋信息
				HSSFSheet sheet1 = wb.createSheet("实验室设备台帐");
				HSSFRow row=null;
				Computer temp=null;
				row=sheet1.createRow(0);
				row.createCell(0).setCellValue("设备类型");
				row.createCell(1).setCellValue("设备编号");
				row.createCell(2).setCellValue("设备名称");
				row.createCell(3).setCellValue("序列号");
				row.createCell(4).setCellValue("型号");
				row.createCell(5).setCellValue("生产厂商");
				row.createCell(6).setCellValue("领用日期");
				row.createCell(7).setCellValue("领用人");
				row.createCell(8).setCellValue("使用地点");
				row.createCell(9).setCellValue("状态");
				row.createCell(10).setCellValue("配置");
				row.createCell(11).setCellValue("备注");
				
				List<Computer> list = dao.export(query_condition);
				for (int i = 0; i < list.size(); i++) {
					row=sheet1.createRow(i+1);
					temp=list.get(i);
					row.createCell(0).setCellValue(computer_types.get(temp.getComputer_type()).toString());
					row.createCell(1).setCellValue(temp.getCode());
					row.createCell(2).setCellValue(temp.getName());
					row.createCell(3).setCellValue(temp.getSerial_number());
					row.createCell(4).setCellValue(temp.getType());
					row.createCell(5).setCellValue(temp.getManufactory());
					row.createCell(6).setCellValue(temp.getBegin_use_time());
					row.createCell(7).setCellValue(temp.getOwner());
					row.createCell(8).setCellValue(temp.getUse_site());
					row.createCell(9).setCellValue(computer_status.get(temp.getStatus()).toString());
					row.createCell(10).setCellValue(temp.getConfiguration());
					row.createCell(11).setCellValue(temp.getMemo());			
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
		Map<String,Object> map = dao.queryByComputer(query_condition);
		List<Computer> list = (List<Computer>)map.get("list");
		
		//将查询结果放入request
		request.setAttribute("computer_query_result", list);
		
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
		return "computer_query.jsp";
	}

	/*
	 * 新增
	 */
	private String add() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		String url = null;
		Computer computer = new Computer();
		computer.setPk(UUIDGenerator.getRandomUUID());
		computer.setCode(request.getParameter("code"));
		computer.setComputer_type(request.getParameter("computer_type"));
		computer.setName(request.getParameter("name"));
		computer.setOwner(request.getParameter("owner"));
		computer.setSerial_number(request.getParameter("serial_number"));
		computer.setType(request.getParameter("type"));
		computer.setManufactory(request.getParameter("manufactory"));
		computer.setBegin_use_time(request.getParameter("begin_use_time"));
		computer.setUse_site(request.getParameter("use_site"));
		computer.setStatus(request.getParameter("status"));
		computer.setConfiguration(request.getParameter("configuration"));
		computer.setIp(request.getParameter("ip"));
		computer.setMemo(request.getParameter("memo"));

		dao.save(computer);

		request.setAttribute("msg","增加记录["+computer.getCode()+","+computer.getName()+","+computer.getOwner()+"]成功！");
		String forward=request.getParameter("action");
		
		if("continue".equals(forward)){
			url = "computer_add.jsp";
		}else{
			request.setAttribute("computer.view", computer);
			url="computer_detail.jsp";
		}
		return url;
	}
}
