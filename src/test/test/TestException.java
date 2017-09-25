package test.test;

import java.io.PrintWriter;
import java.io.StringWriter;

public class TestException {

	public static void main(String[] args) {
		try {
			int a = 2/0;
		} catch (Exception e) {
			String errorInfo = getExceptionInfo(e);
			System.out.println(errorInfo);
		}
	}
	/*
	 * 获得异常的堆栈信息，以字符串的形式返回。
	 */
	private static String getExceptionInfo(Throwable e){
		
		StringWriter sw = new StringWriter();
	    PrintWriter pw = new PrintWriter(sw, true);
	    e.printStackTrace(pw);
	    pw.flush();
	    sw.flush();
		return sw.toString();
	}
}
