package test.test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class TestExec {

	public static void main(String[] args) {

		try {
			Process process = Runtime.getRuntime().exec("java");
			
			//方式一、新启线程接收、输出
			new MyThread1(process.getErrorStream()).start();
			new MyThread1(process.getInputStream()).start();
			
			//方式二、主进程进行接收、输出
//			mainMethod(process.getErrorStream());
//			mainMethod(process.getInputStream());
			
			int status = process.waitFor();
			if (status == 0) {
				System.out.println("exit success");
			} else {
				System.out.println("exit fail");

			}
		} catch (Exception e) {
			System.out.println("exception occurs......");
			e.printStackTrace();
		}
	}
	
	static void mainMethod(InputStream input){
		BufferedReader bf;
		bf = new BufferedReader(new InputStreamReader(input));
		String line;
		try {
			line = bf.readLine();
			while (line != null) {
				System.out.println(line);
				line = bf.readLine();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	
	}
}

class MyThread1 extends Thread {
	BufferedReader bf;
	public MyThread1(InputStream input) {
		bf = new BufferedReader(new InputStreamReader(input));
	}
	public void run() {
		String line;
		try {
			line = bf.readLine();
			while (line != null) {
				System.out.println(line);
				line = bf.readLine();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
