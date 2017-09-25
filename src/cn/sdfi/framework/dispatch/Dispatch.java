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
 * �����ǿ��������������������� .do ��β�����󣬲����������ļ� object.properties
 * ���ݽ����� ·�� �ҵ���Ӧ�� ����ִ��ҵ����ִ࣬����Ͻ�������ת��
 */
public class Dispatch extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(Dispatch.class);
	
	//���ó�static Map���ڳ��������ڼ�ֻ����һ��property�ļ���
	private static Properties properties = null;
	
	@Override
	public void init() throws ServletException {
		super.init();
		log.debug("---------------��ʼ���ַ���-------");
		System.out.println("---------------��ʼ���ַ���---testlab----");
	}
	@Override
	public void destroy() {
		super.destroy();
		log.debug("---------------���ٷַ���-----------");
		System.out.println("---------------���ٷַ���---testlab----");
	}

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		//���ñ���
		request.setCharacterEncoding(Const.CHARACTOR_ENCODING);
		response.setCharacterEncoding(Const.CHARACTOR_ENCODING);
		response.setContentType(Const.CONTENT_TYPE);

		//���������url
		StringBuffer url = request.getRequestURL();
		if(Const.is_print_system_out){		
			System.out.println(Thread.currentThread().getName()+",�ػ�URL��"+url);
		}

		//http://localhost:8080/test4/UserCommand.do
		int a = url.lastIndexOf("/");
		int b = url.lastIndexOf(".do");

		//��ȡ�����cmd���������
		String cmdName = url.substring(a + 1, b);//substring(begin(��),end(����))����[)
		
		//��ȡ����ķ�����
		String methodName = request.getParameter("method");
		
		//δ��¼��δ��Ȩʱ��ǿ��ת���ҳ�档
		String no_login="no_login.jsp";
		String no_privilege="no_privilege.jsp";
		
		
		//��̨Ȩ��У��-�ĵ���أ����������ļ�����ϵ�ļ���-
		if("filecoverdo".equals(cmdName)||"filecovercontentdo".equals(cmdName)||"systemfiledo".equals(cmdName)){
			
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//����Ȳ����ĵ�����Ա��Ҳ���ǳ�������Ա�Ļ����ǲ��ܽ����ĵ�������ӡ��޸ġ�ɾ�������ġ�
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
		//��̨Ȩ��У��-�豸���
		else if("computerdo".equals(cmdName)){
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			
			//����Ȳ����豸����Ա��Ҳ���ǳ�������Ա�Ļ����ǲ��ܽ����ĵ�������ӡ��޸ġ�ɾ�������ġ�
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
		//��̨Ȩ��У��-�û����
		else if("userdo".equals(cmdName)){
	
			//ֻ���ѵ�¼�û����ܽ��л������޸��������
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
				//ֻ�г�������Ա����ǿ�ƶϿ�ĳ���Ự�������û��Ƿ���ڡ������û����޸��û���ɾ���û����鿴�û���ϸ
			}else if("outSession".equals(methodName)||"isExist".equals(methodName)||"add".equals(methodName)||"forupdate".equals(methodName)||"update".equals(methodName)||"delete".equals(methodName)||"detail".equals(methodName)){
				
				//���ж��Ƿ��¼
				boolean isNotLogin = Tool.isNotLogin(request);
				if(isNotLogin){
					try {
						request.getRequestDispatcher(no_login).forward(request, response);
						return;
					} catch (Exception e) {
						log.error("",e);
					}
				}
				//Ȼ���ж��Ƿ��ǹ���Ա
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
		//��̨Ȩ��У��-��Ŀ���-
		else if("projectdo".equals(cmdName)){
			
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//��������ĵ�����Ա�����Ը����ˡ���������Ա�����ܽ�����Ŀ��Ϣ������ӡ��޸ġ�ɾ�������ġ�
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
		//��̨Ȩ��У��-������-
		else if("casedo".equals(cmdName)){
			
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//��������ĵ�����Ա����������Ա�����ܶ԰������С���׼��/�����ء�/���Զ�ת����������
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
		}//��̨Ȩ��У��-֪ʶ��-
		else if("knowdo".equals(cmdName)){
			
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//��������ĵ�����Ա����������Ա�����ܶ��ļ����С���׼��/�����ء�/���Զ�ת����������
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
			
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
			//��������ĵ�����Ա�����Ը����ˡ���������Ա�����ܽ���ȱ��������Ϣ������ӡ��޸ġ�ɾ�������ġ�
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
		
		}//��Ʒά������Ȩ��У��
		else if("productdo".equals(cmdName)){
			
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}
		
			//ֻ�г�������Ա���ܶԲ�Ʒ(Product)��Ϣ�����޸ġ�ɾ��������
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
		}else if("auditdo".equals(cmdName)){//��ƹ���--Ȩ��У��
			//���ж��Ƿ��¼
			boolean isNotLogin = Tool.isNotLogin(request);
			if(isNotLogin){
				try {
					request.getRequestDispatcher(no_login).forward(request, response);
					return;
				} catch (Exception e) {
					log.error("",e);
				}
			}		
			//ֻ�г�������Ա���ܲ鿴��ɾ�������Ϣ
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
			
			//���������cmd�ļ�ƣ���ȡ����ȫ·����
			String fullCmdName = getFullName(cmdName);
			
			//��ȡ�����cmd��ʵ��
			Object cmdObj = ObjectFactory.getObject(fullCmdName);
			
			//����Command��������Ϣ�������̱߳����С�
			CommandContext.init(request, response, getServletContext(), getServletConfig());
			
			//ͨ�����䣬ִ������ķ�����cmd��ķ���
			Method realMehood = cmdObj.getClass().getMethod(methodName);
			forwardPath = realMehood.invoke(cmdObj);
			
		} catch (Exception e) {
			
			log.error("�����ˣ�", e);
			
			//cmd��ͬʱҲ��ҵ���߼��㣬cmd��ķ������������ԣ�dao��cmd�е��쳣��Ϣͨ��throw new RunTimeException�����׳����ڴ�ͳһ�������ҳ�档
			forwardPath = "error.jsp";
			StringWriter sw = new StringWriter();
		    PrintWriter pw = new PrintWriter(sw, true);
		    e.printStackTrace(pw);
		    pw.flush();
		    sw.flush();
		    String htmlStr = sw.toString().replace("\n", "<br>");
			request.setAttribute("error", htmlStr);
		}

		//ִ����ϣ�����ҳ����ת
		if(forwardPath != null){			
			request.getRequestDispatcher(forwardPath+"").forward(request, response);
		}	
	}
	
	/*
	 *  ���� һ����ֵ ,���ظü�ֵ��Ӧ����İ�ȫ·����userdo=cn.sdfi.service.UserDo
	 */
	private String getFullName(String name) {
		if(null == properties){
			properties = Tool.load_property_file("object.properties");
			log.debug("--------����object.properties-------");
		}
		return properties.get(name)+"";	
	}
}
