package cn.sdfi.filecovercontent.cmd;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.lxh.smart.File;
import org.lxh.smart.Files;
import org.lxh.smart.Request;
import org.lxh.smart.SmartUpload;

import cn.sdfi.filecover.dao.FileCoverDao;
import cn.sdfi.filecovercontent.bean.FileCoverContent;
import cn.sdfi.filecovercontent.dao.FileCoverContentDao;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.GetFileNames;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;


public class FileCoverContentCmd{

	private Logger log = Logger.getLogger(FileCoverContentCmd.class);
	private FileCoverContentDao fileCoverContentDao = (FileCoverContentDao)ObjectFactory.getObject(FileCoverContentDao.class.getName());
	private FileCoverDao fileCoverDao = (FileCoverDao)ObjectFactory.getObject(FileCoverDao.class.getName());
	private UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());

	/*
	 * 下载附件
	 */
	public String download() {

		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		String url = null;
		String pk = request.getParameter("pk");
		FileCoverContent filecovercontent = fileCoverContentDao.queryByPK(pk);
 
		try {
			String path = request.getSession().getServletContext().getRealPath("/")+"WEB-INF\\document";
			String filenames[] = GetFileNames.getFileNamesStartWithPrefix(path, pk);

			//如果存在附件
			if(filenames.length>0){
				String ext = filenames[0].substring( filenames[0].lastIndexOf("."));//获取文件后缀
				String newfilename = filecovercontent.getFile_cover_content_name()+ext;//组装新的文件名称	
				FileInputStream fileInputStream = new FileInputStream(path+"\\"+filenames[0]);
				InputStream fileBytes = new BufferedInputStream(fileInputStream);
				response.setContentType("application/octet-stream");
				response.setHeader("Content-Disposition", "attachment;filename=" + Tool.toUtf8String(newfilename));
				OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
				int bytes;
				while ((bytes = fileBytes.read()) != -1) {
					toClient.write(bytes);
				}
				fileInputStream.close();
				fileBytes.close();
				toClient.flush();
				toClient.close();
			}
			//如果不存在
			else{
				request.setAttribute("msg","Sorry，该文件没有对应的附件！");
				filecovercontent.setFile_cover_name(fileCoverDao.queryByPK(filecovercontent.getFk()).getFile_cover_name());
				request.setAttribute("file_cover_content.view", filecovercontent);
				url="file_cover_content_detail.jsp";
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return url;
	}
	/*
	 * 接收Ajax请求，检验该文件编号是否已存在
	 */
	public String isExist() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		//检查该档案袋编号是否已存在
		String file_cover_content_code = request.getParameter("file_cover_content_code");
		boolean isExist = fileCoverContentDao.isExist(file_cover_content_code);
		
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
	public String delete() {	
		
		HttpServletRequest request = CommandContext.getRequest();
		
		// 可以批量删除，所以接受参数时，使用 request.getParameterValues，返回字符串数组
		String[] pk = request.getParameterValues("pk");
		fileCoverContentDao.batchDeleteByPk(pk);
		request.setAttribute("msg", "删除 " + pk.length + " 条记录成功！");
		
		//删除附件
		String documentPath = request.getSession().getServletContext().getRealPath("/")+"WEB-INF\\document";
		
		for (int i = 0; i < pk.length; i++) {	
			String filenames[] = GetFileNames.getFileNamesStartWithPrefix(documentPath, pk[i]);
			
			//如果存在附件
			if(filenames.length>0){
				
				java.io.File file = new java.io.File(documentPath+"\\"+filenames[0]); 
				if(file.exists()){ 		
					file.delete(); 			
				} 
			}
		}
		String file_cover_pk=request.getParameter("file_cover_pk");
		String path =request.getParameter("path");
		
		//在档案袋明细页面删除文件后，重新返回到档案袋明细页面
		if("from_file_cover_detail_page".equals(path)){
			return "filecoverdo.do?method=detail&pk="+file_cover_pk;
		}
		else{
			return "filecovercontentdo.do?method=query";
		}	
	}

	/*
	 * 更新
	 */
	public String update() {
	
		SmartUpload smart = new SmartUpload();
		ServletConfig config = CommandContext.getServletConfig();
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		try {
			// 1、上传初始化
			smart.initialize(config, request, response);
			// 2、准备上传
			smart.upload();
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		Request smartrequest = smart.getRequest();

		String url = null;
		FileCoverContent filecovercontent = new FileCoverContent();
		filecovercontent.setPk(smartrequest.getParameter("pk"));
		filecovercontent.setFile_cover_content_code(smartrequest.getParameter("file_cover_content_code").trim());
		filecovercontent.setFile_cover_content_name(smartrequest.getParameter("file_cover_content_name").trim());
		filecovercontent.setFk(smartrequest.getParameter("fk"));
		filecovercontent.setMemo(smartrequest.getParameter("memo"));
		filecovercontent.setPages(smartrequest.getParameter("pages"));
		filecovercontent.setVersion(smartrequest.getParameter("version"));

		//调用dao层，执行更新操作
		fileCoverContentDao.update(filecovercontent);
		
		//执行文件上传
		Files files = smart.getFiles();
		//对于空附件的判断
		if(files.getCount()!=0){
			try {
			long size = files.getSize();
			if(size!=0){
			File file = files.getFile(0);
			String ext = file.getFileExt();//获取文件后缀
				//如果该文件已存在附件，则先将原来的附件删除。
				String documentPath = request.getSession().getServletContext().getRealPath("/")+"WEB-INF\\document";
				String filenames[] = GetFileNames.getFileNamesStartWithPrefix(documentPath,smartrequest.getParameter("pk"));
				for (int i = 0; i < filenames.length; i++) {	
					java.io.File javafile = new java.io.File(documentPath+"\\"+filenames[i]); 
					if(javafile.exists()) 
					{ 		
						javafile.delete(); 			
					} 
				}
				//保存新附件
				file.saveAs("\\WEB-INF\\document\\" + smartrequest.getParameter("pk") + "." + ext);	
			}
			} catch (Exception e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}		
		}
		request.setAttribute("msg","文件信息更新成功！");
		filecovercontent.setFile_cover_name(fileCoverDao.queryByPK(filecovercontent.getFk()).getFile_cover_name());
		request.setAttribute("file_cover_content.view", filecovercontent);
		url="file_cover_content_detail.jsp";
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
		HttpServletRequest request = CommandContext.getRequest();
		String pk =request.getParameter("pk");
		FileCoverContent filecovercontent = fileCoverContentDao.queryByPK(pk);
		filecovercontent.setFile_cover_name(fileCoverDao.queryByPK(filecovercontent.getFk()).getFile_cover_name());
		request.setAttribute("file_cover_content.view", filecovercontent);
		return "file_cover_content_detail.jsp";
	}

	/*
	 * 查询
	 */
	public String query() {	
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则默认按照文件编码（code）升序排列。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String file_cover_content_name=request.getParameter("file_cover_content_name");
		String file_cover_content_code=request.getParameter("file_cover_content_code");
		String fk=request.getParameter("fk");
		String fk_show=request.getParameter("fk_show");//fk_show不参与查询，只是显示
		
		//空值处理
		if(pageSize==null||"".equals(pageSize)){
			pageSize=request.getSession().getAttribute("pageSize").toString();
		}else{
			//如果用户的pageSize发生改变，则同步更新session中的pageSize和数据库中的pageSize
			if(!pageSize.equals(request.getSession().getAttribute("pageSize").toString())){
				request.getSession().setAttribute("pageSize", pageSize);
				userDao.changePageSize(CommandContext.getSession().getAttribute("username")+"", pageSize);
			}
		}	
		if(sort==null)sort="file_cover_content_code";	
		if(sortType==null)sortType="ASC";
		if(file_cover_content_name==null)file_cover_content_name="";
		if(file_cover_content_code==null)file_cover_content_code="";
		if(fk==null)fk="";
		if(fk_show==null)fk_show="";	
		
		// 将查询条件组合成对象
		FileCoverContent query_condition = new FileCoverContent();
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setSort(sort);
		query_condition.setSortType(sortType);
		query_condition.setFile_cover_content_name(file_cover_content_name.trim());
		query_condition.setFile_cover_content_code(file_cover_content_code.trim());
		query_condition.setFk(fk);
			
		//----------------如果是执行导出excel操作---------------------
		if("exportExcel".equals(request.getParameter("action"))){		
			try {
				List<FileCoverContent> list = fileCoverContentDao.export(query_condition);
				response.setContentType("application/octet-stream;charset=UTF-8");
				response.setHeader("Content-Disposition","attachment;filename="+Tool.toUtf8String("文件信息台帐")+".xls");
				HSSFWorkbook wb = new HSSFWorkbook();
				
				//第一个标签显示档案袋信息
				HSSFSheet sheet1 = wb.createSheet("文件信息");
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
		if (request.getParameter("showPage") != null&&!request.getParameter("showPage").equals("")){
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
		Map<String,Object> map = fileCoverContentDao.queryByFileCoverContent(query_condition);
		List<FileCoverContent> list = (List<FileCoverContent>)map.get("list");
		
		//将查询结果放入request
		request.setAttribute("file_cover_content_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString());
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);
		query_condition.setRecordCount(newRecordCount); //总记录数
		query_condition.setPageCount(newPageCount);//总页数
		request.setAttribute("query_condition",query_condition);
		request.setAttribute("fk_show",fk_show);

		//如果查询结果为空
		if(newRecordCount<1){			
			String path = request.getParameter("path");
			if (!"after_delete".equals(path)) {		
				request.setAttribute("msg", "Sorry，无符合条件的记录！");
			}
		}
			return "file_cover_content_query.jsp";
		}
	//----------------查询操作到此结束---------------------

	public String add() {

		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		ServletConfig config = CommandContext.getServletConfig();
		
		SmartUpload smart = new SmartUpload();

		try {
			smart.initialize(config, request, response);//上传初始化	
			smart.upload();//上传
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		Request smartrequest = smart.getRequest();

		String url = null;

		//接收信息
		String fk=smartrequest.getParameter("fk").trim();
		String fk_show=smartrequest.getParameter("fk_show").trim();
		String pk=UUIDGenerator.getRandomUUID();
		String file_cover_content_code=smartrequest.getParameter("file_cover_content_code").trim();
		String file_cover_content_name=smartrequest.getParameter("file_cover_content_name").trim();
		String pages=smartrequest.getParameter("pages");
		String version=smartrequest.getParameter("version");
		String memo=smartrequest.getParameter("memo");

		//将接收的信息组装成对象
		FileCoverContent filecovercontent = new FileCoverContent();
		filecovercontent.setFile_cover_content_code(file_cover_content_code);
		filecovercontent.setPk(pk);
		filecovercontent.setFk(fk);
		filecovercontent.setFile_cover_content_name(file_cover_content_name);
		filecovercontent.setPages(pages);
		filecovercontent.setVersion(version);
		filecovercontent.setMemo(memo);

		//执行保存
		fileCoverContentDao.save(filecovercontent);

		request.setAttribute("msg","增加记录["+filecovercontent.getFile_cover_content_code()+","+filecovercontent.getFile_cover_content_name()+"]成功！");

		//action是get方式传过来的，所以需要用request来接收，而不能使用smartrequest。
		String forward=request.getParameter("action");

		//保存并继续，再次进入文件增加页面。
		if("continue".equals(forward)){
			request.setAttribute("fk", fk);
			request.setAttribute("fk_show", fk_show);
			url = "file_cover_content_add.jsp";
		}
		//保存后，进入明细页面
		else{
			filecovercontent.setFile_cover_name(fileCoverDao.queryByPK(filecovercontent.getFk()).getFile_cover_name());
			request.setAttribute("file_cover_content.view", filecovercontent);
			url="file_cover_content_detail.jsp";
		}	

		//执行文件上传
		Files files = smart.getFiles();
		File file = files.getFile(0);
		String ext = file.getFileExt();//获取文件后缀

		if(file.getSize()>10*1024*1024){
			log.error("附件大小超出限制"+file.getSize()/1024/1024);
			request.setAttribute("msg","增加记录["+filecovercontent.getFile_cover_content_code()+","+filecovercontent.getFile_cover_content_name()+"]成功！但是由于附件大小超过限制10M，没有上传成功！");
			return url;
		}
		//对于空附件的判断
		if(ext!=null&&!"".equals(ext)&&file.getSize()!=0){

			try {
				file.saveAs("\\WEB-INF\\document\\" + pk + "." + ext);
			} catch (Exception e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}
		}
		return url;
	}
}
