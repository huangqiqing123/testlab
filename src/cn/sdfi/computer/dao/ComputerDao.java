package cn.sdfi.computer.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.computer.bean.Computer;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class ComputerDao{
	
	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(ComputerDao.class);
	
	/*
	 * 执行保存
	 */
	public void save(Computer view) {
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into t_computer");
		sql.append("(pk,computer_type,code,name,owner,serial_number,type,manufactory,begin_use_time,use_site,status,configuration,ip,memo)") ;
		sql.append(" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;

		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,view.getPk());
			ps.setString(2,view.getComputer_type());
			ps.setString(3,view.getCode());
			ps.setString(4,view.getName());
			ps.setString(5,view.getOwner());
			ps.setString(6,view.getSerial_number());
			ps.setString(7,view.getType());
			ps.setString(8,view.getManufactory());
			ps.setString(9,view.getBegin_use_time());
			ps.setString(10,view.getUse_site());
			ps.setString(11,view.getStatus());
			ps.setString(12,view.getConfiguration());
			ps.setString(13,view.getIp());
			ps.setString(14,view.getMemo());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("保存设备信息出错！",e);
			throw new RuntimeException("保存设备信息出错！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}	
	}

	
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<Computer> changeResultSet(ResultSet rs) {
		
		List<Computer> list=new ArrayList<Computer>();
		Computer view=null;
		if (rs==null) {
			return list;
		}
		try {
			while(rs.next()){			
				view=new Computer();
				view.setPk(rs.getString("pk"));
				view.setComputer_type(rs.getString("computer_type"));
				view.setCode(rs.getString("code"));
				view.setName(rs.getString("name"));
				view.setOwner(rs.getString("owner"));
				view.setSerial_number(rs.getString("serial_number"));
				view.setType(rs.getString("type"));
				view.setManufactory(rs.getString("manufactory"));
				view.setBegin_use_time(rs.getString("begin_use_time"));
				view.setUse_site(rs.getString("use_site"));
				view.setStatus(rs.getString("status"));
				view.setConfiguration(rs.getString("configuration"));
				view.setIp(rs.getString("ip"));
				view.setMemo(rs.getString("memo"));
				list.add(view);	
			}
		} catch (SQLException e) {
			log.error("转换bean异常！",e);
			throw new RuntimeException("转换bean异常！",e);
		}
		return list;
	}
	
	/*
	 * 按照设备主键批量删除
	 */
	public void batchDeleteByPk(String [] pk){

		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_computer where pk in (");
		for (int i = 0; i < pk.length; i++) {
			sql.append("'");
			sql.append(pk[i]);
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
			log.error("执行删除操作出错！",e);
			throw new RuntimeException("执行删除操作出错！",e);
		}finally{	
			Tool.closeConnection(null, ps, conn);
		}
	}
	
/*
 * 修改
 */
	public void update(Computer computer){
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer("update t_computer set computer_type=?,code=?,name=?,owner=?,serial_number=?,type=?,manufactory=?,begin_use_time=?,use_site=?,status=?,configuration=?,ip=?,memo=? where pk=?");

		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, computer.getComputer_type());
			ps.setString(2, computer.getCode());
			ps.setString(3, computer.getName());
			ps.setString(4, computer.getOwner());
			ps.setString(5, computer.getSerial_number());
			ps.setString(6, computer.getType());
			ps.setString(7, computer.getManufactory());
			ps.setString(8, computer.getBegin_use_time());
			ps.setString(9, computer.getUse_site());
			ps.setString(10, computer.getStatus());
			ps.setString(11, computer.getConfiguration());
			ps.setString(12, computer.getIp());
			ps.setString(13, computer.getMemo());
			ps.setString(14, computer.getPk());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("更新操作出错！",e);
			throw new RuntimeException("更新操作出错！",e);
		}finally{	
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 结果集到实体对象的转换
	 */
	public Computer changeRsToView(ResultSet rs){	
		Computer view = new Computer();
		try {
			if (rs.next()) {
				view.setPk(rs.getString("pk"));
				view.setComputer_type(rs.getString("computer_type"));
				view.setCode(rs.getString("code"));
				view.setName(rs.getString("name"));
				view.setOwner(rs.getString("owner"));
				view.setSerial_number(rs.getString("serial_number"));
				view.setType(rs.getString("type"));
				view.setManufactory(rs.getString("manufactory"));
				view.setBegin_use_time(rs.getString("begin_use_time"));
				view.setUse_site(rs.getString("use_site"));
				view.setStatus(rs.getString("status"));
				view.setConfiguration(rs.getString("configuration"));
				view.setIp(rs.getString("ip"));
				view.setMemo(rs.getString("memo"));
				}
		} catch (Exception e) {
			log.error("转换bean异常！",e);
			throw new RuntimeException("转换bean异常！",e);
		}	
		return view;
	}
	/*
	 * 按照主键进行查询
	 */
	public Computer queryByPK(String pk) {
	
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		Computer computer = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_computer");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {		
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			computer = changeRsToView(rs);	
		} catch (Exception e) {
			log.error("查询异常！",e);
			throw new RuntimeException("查询异常！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return computer;
	}
	/*
	 * 导出excel
	 */
		public List<Computer> export(Computer view) {
			
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			
			List<Computer> list = new ArrayList<Computer>();
			StringBuffer sql = new StringBuffer();
			String wheresql = this.getWhereSql(view);
			sql.append("select * FROM t_computer where 1=1");
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
				log.error("查询异常！",e);
				throw new RuntimeException("查询异常！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return list;
		}
		//获取查询sql语句
		private String getWhereSql(Computer view){
			/*
			 * 查询字段：设备编号、领用人、IP、状态、设备类型
			 */
			StringBuffer wheresql = new StringBuffer();
			if(!"".equals(view.getCode())){		
				wheresql.append(" and code like '%");
				wheresql.append(view.getCode());
				wheresql.append("%'");
			}
			if(!"".equals(view.getOwner())){		
				wheresql.append(" and owner like '%");
				wheresql.append(view.getOwner());
				wheresql.append("%'");
			}
			if(!"".equals(view.getIp())){		
				wheresql.append(" and ip like '%");
				wheresql.append(view.getIp());
				wheresql.append("%'");
			}	
			if(!"".equals(view.getStatus())){		
				wheresql.append(" and status like '%");
				wheresql.append(view.getStatus());
				wheresql.append("%'");
			}	
			if(!"".equals(view.getComputer_type())){		
				wheresql.append(" and computer_type like '%");
				wheresql.append(view.getComputer_type());
				wheresql.append("%'");
			}	
			return wheresql.toString();
		}
	/*
	 * 接收一个 Computer 对象作为查询条件。
	 */
		public Map<String, Object> queryByComputer(Computer view) {
			
			Connection conn=pool.getConnection();
			PreparedStatement ps1 = null;
			ResultSet rs1 = null;
			PreparedStatement ps2 = null;
			ResultSet rs2 = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			List<Computer> list = new ArrayList<Computer>();	
			String wheresql = this.getWhereSql(view);

			//countSql 查询符合指定条件的总记录数。
			int count = 0;
			StringBuffer countSql = new StringBuffer();
			countSql.append("select count(*) from t_computer where 1=1 ");
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
					sql.append("  * FROM t_computer where pk not in(select top ");
					sql.append(view.getPageSize()*(view.getShowPage()-1));
					sql.append(" pk from t_computer where 1=1");
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
				log.error("查询异常！",e);
				throw new RuntimeException("查询异常！",e);
			}finally{
				Tool.closeConnection(rs1, ps1, null);
				Tool.closeConnection(rs2, ps2, conn);
			} 
			map.put("count", count);		
			map.put("list",list);
			return map;		
		}
		/*
		 * 按照设备编码进行精确查询，检查该编码是否已存在，存在返回true，不存在返回false。
		 */
		public boolean isExist(String code) {
			boolean flag = false;
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			String sql = "select * FROM t_computer where code = ?";
			try {
				ps = conn.prepareStatement(sql);
				ps.setString(1,code);
				rs = ps.executeQuery();
				if(rs.next()){
					flag=true;
				}
			} catch (Exception e) {
				log.error("查询异常！",e);
				throw new RuntimeException("查询异常！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return flag;		
		}
}
