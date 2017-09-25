package cn.sdfi.framework.dispatch;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.Tool;

/*
 * 该类是控制器，负责拦截所有以 .do 结尾的请求，并加载配置文件 object.properties
 * 根据解析的 路径 找到相应的 具体执行业务的类，执行完毕进行请求转发
 */
public class Dispatch extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(Dispatch.class);
	
	//设置成static Map，在程序运行期间只加载一次property文件。
	private static Properties properties = null;
	
	@Override
	public void init() throws ServletException {
		super.init();
		log.debug("---------------初始化分发器-------");
		System.out.println("---------------初始化分发器---testlab----");
	}
	@Override
	public void destroy() {
		super.destroy();
		log.debug("---------------销毁分发器-----------");
		System.out.println("---------------销毁分发器---testlab----");
	}

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		//设置编码
		request.setCharacterEncoding(Const.CHARACTOR_ENCODING);
		response.setCharacterEncoding(Const.CHARACTOR_ENCODING);
		response.setContentType(Const.CONTENT_TYPE);

		//解析请求的url
		StringBuffer url = request.getRequestURL();
		if(Const.is_print_system_out){		
			System.out.println(Thread.currentThread().getName()+",截获URL："+url);
		}

		//http://localhost:8080/test4/UserCommand.do
		int a = url.lastIndexOf("/");
		int b = url.lastIndexOf(".do");

		//获取请求的cmd的类名简称
		String cmdName = url.substring(a + 1, b);//substring(begin(含),end(不含))，即[)
		
		//获取请求的方法名
		String methodName = request.getParameter("method");
		
		//未登录、未授权时，强制转向的页面。
		String no_login="no_login.jsp";
		String no_privilege="no_privilege.jsp";
		
		
		//后台权限校验-文档相关（档案袋、文件、体系文件）-
		if("filecoverdo".equals(cmdName)||"filecovercontentdo".equals(cmdName)||"systemfiledo".equals(cmdName)){
			
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//如果既不是文档管理员，也不是超级管理员的话，是不能进行文档相关增加、修改、删除操作的。
			if("update".equals(methodName)||"delete".equals(methodName)||"add".equals(methodName)||"hasContent".equals(methodName)||"isExist".equals(methodName)){
				boolean isSuperadmin = Tool.isSuperadmin(request);
				boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
				if(!isSuperadmin&&!isDocmentAdmin){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		}
		//后台权限校验-设备相关
		else if("computerdo".equals(cmdName)){
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			
			//如果既不是设备管理员，也不是超级管理员的话，是不能进行文档相关增加、修改、删除操作的。
			if("update".equals(methodName)||"delete".equals(methodName)||"add".equals(methodName)||"isExist".equals(methodName)){	
				boolean isSuperadmin = Tool.isSuperadmin(request);
				boolean isComputerAdmin = Tool.isComputerAdmin(request);
				if(!isSuperadmin&&!isComputerAdmin){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		}
		//后台权限校验-用户相关
		else if("userdo".equals(cmdName)){
	
			//只有已登录用户才能进行换肤、修改密码操作
			if("changeskin".equals(methodName)||"changePassword".equals(methodName)||"isCorrect".equals(methodName)){
				
				boolean isNotLogin = Tool.isNotLogin(request);
				if(isNotLogin){
					try {
						request.getRequestDispatcher(no_login).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
				//只有超级管理员才能强制断开某个会话、检验用户是否存在、新增用户、修改用户、删除用户、查看用户明细
			}else if("outSession".equals(methodName)||"isExist".equals(methodName)||"add".equals(methodName)||"forupdate".equals(methodName)||"update".equals(methodName)||"delete".equals(methodName)||"detail".equals(methodName)){
				
				//先判断是否登录
				boolean isNotLogin = Tool.isNotLogin(request);
				if(isNotLogin){
					try {
						request.getRequestDispatcher(no_login).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
				//然后判断是否是管理员
				boolean isSuperadmin = Tool.isSuperadmin(request);
					if(!isSuperadmin){
						try {
							request.getRequestDispatcher(no_privilege).forward(request, response);
							return;
						} catch (Exception e) {
							log.error("",e);
						}
					}
				}
		}
		//后台权限校验-项目相关-
		else if("projectdo".equals(cmdName)){
			
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//如果不是文档管理员、测试负责人、超级管理员，则不能进行项目信息相关增加、修改、删除操作的。
			if("update".equals(methodName)||"delete".equals(methodName)||"add".equals(methodName)||"isExist".equals(methodName)){
				boolean isSuperadmin = Tool.isSuperadmin(request);
				boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
				boolean isFunctionManager = Tool.isFunctionManager(request);
				if(!isSuperadmin&&!isDocmentAdmin&&!isFunctionManager){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		}
		//后台权限校验-案例库-
		else if("casedo".equals(cmdName)){
			
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//如果不是文档管理员、超级管理员，则不能对案例进行“批准”/“驳回”/“自动转换”操作。
			if("approve".equals(methodName)||"reject".equals(methodName)||"autoConvert".equals(methodName)){	
				boolean isSuperadmin = Tool.isSuperadmin(request);
				boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
				if(!isSuperadmin&&!isDocmentAdmin){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		}//后台权限校验-知识库-
		else if("knowdo".equals(cmdName)){
			
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//如果不是文档管理员、超级管理员，则不能对文件进行“批准”/“驳回”/“自动转换”操作。
			 if("approve".equals(methodName)||"reject".equals(methodName)||"autoConvert".equals(methodName)){		
				boolean isSuperadmin = Tool.isSuperadmin(request);
				boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
				if(!isSuperadmin&&!isDocmentAdmin){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		}else if("defectdo".equals(cmdName)){		
			
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//如果不是文档管理员、测试负责人、超级管理员，则不能进行缺陷数据信息相关增加、修改、删除操作的。
			if("forupdate".equals(methodName)||"update".equals(methodName)||"delete".equals(methodName)||"add".equals(methodName)||"isExist".equals(methodName)){				
				boolean isSuperadmin = Tool.isSuperadmin(request);
				boolean isDocmentAdmin = Tool.isDocmentAdmin(request);
				boolean isFunctionManager = Tool.isFunctionManager(request);
				if(!isSuperadmin&&!isDocmentAdmin&&!isFunctionManager){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		
		}//产品维护——权限校验
		else if("productdo".equals(cmdName)){
			
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
		
			//只有超级管理员才能对产品(Product)信息进行修改、删除操作。
			if("update".equals(methodName)||"forupdate".equals(methodName)||"delete".equals(methodName)||"add".equals(methodName)||"isInUse".equals(methodName)){	
				boolean isSuperadmin = Tool.isSuperadmin(request);
				if(!isSuperadmin){
					try {
						request.getRequestDispatcher(no_privilege).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
			}
		}else if("auditdo".equals(cmdName)){//审计管理--权限校验
			//先判断是否登录
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}		
			//只有超级管理员才能查看、删除审计信息
			boolean isSuperadmin = Tool.isSuperadmin(request);
			if(!isSuperadmin){
				try {
					request.getRequestDispatcher(no_privilege).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
		}

		Object forwardPath = null;
		try {
			
			//根据请求的cmd的简称，获取到包全路径。
			String fullCmdName = getFullName(cmdName);
			
			//获取请求的cmd的实例
			Object cmdObj = ObjectFactory.getObject(fullCmdName);
			
			//设置Command上下文信息，放于线程变量中。
			CommandContext.init(request, response, getServletContext(), getServletConfig());
			
			//通过反射，执行请求的方法，cmd层的方法
			Method realMehood = cmdObj.getClass().getMethod(methodName);
			forwardPath = realMehood.invoke(cmdObj);
			
		} catch (Exception e) {
			
			log.error("出错了！", e);
			
			//cmd层同时也是业务逻辑层，cmd层的方法具有事务性，dao、cmd中的异常信息通过throw new RunTimeException向上抛出，在此统一抛向错误页面。
			forwardPath = "error.jsp";
			StringWriter sw = new StringWriter();
		    PrintWriter pw = new PrintWriter(sw, true);
		    e.printStackTrace(pw);
		    pw.flush();
		    sw.flush();
		    String htmlStr = sw.toString().replace("\n", "<br>");
			request.setAttribute("error", htmlStr);
		}

		//执行完毕，进行页面跳转
		if(forwardPath != null){			
			request.getRequestDispatcher(forwardPath+"").forward(request, response);
		}	
	}
	
	/*
	 *  接收 一个键值 ,返回该键值对应的类的包全路径：userdo=cn.sdfi.service.UserDo
	 */
	private String getFullName(String name) {
		if(null == properties){
			properties = Tool.load_property_file("object.properties");
			log.debug("--------加载object.properties-------");
		}
		return properties.get(name)+"";	
	}
}
