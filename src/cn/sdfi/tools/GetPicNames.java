package cn.sdfi.tools;

import java.io.File;
import java.io.FilenameFilter;

public class GetPicNames implements FilenameFilter {

//重写接口中的方法 accept，设定过滤规则
public boolean accept(File file, String name) {
	if(name.endsWith("jpg")||name.endsWith("gif")){
		return true;
	}
	return false;	
	}
/*
 * 获取指定路径下的所有符合过滤规则的文件名
 */
  public String[] getPicNamesEndsWithJpg(String path){
	  File file=new File(path);
	  return file.list(new GetPicNames());  
  }
}
