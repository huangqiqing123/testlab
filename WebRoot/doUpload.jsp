<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%
	//��������豸����Ա/�ĵ�����Ա/��������Ա������Ȩ�����ҳ�档
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
<title>Excel�ļ���Ϣ����</title>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>" >
<span id="tips"></span>
<h2 align='center'>��ʾ</h2>
<div align="right">
<input type="button" class="btbox" value="������һҳ" onClick="javascript:parent.history.back(); return;">
</div>
<hr>
<%
	int ok = 0;//����ɹ��ļ�¼��
	int not_ok = 0;//�Ѿ����ڵļ�¼��
	StringBuffer not_ok_code = new StringBuffer();//û�е�����ļ�����
	String UPLOAD_FILE_PATH = application.getRealPath("/")+"WEB-INF\\temp\\"; //�ļ��ϴ���ַ
	
	SmartUpload smart = new SmartUpload();

	// 1���ϴ���ʼ��
	smart.initialize(pageContext);
	// 2��׼���ϴ�
	smart.upload();
	//3�������ļ����͵ĺϷ���
	String path = smart.getRequest().getParameter("path");
	
	//����ǵ����ļ���Ϣ������
	if("file_cover_content_import.jsp".equals(path)){
			
	String fk = smart.getRequest().getParameter("fk");
	String file_cover_code = smart.getRequest().getParameter("file_cover_code");
	File file = smart.getFiles().getFile(0);
	String ext = file.getFileExt();
	
	if (!"xls".equals(ext) && !"XLS".equals(ext)) {
		out.println("<h3>�ļ����Ͳ���ȷ��������ѡ��Ҫ������ļ���</h3>");
		return;
	} 
	else{
		Exception exception = null;

		// 3�������ϴ����ļ�
		smart.save("\\WEB-INF\\temp");//Ĭ���ļ������棬���ϴ����ļ������ļ�����һ�£�����Ѵ���ͬ���ļ����򸲸ǡ�
		String filename = file.getFileName();
		int rows =0;
		try {
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(UPLOAD_FILE_PATH + filename));

			//��ȡ��һ����ǩҳ   
			HSSFSheet sheet = workbook.getSheetAt(0);

			//��ǩҳ���������ļ���Ϣ̨�ʡ��е�������
			rows = sheet.getPhysicalNumberOfRows();
			if (rows < 2) {
				out.println("<h3>�ļ�����Ϊ�գ�������ѡ��</h3>");
				return;
			}

			//��Ϊ�յĵ�Ԫ����  ����һ���Ǳ�����
			int cells = sheet.getRow(0).getPhysicalNumberOfCells();
			if (cells !=5) {
				out.println("<h3>�ļ����ݸ�ʽ����ȷ����ȷ���ļ���ʽ��ģ�屣��һ�£�</h3>");
				return;
			}
			
			//�Ƚ����ݷ���List�����ȫ��У��ͨ������ͳһ�����ݿ��в��룬������κ�һ����¼�������⣬�򶼲�ִ�в��������
			List<FileCoverContent> contentList = new ArrayList<FileCoverContent>();
			FileCoverContentDao dao = new FileCoverContentDao();
			FileCoverContent content = null;
			
			//ѭ����������һ���Ǳ��⣬���Դ� 1 ��ʼ������0��ʾ��һ�У�1��ʾ�ڶ��У�
			first: for (int r = 1; r < rows; r++) {
				HSSFRow row = sheet.getRow(r);
				content = new FileCoverContent();
				if (row != null) {
					String value = "";
					second: for (short c = 0; c < 5; c++) //��5�У�0�ļ���š�1�ļ����ơ�2ҳ����3�汾��4��ע��   
					{
						HSSFCell cell = row.getCell(c);

						//�����Ԫ��Ϊ��
						if (cell != null) {				
							switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_FORMULA:
								break;
							case HSSFCell.CELL_TYPE_NUMERIC:
								
								//�����ֽ��и�ʽ����ʹ�䲻�Զ�ת��Ϊ��ѧ��������
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
						//�����Ԫ��Ϊ��
						else {
							value = "";
						}
						//�ļ�����
						if (c == 0) {
							
							//�ǿռ��
							if(value==null||"".equals(value)){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��ļ����벻��Ϊ�գ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							//�Ƿ������˫�ֽ��ַ��ģ��磺���ģ����
							if(Tool.getGBKlength(value)!=value.length()){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��ļ����벻�ܰ���ȫ�Ǻ������ַ�����ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
							if(Tool.getGBKlength(value)>20){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��ļ����볬������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							//����ļ������Ƿ��������ڵ��������뿪ͷ
							if(!value.startsWith(file_cover_code+"-")){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��ļ������ʽ����ȷ���ļ���������������ڵ��������뿪ͷ���������л��������ӣ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							//�����ͬ��ŵ��ļ������ݿ����Ѵ��ڣ����ٽ��е��롣
							if (dao.isExist(value)) {
								not_ok++;
								not_ok_code.append(value);
								not_ok_code.append(",");
								
								//ÿ����ʾ10��
								if(not_ok%10==0){
									not_ok_code.append("<br>");
								}
								continue first;
							}
							content.setFile_cover_content_code(value);
						} else if (c == 1) {
							//�ǿռ��
							if(value==null||"".equals(value)){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��ļ����Ʋ���Ϊ�գ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
							if(Tool.getGBKlength(value)>80){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��ļ����Ƴ�������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							content.setFile_cover_content_name(value);
						} else if (c == 2) {

							if(value!=null&&!"".equals(value)){
							//ҳ����������С����Ĭ�Ͻ�С�����������ݲü�����
							if (value.contains(".")) {
								value = value.replace(".", "-");//split��������ֱ��ʹ��"."���зָ
								value = value.split("-")[0];
							}
							//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
							if(Tool.getGBKlength(value)>10){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У�ҳ����Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							}
							content.setPages(value);
						} else if (c == 3) {
							
							if(value!=null&&!"".equals(value)){
							//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
							if(Tool.getGBKlength(value)>10){
								out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��汾��Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
								return;
							}
							}
							content.setVersion(value);
						} else if (c == 4) {
							if(value!=null&&!"".equals(value)){
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(Tool.getGBKlength(value)>1000){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��汾��Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
							}
							content.setMemo(value);
						} else {
							out.println("--------------������------------");
						}
					}
					content.setPk(UUIDGenerator.getRandomUUID());//�����Զ�����
					content.setFk(fk);//��������������ļ�����������������
					contentList.add(content);
					
				}
			}
			//ִ�б���
			for(int i=0;i<contentList.size();i++){

				if("success".equals(dao.save(contentList.get(i)))){		
					ok++;
				}else{
					out.println("<h3>�����¼{"+contentList.get(i).toString()+"}ʱ������ϸ��Ϣ��鿴��־��</h3>");
				}
			}
		} catch (Exception e) {
			exception = e;
			out.println("�����ˣ�" + e);
		}
		if (exception == null) {

			out.print("<h3>����������ɣ���<font color='red'>" + (rows-1)
					+ "</font>����¼�����гɹ�����<font color='red'>" + ok
					+ "</font>����¼������ʱ����<font color='red'>"+(rows-1-ok-not_ok)
					+"</font>����¼������ظ���<font color='red'>" + not_ok
					+ "</font>����¼δִ�е��룡</h3>");
			if (not_ok > 0) {
				out.print("<h3>����ظ�δִ�е�����ļ�������£�</h3>");
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
	//����ǵ����豸��Ϣ������
	else if("computer_import.jsp".equals(path)){
		
		File file = smart.getFiles().getFile(0);
		String ext = file.getFileExt();
		
		if (!"xls".equals(ext) && !"XLS".equals(ext)) {
			out.println("<h3>�ļ����Ͳ���ȷ��������ѡ��Ҫ������ļ���</h3>");
			return;
		}
		else{
			Exception exception = null;

			// 3�������ϴ����ļ�
			smart.save("\\WEB-INF\\temp");//Ĭ���ļ������棬���ϴ����ļ������ļ�����һ�£�����Ѵ���ͬ���ļ����򸲸ǡ�
			String filename = file.getFileName();
			int rows = 0;
			try {
				HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(UPLOAD_FILE_PATH + filename));

				//��ȡ��һ����ǩҳ   
				HSSFSheet sheet = workbook.getSheetAt(0);

				//��ǩҳ���������ļ���Ϣ̨�ʡ��е�����������һ���Ǳ��⣬����rows����ӦΪ2�� 
				rows = sheet.getPhysicalNumberOfRows();
				if (rows < 2) {
					out.println("<h3>�ļ�����Ϊ�գ�������ѡ��</h3>");
					return;
				}

				//��������еĵ�Ԫ��������Ϊ�յĵ�Ԫ���Ƿ���ȷ��  
				int cells = sheet.getRow(0).getPhysicalNumberOfCells();
				if (cells != 12) {
					out.println("<h3>�ļ����ݸ�ʽ����ȷ����ȷ���ļ���ʽ��ģ�屣��һ�£�</h3>");
					return;
				}				
				Map<String,String> computer_status = Const.getEnumMap().get("computer_status");	
				Map<String,String> computer_type = Const.getEnumMap().get("computer_type");	
				
				//�Ƚ����ݷ���List�����ȫ��У��ͨ������ͳһ�����ݿ��в��룬������κ�һ����¼�������⣬�򶼲�ִ�в��������
				List<Computer> list = new ArrayList<Computer>();
				ComputerDao dao = new ComputerDao();
				Computer computer = null;
				
				//ѭ����������һ���Ǳ��⣬���Դ� 1 ��ʼ������0��ʾ��һ�У�1��ʾ�ڶ��У�
				first: for (int r = 1; r < rows; r++) {

					HSSFRow row = sheet.getRow(r);
					computer = new Computer();
					if (row != null) {
						String value = "";
						second: for (short c = 0; c < 12; c++) //��12��
						{
							HSSFCell cell = row.getCell(c);

							//�����Ԫ��Ϊ��
							if (cell != null) {

								switch (cell.getCellType()) {
								case HSSFCell.CELL_TYPE_FORMULA:
									break;
								case HSSFCell.CELL_TYPE_NUMERIC:
									
									//�����ֽ��и�ʽ����ʹ�䲻�Զ�ת��Ϊ��ѧ��������
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
							//�����Ԫ��Ϊ��
							else {
								value = "";
							}
							//�豸����
							if(c == 0){
								
								//�ǿռ��
								if(value==null||"".equals(value)){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���Ͳ���Ϊ�գ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								//�豸���͵���Ч�Լ��
								boolean isOK = false;
								for (Map.Entry<String, String> entry : computer_type.entrySet()) {
									if(entry.getValue().equals(value.trim())){
										value=entry.getKey();
										isOK = true;
										break;
									}
								}
								if(!isOK){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���͡�<font color='red'>"+value+"</font>�������ڣ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								computer.setComputer_type(value.trim());	
							//�豸����
							}else if (c == 1) {
								
								//�ǿռ��
								if(value==null||"".equals(value)){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���벻��Ϊ�գ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								//�Ƿ������˫�ֽ��ַ��ģ��磺���ģ����
								if(Tool.getGBKlength(value)!=value.length()){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���벻�ܰ���ȫ�Ǻ������ַ�����ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(Tool.getGBKlength(value)>15){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���볬������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								//�����ͬ��ŵ��ļ������ݿ����Ѵ��ڣ����ٽ��е��롣
								if (dao.isExist(value)) {
									not_ok++;
									not_ok_code.append(value);
									not_ok_code.append(",");
									
									//ÿ����ʾ10��
									if(not_ok%10==0){
										not_ok_code.append("<br>");
									}
									continue first;
								}
								computer.setCode(value.trim());
							} 
							//�豸����
							else if (c == 2) {
								
								//�ǿռ��
								if(value==null||"".equals(value)){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���Ʋ���Ϊ�գ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(Tool.getGBKlength(value)>30){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���Ƴ�������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								computer.setName(value.trim());
							} 
							//�豸���к�
							else if (c == 3) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>50){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸���кų�������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setSerial_number(value.trim());
							} 
							//�豸�ͺ�
							else if (c == 4) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>50){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸�ͺų�������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setType(value.trim());
							} 
							//��������
							else if (c == 5) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>100){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸�������̳�������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setManufactory(value.trim());
							} 
							//�豸����ʱ��
							else if (c == 6) {
								
								if(value!=null&&!"".equals(value)){
								
								//�Ƿ������˫�ֽ��ַ��ģ��磺���ģ����
								if(Tool.getGBKlength(value)!=value.length()){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��������ڸ�ʽ����ȷ��"+value+"������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								//�����ڵ����⴦��ȥ��������׷�ӵ�С��λ
								if (value.contains(".")) {
									value = value.replace(".", "-");//split��������ֱ��ʹ��"."���зָ
									value = value.split("-")[0];
								}
								//���ڸ�ʽ��ҪôΪ�գ�Ҫô����ָ����ʽ��4λ��2λ�£���
								if(!Tool.isDate(value,"yyyyMM")){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��������ڸ�ʽ����ȷ("+value+")���������ڸ�ʽ������4λ�꣬2λ�µĸ�ʽ���磺<font color=\"red\">201002</font></h3>");
									return;
								}
								}
								computer.setBegin_use_time(value.trim());
							} 
							//�豸������
							else if (c == 7) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>20){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У���������Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setOwner(value.trim());
							} 
							//�豸ʹ�õص�
							else if (c == 8) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>200){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У�ʹ�õص���Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setUse_site(value.trim());
							}
							//�豸״̬
							else if (c == 9) {
								
								//�ǿռ��
								if(value==null||"".equals(value)){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸״̬����Ϊ�գ�</h3>");
									return;
								}
								//��Ч�Լ��
								boolean isOK = false;
								for (Map.Entry<String, String> entry : computer_status.entrySet()) {
									if(entry.getValue().equals(value)){
										value=entry.getKey();
										isOK = true;
										break;
									}
								}
								if(!isOK){
									out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У��豸״̬��<font color='red'>"+value+"</font>�������ڣ���ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
									return;
								}
								computer.setStatus(value.trim());
							} 
							//�豸����
							else if (c == 10) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>200){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У�������Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setConfiguration(value.trim());
							} 
							//�豸��ע
							else if (c == 11) {
								
								//�������,���ܳ������ݿ�����Ӧ�ֶεĳ���
								if(value!=null&&!"".equals(value)){
									if(Tool.getGBKlength(value)>1000){
										out.println("<h3>��"+(r+1)+"�У���"+(c+1)+"�У���ע��Ϣ��������ȷ�������ļ��ĸ�ʽ�����ݵ���ȷ�ԣ�</h3>");
										return;
									}
								}
								computer.setMemo(value.trim());
							} 
							else {
								out.println("--------------������------------");
							}
						}
						computer.setPk(UUIDGenerator.getRandomUUID());//�����Զ�����
						list.add(computer);//����ȡ�ļ�¼��Ϣ���浽List�С�
					}
				}
			//ִ�б���
			for(int i=0;i<list.size();i++){		
				if("success".equals(dao.save(list.get(i)))){		
					ok++;
				}else{
					out.println("<h3>�����¼{"+list.get(i).toString()+"}ʱ������ϸ��Ϣ��鿴��־��</h3>");
				}
			}
			} catch (Exception e) {
				exception = e;
				out.println("�����ˣ�" + e);
			}
			if (exception == null) {

				out.print("<h3>����������ɣ���<font color='red'>" + (rows-1)
						+ "</font>����¼�����гɹ�����<font color='red'>" + ok
						+ "</font>����¼������ʱ����<font color='red'>"+(rows-1-ok-not_ok)
						+"</font>����¼������ظ���<font color='red'>" + not_ok
						+ "</font>����¼δִ�е��룡</h3>");
				if (not_ok > 0) {
					out.print("<h3>����ظ�δִ�е�����豸������£�</h3>");
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