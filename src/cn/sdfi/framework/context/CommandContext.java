package cn.sdfi.framework.context;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CommandContext {

	private static ThreadLocal<Map<String,Object>> threadLocal = new ThreadLocal<Map<String,Object>>();
	
	private static final String HTTP_SERVLET_REQUEST = "1";
	private static final String HTTP_SERVLET_RESPONSE = "2";
	private static final String SERVLET_CONTEXT = "3";
	private static final String SERVLET_CONFIG = "4";
	
	/*
	 * ��ʼ���ֲ߳̾�����
	 */
	public static void init(HttpServletRequest req,HttpServletResponse resp,ServletContext context,ServletConfig config){
		threadLocal.remove();
		Map<String,Object> localMap = new HashMap<String, Object>();
		localMap.put(HTTP_SERVLET_REQUEST, req);
		localMap.put(HTTP_SERVLET_RESPONSE, resp);
		localMap.put(SERVLET_CONTEXT, context);
		localMap.put(SERVLET_CONFIG, config);
		threadLocal.set(localMap);
	}
	/*
	 * ��ȡrequest����
	 */
	public static HttpServletRequest getRequest(){
		return (HttpServletRequest)threadLocal.get().get(HTTP_SERVLET_REQUEST);
	}
	/*
	 * ��ȡresponse����
	 */
	public static HttpServletResponse getResponse(){
		return (HttpServletResponse)threadLocal.get().get(HTTP_SERVLET_RESPONSE);
	}
	/*
	 * ��ȡsession����
	 */
	public static HttpSession getSession(){
		return getRequest().getSession();
	}
	/*
	 * ��ȡservletContext����
	 */
	public static ServletContext getServletContext(){
		return (ServletContext)threadLocal.get().get(SERVLET_CONTEXT);
	}
	/*
	 * ��ȡservletConfig����
	 */
	public static ServletConfig getServletConfig(){
		return (ServletConfig)threadLocal.get().get(SERVLET_CONFIG);
	}
}
