package cn.sdfi.filecovercontent.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import cn.sdfi.filecovercontent.bean.FileCoverContent;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class FileCoverContentDao{
	
	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(FileCoverContentDao.class);
	
	/*
	 * 执行保存
	 */
	public void save(FileCoverContent view) {		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer();
		sql.append("insert into t_file_cover_content(pk,fk,file_cover_content_code,file_cover_content_name,pages,version,memo)values(?,?,?,?,?,?,?)");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getPk());
			ps.setString(2, view.getFk());
			ps.setString(3, view.getFile_cover_content_code());
			ps.setString(4, view.getFile_cover_content_name());
			ps.setString(5, view.getPages());
			ps.setString(6, view.getVersion());
			ps.setString(7, view.getMemo());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}		
	}
	/*
	 * 查询数据库中所有记录，返回由主键组成的List
	 */
	public List<String> getAllPks() {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<String> pks = new ArrayList<String>();
		String sql = "SELECT pk FROM t_file_cover_content";
		try {	
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){	
				pks.add(rs.getString("pk"));
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return pks;
	}
	/*
	 * 检查该文件编号是否已存在
	 */
	public boolean isExist(String file_cover_code) {
		boolean isExist=false;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select pk from t_file_cover_content where file_cover_content_code=?";	
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
	/*
	 * 按 档案袋主键进行查询
	 */
	public List<FileCoverContent> queryByFK(String fk){
		
		List<FileCoverContent> list=null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM  t_file_cover_content");
		sql.append(" WHERE fk='");
		sql.append(fk);
		sql.append("'");
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			rs=ps.executeQuery();
			list=changeResultSet(rs);
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return list;
	}
	/*
	 * 根据文件的外键（档案袋的主键），获取对应的文件的主键。
	 */
	public List<String> getPKsByFKs(String [] fks){
		
		List<String> list=new ArrayList<String>();
		StringBuffer sql = new StringBuffer();
		sql.append("select pk from t_file_cover_content where fk in (");
		for (int i = 0; i < fks.length; i++) {
			sql.append("'");
			sql.append(fks[i]);
			sql.append("',");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			rs=ps.executeQuery();
			while(rs.next()){
				list.add(rs.getString("pk"));
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return list;
	}
	/*
	 * 根据文件的外键（档案袋的主键），获取对应的文件的主键。
	 */
	public List<String> getPKsByFK(String fk){
		
		String[] fks = new String[1];
		fks[0] = fk;
		return this.getPKsByFKs(fks);
	}
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<FileCoverContent> changeResultSet(ResultSet rs) {
		
		List<FileCoverContent> list=new ArrayList<FileCoverContent>();
		FileCoverContent view=null;
		if (rs==null) {
			return list;
		}
		try {
			while(rs.next()){			
				view=new FileCoverContent();
				view.setPk(rs.getString("pk"));
				view.setFk(rs.getString("fk"));
				view.setFile_cover_content_code(rs.getString("file_cover_content_code"));
				view.setFile_cover_content_name(rs.getString("file_cover_content_name"));
				view.setPages(rs.getString("pages"));
				view.setVersion(rs.getString("version"));
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
	 * 按照文件主键批量删除
	 */
	public void batchDeleteByPk(String [] pk){

		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_file_cover_content where pk in (");
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
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{	
			Tool.closeConnection(null, ps, conn);
		}
	}
	
/*
 * 修改
 */
	public void update(FileCoverContent filecovercontent){
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer();
		sql.append("update t_file_cover_content set file_cover_content_name=?,file_cover_content_code=?,fk=?,pages=?,version=?,memo=? where pk=?");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, filecovercontent.getFile_cover_content_name());
			ps.setString(2, filecovercontent.getFile_cover_content_code());
			ps.setString(3, filecovercontent.getFk());
			ps.setString(4, filecovercontent.getPages());
			ps.setString(5, filecovercontent.getVersion());
			ps.setString(6, filecovercontent.getMemo());
			ps.setString(7, filecovercontent.getPk());
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
	private FileCoverContent changeRsToView(ResultSet rs) throws Exception {
		
		FileCoverContent filecovercontent = new FileCoverContent();
		if (rs.next()) {
			filecovercontent.setPk(rs.getString("pk"));
			filecovercontent.setFk(rs.getString("fk"));
			filecovercontent.setFile_cover_content_code(rs.getString("file_cover_content_code"));
			filecovercontent.setFile_cover_content_name(rs.getString("file_cover_content_name"));
			filecovercontent.setMemo(rs.getString("memo"));
			filecovercontent.setPages(rs.getString("pages"));
			filecovercontent.setVersion(rs.getString("version"));
			}
		return filecovercontent;
	}
	/*
	 * 按照主键进行查询
	 */
	public FileCoverContent queryByPK(String pk) {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		FileCoverContent filecovercontent = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_file_cover_content");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {		
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			filecovercontent = changeRsToView(rs);	
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return filecovercontent;
	}
	/*
	 * 导出excel
	 */
		public List<FileCoverContent> export(FileCoverContent filecovercontent) {
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			List<FileCoverContent> list = new ArrayList<FileCoverContent>();
			/*
			 * 按文件名称进行模糊查询
			 * 按文件编码进行模糊查询
			 * 按外键fk进行精确查询
			 */
			StringBuffer sql = new StringBuffer();
			sql.append("select * FROM t_file_cover_content where 1=1");
			if(!"".equals(filecovercontent.getFk())){		
				sql.append(" and fk ='");
				sql.append(filecovercontent.getFk());
				sql.append("'");
			}
			if(!"".equals(filecovercontent.getFile_cover_content_code())){		
				sql.append(" and file_cover_content_code like '%");
				sql.append(filecovercontent.getFile_cover_content_code());
				sql.append("%'");
			}
			if(!"".equals(filecovercontent.getFile_cover_content_name())){		
				sql.append(" and file_cover_content_name like '%");
				sql.append(filecovercontent.getFile_cover_content_name());
				sql.append("%'");
			}		
			sql.append(" order by ");
			sql.append(filecovercontent.getSort());
			sql.append(" ");
			sql.append(filecovercontent.getSortType());

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
		 * 接收一个 FileCoverContent 对象作为查询条件，查询结果将以 list 的形式返回。
		 * select top 10 * FROM t_file_cover_content where pk not in
		 * (select top 290 pk from t_file_cover_content 
		 * where file_cover_content_name like '%%' and fk like '%%' and file_cover_content_code like '%%' 
		 * order by file_cover_content_code ASC) and file_cover_content_name like '%%' 
		 * and fk like '%%' and file_cover_content_code like '%%' order by file_cover_content_code ASC
		 */
			public Map<String, Object> queryByFileCoverContent(FileCoverContent model) {
				Connection conn=pool.getConnection();
				PreparedStatement ps = null;
				ResultSet rs = null;
				Map<String, Object> map = new HashMap<String, Object>();
				List<FileCoverContent> list = new ArrayList<FileCoverContent>();
				/*
				 * 按文件名称进行模糊查询
				 * 按文件编码进行模糊查询
				 * 按外键fk进行精确查询
				 */
				String fk = model.getFk();
				String code = model.getFile_cover_content_code();
				String name = model.getFile_cover_content_name();
				
				StringBuffer wheresql = new StringBuffer();
				if(!"".equals(fk)){		
					wheresql.append(" and fk = '");
					wheresql.append(fk);
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
				//countSql 查询符合指定条件的总记录数。
				int count = 0;
				StringBuffer countSql = new StringBuffer();
				countSql.append("select count(*) from t_file_cover_content where 1=1 ");
				countSql.append(wheresql);
				try {
					ps = conn.prepareStatement(countSql.toString());
					rs = ps.executeQuery();
					if(rs.next()){	
						count = rs.getInt(1);
					}
					//如果查询结果不为空
					if(count>0){
						wheresql.append(" order by ");
						wheresql.append(model.getSort());
						wheresql.append(" ");
						wheresql.append(model.getSortType());

						//拼接获取符合指定条件的前 pageSize 条记录的sql
						StringBuffer sql = new StringBuffer();
						sql.append("select top ");
						sql.append(model.getPageSize());
						sql.append("  * FROM t_file_cover_content where pk not in(select top ");
						sql.append(model.getPageSize()*(model.getShowPage()-1));
						sql.append(" pk from t_file_cover_content where 1=1");
						sql.append(wheresql);
						sql.append(") ");
						sql.append(wheresql);

						ps = conn.prepareStatement(sql.toString());
						rs = ps.executeQuery();
						list = changeResultSet(rs);
					}
				}catch (Exception e) {
					log.error("出错了！",e);
					throw new RuntimeException("出错了！",e);
				}finally{
					Tool.closeConnection(rs, ps, null);
				} 
				map.put("count", count);		
				map.put("list",list);
				return map;
			}
			
		/*
		 * 如果档案袋编号改变，则同步修改其内的文件编号。
		 */
		public void batchUpdateFileCoverContentCode(String fk,String old_file_cover_code,String new_file_cover_code) {
			List<FileCoverContent> list = queryByFK(fk);
			String temp="";	
			for (int i = 0; i < list.size(); i++) {
				temp = list.get(i).getFile_cover_content_code();
				temp = temp.replace(old_file_cover_code, new_file_cover_code);
				list.get(i).setFile_cover_content_code(temp);
				update(list.get(i));
			}	
		}
}
