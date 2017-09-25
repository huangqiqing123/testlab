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
		log.debug("------����������----------");
	}

	public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {
		
		// ����ͳһ������� GBK����jspҳ���У�
		// �����ڵ���д request.setCharacterEncoding("GBK")
		try {
			request.setCharacterEncoding(encoding);
			response.setCharacterEncoding(encoding);
	
		} catch (Exception e) {
			chain.doFilter(request, response);
		}
		//log.debug("����ǰ");
		chain.doFilter(request, response);
		//log.debug("���ݺ�");
	}

	public void init(FilterConfig config) throws ServletException {
		
		log.debug("---��������ʼ��---");
		this.encoding = config.getInitParameter("encoding");
		log.debug("---��ʼ��encoding" + encoding+"---");
		System.out.println("--��ʼ��������---testlab---");
	}


}
