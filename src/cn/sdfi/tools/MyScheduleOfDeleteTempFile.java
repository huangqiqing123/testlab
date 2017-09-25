package cn.sdfi.tools;

import java.io.File;
import java.util.TimerTask;
import org.apache.log4j.Logger;

public class MyScheduleOfDeleteTempFile extends TimerTask {

	private Logger log = Logger.getLogger(MyScheduleOfDeleteTempFile.class);		
	@Override
	public void run() {
		String tempDirName = System.getProperty("java.io.tmpdir");
		if(tempDirName==null){
			log.error("获取系统临时目录出错！");
		}else{	
			log.debug("定时清理Jfreechart临时文件："+tempDirName);
			File tempDir = new File(tempDirName);
			String[] files = tempDir.list();
			for (int i = 0; i < files.length; i++) {	 
				if (files[i].startsWith("jfreechart")) {//删除所有Jfreechart的图表文件
					File jfreechart_file = new File(tempDirName+"\\"+files[i]);
					if(jfreechart_file.delete()){
						log.debug("删除文件"+jfreechart_file.getAbsolutePath()+"成功！");
					}else{
						log.error("删除文件"+jfreechart_file.getAbsolutePath()+"时出错，建议进行手动删除！");
					}
				}
			}
		}
	}

}
