package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class LoginFilter implements Filter {
	
	public void doFilter(ServletRequest req, ServletResponse response,FilterChain chain) throws IOException, ServletException {
		
		//上海邮政过滤器伪代码
		//1、检查是否已登录（1、检查session；2、检查cookie）
		//检查session
		HttpServletRequest request = (HttpServletRequest)req;
		Object uid = request.getSession().getAttribute("uid");
		if(uid == null){
			//检查cookie
			Cookie jcookies[] = request.getCookies();
			Cookie cookie = null;
			String cookieName = null;
			String cookieValue = null;
			if(jcookies!=null){
				for (int i = 0; i < jcookies.length; i++) {
					cookie = jcookies[i];
					cookieName = cookie.getName();
					if ("uc_uid".equals(cookieName)) {
						cookieValue = cookie.getValue();
						break;
					}
				}
			}	
			//如果session、cookie中都不存在用户登录信息，则重定向至用户中心进行登录。
			if(cookieValue == null){
				String uc_sso_url =  "http://localhost/UCPHPFront/index.php?m=member&c=index&a=sharesso";
				StringBuffer relayState = request.getRequestURL();
				request.setAttribute("uc_sso_url",uc_sso_url);
				request.setAttribute("relayState",relayState);
				request.getRequestDispatcher("toIdp.jsp").forward(request,response);
				return;
			}else{
				//对cookie value进行解密，并创建会话
				String uc_uid = ICity365Util.decode(cookieValue);System.out.println("uc_uid="+uc_uid);
				request.getSession().setAttribute("uid",uc_uid);
			}
		}
		//请求继续传递
		chain.doFilter(request, response);
	}

	public void destroy() {
		// TODO Auto-generated method stub
	}

	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
	}
}
