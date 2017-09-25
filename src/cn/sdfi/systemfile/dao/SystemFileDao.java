package cn.sdfi.systemfile.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.systemfile.bean.SystemFile;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class SystemFileDao{

	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(SystemFileDao.class);
	
	/*
	 * 按照体系文件编码进行精确查询，检查该编码是否已存在，存在返回true，不存在返回false。
	 */
	public boolean isExist(String code) {
		boolean flag = false;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select pk FROM t_system_file where code = ?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1,code);
			rs = ps.executeQuery();
			if(rs.next()){
				flag=true;
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return flag;		
	}
	/*
	 * 执行保存
	 */
	public void save(SystemFile view){

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		String sql = "insert into t_system_file(pk,code,name,pages,memo,version,controlled_number,state)values(?,?,?,?,?,?,?,?)";	
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1,view.getPk());
			ps.setString(2,view.getCode());
			ps.setString(3,view.getName());
			ps.setString(4,view.getPages());
			ps.setString(5,view.getMemo());
			ps.setString(6,view.getVersion());
			ps.setString(7,view.getControlledNumber());
			ps.setString(8,view.getState());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}

	/*
	 * 根据主键查询
	 */
	public SystemFile queryByPK(String pk) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		SystemFile view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_system_file");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			view = this.changeRsToView(rs);
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{	
			Tool.closeConnection(rs, ps, conn);
		}
		return view;
	}
	
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<SystemFile> changeResultSet(ResultSet rs) {
		List<SystemFile> list = new ArrayList<SystemFile>();
		SystemFile view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new SystemFile();
				view.setPk(rs.getString("pk"));
				view.setCode(rs.getString("code"));
				view.setName(rs.getString("name"));
				view.setControlledNumber(rs.getString("controlled_number"));
				view.setMemo(rs.getString("memo"));
				view.setPages(rs.getString("pages"));
				view.setState(rs.getString("state"));
				view.setVersion(rs.getString("version"));
				list.add(view);
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return list;
	}

	/*
	 * 根据主键批量删除
	 */
	public void batchDeleteByPK(String[] pk){

		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_system_file where pk in(");
		for (int i = 0; i < pk.length; i++) {
			sql.append("'");
			sql.append(pk[i]);
			sql.append("'");
			sql.append(",");	
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 结果集到实体对象的转换
	 */
	private SystemFile changeRsToView(ResultSet rs) {

		SystemFile view = new SystemFile();
		try {
			if (rs.next()) {
				view.setPk(rs.getString("pk"));
				view.setCode(rs.getString("code"));
				view.setName(rs.getString("name"));
				view.setMemo(rs.getString("memo"));
				view.setControlledNumber(rs.getString("controlled_number"));
				view.setPages(rs.getString("pages"));
				view.setState(rs.getString("state"));
				view.setVersion(rs.getString("version"));
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return view;
	}
	/*
	 * 接收一个 SystemFile 对象作为查询条件。
	 * 返回值Map{
	 * key：count—— 符合条件总记录数
	 * key：list—— 返回指定页的记录
	 * }
	 */
		public Map<String, Object> querySystemFile(SystemFile view) {
			Connection conn=pool.getConnection();
			PreparedStatement ps1 = null;
			ResultSet rs1 = null;
			PreparedStatement ps2 = null;
			ResultSet rs2 = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			List<SystemFile> list = new ArrayList<SystemFile>();	
			String wheresql = this.getWhereSql(view);

			//countSql 查询符合指定条件的总记录数。
			int count = 0;
			StringBuffer countSql = new StringBuffer();
			countSql.append("select count(*) from t_system_file where 1=1 ");
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
					sql.append("  * FROM t_system_file where pk not in(select top ");
					sql.append(view.getPageSize()*(view.getShowPage()-1));
					sql.append(" pk from t_system_file where 1=1");
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
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs1, ps1, null);
				Tool.closeConnection(rs2, ps2, conn);
			} 
			map.put("count", count);		
			map.put("list",list);
			return map;		
		}
	/*
	 * 获取查询wheresql语句
	 */
	private String getWhereSql(SystemFile view){
		/*
		 * 按照项目编号、名称、受控号、状态（有效、已废弃）查询
		 * code  name  controlled_number  state
		 */
		StringBuffer wheresql = new StringBuffer();
		if(!"".equals(view.getState())){		
			wheresql.append(" and state = '");
			wheresql.append(view.getState());
			wheresql.append("'");
		}	
		if(!"".equals(view.getCode())){		
			wheresql.append(" and code like '%");
			wheresql.append(view.getCode());
			wheresql.append("%'");
		}
		if(!"".equals(view.getName())){		
			wheresql.append(" and name like '%");
			wheresql.append(view.getName());
			wheresql.append("%'");
		}
		if(!"".equals(view.getControlledNumber())){		
			wheresql.append(" and controlled_number like '%");
			wheresql.append(view.getControlledNumber());
			wheresql.append("%'");
		}		
		return wheresql.toString();
	}
	/*
	 * 导出excel
	 */
		public List<SystemFile> export(SystemFile view) {
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			List<SystemFile> list = new ArrayList<SystemFile>();
			StringBuffer sql = new StringBuffer();
			String wheresql = this.getWhereSql(view);
			sql.append("select * FROM t_system_file where 1=1");
			sql.append(wheresql);
			sql.append(" order by ");
			sql.append(view.getSort());
			sql.append(" ");
			sql.append(view.getSortType());
			try {
				ps = conn.prepareStatement(sql.toString());
				rs = ps.executeQuery();
				list = changeResultSet(rs);
			} catch (Exception e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return list;
		}
	/*
	 * 更新
	 */
	public void update(SystemFile systemfile) {
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		String sql = "update t_system_file set name=?,controlled_number=?,version=?,state=?,pages=?,memo=?,code=? where pk=?";
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, systemfile.getName());
			ps.setString(2, systemfile.getControlledNumber());
			ps.setString(3, systemfile.getVersion());
			ps.setString(4, systemfile.getState());
			ps.setString(5, systemfile.getPages());
			ps.setString(6, systemfile.getMemo());
			ps.setString(7, systemfile.getCode());
			ps.setString(8, systemfile.getPk());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	
}
