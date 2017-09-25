package cn.sdfi.filecover.cmd;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import cn.sdfi.filecover.bean.FileCover;
import cn.sdfi.filecover.dao.FileCoverDao;
import cn.sdfi.filecovercontent.bean.FileCoverContent;
import cn.sdfi.filecovercontent.dao.FileCoverContentDao;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;

public class FileCoverCmd{

	private Logger log = Logger.getLogger(FileCoverCmd.class);
	FileCoverDao fileCoverDao = (FileCoverDao)ObjectFactory.getObject(FileCoverDao.class.getName());
	FileCoverContentDao contentDao = (FileCoverContentDao)ObjectFactory.getObject(FileCoverContentDao.class.getName());

	/*
	 * 接收Ajax请求，检验该档案袋内是否存在文件。
	 */
	public String hasContent() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		
		String[] pks = request.getParameterValues("pk");//接收档案袋主键	
		List<String> not_empty_codes = new ArrayList<String>();//非空档案袋编号集合
		List<String> contentPKlist = null;
		
		//循环遍历每一个档案袋，检查其内是否存在文件，如果存在文件，则获取该档案袋的编号，并保存到list集合中。
		for (int i = 0; i < pks.length; i++) {
			contentPKlist = contentDao.getPKsByFK(pks[i]);
			if(contentPKlist.size()>0){
				not_empty_codes.add(fileCoverDao.queryByPK(pks[i]).getFile_cover_code());
			}
		}
		//向客户端反馈信息
		try {	
			PrintWriter out = response.getWriter();
			
			//如果选择的档案袋中存在非空档案袋
			if(not_empty_codes.size()>0){
				StringBuffer msg = new StringBuffer();
				msg.append("档案袋{");
				for(int j=0;j<not_empty_codes.size();j++){
					msg.append(not_empty_codes.get(j));
					msg.append(",");
				}
				msg.deleteCharAt(msg.length()-1);
				msg.append("}非空，请先删除档案袋内文件，然后再执行该操作！");
				out.write(msg.toString());
			}else{
				out.write("");
			}
		} catch (IOException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return null;
	}

	/*
	 * 接收Ajax请求，检验该档案袋编号是否已存在
	 */
	public String isExist() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		//检查该档案袋编号是否已存在
		String file_cover_code = request.getParameter("file_cover_code");
		boolean isExist=fileCoverDao.isExist(file_cover_code);
		
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);

		try {		
			PrintWriter out = response.getWriter();
			out.write("<?xml version=\"1.0\" encoding=\"GBK\"?>");
			out.write("<response>");
			if(isExist){		
				out.write("<msg>not_ok</msg>");
			}else{
				out.write("<msg>ok</msg>");
			}
			out.write("</response>");
		} catch (IOException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return null;
	}

	/*
	 * 删除操作
	 */
	@Trans
	public String delete() {
		
		HttpServletRequest request = CommandContext.getRequest();

		String[] pks = request.getParameterValues("pk");		
		fileCoverDao.batchDeleteByPk(pks);	
		
		request.setAttribute("msg", "删除 " + pks.length + " 条记录成功！");
		return "filecoverdo.do?method=query&path=after_delete";
	}

	/*
	 * 更新
	 */
	public String update() {
		
		HttpServletRequest request = CommandContext.getRequest();
	
		String url = null;
		FileCover filecover = new FileCover();
		filecover.setPk(request.getParameter("pk"));
		filecover.setFile_cover_code(request.getParameter("file_cover_code").trim());
		filecover.setFile_cover_name(request.getParameter("file_cover_name").trim());
		filecover.setFile_cover_year(request.getParameter("file_cover_year").trim());
		filecover.setFile_cover_type(request.getParameter("file_cover_type").trim());
		filecover.setMemo(request.getParameter("memo"));

		//如果档案袋编号改变，则同步修改其内的档案袋文件
		String old_file_cover_code=fileCoverDao.queryByPK(filecover.getPk()).getFile_cover_code();
		if(!filecover.getFile_cover_code().equals(old_file_cover_code)){
			log.debug("档案袋编号改变，同步修改其内文件编号！（新编号："+filecover.getFile_cover_code()+", 原来编号："+old_file_cover_code+"）");
			contentDao.batchUpdateFileCoverContentCode(filecover.getPk(),old_file_cover_code,filecover.getFile_cover_code());
		}
		
		fileCoverDao.update(filecover);
		
		request.setAttribute("msg", "档案袋信息更新成功！");
		request.setAttribute("file_cover_view", filecover);
		url = "file_cover_detail.jsp";
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() throws IOException {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		//获取档案袋主键
		String pk = request.getParameter("pk");
		
		//===============在file_cover_detail页面执行Excel导出================
		
		if("exportExcel".equals(request.getParameter("action"))){	

			String file_cover_name=request.getParameter("file_cover_name");
			List<FileCoverContent> list = contentDao.queryByFK(pk);
			response.setContentType("application/octet-stream;charset=UTF-8");
			response.setHeader("Content-Disposition","attachment;filename="+Tool.toUtf8String("档案袋信息明细")+".xls");
			HSSFWorkbook wb = new HSSFWorkbook();
			HSSFSheet sheet1 = wb.createSheet(file_cover_name+"档案袋内文件信息明细");
			HSSFRow row=null;
			FileCoverContent temp=null;
			row=sheet1.createRow(0);
			row.createCell(0).setCellValue("文件编号");
			row.createCell(1).setCellValue("文件名称");
			row.createCell(2).setCellValue("页数");
			row.createCell(3).setCellValue("版本");
			row.createCell(4).setCellValue("备注");
			for (int i = 0; i < list.size(); i++) {
				row=sheet1.createRow(i+1);
				temp=list.get(i);
				row.createCell(0).setCellValue(temp.getFile_cover_content_code());
				row.createCell(1).setCellValue(temp.getFile_cover_content_name());
				row.createCell(2).setCellValue(temp.getPages());
				row.createCell(3).setCellValue(temp.getVersion());
				row.createCell(4).setCellValue(temp.getMemo());
			}	
							
			//向客户端写数据
			wb.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();	
		
			return "file_cover_detail.jsp";			
		}
		//====================================
		
		FileCover filecover=null;
		if("project_detail.jsp".equals(request.getParameter("path"))){
			String file_cover_code = request.getParameter("file_cover_code");
			filecover = fileCoverDao.queryByFileCoverCode(file_cover_code);
			if(filecover.getPk()==null||"".equals(filecover.getPk())){
				request.setAttribute("msg", "该项目尚未归档，找不到相应的档案袋信息！&nbsp;<input type=button class='btbox' value='归档 GO' onclick=window.location.href='file_cover_add.jsp?file_cover_code="+file_cover_code+"'  >");
				return "projectdo.do?method=detail&pk="+request.getParameter("project_pk");
			}
		}else{
			
			 filecover = fileCoverDao.queryByPK(pk);
		}
		request.setAttribute("file_cover_view", filecover);
		return "file_cover_detail.jsp";

	}

	/*
	 * 查询
	 */
	public String query() throws IOException {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则默认按照文件编码（code）排序。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String file_cover_code = request.getParameter("file_cover_code");
		String file_cover_name = request.getParameter("file_cover_name");
		String file_cover_year = request.getParameter("file_cover_year");
		String file_cover_type = request.getParameter("file_cover_type");
		String path = request.getParameter("path");

		//空值处理
		if(sort==null)sort="file_cover_code";	
		if(sortType==null)sortType="ASC";
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
		if (file_cover_code == null)file_cover_code = "";
		if (file_cover_name == null)file_cover_name = "";
		if (file_cover_year == null)file_cover_year = "";
		if (file_cover_type == null)file_cover_type = "";

		// 将查询条件组合成对象
		FileCover query_condition = new FileCover();
		query_condition.setSort(sort);
		query_condition.setSortType(sortType);
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setFile_cover_code(file_cover_code.trim());
		query_condition.setFile_cover_name(file_cover_name.trim());
		query_condition.setFile_cover_year(file_cover_year.trim());
		query_condition.setFile_cover_type(file_cover_type.trim());
		
		//----------------如果是执行导出excel操作---------------------
		if("exportExcel".equals(request.getParameter("action"))){			
			List<FileCover> list = fileCoverDao.export(query_condition);
			Map<String, String> file_cover_types = Const.getEnumMap().get("file_cover_type");

			//response.reset();
			response.setContentType("application/octet-stream;charset=UTF-8");
			response.setHeader("Content-Disposition","attachment;filename="+Tool.toUtf8String("档案袋信息台帐")+".xls");
			HSSFWorkbook wb = new HSSFWorkbook();
			
			//第一个标签显示档案袋信息
			HSSFSheet sheet1 = wb.createSheet("档案袋信息");
			HSSFRow row=null;
			FileCover temp=null;
			row=sheet1.createRow(0);
			row.createCell(0).setCellValue("档案袋编号");
			row.createCell(1).setCellValue("档案袋名称");
			row.createCell(2).setCellValue("类型");
			row.createCell(3).setCellValue("年度");
			row.createCell(4).setCellValue("备注");
			for (int i = 0; i < list.size(); i++) {
				row=sheet1.createRow(i+1);
				temp=list.get(i);
				row.createCell(0).setCellValue(temp.getFile_cover_code());
				row.createCell(1).setCellValue(temp.getFile_cover_name());
				row.createCell(2).setCellValue(file_cover_types.get(temp.getFile_cover_type()));
				row.createCell(3).setCellValue(temp.getFile_cover_year());
				row.createCell(4).setCellValue(temp.getMemo());		
			}				
			//向客户端写数据
			wb.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();		
			return null;			
		}
		//----------------导出excel操作到此结束---------------------

		//----------------如果是执行查询操作---------------------
		
		//分页
		int showPage =1;
		
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
		//执行查询，返回Map
		query_condition.setShowPage(showPage);
		Map<String,Object> map = fileCoverDao.queryByFileCover(query_condition);
		List<FileCover> list = (List<FileCover>)map.get("list");		
		
		//将查询结果放入request
		request.setAttribute("file_cover_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString());
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);
		query_condition.setRecordCount(newRecordCount); //总记录数
		query_condition.setPageCount(newPageCount);//总页数
		request.setAttribute("query_condition",query_condition);
		
		return "help".equals(path)?"file_cover_help.jsp":"file_cover_query.jsp";
	}

	/*
	 * 新增
	 */
	public String add() {
		
		HttpServletRequest request = CommandContext.getRequest();
	
		String url = null;
		FileCover filecover = new FileCover();
		String pk=UUIDGenerator.getRandomUUID();
		String code = request.getParameter("file_cover_code").trim();
		String name = request.getParameter("file_cover_name").trim();
		String type = request.getParameter("file_cover_type");
		String year = request.getParameter("file_cover_year");
		if (year == null) {
			year = "";
		}
		String memo = request.getParameter("memo");
		if (memo == null) {
			memo = "";
		}
		filecover.setPk(pk);
		filecover.setFile_cover_code(code);
		filecover.setFile_cover_name(name);
		filecover.setFile_cover_type(type);
		filecover.setFile_cover_year(year);
		filecover.setMemo(memo);

		//检查该档案袋编号是否已存在
		boolean isExist=fileCoverDao.isExist(code);
		if(isExist){		
			request.setAttribute("msg", "档案袋编号["+code+"]已存在，请更换！");
			url = "file_cover_add.jsp";
		}else{		
			//执行保存
			fileCoverDao.save(filecover);
			request.setAttribute("msg", "增加记录[" + filecover.getFile_cover_code()
					+ "," + filecover.getFile_cover_name() + ","
					+ filecover.getFile_cover_year() + "]成功！");
			String forward = request.getParameter("action");
			
			//保存并继续，再次进入增加页面
			if ("continue".equals(forward)) {
				url = "file_cover_add.jsp";
			} 
			//如果是保存，则进入明细页面
			else {
				request.setAttribute("file_cover_view", filecover);
				url = "file_cover_detail.jsp";
			}
		}	
		return url;
	}
}
