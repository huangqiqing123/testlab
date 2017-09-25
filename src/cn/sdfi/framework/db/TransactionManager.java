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
	 * 开启事务
	 */
	public void beginTransaction(){
		try {
			con.setAutoCommit(false);
			if(Const.is_print_system_out){					
				System.out.println(Thread.currentThread().getName()+" 开启事务");
			}
		} catch (SQLException e) {
			throw new RuntimeException("开启事务失败！",e);
		}
	}
	/*
	 * 提交事务
	 */
	public void commitTransaction(){
		try {
			con.commit();
			if(Const.is_print_system_out){				
				System.out.println(Thread.currentThread().getName()+" 提交事务");
			}
		} catch (SQLException e) {
			throw new RuntimeException("提交事务失败！",e);
		}finally{		
			ConnectionPool.getInstance().release(con);	
		}
	}
	/*
	 * 回滚事务
	 */
	public void rollbackTransaction(){
		try {
			con.rollback();
			if(Const.is_print_system_out){					
				System.out.println(Thread.currentThread().getName()+" 回滚事务");
			}		
		} catch (SQLException e) {
			throw new RuntimeException("回滚事务失败！",e);
		}finally{
			ConnectionPool.getInstance().release(con);	
		}
	}
	/*
	 * 获取事务管理器
	 */
	public static TransactionManager getTransManager(){
		return new TransactionManager(ConnectionPool.getInstance().getConnection());
	}
}
