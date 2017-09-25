package cn.sdfi.tools;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import org.apache.log4j.Logger;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.MyScheduleOfConnectionPool;
import cn.sdfi.tools.MyScheduleOfDeleteTempFile;
import cn.sdfi.tools.Tool;
import cn.sdfi.user.bean.User;

public class OnLineListener implements ServletContextListener,HttpSessionListener, HttpSessionAttributeListener {
	
	private Logger log = Logger.getLogger(OnLineListener.class);
	Timer timer = null;
	
	public void contextDestroyed(ServletContextEvent arg0) {
//		
//		log.debug("------清除容器中所有会话");
//		ServletContext application = arg0.getServletContext();
//		HashMap<String, HttpSession> sessions =(HashMap<String, HttpSession>)(application.getAttribute("sessions"));
//		if(sessions!=null){
//			
//			log.debug("容器中存在会话数="+sessions.size());
//			for (Map.Entry<String, HttpSession> entry : sessions.entrySet()) {
//				log.debug("="+entry.getKey());
//				entry.getValue().setMaxInactiveInterval(0);
//			}
//		}
//		log.debug("------清除容器中所有会话结束");
//		
//		if(timer!=null){		
//			timer.cancel();
//			log.debug("-----定时器销毁");
//		}
		log.debug("----关闭连接池");
		ConnectionPool.getInstance().closePool();
		log.debug("-----容器销毁--------");
		if(Const.is_print_system_out){
			System.out.println("销毁容器");
		}
	}

	/*
	 * 容器监听器
	 */
	public void contextInitialized(ServletContextEvent arg0) {
		
		if(Const.is_print_system_out){
			System.out.println("容器初始化");
		}

		log.debug("-----容器初始化开始---------");
		log.debug("-----加载enum.properties文件开始---------");
		Const.setEnumMap(Tool.load_enum_file("enum.properties")); 
		log.debug("-----加载enum.properties文件完成---------");

		log.debug("-----加载other.properties文件开始---------");
		List<String> canPrintDocs = Const.getCanPrintDocs();
		Properties properties = Tool.load_property_file("other.properties");
		String value = properties.getProperty("can_print_docs");
		try {
			value = new String(value.getBytes("ISO8859-1"), "GBK");
		} catch (UnsupportedEncodingException e) {
			log.error("",e);
		}
		String[] arrays = value.split(",");
		for (int i = 0; i < arrays.length; i++) {
			canPrintDocs.add(arrays[i]);
		}
		Const.is_print_system_out = properties.getProperty("is_print_systemout").equals("true")?true:false;
		log.debug("-----加载other.properties文件完成---------");

		log.debug("-----初始化数据库连接池开始---------");
		ConnectionPool.getInstance();
		log.debug("-----初始化数据库连接池完成---------");
		
		log.debug("-----启动定时器开始！-----");
		timer = new Timer(true); 
		//第三个参数表示30分钟(即30*60*1000毫秒)被触发一次，中间参数0表示无延迟
		timer.schedule(new MyScheduleOfConnectionPool(), 0, 1*60*1000); //2小时检查一次数据库连接池中可用的连接数。
		timer.schedule(new MyScheduleOfDeleteTempFile(), 0, 120*60*1000);//2小时清理一次Jfreechart的图表文件。
		log.debug("-----启动定时器完成！-----");
		
		log.debug("-----容器初始化完成---------");
	}

	public void sessionCreated(HttpSessionEvent event) { 
//		log.debug("sessionCreated");
//		HttpSession session = event.getSession();
//		Enumeration<String> enums = session.getAttributeNames();
//		while (enums.hasMoreElements()) {
//			String string =  enums.nextElement();
//			log.debug(string);
//		}	
		}

	/*
	 * 当session会话失效，或者显示调用session.invalidate()时，
	 * sessionDestroyed()方法会被执行。
	 */
	public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
		
		//将用户名称从列表中删除
		//log.debug("执行方法——sessionDestroyed(HttpSessionEvent httpSessionEvent)");
		HttpSession session=httpSessionEvent.getSession();//public HttpSession getSession(),Return the session that changed
		String username= session.getAttribute("username").toString();
		
		Map<String,User> map = Const.getOnlineUserMap() ;
		if(map.containsKey(username))
		{  
			map.remove(username);
			log.debug("用户["+username+"]下线");
		}else{
			log.error("用户下线时出错");
		}
	}

	public void attributeAdded(HttpSessionBindingEvent arg0) {
		// 如果登陆成功，则将用户名保存在列表之中
		//log.debug("session 增加属性:"+arg0.getName()+" --> "+arg0.getValue()) ;
		//List list = (List)this.application.getAttribute("alluser") ;
		//list.add(arg0.getSession().getAttribute("who"));
		//this.application.setAttribute("alluser",list) ;
	}

	public void attributeRemoved(HttpSessionBindingEvent arg0) {
		//log.debug("session属性移出["+arg0.getName()+"]["+arg0.getValue()+"]");
	}

	public void attributeReplaced(HttpSessionBindingEvent event) {
//		HttpSession session = event.getSession();
//		String key = event.getName();//发生改变的属性key	
//		Object oldValue = event.getValue();//属性原来的值
//		Object newValue = session.getAttribute(key);//属性的新值
//		log.debug("session属性改变["+key+","+oldValue+"]-->["+key+","+newValue+"]");
	}
}
