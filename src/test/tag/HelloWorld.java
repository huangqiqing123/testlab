package test.tag;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import cn.sdfi.tools.Tool;

public class HelloWorld extends TagSupport {

	int times;

	@Override
	public int doAfterBody() throws JspException {

		JspWriter out = pageContext.getOut();
		try {
			out.println("<br>-----doAfterBody()------");
		} catch (IOException e) {
			e.printStackTrace();
		}
		times--;
		if (times == 0) {
			return SKIP_BODY;
		}
		return EVAL_BODY_AGAIN;
	}

	@Override
	public int doEndTag() throws JspException {

		JspWriter out = pageContext.getOut();
		try {
			out.println("<br>-----doEndTag()------");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}

	public void setTimes(int times) {

		JspWriter out = pageContext.getOut();
		try {
			out.println("<br>-----setTimes(int times)------");
			out.println("<br>times=" + times);
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.times = times;
	}

	public void setHeight(String height) {

		System.out.println("height=");
		System.out.println(height);
	}

	@Override
	public int doStartTag() throws JspException {

		JspWriter out = pageContext.getOut();
		
		try {
			out.println("<br>-----doStartTag()-----");
			out.println(Tool.getWebPath((HttpServletRequest)pageContext.getRequest()));//http://localhost:8080/testlab 

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return EVAL_BODY_INCLUDE;
	}

}

