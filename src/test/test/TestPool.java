package test.test;

import java.sql.Connection;

import cn.sdfi.tools.ConnectionPool;

public class TestPool extends Thread {

	ConnectionPool pool = ConnectionPool.getInstance();

	public TestPool(String name) {
		super(name);
		
	}

	public static void main(String[] args) {
		TestPool test1 = new TestPool("线程1");
		TestPool test2 = new TestPool("线程2");
		TestPool test3 = new TestPool("线程3");
		TestPool test4 = new TestPool("线程4");
		TestPool test5 = new TestPool("线程5");
		TestPool test6 = new TestPool("线程6");
		test1.start();
		test2.start();
		test3.start();
		test4.start();
		test5.start();
		test6.start();
	}

	@Override
	public void run() {
		
		
			Connection con = pool.getConnection();
			try {
				sleep(500);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			pool.release(con);
		}

}
