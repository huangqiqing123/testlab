package cn.sdfi.know.cmd;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.lxh.smart.File;
import org.lxh.smart.Files;
import org.lxh.smart.Request;
import org.lxh.smart.SmartUpload;

import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.know.bean.Know;
import cn.sdfi.know.dao.KnowDao;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;


public class KnowCmd{

	private Logger log = Logger.getLogger(this.getClass());
	private KnowDao knowDao = (KnowDao)ObjectFactory.getObject(KnowDao.class.getName());

	/*
	 * Ajax判断是否可以在线阅读
	 */
	public String canOnlineRead() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		
		//接收信息
		String pk = request.getParameter("pk");
		//应用的物理根路径
		String root_path = request.getSession().getServletContext().getRealPath("/");
		//用于在线阅读的swf文件所在位置
		String swf_path = root_path + "swf\\";
		java.io.File javafile = new java.io.File(swf_path+pk+".swf"); 
		if(javafile.exists()) {
			try{	
				PrintWriter out = response.getWriter();
				out.print("ok");
			} catch (IOException e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}		
		}else{
			try{	
				PrintWriter out = response.getWriter();
				out.print("not_ok");//如果使用out.println()，前台接收后，用==号比较会不相等。
			} catch (IOException e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}
		}
		return null;
	}
	/*
	 * 智能提示
	 */
	public String suggest() {
	
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		String path = request.getParameter("path");
		String title = request.getParameter("info");
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
	
		try {
			PrintWriter out = response.getWriter();
			out.write("<?xml version=\"1.0\" encoding=\"GBK\"?>");
			out.write("<response>");
			
			List<String> list = null;
			
			if("know_dept_query_user.jsp".equals(path)){//部门知识库（普通用户）
				list = knowDao.suggest(title, "4", null);//4 表示审核通过
			}else if("know_dept_query_admin.jsp".equals(path)){//部门知识库（文档管理员or超级管理员）
				list = knowDao.suggest(title, null, null);
			}else if("know_of_myself.jsp".equals(path)){//我的知识库
				String upload_person = request.getSession().getAttribute("who").toString();
				list = knowDao.suggest(title, null, upload_person);
			}else if("know_submit_query.jsp".equals(path)){//待审核文件
				list = knowDao.suggest(title, "3", null);//4 表示审核通过
			}else{
				log.error("出错了！传入参数有误！");
				throw new RuntimeException("出错了！传入参数有误！");
			}
			
			for(int i=0;i<list.size();i++){		
				out.write("<res>");
				out.write(list.get(i));
				out.write("</res>");
			}		
			out.write("</response>");		
			out.flush();
			out.close();
		} catch (IOException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return null;
	}
	/*
	 * 将指定的单个可打印文档自动转换成swf文档。
	 * 入参request中需传递pk suffix。
	 */
	public String convertToSWFwinthSingle(){
		
		HttpServletRequest request = CommandContext.getRequest();
		
		//应用的物理根路径
		String root_path = request.getSession().getServletContext().getRealPath("/");

		//用于在线阅读的swf文件所在位置
		String swf_path = root_path + "swf\\";

		//知识库和案例库文件所在位置
		String file_path = root_path + "WEB-INF\\file\\";
		
		String pk = request.getParameter("pk");
		String suffix = request.getParameter("suffix");
		
		List<String> canPrintDocs = Const.getCanPrintDocs();
		if(canPrintDocs.contains(suffix)){		
			Tool.toSWF(file_path+pk+"."+suffix, swf_path+pk+".swf");			
			while(!new java.io.File(swf_path+pk+".swf").exists()){//去swf目录下，检查是否转换完成。
				try {
					Thread.sleep(1000);//每1秒检查一次
				} catch (InterruptedException e) {
					log.error("出错了！",e);
					throw new RuntimeException("出错了！",e);
				}
			}	
			request.setAttribute("msg", "转换完成！");	
		}else{
			request.setAttribute("msg", suffix+" 结尾的文档不是可打印文档，无法转换成swf文件！");
		}	
		return "know_need_convert_to_swf.jsp";
	}
	/*
	 * 所有审核通过的文件，如果未转换成flash格式
	 * 自动将其转换为flash格式
	 */
	public String autoConvert() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();

		//应用的物理根路径
		String root_path = request.getSession().getServletContext().getRealPath("/");

		//用于在线阅读的swf文件所在位置
		String swf_path = root_path + "swf\\";

		//知识库和案例库文件所在位置
		String file_path = root_path + "WEB-INF\\file\\";
		List<Know> list = knowDao.noPageQueryByStauts("4");//4 代表审核通过，获取所有审核通过的记录	
		
		//获取所有swf文件名称
		List<String> swf_file_names = new ArrayList<String>();
		java.io.File file = new java.io.File(swf_path);
		java.io.File swf_files[] = file.listFiles();
		for(int m=0;m<swf_files.length;m++){
			if(swf_files[m].isFile()){
				swf_file_names.add(swf_files[m].getName());
			}
		}
		//待转换的文件列表
		List<Know> needConvertList = new ArrayList<Know>();	
		for(int k=0;k<list.size();k++){
			boolean needConvert = true;
			for(int m=0;m<swf_file_names.size();m++){							
				if(swf_file_names.get(m).startsWith(list.get(k).getPk())){
					needConvert = false;
					break;
				}
			}
			if(needConvert){
				needConvertList.add(list.get(k));
			}
		}
		//执行转换操作
		for(int i=0;i<needConvertList.size();i++){
			Know view = needConvertList.get(i);
			String pk = view.getPk();
			String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
			log.debug(file_path+pk+"."+suffix);
			log.debug(swf_path+pk+".swf");
			
			List<String> canPrintDocs = Const.getCanPrintDocs();//可打印文档列表
			if(canPrintDocs.contains(suffix)){		
				Tool.toSWF(file_path+pk+"."+suffix, swf_path+pk+".swf");			
				while(!new java.io.File(swf_path+pk+".swf").exists()){//去swf目录下，检查是否转换完成。
					try {
						Thread.sleep(1000);//每1秒检查一次
					} catch (InterruptedException e) {
						log.error("出错了！",e);
						throw new RuntimeException("出错了！",e);
					}
				}	
			}		
		}	
		request.setAttribute("msg", "转换完成！");
		return "know_need_convert_to_swf.jsp";
	}
	/*
	 * 下载附件
	 */
	public String download() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();

		String url = null;
		String pk = request.getParameter("pk");
		Know view = knowDao.queryByPK(pk);
		try {
			//磁盘存放 ---主键.后缀  ；数据库存放--- 真实文件名
			String path = request.getSession().getServletContext().getRealPath("/")+"WEB-INF\\file";	
			String filename = view.getBlob_name();
			String savename = pk+(filename.substring(filename.lastIndexOf(".")));
			FileInputStream fileInputStream = new FileInputStream(path+"\\"+savename);
			InputStream fileBytes = new BufferedInputStream(fileInputStream);
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment;filename=" + Tool.toUtf8String(filename));
			OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
			int bytes;
			while ((bytes = fileBytes.read()) != -1) {
				toClient.write(bytes);
			}
			fileInputStream.close();
			fileBytes.close();
			toClient.flush();
			toClient.close();
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return url;
	}

	/*
	 * 删除操作
	 */
	public String delete() {
		
		HttpServletRequest request = CommandContext.getRequest();	
		
		// 可以批量删除，所以接受参数时，使用 request.getParameterValues，返回字符串数组
		String[] pk = request.getParameterValues("pk");
		knowDao.batchDeleteByPk(pk);

		request.setAttribute("msg", "删除 " + pk.length + " 条记录成功！");
		
		//删除附件
		String root_path = request.getSession().getServletContext().getRealPath("/");
		String filePath = root_path + "WEB-INF\\file\\";
		String swf_path = root_path + "swf\\";
		java.io.File file = new java.io.File(filePath);
		String[] files = file.list();
		for (int i = 0; i < pk.length; i++) {		
			//删除 swf 路径下的原flash文件
			java.io.File swffile = new java.io.File(swf_path+pk[i]+".swf"); 			
			if(swffile.exists()) 
			{ 		
				if(swffile.delete()){
					log.debug("删除swf文件{"+pk[i]+".swf}成功！");
				}else{
					log.debug("删除swf文件{"+pk[i]+".swf}失败，可以从辅助功能-冗余数据检查-一键修复！");
				} 			
			} 
			//删除原型文件
			 for (int j = 0; j < files.length; j++) {	 
			    if (files[j].startsWith(pk[i])) {
			    	java.io.File temp_file = new java.io.File(filePath+files[j]);
			    		if(temp_file.delete()){
			    			log.debug("删除附件"+temp_file.getAbsolutePath()+"成功！");
			    		}else{
			    			log.error("删除附件"+temp_file.getAbsolutePath()+"时出错，可以从辅助功能-冗余数据检查-一键修复！");
			    		}
			    	break;
			    	}
			 }
		}
		//在”我的知识库“ 和”部门知识库“ 页面都可以执行删除操作，根据参数path进行相应的页面跳转。
		return "knowdo.do?method=query&path="+request.getParameter("path");
	}
	/*
	 * 在 "待审核知识" 页面执行驳回
	 */
	public String reject() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		String last_update_time = Tool.getDateTime();

		//调用dao层，执行"批准"操作
		knowDao.reject(pk, last_update_time);
		request.setAttribute("msg", "驳回成功！");
		return "knowdo.do?method=query&path=know_submit_query.jsp";
	}
	/*
	 * 在 "待审核知识" 页面执行批准
	 */
	public String approve() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		String last_update_time = Tool.getDateTime();

		//调用dao层，执行"批准"操作
		knowDao.approve(pk, last_update_time);
		request.setAttribute("msg", "批准成功！");
		return "knowdo.do?method=query&path=know_submit_query.jsp";
	}
	/*
	 * 在 "我的知识库" 页面执行提交
	 */
	public String submit() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		String submit_time = Tool.getDateTime();
		knowDao.submit(pk,submit_time);	
		request.setAttribute("msg", "提交成功！");
		return "knowdo.do?method=query&path=know_of_myself.jsp";
	}
	/*
	 * 在 "我的知识库" 页面执行撤回
	 */
	public String back() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		String last_update_time = Tool.getDateTime();
		knowDao.back(pk,last_update_time);	
		request.setAttribute("msg", "撤回成功！");
		return "knowdo.do?method=query&path=know_of_myself.jsp";
	}
	/*
	 * 判断是否是"保存"状态
	 */
	public String isSaveOrRejectStatus() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		
		//检查所有pks，并将所有非"保存/驳回"状态的pk放到list中
		List<String> notSaveOrRejectPks = new ArrayList<String>();
		for (int i = 0; i < pk.length; i++) {			
			if(!knowDao.isSaveOrRejectStatus(pk[i])){
				notSaveOrRejectPks.add(pk[i]);	
			}	
		}
		//如果包含有非"保存/驳回"状态的记录
		if(notSaveOrRejectPks.size()>0){
			StringBuffer titles = new StringBuffer();//所有非“保存、驳回”记录的title
			for (int i = 0; i < notSaveOrRejectPks.size(); i++) {
				titles.append(knowDao.queryByPK(notSaveOrRejectPks.get(i)).getTitle());
				titles.append(",");
			}
			titles.deleteCharAt(titles.length()-1);
			try{	
				PrintWriter out = response.getWriter();
				out.print(titles.toString());
			} catch (IOException e) {
				log.error("出错了!",e);
				throw new RuntimeException("出错了!",e);
			}
		}else{	
			try{	
				PrintWriter out = response.getWriter();
				out.print("ok");//如果使用out.println()，前台接收后，用==号比较会不相等。
			} catch (IOException e) {
				log.error("出错了!",e);
				throw new RuntimeException("出错了!",e);
			}
		}
		return null;
	}
	/*
	 * 判断是否是"待审核"状态
	 */
	public String isSubmitStatus() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		
		//检查所有pks，并将所有非"待审核"状态的pk放到list中
		List<String> notStatusPks = new ArrayList<String>();
		for (int i = 0; i < pk.length; i++) {			
			if(!knowDao.isSubmitStatus(pk[i])){
				notStatusPks.add(pk[i]);	
			}	
		}
		//如果包含有非"待审核"状态的记录
		if(notStatusPks.size()>0){
			StringBuffer titles = new StringBuffer();
			for (int i = 0; i < notStatusPks.size(); i++) {
				titles.append(knowDao.queryByPK(notStatusPks.get(i)).getTitle());
				titles.append(",");
			}
			titles.deleteCharAt(titles.length()-1);	
			try{	
				PrintWriter out = response.getWriter();
				out.print(titles);
			} catch (IOException e) {
				log.error("出错了!",e);
				throw new RuntimeException("出错了!",e);
			}
		}else{	
			try{	
				PrintWriter out = response.getWriter();
				out.print("ok");//如果使用out.println()，前台接收后，用==号比较会不相等。
			} catch (IOException e) {
				log.error("出错了!",e);
				throw new RuntimeException("出错了!",e);
			}
		}
		return null;
	}
	/*
	 * 更新(根据action不同，分为 保存 和 提交(submit))
	 */
	public String update() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		SmartUpload smart = new SmartUpload();
		ServletConfig config = (ServletConfig)request.getAttribute("config");
		
		try {
			// 1、上传初始化
			smart.initialize(config, request, response);
			// 2、准备上传
			smart.upload();
		} catch (Exception e) {
			log.error("出错了!",e);
			throw new RuntimeException("出错了!",e);
		}
		String url = null;
		String blob_name = null;
		Request smartrequest = smart.getRequest();
		String pk = smartrequest.getParameter("pk");
		String do_upload = smartrequest.getParameter("do_upload");
		
		//如果更新了附件，则执行文件上传，上传之前先删除原有附件；如果未更新附件，则不再执行文件上传。
		if("yes".equals(do_upload)){
		Files files = smart.getFiles();
		if(files.getCount()!=0){
		try {
			long size = files.getSize();
			if(size!=0){
			File file = files.getFile(0);
			String ext = file.getFileExt();
			blob_name = file.getFileName();
			
			//删除 file 路径下的原文件
			String root_path = request.getSession().getServletContext().getRealPath("/");
			String filepath = root_path + "WEB-INF\\file";
			String swf_path = root_path + "swf";
			String old_blob_name = knowDao.queryByPK(pk).getBlob_name();
			String old_save_name = pk+(old_blob_name.substring(old_blob_name.lastIndexOf(".")));
			java.io.File javafile = new java.io.File(filepath+"\\"+old_save_name); 		
			if(javafile.exists()) 
			{ 		
				javafile.delete();	
			} 
			//删除 swf 路径下的原flash文件
			java.io.File swffile = new java.io.File(swf_path+"\\"+pk+".swf"); 			
			if(swffile.exists()) 
			{ 		
				swffile.delete();	
			} 	
			//保存新附件
			file.saveAs("\\WEB-INF\\file\\" + smartrequest.getParameter("pk") + "." + (ext.toLowerCase()));	
		}
		} catch (Exception e) {
			log.error("出错了!",e);
			throw new RuntimeException("出错了!",e);
		}		
		}
		}
		//更新数据库信息
		Know view = new Know();	
		view.setPk(pk);
		view.setBlob_name(blob_name);
		view.setLast_update_time(Tool.getDateTime());
		view.setTitle(smartrequest.getParameter("title"));
		view.setType(smartrequest.getParameter("type"));
		view.setVersion(smartrequest.getParameter("version"));
		view.setPages(smartrequest.getParameter("pages"));
		view.setMemo(smartrequest.getParameter("memo"));
		
		String path = request.getParameter("path");
		if("know_update_admin.jsp".equals(path)){
			view.setStatus(smartrequest.getParameter("status"));
		}else{
			//判断是执行【保存】还是执行【提交】，由于action是通过get方式传过来的值，所以此处用request来获取。
			String action = request.getParameter("action");
			if("submit".equals(action)){
				view.setStatus("3");//3 表示 待审核
			}else if("save".equals(action)){
				view.setStatus("1");//1表示 保存
			}else{
				log.error("出错了!入参有误！");
				throw new RuntimeException("出错了!入参有误！");
			}
		}
		
		//调用dao层，执行更新操作
		knowDao.update(view);
		url="know_detail.jsp";
		request.setAttribute("msg","信息更新成功！");
		request.setAttribute("know.view", knowDao.queryByPK(pk));
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
		
		HttpServletRequest request = CommandContext.getRequest();		
		String pk =request.getParameter("pk");
		Know view = knowDao.queryByPK(pk);
		request.setAttribute("know.view", view);
		return "know_detail.jsp";
	}
	/*
	 * 执行更新前的查询
	 */
	public String forupdate() {
		
		HttpServletRequest request = CommandContext.getRequest();		
		String pk =request.getParameter("pk");
		String path = request.getParameter("path");
		Know view = knowDao.queryByPK(pk);
		request.setAttribute("know.view", view);
		if("know_dept_query_admin.jsp".equals(path)){
			return "know_update_admin.jsp";
		}else{		
			return "know_update_myself.jsp";
		}
	}

	/*
	 * 查询
	 */
	@Trans
	public String query() {
		
		HttpServletRequest request = CommandContext.getRequest();

		//获取从哪个页面发送的请求，以便将查询结果返回至相应的页面。
		String path = request.getParameter("path");
		
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则按照最后更新时间进行排序。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String title=request.getParameter("title");
		String type=request.getParameter("type");
		String pageSize=request.getParameter("pageSize");
		
		//如果是在“我的案例库”页面执行查询，则“上传者”始终是当前用户自己
		String upload_person = null;
		if("know_of_myself.jsp".equals(path)){
			upload_person = request.getSession().getAttribute("who").toString();
		}else{			
			upload_person = request.getParameter("upload_person");
		}
		
		//如果是在“待审核知识”页面执行查询，则“知识状态”始终是3，即待审核
		//如果是在“部门知识库-user”页面执行查询，则知识状态始终是4,即审核通过
		String status = null;
		if("know_submit_query.jsp".equals(path)){
			status = "3";//3 表示待审核
		}else if("know_dept_query_user.jsp".equals(path)){
			status = "4";//4 表示审核通过
		}else{			
			status = request.getParameter("status");
		}
		
		//空值处理
		if(sort==null)sort="last_update_time";	//查询结果默认按照“最后更新时间”进行倒序排列
		if(sortType==null)sortType="DESC";
		if(title==null)title="";
		if(type==null)type="";
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
		if(status==null)status="";	
		if(upload_person==null)upload_person="";	
		
		// 将查询条件组合成对象
		Know query_condition = new Know();
		query_condition.setSort(sort);
		query_condition.setSortType(sortType);
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setTitle(title);
		query_condition.setType(type);
		query_condition.setStatus(status);
		query_condition.setUpload_person(upload_person);
		
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
		Map<String,Object> map = knowDao.queryByKnow(query_condition);
		List<Know> list = (List<Know>)map.get("list");
		request.setAttribute("know_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString()); //获取查询出的总记录数
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);//总页数
		query_condition.setRecordCount(newRecordCount);
		query_condition.setPageCount(newPageCount);
		request.setAttribute("query_condition", query_condition);
		return forward_after_query(path);
	}

	/*
	 * 文件上传（单个文件上传isBatchAdd=false、批量上传isBatchAdd=true）
	 */
	public String add() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();

		String url = null;
		boolean isBatchAdd = "1".equals(request.getParameter("isBatchAdd"));//是否批量上传
		SmartUpload smart = new SmartUpload();
		ServletConfig config = (ServletConfig)request.getAttribute("config");
		try {	
			smart.initialize(config, request, response);//上传初始化	
			smart.upload();	//执行上传	
			Request smartrequest = smart.getRequest();//获取smartRequest
			Files files = smart.getFiles();//获取所有附件
			int count = files.getCount();
			
			//如果上传文件数等于0
			if(count==0){
				request.setAttribute("msg","请选择要上传的文件！");
				url = isBatchAdd?"know_batchUpload_file.jsp":"know_add.jsp";
				return url;
			}

			//action是get方式传过来的，所以需要用request来接收，而不能使用smartrequest。
			//根据action来判断是 保存 还是 提交
			String status =null;
			String action=request.getParameter("action");
			if("save".equals(action)){
				status = "1";//1表示保存
			}else if("submit".equals(action)){
				status = "3";//3表示待审核（提交）
			}else{
				log.error("出错了！无效参数action="+action);
				throw new RuntimeException("出错了！无效参数action="+action);
			}
			Know view = null;
			String uploadPerson = request.getSession().getAttribute("who").toString();//上传人为当前登录用户

			//遍历所有附件，分别上传
			Enumeration<File> file_enum = (Enumeration<File>)files.getEnumeration();
			while(file_enum.hasMoreElements()){

				//取出当前文件
				File file = file_enum.nextElement();	
				String ext = file.getFileExt();

				//空附件校验
				if(ext==null||"".equals(ext)||file.getSize()==0){
					request.setAttribute("msg","附件缺少后缀，或者无附件，请重新选择！");
					url = isBatchAdd?"know_batchUpload_file.jsp":"know_add.jsp";
					return url;
				}

				//附件大小校验
				if(file.getSize()>20*1024*1024){
					request.setAttribute("msg","单个最大可上传附件为20M，文件< "+file.getFileName()+">("+file.getSize()/1024/1024+"M)大小超出限制，请重新选择！");
					url = isBatchAdd?"know_batchUpload_file.jsp":"know_add.jsp";
					return url;
				}

				//获取附件名称，并统一将文件后缀改成小写
				String blob_name = file.getFileName();
				blob_name = blob_name.substring(0, blob_name.lastIndexOf(".")+1)
				+(blob_name.substring(blob_name.lastIndexOf(".")+1).toLowerCase());

				//流水号主键
				String pk=UUIDGenerator.getRandomUUID();
				
				//将附件保存到指定目录，磁盘中的文件与数据库中记录通过主键pk进行关联		
				file.saveAs("\\WEB-INF\\file\\" + pk + "." + (ext.toLowerCase()));

				//将信息保存到数据库
				view = new Know();
				view.setPk(pk);
				view.setUpload_person(uploadPerson);//上传人
				view.setUpload_time(Tool.getDateTime());//上传时间
				view.setLast_update_time(view.getUpload_time());//新上传文件时，上传时间与最后更新时间相同。	
				view.setPages(isBatchAdd?"":smartrequest.getParameter("pages"));//页数
				view.setMemo(isBatchAdd?"":smartrequest.getParameter("memo"));//备注
				view.setTitle(isBatchAdd?blob_name:smartrequest.getParameter("title"));//关键字
				
				//获取当前附件对应的表单域的名称
				String fieldName = file.getFieldName();
				view.setType(isBatchAdd?smartrequest.getParameter(fieldName.replace("filename", "type")):smartrequest.getParameter("type"));//文件类型
				view.setVersion(isBatchAdd?"":smartrequest.getParameter("version"));//版本
				view.setStatus(status);//文件状态（提交、审核。。。）
				view.setBlob_name(blob_name);//文件名称
				
				//保存至数据库
				knowDao.save(view);
				
			}//while循环至此结束	
			if(isBatchAdd){			
				request.setAttribute("msg","文件上传成功！");
				url = "know_batchUpload_file.jsp";
				return url;
			}else{
				request.setAttribute("msg","上传文件["+view.getBlob_name()+"]成功！");
				request.setAttribute("know.view", view);
				url="know_detail.jsp?path=know_add.jsp";	
				return url;
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}	
	}
	//执行查询后的页面跳转
	public String forward_after_query(String path){
		
		if("know_submit_query.jsp".equals(path)){
			return "know_submit_query.jsp";//返回待审核页面
		}else if("know_of_myself.jsp".equals(path)){
			return "know_of_myself.jsp";//返回我的知识库页面
		}else if("know_dept_query_user.jsp".equals(path)){		
			return "know_dept_query_user.jsp";//返回部门知识库（普通用户）页面
		}else if("know_dept_query_admin.jsp".equals(path)){
			return "know_dept_query_admin.jsp";//返回部门知识库（管理员）页面
		}else{
			log.error("接收到了无效的参数，path="+path);
			return null;
		}
	}
}
