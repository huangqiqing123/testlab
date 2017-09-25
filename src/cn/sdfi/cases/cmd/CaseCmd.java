package cn.sdfi.cases.cmd;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
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

import cn.sdfi.cases.bean.Case;
import cn.sdfi.cases.dao.CaseDao;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;


public class CaseCmd{

	private CaseDao caseDao = (CaseDao)ObjectFactory.getObject(CaseDao.class.getName());
	private Logger log = Logger.getLogger(CaseCmd.class);
	
	/*
	 * 所有审核通过的文件，如果未转换成flash格式
	 * 自动将其转换为flash格式
	 */
	@Trans
	public String autoConvert() {

		//应用的物理根路径
		String root_path = CommandContext.getServletContext().getRealPath("/");

		//用于在线阅读的swf文件所在位置
		String swf_path = root_path + "swf\\";

		//知识库和案例库文件所在位置
		String file_path = root_path + "WEB-INF\\file\\";
		List<Case> list = caseDao.noPageQueryByStauts("4");//4 代表审核通过，获取所有审核通过的记录	
		
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
		List<Case> needConvertList = new ArrayList<Case>();	
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
			Case view = needConvertList.get(i);
			String pk = view.getPk();
			String suffix = (view.getBlob_name().substring(view.getBlob_name().lastIndexOf(".")+1)).toLowerCase();
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
		CommandContext.getRequest().setAttribute("msg", "转换完成！");
		return "case_need_convert_to_swf.jsp";
	}
	/*
	 * 将指定的单个可打印文档自动转换成swf文档。
	 * 入参request中需传递pk suffix。
	 */
	@Trans
	public String convertToSWFwinthSingle(){
		
		//应用的物理根路径
		String root_path = CommandContext.getServletContext().getRealPath("/");

		//用于在线阅读的swf文件所在位置
		String swf_path = root_path + "swf\\";

		//知识库和案例库文件所在位置
		String file_path = root_path + "WEB-INF\\file\\";
		
		String pk = CommandContext.getRequest().getParameter("pk");
		String suffix = CommandContext.getRequest().getParameter("suffix");
		
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
			CommandContext.getRequest().setAttribute("msg", "转换完成！");	
		}else{
			CommandContext.getRequest().setAttribute("msg", suffix+" 结尾的文档不是可打印文档，无法转换成swf文件！");
		}	
		return "case_need_convert_to_swf.jsp";
	}
	/*
	 * 下载附件
	 */
	public String download() {

		String url = null;
		String pk = CommandContext.getRequest().getParameter("pk");
		Case view = caseDao.queryByPK(pk);
		try {
			//磁盘存放 ---主键.后缀  ；数据库存放--- 真实文件名
			String path = CommandContext.getServletContext().getRealPath("/")+"WEB-INF\\file";	
			String filename = view.getBlob_name();
			String savename = pk+(filename.substring(filename.lastIndexOf(".")));
			FileInputStream fileInputStream = new FileInputStream(path+"\\"+savename);
			InputStream fileBytes = new BufferedInputStream(fileInputStream);
			CommandContext.getResponse().setContentType("application/octet-stream");
			CommandContext.getResponse().setHeader("Content-Disposition", "attachment;filename=" + Tool.toUtf8String(filename));
			OutputStream toClient = new BufferedOutputStream(CommandContext.getResponse().getOutputStream());
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
	
		
		// 可以批量删除，所以接受参数时，使用 request.getParameterValues，返回字符串数组
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		caseDao.batchDeleteByPk(pk);

		CommandContext.getRequest().setAttribute("msg", "删除 " + pk.length + " 条记录成功！");
		
		//删除附件
		String root_path = CommandContext.getServletContext().getRealPath("/");
		String filePath = root_path + "WEB-INF\\file\\";
		String swf_path = root_path + "swf\\";
		java.io.File file = new java.io.File(filePath);
		String[] files = file.list();
		
		for (int i = 0; i < pk.length; i++) {	
			
			//删除 swf 路径下的原flash文件
			java.io.File swffile = new java.io.File(swf_path+pk[i]+".swf"); 			
			if(swffile.exists()) 
			{ 		
				swffile.delete();		
			} 
			//删除原型文件
			 for (int j = 0; j < files.length; j++) {	 
			    if (files[j].startsWith(pk[i])) {
			    	java.io.File temp_file = new java.io.File(filePath+files[j]);
			    	temp_file.delete();
			    	break;
			    	}
			 }
		}
	
		//在”我的案例库“ 和”部门案例库“ 页面都可以执行删除操作，根据参数path进行相应的页面跳转。
		return "casedo.do?method=query&path="+CommandContext.getRequest().getParameter("path");
	}
	/*
	 * 在 "待审核案例" 页面执行驳回
	 */
	public String reject() {
		
		//接收信息
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		String last_update_time = Tool.getDateTime();

		//调用dao层，执行"批准"操作
		caseDao.reject(pk, last_update_time);
		CommandContext.getRequest().setAttribute("msg", "驳回成功！");
		
		return "casedo.do?method=query&path=case_submit_query.jsp";
	}
	/*
	 * 在 "待审核案例" 页面执行批准
	 */
	public String approve() {
		
		//接收信息
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		String last_update_time = Tool.getDateTime();

		//调用dao层，执行"批准"操作
		caseDao.approve(pk, last_update_time);
		CommandContext.getRequest().setAttribute("msg", "批准成功！");
		
		return "casedo.do?method=query&path=case_submit_query.jsp";
	}
	/*
	 * 在 "我的案例库" 页面执行提交
	 */
	public String submit() {
		
		//接收信息
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		String submit_time = Tool.getDateTime();
		caseDao.submit(pk,submit_time);	
		CommandContext.getRequest().setAttribute("msg", "提交成功！");
	
		return "casedo.do?method=query&path=case_of_myself.jsp";
	}
	/*
	 * 在 "我的案例库" 页面执行撤回
	 */
	public String back() {
		
		//接收信息
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		String last_update_time = Tool.getDateTime();
		caseDao.back(pk,last_update_time);	
		CommandContext.getRequest().setAttribute("msg", "撤回成功！");

		return "casedo.do?method=query&path=case_of_myself.jsp";
	}
	/*
	 * 判断是否是"保存"状态
	 */
	public String isSaveOrRejectStatus() {
	
		CommandContext.getResponse().setHeader("Cache-Control", "no-store");
		CommandContext.getResponse().setHeader("Pragma","no-cache");
		CommandContext.getResponse().setDateHeader("Expires",0);
		
		//接收信息
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		
		//检查所有pks，并将所有非"保存/驳回"状态的pk放到list中
		List<String> notSaveOrRejectPks = new ArrayList<String>();
		for (int i = 0; i < pk.length; i++) {			
			if(!caseDao.isSaveOrRejectStatus(pk[i])){
				notSaveOrRejectPks.add(pk[i]);	
			}	
		}
		//如果包含有非"保存/驳回"状态的记录
		if(notSaveOrRejectPks.size()>0){
			StringBuffer titles = new StringBuffer();//所有非“保存、驳回”记录的title
			for (int i = 0; i < notSaveOrRejectPks.size(); i++) {
				titles.append(caseDao.queryByPK(notSaveOrRejectPks.get(i)).getTitle());
				titles.append(",");
			}
			titles.deleteCharAt(titles.length()-1);
			try{	
				PrintWriter out = CommandContext.getResponse().getWriter();
				out.print(titles.toString());
			} catch (IOException e) {
				throw new RuntimeException("出错了！",e);
			}
		}else{	
			try{	
				PrintWriter out = CommandContext.getResponse().getWriter();
				out.print("ok");//如果使用out.println()，前台接收后，用==号比较会不相等。
			} catch (IOException e) {
				throw new RuntimeException("出错了！",e);
			}
		}
		return null;
	}
	/*
	 * 判断是否是"待审核"状态
	 */
	public String isSubmitStatus() {
	
		CommandContext.getResponse().setHeader("Cache-Control", "no-store");
		CommandContext.getResponse().setHeader("Pragma","no-cache");
		CommandContext.getResponse().setDateHeader("Expires",0);
		
		//接收信息
		String[] pk = CommandContext.getRequest().getParameterValues("pk");
		
		//检查所有pks，并将所有非"待审核"状态的pk放到list中
		List<String> notStatusPks = new ArrayList<String>();
		for (int i = 0; i < pk.length; i++) {			
			if(!caseDao.isSubmitStatus(pk[i])){
				notStatusPks.add(pk[i]);	
			}	
		}
		//如果包含有非"待审核"状态的记录
		if(notStatusPks.size()>0){
			StringBuffer titles = new StringBuffer();
			for (int i = 0; i < notStatusPks.size(); i++) {
				titles.append(caseDao.queryByPK(notStatusPks.get(i)).getTitle());
				titles.append(",");
			}
			titles.deleteCharAt(titles.length()-1);
			
			try{	
				PrintWriter out = CommandContext.getResponse().getWriter();
				out.print(titles);
			} catch (IOException e) {
				throw new RuntimeException("出错了！",e);
			}
		}else{	
			try{	
				PrintWriter out = CommandContext.getResponse().getWriter();
				out.print("ok");//如果使用out.println()，前台接收后，用==号比较会不相等。
			} catch (IOException e) {
				throw new RuntimeException("出错了！",e);
			}
		}
		return null;
	}
	/*
	 * 更新(根据action不同，分为 保存 和 提交(submit))
	 */
	public String update() {
	
		SmartUpload smart = new SmartUpload();
		ServletConfig config = CommandContext.getServletConfig();
		
		try {
			// 1、上传初始化
			smart.initialize(config, CommandContext.getRequest(), CommandContext.getResponse());
			// 2、准备上传
			smart.upload();
		} catch (Exception e) {
			throw new RuntimeException("出错了！",e);
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
			String root_path = CommandContext.getServletContext().getRealPath("/");
			String filepath = root_path + "WEB-INF\\file";
			String swf_path = root_path + "swf";
			String old_blob_name = caseDao.queryByPK(pk).getBlob_name();
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
			throw new RuntimeException("出错了！",e);
		}		
		}
		}
		//更新数据库信息
		Case view = new Case();	
		view.setPk(pk);
		view.setBlob_name(blob_name);
		view.setLast_update_time(Tool.getDateTime());
		view.setAnalyze(smartrequest.getParameter("analyze"));
		view.setDetail(smartrequest.getParameter("detail"));
		view.setResult(smartrequest.getParameter("result"));
		view.setSolve(smartrequest.getParameter("solve"));
		view.setSummary(smartrequest.getParameter("summary"));
		view.setTitle(smartrequest.getParameter("title"));
		view.setType(smartrequest.getParameter("type"));
		view.setVersion(smartrequest.getParameter("version"));
		
		String path = CommandContext.getRequest().getParameter("path");
		if("case_update_admin.jsp".equals(path)){
			view.setStatus(smartrequest.getParameter("status"));
		}else{
			//判断是执行【保存】还是执行【提交】，由于action是通过get方式传过来的值，所以此处用request来获取。
			String action = CommandContext.getRequest().getParameter("action");
			if("submit".equals(action)){
				view.setStatus("3");//3 表示 待审核
			}else if("save".equals(action)){
				view.setStatus("1");//1 表示 保存
			}else{
				log.error("执行更新时，传入参数有误！action="+action);
			}
		}
		
		//调用dao层，执行更新操作
		caseDao.update(view);
		
		CommandContext.getRequest().setAttribute("msg","信息更新成功！");
		CommandContext.getRequest().setAttribute("case.view", caseDao.queryByPK(pk));
		
		url="case_detail.jsp";
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
		String pk =CommandContext.getRequest().getParameter("pk");
		Case view = caseDao.queryByPK(pk);
		CommandContext.getRequest().setAttribute("case.view", view);
		return "case_detail.jsp";
	}
	/*
	 * 执行更新前的查询
	 */
	public String forupdate() {
		String pk =CommandContext.getRequest().getParameter("pk");
		String path = CommandContext.getRequest().getParameter("path");
		Case view = caseDao.queryByPK(pk);
		CommandContext.getRequest().setAttribute("case.view", view);
		if("case_dept_query_admin.jsp".equals(path)){
			return "case_update_admin.jsp";
		}else{		
			return "case_update_myself.jsp";
		}
	}

	/*
	 * 查询
	 */
	public String query() {

		//获取从哪个页面发送的请求，以便将查询结果返回至相应的页面。
		String path = CommandContext.getRequest().getParameter("path");
		
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则按照最后更新时间进行排序。
		String sort=CommandContext.getRequest().getParameter("sort");
		String sortType=CommandContext.getRequest().getParameter("sortType");
		String title=CommandContext.getRequest().getParameter("title");
		String type=CommandContext.getRequest().getParameter("type");
		String pageSize=CommandContext.getRequest().getParameter("pageSize");
		
		//如果是在“我的案例库”页面执行查询，则“上传者”始终是当前用户自己
		String upload_person = null;
		if("case_of_myself.jsp".equals(path)){
			upload_person = CommandContext.getSession().getAttribute("who").toString();
		}else{			
			upload_person = CommandContext.getRequest().getParameter("upload_person");
		}
		
		//如果是在“待审核知识”页面执行查询，则“知识状态”始终是3，即待审核
		//如果是在“部门知识库-user”页面执行查询，则知识状态始终是4,即审核通过
		String status = null;
		if("case_submit_query.jsp".equals(path)){
			status = "3";//3 表示待审核
		}else if("case_dept_query_user.jsp".equals(path)){
			status = "4";//4 表示审核通过
		}else{			
			status = CommandContext.getRequest().getParameter("status");
		}
		
		//空值处理
		if(sort==null)sort="last_update_time";	//查询结果默认按照“最后更新时间”进行倒序排列
		if(sortType==null)sortType="DESC";
		if(title==null)title="";
		if(type==null)type="";
		if(pageSize==null||"".equals(pageSize)){
			pageSize=CommandContext.getSession().getAttribute("pageSize").toString();
		}else{
			//如果用户的pageSize发生改变，则同步更新session中的pageSize和数据库中的pageSize
			if(!pageSize.equals(CommandContext.getSession().getAttribute("pageSize").toString())){
				CommandContext.getSession().setAttribute("pageSize", pageSize);
				UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());
				userDao.changePageSize(CommandContext.getSession().getAttribute("username").toString(), pageSize);
			}
		}	
		if(status==null)status="";	
		if(upload_person==null)upload_person="";	
		
		// 将查询条件组合成对象
		Case query_condition = new Case();
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
		if (CommandContext.getRequest().getParameter("showPage") != null&&!CommandContext.getRequest().getParameter("showPage").equals("")){
			CommandContext.getRequest().setAttribute("showPage",CommandContext.getRequest().getParameter("showPage"));
			showPage=Integer.parseInt(CommandContext.getRequest().getParameter("showPage").trim());
		
		//如果是点击翻页按钮
		}else if (CommandContext.getRequest().getParameter("view")!=null&&(!(CommandContext.getRequest().getParameter("view").equals("")))){

			int select=1;//1代表第一页、2代表上一页、3代表下一页、4代表最后一页，默认显示第一页
			int oldPageCount = Integer.parseInt(CommandContext.getRequest().getParameter("pageCount"));
			select = Integer.parseInt(CommandContext.getRequest().getParameter("view"));
			showPage = Integer.parseInt(CommandContext.getRequest().getParameter("currentPage"));

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
		Map<String,Object> map = caseDao.queryByCase(query_condition);
		List<Case> list = (List<Case>)map.get("list");
		CommandContext.getRequest().setAttribute("case_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString()); //获取查询出的总记录数
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);//总页数
		query_condition.setRecordCount(newRecordCount);
		query_condition.setPageCount(newPageCount);
		CommandContext.getRequest().setAttribute("query_condition", query_condition);
		return forward_after_query(path);
	}

	/*
	 * 新增
	 */
	@Trans
	public String add() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		ServletConfig config = CommandContext.getServletConfig();
		
		String url = null;
		SmartUpload smart = new SmartUpload();
		try {
			// 1、上传初始化
			smart.initialize(config, request, response);
			// 2、准备上传
			smart.upload();		
			//3、 接收信息
			Request smartrequest = smart.getRequest();
			String pk=UUIDGenerator.getRandomUUID();
			Case view = new Case();
			view.setPk(pk);
			view.setAnalyze(smartrequest.getParameter("analyze"));
			view.setDetail(smartrequest.getParameter("detail"));
			view.setUpload_person(request.getSession().getAttribute("who").toString());//上传人
			view.setUpload_time(Tool.getDateTime());//上传时间
			view.setLast_update_time(view.getUpload_time());//新增加时，上传时间与最后更新时间相同。
			view.setResult(smartrequest.getParameter("result"));
			view.setSolve(smartrequest.getParameter("solve"));
			
			//action是get方式传过来的，所以需要用request来接收，而不能使用smartrequest。
			//根据action来判断是 保存 还是 提交
			String action=request.getParameter("action");
			if("save".equals(action)){
				view.setStatus("1");//1表示保存
			}else if("submit".equals(action)){
				view.setStatus("3");//3表示待审核（提交）
			}else{
				throw new RuntimeException("出错了！无效的参数！"+action);
			}
			view.setSummary(smartrequest.getParameter("summary"));
			view.setTitle(smartrequest.getParameter("title"));
			view.setType(smartrequest.getParameter("type"));
			view.setVersion(smartrequest.getParameter("version"));
			
			//4、 对附件进行有效性检查
			Files files = smart.getFiles();
			File file = files.getFile(0);
			String ext = file.getFileExt();
			String blob_name = file.getFileName();//获取附件名称
			blob_name = blob_name.substring(0, blob_name.lastIndexOf(".")+1)
						+(blob_name.substring(blob_name.lastIndexOf(".")+1).toLowerCase());//将文件后缀改成小写
			view.setBlob_name(blob_name);
			
			//附件大小校验
			if(file.getSize()>20*1024*1024){
				log.error("附件大小超出限制"+file.getSize()/1024/1024);
				request.setAttribute("msg","最大可上传附件为20M，请重新选择！");
				url = "case_add.jsp";
				return url;
			}
			//空附件校验
			if(ext==null||"".equals(ext)||file.getSize()==0){
				log.error("附件无效，附件缺少后缀，或者无附件！");
				request.setAttribute("msg","附件缺少后缀，或者无附件，请重新选择！");
				url = "case_add.jsp";
				return url;
			}
			//将附件保存到指定目录
			try {
				file.saveAs("\\WEB-INF\\file\\" + pk + "." + (ext.toLowerCase()));
			} catch (Exception e) {
				throw new RuntimeException("出错了！",e);
			}
			//将信息保存到数据库
			try {		
				caseDao.save(view);
			} catch (Exception e) {

				//如果保存失败，则将已上传的附件同步删除。
				String filePath = request.getSession().getServletContext().getRealPath("/")+"WEB-INF\\file\\";	
				java.io.File delfile = new java.io.File(filePath + pk + "." + ext); 
				if(delfile.exists()){ 		
					delfile.delete(); 			
				}			
				throw new RuntimeException("出错了！",e);
			}
			request.setAttribute("msg","增加记录["+view.getBlob_name()+"]成功！");
			request.setAttribute("case.view", view);
			url="case_detail.jsp?path=case_add.jsp";	
		} catch (Exception e) {
			throw new RuntimeException("出错了！",e);
		}
		return url;
	}
	//执行查询后的页面跳转
	public String forward_after_query(String path){
		
		if("case_submit_query.jsp".equals(path)){
			return "case_submit_query.jsp";//返回待审核页面
		}else if("case_of_myself.jsp".equals(path)){
			return "case_of_myself.jsp";//返回我的案例库页面
		}else if("case_dept_query_user.jsp".equals(path)){		
			return "case_dept_query_user.jsp";//返回部门案例库（普通用户）页面
		}else if("case_dept_query_admin.jsp".equals(path)){
			return "case_dept_query_admin.jsp";//返回部门案例库（管理员）页面
		}else{
			log.error("接收到了无效的参数，path="+path);
			return null;
		}
	}
}
