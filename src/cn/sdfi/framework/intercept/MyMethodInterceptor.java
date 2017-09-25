package cn.sdfi.framework.intercept;

import java.lang.reflect.Method;

import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.db.TransactionManager;
import cn.sdfi.tools.Const;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;


public class MyMethodInterceptor implements MethodInterceptor{

	public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxyMethod) throws Throwable {
		
		Trans myAnnotation = method.getAnnotation(Trans.class);
		Object returnValue = null;
		TransactionManager manger = null;
		if(Const.is_print_system_out){					
			System.out.println("拦截方法："+method);
		}
		try {		
			//开启事务
			if(myAnnotation != null){
				manger = TransactionManager.getTransManager();
				manger.beginTransaction();
			}
			
			//执行源对象的method方法
			returnValue = proxyMethod.invokeSuper(obj, args);
			
			//提交事务
			if(myAnnotation != null){
				manger.commitTransaction();
			}
		} catch (Exception e) {
			if(Const.is_print_system_out){					
				System.out.println("执行方法"+method+"抛异常了");
			}
			
			//回滚事务
			if(myAnnotation != null){
				manger.rollbackTransaction();
			}
			throw new RuntimeException("出错了！",e);
		}	
		return returnValue;
	}
}
