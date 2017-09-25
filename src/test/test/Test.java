package test.test;

import java.io.File;
import java.lang.Thread;


class MyThread extends Thread{
  public int x = 0;

  public void run(){
    System.out.println(++x);//输出结果10个1
  }
}

class R implements Runnable{
  private int x = 0;
  public void run(){
    System.out.println(++x);//输出结果1到10
  }
}

public class Test {
  public static void main(String[] args) throws Exception{
	  printFileName("D:/workspace/testlab/WebRoot/WEB-INF/file");//打印指定路径下的所有的文件名称
  }
  public static void printFileName(String path){
	  File file = new File(path);
	  String[] filenames = file.list();
	  for (int i = 0; i < filenames.length; i++) {	
		  System.out.println(filenames[i]);
	}
  }
}
