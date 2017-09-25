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
			System.out.println("���ط�����"+method);
		}
		try {		
			//��������
			if(myAnnotation != null){
				manger = TransactionManager.getTransManager();
				manger.beginTransaction();
			}
			
			//ִ��Դ�����method����
			returnValue = proxyMethod.invokeSuper(obj, args);
			
			//�ύ����
			if(myAnnotation != null){
				manger.commitTransaction();
			}
		} catch (Exception e) {
			if(Const.is_print_system_out){					
				System.out.println("ִ�з���"+method+"���쳣��");
			}
			
			//�ع�����
			if(myAnnotation != null){
				manger.rollbackTransaction();
			}
			throw new RuntimeException("�����ˣ�",e);
		}	
		return returnValue;
	}
}
