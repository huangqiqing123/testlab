package cn.sdfi.tools;

import java.io.File;
import java.io.FilenameFilter;

public class GetFileNames implements FilenameFilter {

	private String filename;
	
	//构造方法
	public GetFileNames(String filename){

		this.filename=filename;
	}

	//重写接口中的方法 accept，设定过滤规则
	public boolean accept(File file, String name) {
		
		if(name.startsWith(filename)){
			return true;
		}
		return false;	
	}
	/*
	 * 获取指定路径下的所有符合过滤规则的文件名
	 */
	public static String[] getFileNamesStartWithPrefix(String path,String prefix){
		File file=new File(path);
		return file.list(new GetFileNames(prefix));  
	}
}
