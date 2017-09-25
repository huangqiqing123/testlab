<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//如果不是设备管理员/文档管理员/超级管理员，则无权进入该页面。
	boolean isSuperadmin = Tool.isSuperadmin(request);
	boolean isComputerAdmin = Tool.isComputerAdmin(request);
	boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
	
	if(!isSuperadmin&&!isComputerAdmin&&!isDocmentAdmin){
	request.getRequestDispatcher("no_privilege.jsp").forward(request, response);
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="org.lxh.smart.SmartUpload"%>
<%@page import="cn.sdfi.operate.FileCoverContentDao"%>
<%@page import="cn.sdfi.model.FileCoverContent"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="cn.sdfi.tools.UUIDGenerator"%>
<%@page import="cn.sdfi.tools.Const"%>
<%@page import="cn.sdfi.operate.ComputerDao"%>
<%@page import="cn.sdfi.model.Computer"%>
<%@page import="java.util.Map"%>
<%@page import="cn.sdfi.tools.Tool"%>
<%@page import="org.lxh.smart.File"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<html>
<head>
<title>Excel文件信息导入</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>" >
<span id="tips"></span>
<h2 align='center'>提示</h2>
<div align="right">
<input type="button" class="btbox" value="返回上一页" onClick="javascript:parent.history.back(); return;">
</div>
<hr>
<%
	int ok = 0;//导入成功的记录数
	int not_ok = 0;//已经存在的记录数
	StringBuffer not_ok_code = new StringBuffer();//没有导入的文件编码
	String UPLOAD_FILE_PATH = application.getRealPath("/")+"WEB-INF\\temp\\"; //文件上传地址
	
	SmartUpload smart = new SmartUpload();

	// 1、上传初始化
	smart.initialize(pageContext);
	// 2、准备上传
	smart.upload();
	//3、检验文件类型的合法性
	String path = smart.getRequest().getParameter("path");
	
	//如果是导入文件信息。。。
	if("file_cover_content_import.jsp".equals(path)){
			
	String fk = smart.getRequest().getParameter("fk");
	String file_cover_code = smart.getRequest().getParameter("file_cover_code");
	File file = smart.getFiles().getFile(0);
	String ext = file.getFileExt();
	
	if (!"xls".equals(ext) && !"XLS".equals(ext)) {
		out.println("<h3>文件类型不正确，请重新选择要导入的文件！</h3>");
		return;
	} 
	else{
		Exception exception = null;

		// 3、保存上传的文件
		smart.save("\\WEB-INF\\temp");//默认文件名保存，与上传的文件名和文件类型一致，如果已存在同名文件，则覆盖。
		String filename = file.getFileName();
		int rows =0;
		try {
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(UPLOAD_FILE_PATH + filename));

			//获取第一个标签页   
			HSSFSheet sheet = workbook.getSheetAt(0);

			//标签页“档案袋文件信息台帐”中的总行数
			rows = sheet.getPhysicalNumberOfRows();
			if (rows < 2) {
				out.println("<h3>文件内容为空，请重新选择！</h3>");
				return;
			}

			//不为空的单元格数  ，第一行是标题列
			int cells = sheet.getRow(0).getPhysicalNumberOfCells();
			if (cells !=5) {
				out.println("<h3>文件内容格式不正确，请确保文件格式与模板保持一致！</h3>");
				return;
			}
			
			//先将数据放入List，如果全部校验通过，再统一往数据库中插入，如果有任何一条记录存在问题，则都不执行插入操作。
			List<FileCoverContent> contentList = new ArrayList<FileCoverContent>();
			FileCoverContentDao dao = new FileCoverContentDao();
			FileCoverContent content = null;
			
			//循环遍历，第一行是标题，所以从 1 开始遍历（0表示第一行，1表示第二行）
			first: for (int r = 1; r < rows; r++) {
				HSSFRow row = sheet.getRow(r);
				content = new FileCoverContent();
				if (row != null) {
					String value = "";
					second: for (short c = 0; c < 5; c++) //共5列（0文件编号、1文件名称、2页数、3版本、4备注）   
					{
						HSSFCell cell = row.getCell(c);

						//如果单元格不为空
						if (cell != null) {				
							switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_FORMULA:
								break;
							case HSSFCell.CELL_TYPE_NUMERIC:
								
								//对数字进行格式化，使其不自动转化为科学计数法。
								java.text.NumberFormat nf = java.text.NumberFormat.getInstance(); 
								nf.setGroupingUsed(false); 
								value = nf.format( new Double(cell.getNumericCellValue()));
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = cell.getStringCellValue();
								break;
							case HSSFCell.CELL_TYPE_BLANK:
								value = "";
								break;
							default:
								value = "";
							}
						}
						//如果单元格为空
						else {
							value = "";
						}
						//文件编码
						if (c == 0) {
							
							//非空检查
							if(value==null||"".equals(value)){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，文件编码不能为空，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							//是否包含有双字节字符的（如：中文）检查
							if(Tool.getGBKlength(value)!=value.length()){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，文件编码不能包含全角和中文字符，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							//超长检查,不能超过数据库中相应字段的长度
							if(Tool.getGBKlength(value)>20){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，文件编码超长，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							//检查文件编码是否以其所在档案袋编码开头
							if(!value.startsWith(file_cover_code+"-")){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，文件编码格式不正确，文件编码必须以其所在档案袋编码开头，并且以中划线相连接，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							//如果相同编号的文件在数据库中已存在，则不再进行导入。
							if (dao.isExist(value)) {
								not_ok++;
								not_ok_code.append(value);
								not_ok_code.append(",");
								
								//每行显示10个
								if(not_ok%10==0){
									not_ok_code.append("<br>");
								}
								continue first;
							}
							content.setFile_cover_content_code(value);
						} else if (c == 1) {
							//非空检查
							if(value==null||"".equals(value)){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，文件名称不能为空，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							//超长检查,不能超过数据库中相应字段的长度
							if(Tool.getGBKlength(value)>80){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，文件名称超长，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							content.setFile_cover_content_name(value);
						} else if (c == 2) {

							if(value!=null&&!"".equals(value)){
							//页数不可能是小数，默认将小数点后面的数据裁剪掉。
							if (value.contains(".")) {
								value = value.replace(".", "-");//split方法不能直接使用"."进行分割。
								value = value.split("-")[0];
							}
							//超长检查,不能超过数据库中相应字段的长度
							if(Tool.getGBKlength(value)>10){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，页数信息超长，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							}
							content.setPages(value);
						} else if (c == 3) {
							
							if(value!=null&&!"".equals(value)){
							//超长检查,不能超过数据库中相应字段的长度
							if(Tool.getGBKlength(value)>10){
								out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，版本信息超长，请确保导入文件的格式及内容的正确性！</h3>");
								return;
							}
							}
							content.setVersion(value);
						} else if (c == 4) {
							if(value!=null&&!"".equals(value)){
								//超长检查,不能超过数据库中相应字段的长度
								if(Tool.getGBKlength(value)>1000){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，版本信息超长，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
							}
							content.setMemo(value);
						} else {
							out.println("--------------出错了------------");
						}
					}
					content.setPk(UUIDGenerator.getRandomUUID());//主键自动生成
					content.setFk(fk);//设置外键，即该文件所属档案袋的主键
					contentList.add(content);
					
				}
			}
			//执行保存
			for(int i=0;i<contentList.size();i++){

				if("success".equals(dao.save(contentList.get(i)))){		
					ok++;
				}else{
					out.println("<h3>保存记录{"+contentList.get(i).toString()+"}时出错！详细信息请查看日志！</h3>");
				}
			}
		} catch (Exception e) {
			exception = e;
			out.println("出错了！" + e);
		}
		if (exception == null) {

			out.print("<h3>导入数据完成，共<font color='red'>" + (rows-1)
					+ "</font>条记录，其中成功导入<font color='red'>" + ok
					+ "</font>条记录，导入时出错<font color='red'>"+(rows-1-ok-not_ok)
					+"</font>条记录，编号重复的<font color='red'>" + not_ok
					+ "</font>条记录未执行导入！</h3>");
			if (not_ok > 0) {
				out.print("<h3>编号重复未执行导入的文件编号如下：</h3>");
				out.print(not_ok_code.deleteCharAt(not_ok_code.length() - 1));
			}
		}
		java.io.File javafile = new java.io.File(UPLOAD_FILE_PATH + filename); 
		if(javafile.exists()){ 
			if(javafile.isFile()){
				javafile.delete();
				} 	
			}				
		} 
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////
	//如果是导入设备信息。。。
	else if("computer_import.jsp".equals(path)){
		
		File file = smart.getFiles().getFile(0);
		String ext = file.getFileExt();
		
		if (!"xls".equals(ext) && !"XLS".equals(ext)) {
			out.println("<h3>文件类型不正确，请重新选择要导入的文件！</h3>");
			return;
		}
		else{
			Exception exception = null;

			// 3、保存上传的文件
			smart.save("\\WEB-INF\\temp");//默认文件名保存，与上传的文件名和文件类型一致，如果已存在同名文件，则覆盖。
			String filename = file.getFileName();
			int rows = 0;
			try {
				HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(UPLOAD_FILE_PATH + filename));

				//获取第一个标签页   
				HSSFSheet sheet = workbook.getSheetAt(0);

				//标签页“档案袋文件信息台帐”中的总行数，第一行是标题，所以rows至少应为2。 
				rows = sheet.getPhysicalNumberOfRows();
				if (rows < 2) {
					out.println("<h3>文件内容为空，请重新选择！</h3>");
					return;
				}

				//检验标题列的单元格数（不为空的单元格）是否正确。  
				int cells = sheet.getRow(0).getPhysicalNumberOfCells();
				if (cells != 12) {
					out.println("<h3>文件内容格式不正确，请确保文件格式与模板保持一致！</h3>");
					return;
				}				
				Map<String,String> computer_status = Const.getEnumMap().get("computer_status");	
				Map<String,String> computer_type = Const.getEnumMap().get("computer_type");	
				
				//先将数据放入List，如果全部校验通过，再统一往数据库中插入，如果有任何一条记录存在问题，则都不执行插入操作。
				List<Computer> list = new ArrayList<Computer>();
				ComputerDao dao = new ComputerDao();
				Computer computer = null;
				
				//循环遍历，第一行是标题，所以从 1 开始遍历（0表示第一行，1表示第二行）
				first: for (int r = 1; r < rows; r++) {

					HSSFRow row = sheet.getRow(r);
					computer = new Computer();
					if (row != null) {
						String value = "";
						second: for (short c = 0; c < 12; c++) //共12列
						{
							HSSFCell cell = row.getCell(c);

							//如果单元格不为空
							if (cell != null) {

								switch (cell.getCellType()) {
								case HSSFCell.CELL_TYPE_FORMULA:
									break;
								case HSSFCell.CELL_TYPE_NUMERIC:
									
									//对数字进行格式化，使其不自动转化为科学计数法。
									java.text.NumberFormat nf = java.text.NumberFormat.getInstance(); 
									nf.setGroupingUsed(false); 
									value = nf.format( new Double(cell.getNumericCellValue()));
									break;
								case HSSFCell.CELL_TYPE_STRING:
									value = cell.getStringCellValue();
									break;
								case HSSFCell.CELL_TYPE_BLANK:
									value = "";
									break;
								default:
									value = "";
								}
							}
							//如果单元格为空
							else {
								value = "";
							}
							//设备类型
							if(c == 0){
								
								//非空检查
								if(value==null||"".equals(value)){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备类型不能为空，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								//设备类型的有效性检查
								boolean isOK = false;
								for (Map.Entry<String, String> entry : computer_type.entrySet()) {
									if(entry.getValue().equals(value.trim())){
										value=entry.getKey();
										isOK = true;
										break;
									}
								}
								if(!isOK){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备类型“<font color='red'>"+value+"</font>”不存在，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								computer.setComputer_type(value.trim());	
							//设备编码
							}else if (c == 1) {
								
								//非空检查
								if(value==null||"".equals(value)){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备编码不能为空，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								//是否包含有双字节字符的（如：中文）检查
								if(Tool.getGBKlength(value)!=value.length()){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备编码不能包含全角和中文字符，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								//超长检查,不能超过数据库中相应字段的长度
								if(Tool.getGBKlength(value)>15){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备编码超长，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								//如果相同编号的文件在数据库中已存在，则不再进行导入。
								if (dao.isExist(value)) {
									not_ok++;
									not_ok_code.append(value);
									not_ok_code.append(",");
									
									//每行显示10个
									if(not_ok%10==0){
										not_ok_code.append("<br>");
									}
									continue first;
								}
								computer.setCode(value.trim());
							} 
							//设备名称
							else if (c == 2) {
								
								//非空检查
								if(value==null||"".equals(value)){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备名称不能为空，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								//超长检查,不能超过数据库中相应字段的长度
								if(Tool.getGBKlength(value)>30){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备名称超长，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								computer.setName(value.trim());
							} 
							//设备序列号
							else if (c == 3) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>50){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备序列号超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setSerial_number(value.trim());
							} 
							//设备型号
							else if (c == 4) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>50){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备型号超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setType(value.trim());
							} 
							//生产厂商
							else if (c == 5) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>100){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备生产厂商超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setManufactory(value.trim());
							} 
							//设备领用时间
							else if (c == 6) {
								
								if(value!=null&&!"".equals(value)){
								
								//是否包含有双字节字符的（如：中文）检查
								if(Tool.getGBKlength(value)!=value.length()){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，领用日期格式不正确（"+value+"），请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								//对日期的特殊处理，去除可能误追加的小数位
								if (value.contains(".")) {
									value = value.replace(".", "-");//split方法不能直接使用"."进行分割。
									value = value.split("-")[0];
								}
								//日期格式：要么为空，要么符合指定格式（4位年2位月）。
								if(!Tool.isDate(value,"yyyyMM")){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，领用日期格式不正确("+value+")，领用日期格式必须是4位年，2位月的格式，如：<font color=\"red\">201002</font></h3>");
									return;
								}
								}
								computer.setBegin_use_time(value.trim());
							} 
							//设备领用人
							else if (c == 7) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>20){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，领用人信息超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setOwner(value.trim());
							} 
							//设备使用地点
							else if (c == 8) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>200){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，使用地点信息超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setUse_site(value.trim());
							}
							//设备状态
							else if (c == 9) {
								
								//非空检查
								if(value==null||"".equals(value)){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备状态不能为空！</h3>");
									return;
								}
								//有效性检查
								boolean isOK = false;
								for (Map.Entry<String, String> entry : computer_status.entrySet()) {
									if(entry.getValue().equals(value)){
										value=entry.getKey();
										isOK = true;
										break;
									}
								}
								if(!isOK){
									out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，设备状态“<font color='red'>"+value+"</font>”不存在，请确保导入文件的格式及内容的正确性！</h3>");
									return;
								}
								computer.setStatus(value.trim());
							} 
							//设备配置
							else if (c == 10) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>200){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，配置信息超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setConfiguration(value.trim());
							} 
							//设备备注
							else if (c == 11) {
								
								//超长检查,不能超过数据库中相应字段的长度
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>1000){
										out.println("<h3>第"+(r+1)+"行，第"+(c+1)+"列，备注信息超长，请确保导入文件的格式及内容的正确性！</h3>");
										return;
									}
								}
								computer.setMemo(value.trim());
							} 
							else {
								out.println("--------------出错了------------");
							}
						}
						computer.setPk(UUIDGenerator.getRandomUUID());//主键自动生成
						list.add(computer);//将读取的记录信息保存到List中。
					}
				}
			//执行保存
			for(int i=0;i<list.size();i++){		
				if("success".equals(dao.save(list.get(i)))){		
					ok++;
				}else{
					out.println("<h3>保存记录{"+list.get(i).toString()+"}时出错！详细信息请查看日志！</h3>");
				}
			}
			} catch (Exception e) {
				exception = e;
				out.println("出错了！" + e);
			}
			if (exception == null) {

				out.print("<h3>导入数据完成，共<font color='red'>" + (rows-1)
						+ "</font>条记录，其中成功导入<font color='red'>" + ok
						+ "</font>条记录，导入时出错<font color='red'>"+(rows-1-ok-not_ok)
						+"</font>条记录，编号重复的<font color='red'>" + not_ok
						+ "</font>条记录未执行导入！</h3>");
				if (not_ok > 0) {
					out.print("<h3>编号重复未执行导入的设备编号如下：</h3>");
					out.print(not_ok_code.deleteCharAt(not_ok_code.length() - 1));
				}
			}
			java.io.File javafile = new java.io.File(UPLOAD_FILE_PATH + filename); 
			if(javafile.exists()){ 
				if(javafile.isFile()){
					javafile.delete();
					} 	
				}
		}	
	}
%>
</body>
</html>
<jsp:include page="includes/alert.jsp" flush="true" />