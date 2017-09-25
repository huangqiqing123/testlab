package cn.sdfi.tools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;
import org.apache.log4j.Logger;

public class ConnectionPool {

	private Vector<Connection> pool;
	private String url;
	private String username;
	private String password;
	private String driverClassName;
	private int poolSize;//连接池大小

	private static ConnectionPool instance = null;
	private Logger log = Logger.getLogger(ConnectionPool.class);

	//线程局部变量
	protected static ThreadLocal<Connection>  threadLocalCon = new ThreadLocal<Connection>();
	
	/*
	 * 私有构造方法，禁止在外部创建本类的对象，要想获得本类的对象，统一通过getInstance()方法。
	 * 在构造方法中，完成数据池配置文件的加载以及数据池的创建。
	 */
	private ConnectionPool() {
		
		//加载连接池配置文件dbpool.properties
		Properties properties = Tool.load_property_file("dbpool.properties");
		this.driverClassName = properties.getProperty("driverClassName");
		this.username = properties.getProperty("username");
		this.password = properties.getProperty("password");
		this.url = properties.getProperty("url");
		this.poolSize = Integer.parseInt(properties.getProperty("poolSize"));
		
		//根据配置信息创建连接池
		pool = new Vector<Connection>(poolSize);
		addConnection(poolSize);
	}
	
	/*
	 * 获取本类的对象
	 */
	public static ConnectionPool getInstance() {
		if (instance == null) {
			instance = new ConnectionPool();
		}
		return instance;
	}


	/*
	 * 释放一条连接到连接池中。
	 */
	public synchronized void release(Connection conn) {
		
		//重新设置成自动提交(使用事务时，会设置为不自动提交，所以释放连接时，重置成事务自动提交)
		try {
			conn.setAutoCommit(true);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		//重新放入连接池中
		pool.add(conn);
		if(Const.is_print_system_out){
			System.out.println(Thread.currentThread().getName()+",释放连接："+conn);
		}
		
		//从线程变量中移除
		threadLocalCon.set(null);
	}

	/*
	 * 从连接池中获取一个连接
	 */
	public Connection getConnection() {

		Connection con = threadLocalCon.get();
		try {
			if (con == null || con.isClosed()) {
				
				while (pool.size() == 0) {	
					try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						log.error(e);
					}
				}
				synchronized (this) {	
					con = pool.get(0);
					Connection con2 = pool.remove(0);
					if(Const.is_print_system_out){	
						System.out.println(Thread.currentThread().getName()+"，取得连接："+con2+",剩余连接数："+getAvailableConnectNumber());
					}
					threadLocalCon.set(con);
				}
			}
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		return con;	
	}

	/*
	 * 根据传入的参数，在连接池中新建num个连接。
	 */
	private  void addConnection(int num) {
		Connection conn = null;
		try {
			Class.forName(driverClassName);
			for (int i = 0; i < num; i++) {
				conn = DriverManager.getConnection(url, username,password);
				pool.add(conn);
		}
		} catch (ClassNotFoundException e1) {
			log.error(e1);
		} catch (SQLException e) {
			log.error(e);
		}	
	}

	/*
	 * 清空连接池中所有连接。
	 */
	public synchronized void closePool() {
		for (int i = 0; i < pool.size(); i++) {
			try {
				pool.get(i).close();
			} catch (SQLException e) {
				log.error(e);
			}
			pool.remove(i);
		}
	}
	/*
	 * 获取当前连接池中可用连接数
	 */
	public int getAvailableConnectNumber(){
		return pool.size();
	}
}
