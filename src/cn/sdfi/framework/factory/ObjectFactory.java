package cn.sdfi.framework.factory;

import java.util.HashMap;
import java.util.Map;

import org.jfree.util.Log;

import cn.sdfi.framework.intercept.MyMethodInterceptor;
import cn.sdfi.tools.Const;
import net.sf.cglib.proxy.Enhancer;

/*
 * 实例工厂类，用于统一管理cmd、service、dao的实例。
 */
public class ObjectFactory {

	//创建一个对象池
	private static Map<String,Object> objPool = new HashMap<String, Object>();
	
	/**
	 * 根据类的包路径名称，返回该类的一个实例。
	 * 约定：业务逻辑层（Service层）的类endsWith Service
	 * 为Service层创建代理对象，非Service层直接创建实例。
	 */
	public static Object getObject(String clazz){
		
		Object obj = null;
		if(objPool.containsKey(clazz)){//如果对象池中已存在，则直接从对象池中获取。
			obj = objPool.get(clazz);
		}else{
			try {	
				if(clazz.endsWith("Cmd")){
					
					//如果对象池中不存在，则动态创建一个该类的实例，并将新创建的实例放入对象池。
					Enhancer hancer = new Enhancer();
					
					//设置代理对象的父类
					hancer.setSuperclass(Class.forName(clazz));
					
					//设置回调对象，即调用代理对象里面的方法时，实际上执行的是回调对象（里的intercept方法）。
					hancer.setCallback(new MyMethodInterceptor());
					
					//创建代理对象
					obj = hancer.create();
					if(Const.is_print_system_out){					
						System.out.println("创建"+clazz+"代理对象成功！");
					}
				}else{
					obj = Class.forName(clazz).newInstance();
					if(Const.is_print_system_out){					
						System.out.println("创建"+clazz+"普通对象成功！");
					}
				}
			
				//将新创建的对象放入代理对象池。
				objPool.put(clazz, obj);
			}catch (Exception e) {
				Log.error("出错了！", e);
				throw new RuntimeException("出错了！",e);
			}
		}
		return obj;
	}
}
