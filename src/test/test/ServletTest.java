package test.test;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/*
 * 验证 servlet 的非线程安全性
 */
public class ServletTest extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private String password;//实例变量是非线程安全的
	
	
	@Override
	public void init() throws ServletException {
		System.out.println("我执行了。。。");
	}
	
	public void service(HttpServletRequest request, HttpServletResponse response){
		
		response.setContentType("text/html; charset=gb2312");
		
		//方法里的变量（局部变量）是线程安全的
		String username = null;
		username = request.getParameter("username");
		
		//同步代码块
		//synchronized(this){//开始同步
		password = request.getParameter("pwd");		
		try {
			Thread.sleep(5000); // 每个线程执行至此停留5秒。
			PrintWriter output = response.getWriter();
			output.println("用户名:" + username );
			output.println(" 密码:" + password +"<br>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		//}//结束同步
	}
}
/*
 * 操作：
 * 1、先访问:http://localhost:8080/testlab/test.cmd?username=name1&pwd=password1
 * 2、然后访问:http://localhost:8080/testlab/test.cmd?username=name2&pwd=password2
 * 结果：
 * 用户名:username1 密码:password2
 * 用户名:username2 密码:password2
 */
