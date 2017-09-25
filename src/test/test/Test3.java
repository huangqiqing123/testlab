package test.test;

public class Test3 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		
		try {
			int a = 1/0;
		} catch (Exception e) {
			throw new RuntimeException("计算出错！",e);
		}finally{
			System.out.println("执行finally中语句！");
		}
	}
}
//-----------------输出结果------------------

//执行finally中语句！
//Exception in thread "main" java.lang.RuntimeException: 计算出错！
//	at cn.sdfi.test.Test3.main(Test3.java:15)
//Caused by: java.lang.ArithmeticException: / by zero
//	at cn.sdfi.test.Test3.main(Test3.java:13)

