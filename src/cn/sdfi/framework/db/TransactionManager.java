package cn.sdfi.framework.db;

import java.sql.Connection;
import java.sql.SQLException;

import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Const;

public class TransactionManager {

	private Connection con;
	private TransactionManager(Connection con){
		this.con = con;
	}
	
	/*
	 * ��������
	 */
	public void beginTransaction(){
		try {
			con.setAutoCommit(false);
			if(Const.is_print_system_out){					
				System.out.println(Thread.currentThread().getName()+" ��������");
			}
		} catch (SQLException e) {
			throw new RuntimeException("��������ʧ�ܣ�",e);
		}
	}
	/*
	 * �ύ����
	 */
	public void commitTransaction(){
		try {
			con.commit();
			if(Const.is_print_system_out){				
				System.out.println(Thread.currentThread().getName()+" �ύ����");
			}
		} catch (SQLException e) {
			throw new RuntimeException("�ύ����ʧ�ܣ�",e);
		}finally{		
			ConnectionPool.getInstance().release(con);	
		}
	}
	/*
	 * �ع�����
	 */
	public void rollbackTransaction(){
		try {
			con.rollback();
			if(Const.is_print_system_out){					
				System.out.println(Thread.currentThread().getName()+" �ع�����");
			}		
		} catch (SQLException e) {
			throw new RuntimeException("�ع�����ʧ�ܣ�",e);
		}finally{
			ConnectionPool.getInstance().release(con);	
		}
	}
	/*
	 * ��ȡ���������
	 */
	public static TransactionManager getTransManager(){
		return new TransactionManager(ConnectionPool.getInstance().getConnection());
	}
}
