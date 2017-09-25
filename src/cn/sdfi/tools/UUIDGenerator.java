package cn.sdfi.tools;

import java.util.UUID;

public class UUIDGenerator{

	//获取32位的唯一标识符
	public static synchronized String getRandomUUID(){
		
		return UUID.randomUUID().toString().replaceAll("-","");
	}
}
