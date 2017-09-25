package cn.sdfi.framework.factory;

import java.util.HashMap;
import java.util.Map;

import org.jfree.util.Log;

import cn.sdfi.framework.intercept.MyMethodInterceptor;
import cn.sdfi.tools.Const;
import net.sf.cglib.proxy.Enhancer;

/*
 * ʵ�������࣬����ͳһ����cmd��service��dao��ʵ����
 */
public class ObjectFactory {

	//����һ�������
	private static Map<String,Object> objPool = new HashMap<String, Object>();
	
	/**
	 * ������İ�·�����ƣ����ظ����һ��ʵ����
	 * Լ����ҵ���߼��㣨Service�㣩����endsWith Service
	 * ΪService�㴴��������󣬷�Service��ֱ�Ӵ���ʵ����
	 */
	public static Object getObject(String clazz){
		
		Object obj = null;
		if(objPool.containsKey(clazz)){//�����������Ѵ��ڣ���ֱ�ӴӶ�����л�ȡ��
			obj = objPool.get(clazz);
		}else{
			try {	
				if(clazz.endsWith("Cmd")){
					
					//���������в����ڣ���̬����һ�������ʵ���������´�����ʵ���������ء�
					Enhancer hancer = new Enhancer();
					
					//���ô������ĸ���
					hancer.setSuperclass(Class.forName(clazz));
					
					//���ûص����󣬼����ô����������ķ���ʱ��ʵ����ִ�е��ǻص��������intercept��������
					hancer.setCallback(new MyMethodInterceptor());
					
					//�����������
					obj = hancer.create();
					if(Const.is_print_system_out){					
						System.out.println("����"+clazz+"�������ɹ���");
					}
				}else{
					obj = Class.forName(clazz).newInstance();
					if(Const.is_print_system_out){					
						System.out.println("����"+clazz+"��ͨ����ɹ���");
					}
				}
			
				//���´����Ķ������������ء�
				objPool.put(clazz, obj);
			}catch (Exception e) {
				Log.error("�����ˣ�", e);
				throw new RuntimeException("�����ˣ�",e);
			}
		}
		return obj;
	}
}
