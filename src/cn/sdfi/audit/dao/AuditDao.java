package cn.sdfi.audit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.audit.bean.Audit;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;
import cn.sdfi.tools.UUIDGenerator;

public class AuditDao{

	private static ConnectionPool pool=ConnectionPool.getInstance();
	private static Logger log = Logger.getLogger(AuditDao.class);
	
	/*
	 * 执行保存
	 */	
	public static synchronized void audit(String username,String url,String ip){	
		
		Connection conn = null;
		PreparedStatement statement = null;
		try {
			
			statement = pool.getConnection().prepareStatement("insert into t_audit(pk,username,url,accessTime,ip)values(?,?,?,?,?)");
			statement.setString(1,UUIDGenerator.getRandomUUID());
			statement.setString(2,username==null?"":username);
			statement.setString(3,url);
			statement.setString(4, Tool.getDateTimeWithSeconds());
			statement.setString(5, ip);
			statement.executeUpdate();
		} catch (SQLException e) {
			log.error("执行审计出错!",e);
			throw new RuntimeException("执行审计出错！",e);
		}finally{
			Tool.closeConnection(null, statement, conn);
		}
	}
	
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	public List<Audit> changeResultSet(ResultSet rs) {
		List<Audit> list = new ArrayList<Audit>();
		Audit view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new Audit();
				view.setPk(rs.getString("pk"));
				view.setUsername(rs.getString("username"));
				view.setUrl(rs.getString("url"));
				view.setAccessTime(rs.getString("accessTime"));
				view.setIp(rs.getString("ip"));
				list.add(view);
			}
		} catch (SQLException e) {
			log.error("结果集转换bean出错！",e);
			throw new RuntimeException("结果集转换bean出错！",e);
		}
		return list;
	}

	/*
	 * 根据主键批量删除
	 */
	public void batchDeleteByPK(String[] pk){

		Connection conn = pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_audit where pk in(");
		for (int i = 0; i < pk.length; i++) {
			sql.append("'");
			sql.append(pk[i]);
			sql.append("'");
			sql.append(",");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("执行批量删除操作出错!", e);
			throw new RuntimeException("执行批量删除操作出错！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 清空设计表
	 */
	public void deleteAll(){

		Connection conn = pool.getConnection();
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement("delete from t_audit");
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("清空审计表时出错!", e);//记录日志
			throw new RuntimeException("清空审计表时出错！",e);//抛向前台
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 接收一个 Audit 对象作为查询条件。
	 * 返回值Map{
	 * key：count—— 符合条件总记录数
	 * key：list—— 返回指定页的记录
	 * }
	 */
		public Map<String, Object> queryAudit(Audit view) {
			
			Connection conn = pool.getConnection();
			PreparedStatement ps1 = null;
			PreparedStatement ps2 = null;
			ResultSet rs1 = null;
			ResultSet rs2 = null;
		
			Map<String, Object> map = new HashMap<String, Object>();
			List<Audit> list = new ArrayList<Audit>();	
			String wheresql = this.getWhereSql(view);

			//countSql 查询符合指定条件的总记录数。
			int count = 0;
			StringBuffer countSql = new StringBuffer();
			countSql.append("select count(*) from t_audit where 1=1 ");
			countSql.append(wheresql);
			try {
				ps1 = conn.prepareStatement(countSql.toString());
				rs1 = ps1.executeQuery();
				if(rs1.next()){	
					count = rs1.getInt(1);
				}
				
				//如果查询结果不为空
				if(count>0){

					//拼接获取符合指定条件的前 pageSize 条记录的sql
					StringBuffer sql = new StringBuffer();
					sql.append("select top ");
					sql.append(view.getPageSize());
					sql.append("  * FROM t_audit where pk not in(select top ");
					sql.append(view.getPageSize()*(view.getShowPage()-1));
					sql.append(" pk from t_audit where 1=1");
					sql.append(wheresql);
					sql.append(" order by ");
					sql.append(view.getSort());
					sql.append(" ");
					sql.append(view.getSortType());
					sql.append(") ");
					sql.append(wheresql);
					sql.append(" order by ");
					sql.append(view.getSort());
					sql.append(" ");
					sql.append(view.getSortType());
					ps2 = conn.prepareStatement(sql.toString());
					rs2 = ps2.executeQuery();
					list = changeResultSet(rs2);	
				}
			}catch (Exception e) {
				log.error("审计查询出错！",e);
				throw new RuntimeException("审计查询出错！",e);
			}finally{
				Tool.closeConnection(rs2, ps2, null);
				Tool.closeConnection(rs1, ps1, conn);
			} 
			map.put("count", count);		
			map.put("list",list);
			return map;		
		}
	/*
	 * 获取查询wheresql语句
	 */
	private String getWhereSql(Audit view){
	
		// pk;//主键	 username;//登录用户名	url;//url	 accessTimeBegin;	 accessTimeEnd;
		
		StringBuffer wheresql = new StringBuffer();
		if(!"".equals(view.getAccessTimeBegin())){ 
			wheresql.append(" and accessTime >= '");
			wheresql.append(view.getAccessTimeBegin());
			wheresql.append("'");
		}
		if(!"".equals(view.getAccessTimeEnd())){		
			wheresql.append(" and accessTime <= '");
			wheresql.append(view.getAccessTimeEnd());
			wheresql.append("'");
		}
		if(!"".equals(view.getUsername())){		
			wheresql.append(" and username like '%");
			wheresql.append(view.getUsername());
			wheresql.append("%'");
		}	
		if(!"".equals(view.getUrl())){		
			wheresql.append(" and url like '%");
			wheresql.append(view.getUrl());
			wheresql.append("%'");
		}		
		return wheresql.toString();
	}
}
