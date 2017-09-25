package cn.sdfi.tools;

import java.util.TimerTask;
import org.apache.log4j.Logger;

public class MyScheduleOfConnectionPool extends TimerTask {

	private Logger log = Logger.getLogger(MyScheduleOfConnectionPool.class);	
	private ConnectionPool pool=ConnectionPool.getInstance();	
	@Override
	public void run() {
		
		//检查连接池中可用连接数。
		log.debug("当前连接池中可用连接数"+pool.getAvailableConnectNumber());	
		if(Const.is_print_system_out){
			System.out.println(Thread.currentThread().getName()+",当前连接池中可用连接数"+pool.getAvailableConnectNumber());
		}
		}
	}
