package cn.sdfi.defect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import org.apache.log4j.Logger;

import cn.sdfi.defect.bean.ChartDefect;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class ChartDefectDao{

	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(ChartDefectDao.class);

	/*
	 * 接收一个 ChartDefect 对象作为查询条件。
	 * 返回值Map{
	 * key：count—— 符合条件总记录数
	 * key：list—— 返回指定页的记录
	 * }
	 */
		public Map<String, Object> query(ChartDefect view) {
			
			Connection conn=pool.getConnection();
			PreparedStatement ps1 = null;
			ResultSet rs1 = null;
			PreparedStatement ps2 = null;
			ResultSet rs2 = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			List<ChartDefect> list = new ArrayList<ChartDefect>();	
			String wheresql = this.getWhereSql(view);

			//countSql 查询符合指定条件的总记录数。
			int count = 0;
			StringBuffer countSql = new StringBuffer();
			countSql.append("select count(*) from t_defect_chart where 1=1 ");
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
					sql.append("  * FROM t_defect_chart where pk not in(select top ");
					sql.append(view.getPageSize()*(view.getShowPage()-1));
					sql.append(" pk from t_defect_chart where 1=1");
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
				Tool.closeConnection(rs2, ps2, null);
				Tool.closeConnection(rs1, ps1, conn);
			} 
			map.put("count", count);		
			map.put("list",list);
			return map;		
		}
	/*
	 * 统计分析
	 */
	public Map<String,double[]> analysis(ChartDefect view,String style){
		
		String wheresql = getWhereSql(view);
		StringBuffer sql = new StringBuffer();
		sql.append("select * from t_defect_chart where 1=1 ");
		sql.append(wheresql);
		sql.append(" order by yearMonth asc");//按照年月份进行升序排序
		
		//chart_data=1:包缺陷率环比,2:关键严重缺陷率环比,3:Reopen缺陷率环比,4:缺陷平均处理周期,O:项目整体质量
		if("1".equals(view.getChart_data())){//包缺陷率环比
			
			return analysisPackageDefectRate(sql.toString(), style);
			
		}else if("2".equals(view.getChart_data())){//关键严重缺陷率环比	
			
			return analysisSeriousDefectRate(sql.toString(), style);
			
		}else if("3".equals(view.getChart_data())){//Reopen缺陷率环比	
			
			return analysisReopenDefectRate(sql.toString(), style);
			
		}else if("4".equals(view.getChart_data())){//缺陷平均处理周期	
			
			return analysisProcessTime(sql.toString(), style);
			
		}else if("5".equals(view.getChart_data())){//缺陷平均严重程度
			return analysisDefectWeightedAverage(sql.toString(), style);
		}
		else{//项目整体质量（关键严重缺陷数、总缺陷数、缺陷加权平均数（即缺陷平均严重程度））
			
			return analysisProductQuality(sql.toString(), style);
		}

	}
	/*
	 * 统计分析-缺陷平均处理周期
	 */
	public Map<String,double[]> analysisProcessTime(String sql,String style){

		String column1 = "totalProcessTime";//总处理时长
		String column2 = "totalSeriousDefectWeight";//总缺陷加权值
		
		//平均处理周期（单位小时）= 总处理时长/关键严重缺陷加权值
		Map<String,double[]> returnMap = new HashMap<String,double[]>();
		TreeMap<Integer,Double> totalProcessTimeMap = new TreeMap<Integer, Double>();//<key:年月份    value:总处理时长>
		TreeMap<Integer,Double> totalSeriousDefectWeightMap = new TreeMap<Integer, Double>();//<key:年月份    value:关键严重缺陷加权值>	
	
		Connection conn=pool.getConnection();	
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();	
			
			if(style.equals("project_customer")){//按照部门进行统计
			
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					if(totalProcessTimeMap.containsKey(yearMonth)){//如果已存在相同月份的数据，则进行合计
						totalProcessTimeMap.put(yearMonth, totalProcessTimeMap.get(yearMonth)+rs.getDouble(column1));
						totalSeriousDefectWeightMap.put(yearMonth, totalSeriousDefectWeightMap.get(yearMonth)+rs.getDouble(column2));		
					}else{
						totalProcessTimeMap.put(yearMonth, rs.getDouble(column1));
						totalSeriousDefectWeightMap.put(yearMonth, rs.getDouble(column2));
					}
				}	
			}else if(style.equals("chart_project")){//按照项目进行统计		
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					totalProcessTimeMap.put(yearMonth, rs.getDouble(column1));
					totalSeriousDefectWeightMap.put(yearMonth, rs.getDouble(column2));
				}
			}else{
				log.error("出错了！无效的统计类型！"+style);
			}

			//如果查询结果不为空
			if(totalProcessTimeMap.size()>0){
				
				//Map<Integer,Double>----double[],double[]
				double[] processTime = new double[totalProcessTimeMap.size()];//缺陷平均处理周期
				double[] doubleYearMonth =  new double[totalProcessTimeMap.size()];//年月份
				
				int i=0;
				for (Map.Entry<Integer,Double> entry : totalProcessTimeMap.entrySet()) {
					
					//平均处理周期（单位小时）= 总处理时长/总缺陷加权值，缺陷平均处理周期不保留小数。
					processTime[i]=Tool.format(0,entry.getValue()/totalSeriousDefectWeightMap.get(entry.getKey()));
					doubleYearMonth[i]=entry.getKey();
					i++;
				}			
				returnMap.put("chartData",processTime);
				returnMap.put("yearMonth",doubleYearMonth);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return returnMap;	
	}
	/*
	 * 统计分析-项目整体质量
	 */
	public Map<String,double[]> analysisProductQuality(String sql,String style){

		String column1 = "seriousDefectNumber";
		String column2 = "defectNumber";
		String column3 = "totalDefectWeight";
		
		//缺陷平均严重程度=总缺陷加权值/总缺陷数       totalDefectWeight/defectNumber
		Map<String,double[]> returnMap = new HashMap<String,double[]>();
		TreeMap<Integer,Double> seriousDefectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:关键严重缺陷数>
		TreeMap<Integer,Double> defectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷数>
		TreeMap<Integer,Double> totalDefectWeightMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷加权值>	
		
		Connection conn=pool.getConnection();	
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();	
			
			if(style.equals("project_customer")){//按照部门进行统计	
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					if(seriousDefectNumberMap.containsKey(yearMonth)){//如果已存在相同月份的数据，则进行合计
						seriousDefectNumberMap.put(yearMonth, seriousDefectNumberMap.get(yearMonth)+rs.getDouble(column1));
						defectNumberMap.put(yearMonth, defectNumberMap.get(yearMonth)+rs.getDouble(column2));
						totalDefectWeightMap.put(yearMonth, totalDefectWeightMap.get(yearMonth)+rs.getDouble(column3));			
					}else{
						seriousDefectNumberMap.put(yearMonth, rs.getDouble(column1));
						defectNumberMap.put(yearMonth, rs.getDouble(column2));
						totalDefectWeightMap.put(yearMonth, rs.getDouble(column3));
					}
				}	
			}else if(style.equals("chart_project")){//按照项目进行统计		
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					seriousDefectNumberMap.put(yearMonth, rs.getDouble(column1));
					defectNumberMap.put(yearMonth, rs.getDouble(column2));
					totalDefectWeightMap.put(yearMonth, rs.getDouble(column3));
				}
			}else{
				log.error("出错了！无效的统计类型！"+style);
				throw new RuntimeException("出错了！无效的统计类型！"+style);
			}

			//如果查询结果不为空
			if(seriousDefectNumberMap.size()>0){
				
				//Map<Integer,Double>----double[],double[]
				double[] doubleSeriousDefectNumber = new double[seriousDefectNumberMap.size()];//关键严重缺陷数
				double[] doubleDefectNumber = new double[seriousDefectNumberMap.size()];//总缺陷数
				double[] doubleDefectWeightedAverage = new double[seriousDefectNumberMap.size()];//缺陷平均严重程度
				double[] doubleYearMonth =  new double[seriousDefectNumberMap.size()];//年月份
				
				int i=0;
				for (Map.Entry<Integer,Double> entry : seriousDefectNumberMap.entrySet()) {
					doubleYearMonth[i]=entry.getKey();
					doubleSeriousDefectNumber[i]=entry.getValue();
					i++;
				}
				i=0;
				for (Map.Entry<Integer,Double> entry : defectNumberMap.entrySet()) {
					
					//缺陷平均严重程度保留2位小数。
					doubleDefectWeightedAverage[i]=Tool.format(2,totalDefectWeightMap.get(entry.getKey())/entry.getValue());
					doubleDefectNumber[i]=entry.getValue();
					i++;
				}				
				//将doubleSeriousDefectNumber、doubleDefectNumber、doubleDefectWeightedAverage、doubleYearMonth放入returnMap返回
				returnMap.put("seriousDefectNumber",doubleSeriousDefectNumber);
				returnMap.put("defectNumber",doubleDefectNumber);
				returnMap.put("defectWeightedAverage",doubleDefectWeightedAverage);
				returnMap.put("yearMonth",doubleYearMonth);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return returnMap;	
	}
	/*
	 * 统计分析-缺陷平均严重程度
	 */
	public Map<String,double[]> analysisDefectWeightedAverage(String sql,String style){

		String column2 = "defectNumber";
		String column3 = "totalDefectWeight";
		
		//缺陷平均严重程度=总缺陷加权值/总缺陷数       totalDefectWeight/defectNumber
		Map<String,double[]> returnMap = new HashMap<String,double[]>();
		TreeMap<Integer,Double> defectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷数>
		TreeMap<Integer,Double> totalDefectWeightMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷加权值>	
	
		Connection conn=pool.getConnection();	
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();	
			
			if(style.equals("project_customer")){//按照部门进行统计
			
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					if(defectNumberMap.containsKey(yearMonth)){//如果已存在相同月份的数据，则进行合计
						defectNumberMap.put(yearMonth, defectNumberMap.get(yearMonth)+rs.getDouble(column2));
						totalDefectWeightMap.put(yearMonth, totalDefectWeightMap.get(yearMonth)+rs.getDouble(column3));			
					}else{
						defectNumberMap.put(yearMonth, rs.getDouble(column2));
						totalDefectWeightMap.put(yearMonth, rs.getDouble(column3));
					}
				}	
			}else if(style.equals("chart_project")){//按照项目进行统计		
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					defectNumberMap.put(yearMonth, rs.getDouble(column2));
					totalDefectWeightMap.put(yearMonth, rs.getDouble(column3));
				}
			}else{
				log.error("出错了！无效的统计类型！"+style);
				throw new RuntimeException("出错了！无效的统计类型！"+style);
			}

			//如果查询结果不为空
			if(defectNumberMap.size()>0){
				
				//Map<Integer,Double>----double[],double[]
				double[] doubleDefectWeightedAverage = new double[totalDefectWeightMap.size()];//缺陷平均严重程度
				double[] doubleYearMonth =  new double[defectNumberMap.size()];//年月份
				
				int i=0;
				for (Map.Entry<Integer,Double> entry : defectNumberMap.entrySet()) {
					
					//缺陷平均严重程度保留2位小数。
					doubleDefectWeightedAverage[i]=Tool.format(2,totalDefectWeightMap.get(entry.getKey())/entry.getValue());
					doubleYearMonth[i]=entry.getKey();
					i++;
				}				
				//将doubleDefectWeightedAverage、doubleYearMonth放入returnMap返回
				returnMap.put("chartData",doubleDefectWeightedAverage);
				returnMap.put("yearMonth",doubleYearMonth);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return returnMap;	
	}
	/*
	 * 统计分析-包缺陷率环比
	 */
	public Map<String,double[]> analysisPackageDefectRate(String sql,String style){

		String column1 = "packageNumber";//总包数
		String column2 = "defectNumber";//总缺陷数

		Map<String,double[]> returnMap = new HashMap<String,double[]>();
		TreeMap<Integer,Double> packageNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:总包数>
		TreeMap<Integer,Double> defectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷数>	
		
		Connection conn=pool.getConnection();	
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();	
			
			if(style.equals("project_customer")){//按照部门进行统计
			
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					if(packageNumberMap.containsKey(yearMonth)){//如果已存在相同月份的数据，则进行合计
						packageNumberMap.put(yearMonth, packageNumberMap.get(yearMonth)+rs.getDouble(column1));
						defectNumberMap.put(yearMonth, defectNumberMap.get(yearMonth)+rs.getDouble(column2));			
					}else{
						packageNumberMap.put(yearMonth, rs.getDouble(column1));
						defectNumberMap.put(yearMonth, rs.getDouble(column2));
					}
				}	
			}else if(style.equals("chart_project")){//按照项目进行统计		
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					packageNumberMap.put(yearMonth, rs.getDouble(column1));
					defectNumberMap.put(yearMonth, rs.getDouble(column2));
				}
			}else{
				log.error("出错了！无效的统计类型！"+style);
				throw new RuntimeException("出错了！无效的统计类型！"+style);
			}

			//如果查询结果不为空
			if(packageNumberMap.size()>0){
				
				//Map<Integer,Double>----double[],double[]
				double[] doublePackageDefectRate = new double[packageNumberMap.size()];//包缺陷率
				double[] doubleYearMonth =  new double[packageNumberMap.size()];//年月份
				
				int i=0;
				for (Map.Entry<Integer,Double> entry : packageNumberMap.entrySet()) {
					
					//包缺陷率=总缺陷数/总包数，包缺陷率保留一位小数。
					doublePackageDefectRate[i]=Tool.format(1,defectNumberMap.get(entry.getKey())/entry.getValue());
					doubleYearMonth[i]=entry.getKey();
					i++;
				}		
				returnMap.put("chartData",doublePackageDefectRate);
				returnMap.put("yearMonth",doubleYearMonth);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return returnMap;	
	}
	/*
	 * 统计分析-关键严重缺陷率环比
	 */
	public Map<String,double[]> analysisSeriousDefectRate(String sql,String style){

		String column1 = "seriousDefectNumber";//关键严重缺陷数
		String column2 = "defectNumber";//总缺陷数

		Map<String,double[]> returnMap = new HashMap<String,double[]>();
		TreeMap<Integer,Double> seriousDefectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:关键严重缺陷数>
		TreeMap<Integer,Double> defectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷数>	
		
		Connection conn=pool.getConnection();	
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();	
			
			if(style.equals("project_customer")){//按照部门进行统计
			
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					if(seriousDefectNumberMap.containsKey(yearMonth)){//如果已存在相同月份的数据，则进行合计
						seriousDefectNumberMap.put(yearMonth, seriousDefectNumberMap.get(yearMonth)+rs.getDouble(column1));
						defectNumberMap.put(yearMonth, defectNumberMap.get(yearMonth)+rs.getDouble(column2));			
					}else{
						seriousDefectNumberMap.put(yearMonth, rs.getDouble(column1));
						defectNumberMap.put(yearMonth, rs.getDouble(column2));
					}
				}	
			}else if(style.equals("chart_project")){//按照项目进行统计		
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					seriousDefectNumberMap.put(yearMonth, rs.getDouble(column1));
					defectNumberMap.put(yearMonth, rs.getDouble(column2));
				}
			}else{
				log.error("出错了！无效的统计类型！"+style);
				throw new RuntimeException("出错了！无效的统计类型！"+style);
			}

			//如果查询结果不为空
			if(seriousDefectNumberMap.size()>0){
				
				//Map<Integer,Double>----double[],double[]
				double[] doubleSeriousDefectRate = new double[seriousDefectNumberMap.size()];//关键严重缺陷率
				double[] doubleYearMonth =  new double[seriousDefectNumberMap.size()];//年月份
				
				int i=0;
				for (Map.Entry<Integer,Double> entry : seriousDefectNumberMap.entrySet()) {
					
					//关键严重缺陷率环比=关键严重缺陷数/总缺陷数
					doubleSeriousDefectRate[i]=entry.getValue()/defectNumberMap.get(entry.getKey());
					doubleYearMonth[i]=entry.getKey();
					i++;
				}		
				returnMap.put("chartData",doubleSeriousDefectRate);
				returnMap.put("yearMonth",doubleYearMonth);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return returnMap;	
	}
	/*
	 * 统计分析-Reopen缺陷率环比
	 */
	public Map<String,double[]> analysisReopenDefectRate(String sql,String style){

		String column1 = "reopenNumber";//Reopen缺陷数
		String column2 = "defectNumber";//总缺陷数

		Map<String,double[]> returnMap = new HashMap<String,double[]>();
		TreeMap<Integer,Double> reopenNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:Reopen缺陷数>
		TreeMap<Integer,Double> defectNumberMap = new TreeMap<Integer, Double>();//<key:年月份    value:总缺陷数>	
		Connection conn=pool.getConnection();	
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();	
			
			if(style.equals("project_customer")){//按照部门进行统计
			
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					if(reopenNumberMap.containsKey(yearMonth)){//如果已存在相同月份的数据，则进行合计
						reopenNumberMap.put(yearMonth, reopenNumberMap.get(yearMonth)+rs.getDouble(column1));
						defectNumberMap.put(yearMonth, defectNumberMap.get(yearMonth)+rs.getDouble(column2));			
					}else{
						reopenNumberMap.put(yearMonth, rs.getDouble(column1));
						defectNumberMap.put(yearMonth, rs.getDouble(column2));
					}
				}	
			}else if(style.equals("chart_project")){//按照项目进行统计		
				while (rs.next()) {
					int yearMonth = rs.getInt("yearMonth");
					reopenNumberMap.put(yearMonth, rs.getDouble(column1));
					defectNumberMap.put(yearMonth, rs.getDouble(column2));
				}
			}else{
				log.error("出错了！无效的统计类型！"+style);
				throw new RuntimeException("出错了！无效的统计类型！"+style);
			}

			//如果查询结果不为空
			if(reopenNumberMap.size()>0){
				
				//Map<Integer,Double>----double[],double[]
				double[] doubleReopenDefectRate = new double[reopenNumberMap.size()];//Reopen缺陷率
				double[] doubleYearMonth =  new double[reopenNumberMap.size()];//年月份
				
				int i=0;
				for (Map.Entry<Integer,Double> entry : reopenNumberMap.entrySet()) {
					
					//关键严重缺陷率环比=关键严重缺陷数/总缺陷数
					doubleReopenDefectRate[i]=entry.getValue()/defectNumberMap.get(entry.getKey());
					doubleYearMonth[i]=entry.getKey();
					i++;
				}		
				returnMap.put("chartData",doubleReopenDefectRate);
				returnMap.put("yearMonth",doubleYearMonth);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return returnMap;	
	}
	/*
	 * 按照 所选所属部门进行精确查询 project_customer（技术中心、烟草。。。）
	 * 按照  所选项目进行精确查询 chart_project（楼上平台、杭州物流、。。。
	 * 按照 时间段进行范围查询 yearMonth（201005--201009）
	 * select * from t_defect_chart where yearMonth>201003 and yearMonth<=201009
	 */
	private String getWhereSql(ChartDefect view){
		StringBuffer wheresql = new StringBuffer();
		if(!"".equals(view.getChart_project())){		
			wheresql.append(" and chart_project = '");
			wheresql.append(view.getChart_project());
			wheresql.append("'");
		}
		if(!"".equals(view.getProject_customer())){		
			wheresql.append(" and project_customer = '");
			wheresql.append(view.getProject_customer());
			wheresql.append("'");
		}
		if(view.getYearMonth_begin()!=0){		
			wheresql.append(" and yearMonth >= '");
			wheresql.append(view.getYearMonth_begin());
			wheresql.append("'");
		}
		if(view.getYearMonth_end()!=0){		
			wheresql.append(" and yearMonth <= '");
			wheresql.append(view.getYearMonth_end());
			wheresql.append("'");
		}
		return wheresql.toString();
	}
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<ChartDefect> changeResultSet(ResultSet rs) {
		List<ChartDefect> list = new ArrayList<ChartDefect>();
		ChartDefect view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new ChartDefect();
				view.setPk(rs.getString("pk"));
				view.setYearMonth(rs.getInt("yearMonth"));//年月
				view.setSeriousDefectNumber(rs.getInt("seriousDefectNumber"));//关键严重缺陷数
				view.setDefectNumber(rs.getInt("defectNumber"));//总缺陷数
				view.setReopenNumber(rs.getInt("reopenNumber"));//Reopen缺陷数
				view.setPackageNumber(rs.getInt("packageNumber"));//总包数
				view.setTotalDefectWeight(rs.getFloat("totalDefectWeight"));//总缺陷加权值
				view.setTotalProcessTime(rs.getFloat("totalProcessTime"));//总处理时长
				view.setChart_project(rs.getString("chart_project"));//产品ID
				view.setProject_customer(rs.getString("project_customer"));//所属部门	
				view.setTotalSeriousDefectWeight(rs.getFloat("totalSeriousDefectWeight"));
				list.add(view);
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return list;
	}
	/*
	 * 执行保存
	 */
	public void save(ChartDefect view) {
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into t_defect_chart");
		sql.append("(pk,yearMonth,seriousDefectNumber,defectNumber,reopenNumber,packageNumber,totalDefectWeight,totalProcessTime,chart_project,project_customer,totalSeriousDefectWeight)") ;
		sql.append(" values(?,?,?,?,?,?,?,?,?,?,?)");
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;

		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,view.getPk());
			ps.setInt(2,view.getYearMonth());
			ps.setInt(3, view.getSeriousDefectNumber());
			ps.setInt(4, view.getDefectNumber());
			ps.setInt(5, view.getReopenNumber());
			ps.setInt(6, view.getPackageNumber());
			ps.setFloat(7, view.getTotalDefectWeight());
			ps.setFloat(8, view.getTotalProcessTime());
			ps.setString(9,view.getChart_project());
			ps.setString(10, view.getProject_customer());
			ps.setFloat(11, view.getTotalSeriousDefectWeight());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}	
	}
	/*
	 *检验指定月份、指定项目的记录是否已经存在。
	 */
	public boolean isExist(String yearMonth,String chart_project) {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select * FROM t_defect_chart where yearMonth=? and chart_project=?";
		boolean flag = false;
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1,yearMonth);
			ps.setString(2, chart_project);
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
	 * 根据主键批量删除
	 */
	public void batchDeleteByPK(String[] pk){

		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_defect_chart where pk in(");
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
	 * 根据主键查询
	 */
	public ChartDefect queryByPK(String pk) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		ChartDefect view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_defect_chart");
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
	 * 结果集到实体对象的转换
	 */
	private ChartDefect changeRsToView(ResultSet rs) {
		ChartDefect view = new ChartDefect();
		try {
			if (rs.next()) {
				view = new ChartDefect();
				view.setPk(rs.getString("pk"));
				view.setYearMonth(rs.getInt("yearMonth"));
				view.setSeriousDefectNumber(rs.getInt("seriousDefectNumber"));
				view.setDefectNumber(rs.getInt("defectNumber"));
				view.setReopenNumber(rs.getInt("reopenNumber"));
				view.setPackageNumber(rs.getInt("packageNumber"));
				view.setTotalDefectWeight(rs.getFloat("totalDefectWeight"));
				view.setTotalProcessTime(rs.getFloat("totalProcessTime"));
				view.setChart_project(rs.getString("chart_project"));
				view.setProject_customer(rs.getString("project_customer"));
				view.setTotalSeriousDefectWeight(rs.getFloat("totalSeriousDefectWeight"));
				
				//须计算才能得到的数据
				if(view.getTotalDefectWeight()==0){//如果总缺陷权值等于0
					view.setProcessTime(0.0f);
					view.setDefectWeightedAverage(0.0f);
					view.setSeriousDefectRate(0.0000f);
					view.setReopenDefectRate(0.0000f);
				}else{		
					view.setProcessTime(Tool.format(1,view.getTotalProcessTime()/view.getTotalSeriousDefectWeight()));// 缺陷平均处理周期=总处理时长/关键严重缺陷加权值
					view.setDefectWeightedAverage(Tool.format(2,view.getTotalDefectWeight()/view.getDefectNumber()));//缺陷平均严重程度=总缺陷加权值/总缺陷数
					view.setSeriousDefectRate(Tool.format(4,view.getSeriousDefectNumber()/(view.getDefectNumber()+0.0f)));//严重缺陷占比=严重缺陷数/总缺陷数
					view.setReopenDefectRate(Tool.format(4,view.getReopenNumber()/(view.getDefectNumber()+0.0f)));//reopen缺陷占比=reopen缺陷数/总缺陷数
				}
				if(view.getPackageNumber()==0){//如果总包数等于0
					view.setPackageDefectRate(0.0f);
				}else{	
					view.setPackageDefectRate(Tool.format(2,view.getDefectNumber()/(view.getPackageNumber()+0.0f)));//包缺陷率=总缺陷数/总包数
				}
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return view;
	}
	/*
	 * 更新
	 * 此处是无需对“所属部门”进行修改的
	 */
	public void update(ChartDefect view) {	

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer("update t_defect_chart set yearMonth=?,seriousDefectNumber=?,defectNumber=?,reopenNumber=?,packageNumber=?,totalDefectWeight=?,totalProcessTime=?,chart_project=?,totalSeriousDefectWeight=? where pk=?");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setInt(1,view.getYearMonth());
			ps.setInt(2, view.getSeriousDefectNumber());
			ps.setInt(3, view.getDefectNumber());
			ps.setInt(4, view.getReopenNumber());
			ps.setInt(5, view.getPackageNumber());
			ps.setFloat(6,view.getTotalDefectWeight());
			ps.setFloat(7, view.getTotalProcessTime());
			ps.setString(8,view.getChart_project());
			ps.setFloat(9,view.getTotalSeriousDefectWeight());
			ps.setString(10,view.getPk());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}	
	}
}
