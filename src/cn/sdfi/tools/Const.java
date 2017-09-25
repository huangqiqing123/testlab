package cn.sdfi.tools;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import cn.sdfi.user.bean.User;

public class Const {

	public static final String CONTENT_TYPE = "text/html;charset=GBK";
	public static final String CHARACTOR_ENCODING = "GBK";
	private static Map<String, Map<String,String>> enumMap = null;//用于存储加载的枚举值
	private static Map<String, User> onlineUserMap = null;//用于存储在线用户
	private static Map<String, HttpSession> onlineUserSessionMap = null;//用于存储在线用户的session
	private static List<String>  canPrintDocs = new ArrayList<String>();//可打印文档类型列表
	public static boolean is_print_system_out = false;
		
	public static List<String> getCanPrintDocs() {
		return canPrintDocs;
	}
	public static void setCanPrintDocs(List<String> canPrintDocs) {
		Const.canPrintDocs = canPrintDocs;
	}
	public static void setEnumMap(Map<String, Map<String, String>> enumMap) {
		Const.enumMap = enumMap;
	}
	public static Map<String, Map<String,String>> getEnumMap() {
		return enumMap;
	}
	public static Map<String, User> getOnlineUserMap() {
		return onlineUserMap;
	}
	public static void setOnlineUserMap(Map<String, User> onlineUserMap) {
		Const.onlineUserMap = onlineUserMap;
	}
	public static Map<String, HttpSession> getOnlineUserSessionMap() {
		return onlineUserSessionMap;
	}
	public static void setOnlineUserSessionMap(
			Map<String, HttpSession> onlineUserSessionMap) {
		Const.onlineUserSessionMap = onlineUserSessionMap;
	}	
}
