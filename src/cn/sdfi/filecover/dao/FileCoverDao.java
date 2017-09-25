package cn.sdfi.filecover.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.filecover.bean.FileCover;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class FileCoverDao{

	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(FileCoverDao.class);
	
	/*
	 * 执行保存
	 */
	public void save(FileCover view){

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer("insert into t_file_cover(pk,file_cover_code,file_cover_name,file_cover_type,file_cover_year,memo)values(?,?,?,?,?,?)");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getPk());
			ps.setString(2, view.getFile_cover_code());
			ps.setString(3, view.getFile_cover_name());
			ps.setString(4, view.getFile_cover_type());
			ps.setString(5, view.getFile_cover_year());
			ps.setString(6, view.getMemo());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}

	/*
	 * 按主键查询
	 */
	public FileCover queryByPK(String pk) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		FileCover view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_file_cover");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {		
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			view = this.changeRsToView(rs);
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		}
		return view;
	}
	/*
	 * 按档案袋编码查询，档案袋编码在系统中唯一的，所以返回一个档案袋对象。
	 */
	public FileCover queryByFileCoverCode(String file_cover_code) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		FileCover view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_file_cover");
		sql.append(" WHERE file_cover_code='");
		sql.append(file_cover_code);
		sql.append("'");
		try {		
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();	
			view = this.changeRsToView(rs);
		} catch (Exception e) {
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
	private List<FileCover> changeResultSet(ResultSet rs) {
		
		List<FileCover> list = new ArrayList<FileCover>();
		FileCover view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new FileCover();
				view.setPk(rs.getString("pk"));
				view.setFile_cover_code(rs.getString("file_cover_code"));
				view.setFile_cover_name(rs.getString("file_cover_name"));
				view.setFile_cover_year(rs.getString("file_cover_year"));
				view.setFile_cover_type(rs.getString("file_cover_type"));
				view.setMemo(rs.getString("memo"));
				list.add(view);
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return list;
	}

	/*
	 * 根据主键数组批量删除
	 */
	public void batchDeleteByPk(String [] pk){

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		
		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_file_cover where pk in (");
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
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}
	}

	/*
	 * 结果集到实体对象的转换
	 */
	private FileCover changeRsToView(ResultSet rs) throws Exception {
		
		FileCover view = new FileCover();
		if (rs.next()) {
			view.setPk(rs.getString("pk"));
			view.setFile_cover_code(rs.getString("file_cover_code"));
			view.setFile_cover_name(rs.getString("file_cover_name"));
			view.setFile_cover_type(rs.getString("file_cover_type"));
			view.setFile_cover_year(rs.getString("file_cover_year"));
			view.setMemo(rs.getString("memo"));		
		}
		return view;
	}
	/*
	 * 接收一个 FileCover 对象作为查询条件，查询结果将以 list 的形式返回。
	 */
		public  Map<String, Object> queryByFileCover(FileCover filecover) {
		
			Connection conn=pool.getConnection();
			PreparedStatement ps1 = null;
			ResultSet rs1 = null;
			PreparedStatement ps2 = null;
			ResultSet rs2 = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			List<FileCover> list = new ArrayList<FileCover>();
			
			/*
			 * 按照档案袋编码进行模糊查询询
			 * 按照档案袋名称进行模糊查询
			 * 按照年度进行精确查询
			 * 按照档案袋类型进行精确查询
			 */
			String code = filecover.getFile_cover_code();
			String name = filecover.getFile_cover_name();
			String year = filecover.getFile_cover_year();
			String type = filecover.getFile_cover_type();
		
			StringBuffer wheresql = new StringBuffer();		
			if(!"".equals(type)){		
				wheresql.append(" and file_cover_type = '");
				wheresql.append(type);
				wheresql.append("'");
			}	
			if(!"".equals(year)){		
				wheresql.append(" and file_cover_year = '");
				wheresql.append(year);
				wheresql.append("'");
			}
			if(!"".equals(code)){		
				wheresql.append(" and file_cover_code like '%");
				wheresql.append(code);
				wheresql.append("%'");
			}
			if(!"".equals(name)){		
				wheresql.append(" and file_cover_name like '%");
				wheresql.append(name);
				wheresql.append("%'");
			}	
			//countSql 查询符合指定条件的总记录数。
			int count = 0;
			StringBuffer countSql = new StringBuffer();
			countSql.append("select count(*) from t_file_cover where 1=1 ");
			countSql.append(wheresql);
			try {
				ps1 = conn.prepareStatement(countSql.toString());
				rs1 = ps1.executeQuery();
				if(rs1.next()){	
					count = rs1.getInt(1);
				}
				//如果查询结果不为空
				if(count>0){
				wheresql.append(" order by ");
				wheresql.append(filecover.getSort());
				wheresql.append(" ");
				wheresql.append(filecover.getSortType());
				
				StringBuffer sql = new StringBuffer();	
				sql.append("select top ");
				sql.append(filecover.getPageSize());
				sql.append(" * FROM t_file_cover where pk not in(select top ");
				sql.append(filecover.getPageSize()*(filecover.getShowPage()-1));
				sql.append(" pk from t_file_cover where 1=1");
				sql.append(wheresql);
				sql.append(")");
				sql.append(wheresql);

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
		 * 导出excel
		 */
			public List<FileCover> export(FileCover filecover) {
				Connection conn=pool.getConnection();
				PreparedStatement ps = null;
				ResultSet rs = null;
				
				List<FileCover> list = new ArrayList<FileCover>();
				
				/*
				 * 按照档案袋编码进行模糊查询询
				 * 按照档案袋名称进行模糊查询
				 * 按照年度进行精确查询
				 * 按照档案袋类型进行精确查询
				 */
				String code = filecover.getFile_cover_code();
				String name = filecover.getFile_cover_name();
				String year = filecover.getFile_cover_year();
				String type = filecover.getFile_cover_type();
			
				StringBuffer wheresql = new StringBuffer();		
				if(!"".equals(type)){		
					wheresql.append(" and file_cover_type = '");
					wheresql.append(type);
					wheresql.append("'");
				}	
				if(!"".equals(year)){		
					wheresql.append(" and file_cover_year = '");
					wheresql.append(year);
					wheresql.append("'");
				}
				if(!"".equals(code)){		
					wheresql.append(" and file_cover_content_code like '%");
					wheresql.append(code);
					wheresql.append("%'");
				}
				if(!"".equals(name)){		
					wheresql.append(" and file_cover_content_name like '%");
					wheresql.append(name);
					wheresql.append("%'");
				}	
				wheresql.append(" order by ");
				wheresql.append(filecover.getSort());
				wheresql.append(" ");
				wheresql.append(filecover.getSortType());
				
				StringBuffer sql = new StringBuffer();	
				sql.append("select * FROM t_file_cover where 1=1 ");
				sql.append(wheresql);
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
	public void update(FileCover filecover) {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuffer sql = new StringBuffer("update t_file_cover set file_cover_code=?,file_cover_name=?,file_cover_type=?,file_cover_year=?,memo=?  where pk=?");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, filecover.getFile_cover_code());
			ps.setString(2, filecover.getFile_cover_name());
			ps.setString(3, filecover.getFile_cover_type());
			ps.setString(4, filecover.getFile_cover_year());
			ps.setString(5, filecover.getMemo());
			ps.setString(6, filecover.getPk());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(rs, ps, conn);
		} 
	}
	/*
	 * 检查该档案袋编号是否已存在
	 */
	public boolean isExist(String file_cover_code) {
		boolean isExist=false;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select pk from t_file_cover where file_cover_code=?";
		
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1,file_cover_code);
			rs = ps.executeQuery();
			if(rs.next()){
				isExist=true;
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(rs, ps, conn);
		} 
		return isExist;
	}
}
