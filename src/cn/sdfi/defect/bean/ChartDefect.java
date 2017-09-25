package cn.sdfi.defect.bean;

import java.util.List;

import cn.sdfi.framework.bean.Model;

public class ChartDefect extends Model {

	private String pk;//主键
	private int yearMonth;//年月份
	
	private int defectNumber;//总缺陷数
	private int packageNumber;//总包数
	private float packageDefectRate;//包缺陷率环比
	private int seriousDefectNumber;//严重缺陷数量
	private float seriousDefectRate;//严重缺陷占比
	private int reopenNumber;//reopen缺陷数
	private float reopenDefectRate;//reopen缺陷占比
	private String chart_project;//产品ID
	private String project_customer;//所属部门	
	private float processTime;//平均处理周期（单位小时）= 总处理时长/总缺陷加权值
	private float defectWeightedAverage;//缺陷加权平均数（即缺陷平均严重程度，=总缺陷加权值/总缺陷数）
	private float totalDefectWeight;//总缺陷加权值
	private float totalSeriousDefectWeight;//关键严重缺陷加权值
	private float totalProcessTime;//总处理时长
	
	
	//按照时间段查询时使用
	private int yearMonth_begin;//起始月份
	private int yearMonth_end;//结束月份
	private List<String> chart_projects;//所选项目
	private String chart_data;//统计数据（包缺陷率、严重缺陷占比。。。）
	
	
	public float getTotalSeriousDefectWeight() {
		return totalSeriousDefectWeight;
	}
	public void setTotalSeriousDefectWeight(float totalSeriousDefectWeight) {
		this.totalSeriousDefectWeight = totalSeriousDefectWeight;
	}
	public float getTotalDefectWeight() {
		return totalDefectWeight;
	}
	public void setTotalDefectWeight(float totalDefectWeight) {
		this.totalDefectWeight = totalDefectWeight;
	}
	public float getTotalProcessTime() {
		return totalProcessTime;
	}
	public void setTotalProcessTime(float totalProcessTime) {
		this.totalProcessTime = totalProcessTime;
	}
	public float getDefectWeightedAverage() {
		return defectWeightedAverage;
	}
	public void setDefectWeightedAverage(float defectWeightedAverage) {
		this.defectWeightedAverage = defectWeightedAverage;
	}
	public float getProcessTime() {
		return processTime;
	}
	public void setProcessTime(float processTime) {
		this.processTime = processTime;
	}
	public String getProject_customer() {
		return project_customer;
	}
	public void setProject_customer(String project_customer) {
		this.project_customer = project_customer;
	}
	public String getChart_project() {
		return chart_project;
	}
	public int getReopenNumber() {
		return reopenNumber;
	}
	public void setReopenNumber(int reopenNumber) {
		this.reopenNumber = reopenNumber;
	}

	public float getReopenDefectRate() {
		return reopenDefectRate;
	}
	public void setReopenDefectRate(float reopenDefectRate) {
		this.reopenDefectRate = reopenDefectRate;
	}
	public List<String> getChart_projects() {
		return chart_projects;
	}
	public void setChart_projects(List<String> chart_projects) {
		this.chart_projects = chart_projects;
	}
	public void setChart_project(String chart_project) {
		this.chart_project = chart_project;
	}
	public String getChart_data() {
		return chart_data;
	}
	public void setChart_data(String chart_data) {
		this.chart_data = chart_data;
	}

	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public int getYearMonth() {
		return yearMonth;
	}
	public void setYearMonth(int yearMonth) {
		this.yearMonth = yearMonth;
	}
	public float getPackageDefectRate() {
		return packageDefectRate;
	}
	public void setPackageDefectRate(float packageDefectRate) {
		this.packageDefectRate = packageDefectRate;
	}
	public float getSeriousDefectRate() {
		return seriousDefectRate;
	}
	public void setSeriousDefectRate(float seriousDefectRate) {
		this.seriousDefectRate = seriousDefectRate;
	}
	public int getSeriousDefectNumber() {
		return seriousDefectNumber;
	}
	public void setSeriousDefectNumber(int seriousDefectNumber) {
		this.seriousDefectNumber = seriousDefectNumber;
	}
	public int getDefectNumber() {
		return defectNumber;
	}
	public void setDefectNumber(int defectNumber) {
		this.defectNumber = defectNumber;
	}
	public int getPackageNumber() {
		return packageNumber;
	}
	public void setPackageNumber(int packageNumber) {
		this.packageNumber = packageNumber;
	}
	public int getYearMonth_begin() {
		return yearMonth_begin;
	}
	public void setYearMonth_begin(int yearMonth_begin) {
		this.yearMonth_begin = yearMonth_begin;
	}
	public int getYearMonth_end() {
		return yearMonth_end;
	}
	public void setYearMonth_end(int yearMonth_end) {
		this.yearMonth_end = yearMonth_end;
	}
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("yearMonth=");
		sb.append(this.getYearMonth());
		sb.append(",seriousDefectNumber=");
		sb.append(this.getSeriousDefectNumber());
		sb.append(",defectNumber=");
		sb.append(this.getDefectNumber());
		sb.append(",reopenNumber=");
		sb.append(this.getReopenNumber());
		sb.append(",packageNumber=");
		sb.append(this.getPackageNumber());
		sb.append(",chart_project=");
		sb.append(this.getChart_project());
		sb.append(",project_customer=");
		sb.append(this.getProject_customer());
		sb.append(",totalProcessTime=");
		sb.append(this.getTotalProcessTime());
		sb.append(",totalDefectWeight=");
		sb.append(this.getTotalDefectWeight());
		sb.append(",totalSeriousDefectWeight=");
		sb.append(this.getTotalSeriousDefectWeight());
		sb.append(",pk=");
		sb.append(this.getPk());
		return sb.toString();
	}
	
}
