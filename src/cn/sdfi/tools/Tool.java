package cn.sdfi.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Date; 
import java.util.TimeZone;
import java.util.TreeMap;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;

public class Tool { 
	
	private static Logger log = Logger.getLogger(Tool.class);

	//获取指定路径下的所有文件、文件夹的名称
	public static String[] getFileNames(String path){
		  File file = new File(path);
		  return file.list();
	  }
	
	//在GBK编码下，获取指定字符串的长度
	public static int getGBKlength(String str){
		int length = 0;
		try {
			length = str.getBytes("GBK").length;
		} catch (UnsupportedEncodingException e) {
			log.error("",e);
		}
		return length;
	}
	/*
	 * 查询指定数据库表中所有记录数。
	 */
		public static int getCount(String tableName) {
			PreparedStatement ps = null;
			ResultSet rs = null;
			ConnectionPool pool=ConnectionPool.getInstance();
			String sql = "select count(*) from "+tableName;
			int count = 0;
			Connection conn=pool.getConnection();
			try {
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				if(rs.next()){	
					count = rs.getInt(1);
				}
			} catch (Exception e) {
				log.error("",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return count;
		}
	/*
	 * 对接受的字符串中的中文进行utf-8编码，解决文件下载时的中文乱码问题。
	 */
	public static String toUtf8String(String s) {
		StringBuffer sb = new StringBuffer();
		for (int i=0;i<s.length();i++) {
			char c = s.charAt(i);
			if (c >= 0 && c <= 255) {
				sb.append(c);
			} else {
				byte[] b;
				try {
					b = Character.toString(c).getBytes("utf-8");
				} catch (Exception ex) {
					log.error(ex);
					b = new byte[0];

				}
				for (int j = 0; j < b.length; j++) {
					int k = b[j];
					if (k < 0) k += 256;
					sb.append("%" + Integer.toHexString(k).toUpperCase());
				}
			}
		}
		return sb.toString();
	}
	/*
	 * 检验指定的字符串是否符合指定的日期格式
	 */
	public static boolean isDate(String sourceDate,String format){     
		if(sourceDate==null){     
		return false;     
		}     
		try {     
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);     
		dateFormat.setLenient(false);     
		dateFormat.parse(sourceDate);     
		return true;     
		} catch (Exception e) {     
		}     
		return false;     
		}  
	/*
	 * 获取日期时间（不带秒）
	 * 2008-04-29  08:56
	 */
	public static String getDateTime()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT+8"));//如果不指定时区，在有些机器上会出现时间误差。  
		return sdf.format(new Date());
	}
	/*
	 * 获取日期时间（带秒）
	 * 2008-04-29  08:56:51
	 */
	public static String getDateTimeWithSeconds()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT+8"));//如果不指定时区，在有些机器上会出现时间误差。  
		return sdf.format(new Date());
	}
	/*
	 * http://localhost:8080/testlab 
	 */
	public static String getWebPath(HttpServletRequest request){
		StringBuffer sb = new StringBuffer();
        sb.append(request.getScheme());
        sb.append("://");
        sb.append(request.getServerName());
        sb.append(":");
        sb.append(request.getServerPort());
        sb.append(request.getContextPath());
        return sb.toString();
	}
	/*
	 *  解析properties文件, 返回一个键值对应的 Properties
	 */
	public static Properties load_property_file(String property_file_path) {
		
		Properties prop = new Properties();
		try {
			prop.load(Thread.currentThread().getContextClassLoader()
					.getResourceAsStream(property_file_path));
		} catch (IOException e) {
			log.error("",e);
		}
		return prop;
	}
	/*
	 * 加载枚举文件
	 * 枚举文件格式：file_cover_type=1:测试项目,2:文档管理
	 */
	public static Map<String,Map<String,String>> load_enum_file(String enum_file_path) {
		
		Properties properties = Tool.load_property_file(enum_file_path);
		Map<String,Map<String,String>> enumsMap =new HashMap<String, Map<String,String>>(properties.size());
		String key = null;
		String value=null;
		for (Entry<Object, Object> entry : properties.entrySet()) {

			key = entry.getKey().toString();
			try {
				value = new String(entry.getValue().toString().getBytes("ISO8859-1"), "GBK");
			} catch (UnsupportedEncodingException e) {
				log.error("",e);
			}

			String[] arrays = value.split(",");
			String[] temp = null;
			Map<String, String> map = new TreeMap<String, String>();//此处需使用TreeMap，用HashMap取出来的数据是混乱的。
			for (int i = 0; i < arrays.length; i++) {
				temp = arrays[i].split(":");
				map.put(temp[0], temp[1]);
			}
			enumsMap.put(key, map);
		} 
		return enumsMap;
	}
	/*
	 * 是否超级管理员
	 * 0:超级管理员,1:文档管理员,2:普通用户,3:设备管理员
	 */
	public static  boolean isSuperadmin(HttpServletRequest request){
		
		Object mylevel=request.getSession().getAttribute("mylevel");
		if("0".equals(mylevel)){
			return true;
		}else{
			return false;
		}
	}
	/*
	 * 是否设备管理员
	 */
	public static  boolean isComputerAdmin(HttpServletRequest request){
		
		Object mylevel=request.getSession().getAttribute("mylevel");
		if("3".equals(mylevel)){
			return true;
		}else{
			return false;
		}
	}
	/*
	 * 是否文档管理员
	 */
	public static  boolean isDocmentAdmin(HttpServletRequest request){
		
		Object mylevel=request.getSession().getAttribute("mylevel");
		if("1".equals(mylevel)){
			return true;
		}else{
			return false;
		}
	}
	/*
	 * 是否普通用户
	 */
	public static boolean isCommonUser(HttpServletRequest request){
		
		Object mylevel=request.getSession().getAttribute("mylevel");
		if("2".equals(mylevel)){
			return true;
		}else{
			return false;
		}
	}
	/*
	 * 是否未登录
	 */
	public static boolean isNotLogin(HttpServletRequest request){
		
		Object mylevel=request.getSession().getAttribute("mylevel");
		if(mylevel==null){
			return true;
		}else{
			return false;
		}
	}
	/*
	 * 是否测试负责人
	 */
	public static boolean isFunctionManager(HttpServletRequest request){
		
		Object mylevel=request.getSession().getAttribute("mylevel");
		if("4".equals(mylevel)){
			return true;
		}else{
			return false;
		}
	}
	/*
	 * 关闭连接
	 */
	public static synchronized void closeConnection(ResultSet rs,PreparedStatement ps,Connection conn){
		if(rs!=null){
			try {
				rs.close();
			} catch (SQLException e) {
				log.error("",e);
			}
		}
		if(ps!=null){
			try {
				ps.close();
			} catch (SQLException e) {
				log.error("",e);
			}
		}
		if(conn!=null){
			try {
				//非事务中执行的方法，默认都是自动提交的，此时需要在此释放连接。
				//事务中的方法，默认不是自动提交的，由事务管理器统一负责释放连接。
				if(conn.getAutoCommit()){		
					ConnectionPool.getInstance().release(conn);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	/*
	 * 获取当前年份
	 */
	public static String getCurrentYear(){
		
		Calendar now = Calendar.getInstance();
        return now.get(Calendar.YEAR)+"";
	}
	/*
	 * 获取当前月份
	 */
	public static String getCurrentMonth(){
	
		Calendar now = Calendar.getInstance();
		return now.get(Calendar.MONTH) + 1+"";
	}
	/*
	 * 获取当前日
	 */
	public static String getCurrentDayOfMonth(){		
		Calendar now = Calendar.getInstance();
		return  now.get(Calendar.DAY_OF_MONTH)+"";
	}
	/*
	 * 返回指定size位小数的、四舍五入后的数。
	 */
	public static float format(int size,double number){
		StringBuffer formatString = new StringBuffer("0");
		  if(size>0){
		   formatString.append(".");
		  }
		  for (int i = 0; i < size; i++) {
		   formatString.append("#");
		  }
		  DecimalFormat df = new DecimalFormat(formatString.toString());
		 return Float.parseFloat(df.format(number));
		}
	/*
	 * 返回百分比形式，四舍五入保留指定位数的小树。
	 */
	public static String percentFormat(int size,double number){
		NumberFormat nf = NumberFormat.getPercentInstance();   
		nf.setMinimumFractionDigits(size);// 小数点后保留几位   
		String str = nf.format(number);// 要转化的数  
		return str;
		}
	/*
	 * 获取系统环境变量
	 * 返回 Map
	 */
	public static Map<String,String> getSystemEnv() {
		Map<String,String> map  =  new HashMap<String,String>();
		String OS  =  System.getProperty( "os.name" ).toLowerCase();
		Process p  =   null ;
		
		//如果是windows操作系統
		if (OS.indexOf( "windows" )  >   - 1 ) {
			try  {
				p  =  Runtime.getRuntime().exec( "cmd /c set" );
				BufferedReader br  =   new  BufferedReader( new  InputStreamReader(p.getInputStream()));
				String line;
				while ((line  =  br.readLine())  !=   null ) {
					String[] str  =  line.split("=");
					map.put(str[0], str[1]);System.out.println(str[0]+"="+str[1]);
				}
			}  catch (IOException e) {
				log.error("",e);
			}
		}
		return  map;
	}
	/*
	 * 获取指定的系统环境变量
	 */
	public static String getSystemEnv(String name) {
		
		return  getSystemEnv().get(name);
	}
	/*
	 * 文档转换为flash
	 * 配置环境变量，如：     path   D:\program\FlashPaper2.2
	 */
	public static synchronized Process toSWF(String source,String destination){
		Process proc = null;		
		try {    
				proc=Runtime.getRuntime().exec("FlashPrinter.exe "+source+" -o "+destination);   
				log.debug("转换"+"FlashPrinter.exe "+source+" -o "+destination);
			} catch (IOException e) {   
				log.error("",e);
			} 	
		return proc;
	}
	/*
	 * 查找指定的进程是否存在
	 * 如flashpaper的进程是 FlashPrinter.exe
	 */
	 public static boolean findProcess(String processName){   
		 BufferedReader br=null;   
		 try{   
			 Process proc=Runtime.getRuntime().exec("tasklist");   
			 br=new BufferedReader(new InputStreamReader(proc.getInputStream()));   
			 String line=null;   
			 while((line=br.readLine())!=null){		  
				 if(line.contains(processName)){   //判断指定的进程是否在运行  
					 return true;   
				 }   
			 }   
			 return false;   
		 }catch(Exception e){   
			 log.error("",e);  
			 return false;   
		 }finally{   
			 if(br!=null){   
				 try{   
					 br.close();   
				 }catch(Exception ex){   
					 log.error(ex);
				 }   
			 }   
		 }   
	 }   
	/*
	 * 测试用 main 方法
	 */
	public static void main(String[] args) {
		//toSWF("C:\\aa.rar","C:\\aa.DOC.swf");
		//System.out.println(findProcess("eclips.exe"));
		//getSystemEnv();
		try {    
			File file = new File("D:\\server\\tomcat\\Tomcat60\\webapps\\12.txt");
			System.out.println(file.exists());
			
			Process proc = Runtime.getRuntime().exec("FlashPrinter.exe D:\\server\\tomcat\\Tomcat60\\webapps\\12.txt -o D:\\Desktop\\11.swf"); 
			System.out.println(proc);
		} catch (IOException e) {   
			e.printStackTrace();
		} 	
	}
}