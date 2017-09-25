package cn.sdfi.framework.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.log4j.Logger;

public class Encoding implements Filter {
	
	private String encoding = null;
	private Logger log = Logger.getLogger(Encoding.class);

	public void destroy() {
		log.debug("------过滤器销毁----------");
	}

	public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {
		
		// 设置统一请求编码 GBK，在jsp页面中，
		// 无需在单独写 request.setCharacterEncoding("GBK")
		try {
			request.setCharacterEncoding(encoding);
			response.setCharacterEncoding(encoding);
	
		} catch (Exception e) {
			chain.doFilter(request, response);
		}
		//log.debug("传递前");
		chain.doFilter(request, response);
		//log.debug("传递后");
	}

	public void init(FilterConfig config) throws ServletException {
		
		log.debug("---过滤器初始化---");
		this.encoding = config.getInitParameter("encoding");
		log.debug("---初始化encoding" + encoding+"---");
		System.out.println("--初始化过滤器---testlab---");
	}


}
