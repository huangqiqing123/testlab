package cn.sdfi.user.dao;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;
import cn.sdfi.user.bean.User;

public class UserDao{

	private Logger log = Logger.getLogger(UserDao.class);
	private ConnectionPool pool=ConnectionPool.getInstance();
	
	/*
	 * 执行保存
	 */
	public void save(User view) {
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into t_file_user");
		sql.append("(username,password,mylevel,skin,who,sex,entry_time1,memo,pageSize)") ;
		sql.append(" values(?,?,?,?,?,?,?,?,?)");
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,view.getUsername());
			ps.setString(2,view.getPassword());
			ps.setString(3,view.getMylevel());
			ps.setString(4,view.getSkin());
			ps.setString(5,view.getWho());
			ps.setString(6,view.getSex());
			ps.setString(7,view.getEntry_time());
			ps.setString(8,view.getMemo());
			ps.setString(9,view.getPageSize()+"");
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("保存用户出错",e);
			throw new RuntimeException("保存用户出错！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}	
	}
	/*
	 * 修改
	 */
	public void update(User view) {
		
		String sql = "update t_file_user set username=?,password=?,mylevel=?,skin=?,sex=?,entry_time=?,memo=? where who=?";
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,view.getUsername());
			ps.setString(2,view.getPassword());
			ps.setString(3,view.getMylevel());
			ps.setString(4,view.getSkin());
			ps.setString(5,view.getSex());
			ps.setString(6,view.getEntry_time());
			ps.setString(7,view.getMemo());
			ps.setString(8,view.getWho());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("更新用户出错！",e);
			throw new RuntimeException("更新用户出错！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}		
	}
	/*
	 * 接收一个 User 对象作为查询条件，查询结果将以 list 的形式返回。
	 */
		public List<User> queryByUser(User user) {
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			List<User> list = new ArrayList<User>();
			/*
			 * 查询字段：登录用户名、员工姓名、性别、角色
			 */
			StringBuffer sql = new StringBuffer();
			sql.append("select * FROM t_file_user where who like '%");
			sql.append(user.getWho());
			sql.append("%' and username like '%");
			sql.append(user.getUsername());
			sql.append("%'");
			sql.append(" and sex like '%");
			sql.append(user.getSex());
			sql.append("%'");
			sql.append(" and mylevel like '%");
			sql.append(user.getMylevel());
			sql.append("%'");
			sql.append(" order by ");
			sql.append(user.getSort());
			sql.append(" ");
			sql.append(user.getSortType());
			try {
				ps = conn.prepareStatement(sql.toString());
				rs = ps.executeQuery();
				list = resultSetToList(rs);
			} catch (Exception e) {
				log.error("查询时出错！",e);
				throw new RuntimeException("查询时出错！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return list;
		}
	/*
	 * 登陆处理
	 */
	public String loginProcess(String username,String password) {
	
		String msg=null;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_file_user WHERE username=?");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,username);
			rs = ps.executeQuery();	
			
			//如果该用户名存在，则继续判断密码是否正确。
			if(rs.next()){
				sql.append(" and password=?");
				ps=conn.prepareStatement(sql.toString());
				ps.setString(1, username);
				ps.setString(2, password);
				rs=ps.executeQuery();
				if(rs.next()){		
					msg = "登陆成功！";
				}
				else{
					msg = "登陆失败，你输入的密码不正确！";
				}
			}
			else{
				msg = "登录失败，该用户名不存在！";
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			msg = "系统出错，详细信息请查看日志！";
			throw new RuntimeException("出错了！",e);
		} finally{
			Tool.closeConnection(rs, ps, conn);
		}
		return msg;
	}
	/*
	 * 按照用户名(用户名是唯一的)进行查询，返回一个User对象
	 */
	public User queryByUsername(String username){
		
		User user=null;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM t_file_user WHERE username=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1,username);
			rs = ps.executeQuery();	
			user=changeRsToView(rs);
			
		} catch (SQLException e) {
			log.error("根据用户名执行查询出错！",e);
			throw new RuntimeException("根据用户名执行查询出错！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		}
		return user;
	}
	/*
	 * 按照员工姓名(员工姓名是主键)进行查询，返回一个User对象
	 */
	public User queryByWho(String who){
		User user=null;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM t_file_user WHERE who=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1,who);
			rs = ps.executeQuery();	
			user=changeRsToView(rs);
		} catch (SQLException e) {
			log.error("根据员工姓名执行查询出错！",e);
			throw new RuntimeException("根据员工姓名执行查询出错！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		}
		return user;
	}
	/*
	 * 获取所有用户
	 */
	public List<User> getAllUsers(){
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<User> list = new ArrayList<User>();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_file_user");
		try {
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			list = resultSetToList(rs);
		} catch (Exception e) {
			log.error("获取所有用户时出错！",e);
			throw new RuntimeException("获取所有用户时出错！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return list;
	}
	/*
	 * 结果集到实体对象的转换
	 */
	private User changeRsToView(ResultSet rs){
		User view = new User();
		try {
			if (rs.next()) {
				view.setUsername(rs.getString("username"));
				view.setPassword(rs.getString("password"));
				view.setSkin(rs.getString("skin"));
				view.setMylevel(rs.getString("mylevel"));
				view.setSex(rs.getString("sex"));
				view.setWho(rs.getString("who"));
				view.setEntry_time(rs.getString("entry_time"));
				view.setMemo(rs.getString("memo"));
				view.setPageSize(Integer.parseInt(rs.getString("pageSize")));
			}
		} catch (SQLException e) {
			log.error("结果集向实体bean转换出错！",e);
			throw new RuntimeException("结果集向实体bean转换出错！",e);
		}
		return view;
	}
	/*
	 * 切换皮肤
	 */
	public void changeSkin(String username,String skin){

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;

		StringBuffer sql = new StringBuffer();
		sql.append("update t_file_user set skin='");
		sql.append(skin);
		sql.append("' where username='");
		sql.append(username);
		sql.append("'");	
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("切换皮肤时出错！",e);
			throw new RuntimeException("切换皮肤时出错！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 更新用户的pageSize
	 */
	public void changePageSize(String username,String pageSize){
		
		Connection conn = pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer();
		sql.append("update t_file_user set pageSize='");
		sql.append(pageSize);
		sql.append("' where username='");
		sql.append(username);
		sql.append("'");	
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("更新页大小出错！",e);
			throw new RuntimeException("更新页大小出错！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 修改密码
	 */
	public void changePassword(String username,String password){
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer();
		sql.append("update t_file_user set password='");
		sql.append(password);
		sql.append("' where username='");
		sql.append(username);
		sql.append("'");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("修改密码出错！",e);
			throw new RuntimeException("修改密码出错！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<User> resultSetToList(ResultSet rs) {
		
		List<User> list = new ArrayList<User>();
		User view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new User();
				view.setUsername(rs.getString("username"));
				view.setPassword(rs.getString("password"));
				view.setSkin(rs.getString("skin"));
				view.setMylevel(rs.getString("mylevel"));
				view.setSex(rs.getString("sex"));
				view.setWho(rs.getString("who"));
				view.setEntry_time(rs.getString("entry_time"));
				view.setMemo(rs.getString("memo"));
				view.setPageSize(Integer.parseInt(rs.getString("pageSize")));
				list.add(view);
			}
		} catch (SQLException e) {
			log.error("结果集向bean转换出错！",e);
			throw new RuntimeException("结果集向bean转换出错！",e);
		}
		return list;
	}
	/*
	 * 按照员工姓名批量删除
	 */
	public void batchDeleteByWho(String [] who){

		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_file_user where who in (");
		for (int i = 0; i < who.length; i++) {
			sql.append("'");
			try {
				sql.append(URLDecoder.decode(who[i],"GBK"));	
			} catch (UnsupportedEncodingException e) {
				log.error("解析中文时出错！！",e);
				throw new RuntimeException("解析中文时出错！",e);
			}
			sql.append("',");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("按照员工姓名批量删除时出错！",e);
			throw new RuntimeException("按照员工姓名批量删除时出错！",e);
		}finally{	
			Tool.closeConnection(null, ps, conn);
		}
	}
}
