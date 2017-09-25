package cn.sdfi.project.bean;

import cn.sdfi.framework.bean.Model;

//实验室项目实体类
public class Project extends Model{

	private String pk;//主键
	private String code;//项目编号
	private String name;//项目名称
	private String devmanager;//项目负责人
	private String testmanager;//测试负责人
	private String begintime;//项目开始时间
	private String endtime;//项目结束时间
	private String memo;//备注
	private String year;//年度
	private String state;//状态（正在进行、完成）
	private String project_type;//项目类型（功能、性能、代码审查）
	private String tester;//测试人员
	private String isLabProject;//是否是实验室项目（0：不是，1：是）
	private String project_customer;//客户名称（技术中心、烟草、质检。。。）
	
	
	public String getProject_customer() {
		return project_customer;
	}
	public void setProject_customer(String project_customer) {
		this.project_customer = project_customer;
	}
	public String getProject_type() {
		return project_type;
	}
	public void setProject_type(String project_type) {
		this.project_type = project_type;
	}
	public String getIsLabProject() {
		return isLabProject;
	}
	public void setIsLabProject(String isLabProject) {
		this.isLabProject = isLabProject;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getTester() {
		return tester;
	}
	public void setTester(String tester) {
		this.tester = tester;
	}
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public String getYear() {
		// TODO Auto-generated method stub
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getEndtime() {
		return endtime;
	}
	public void setEndtime(String endtime) {
		this.endtime = endtime;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDevmanager() {
		return devmanager;
	}
	public void setDevmanager(String devmanager) {
		this.devmanager = devmanager;
	}
	public String getTestmanager() {
		return testmanager;
	}
	public void setTestmanager(String testmanager) {
		this.testmanager = testmanager;
	}
	public String getBegintime() {
		return begintime;
	}
	public void setBegintime(String begintime) {
		this.begintime = begintime;
	}

	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("pk=");
		sb.append(getPk());
		sb.append(",code=");
		sb.append(getCode());
		sb.append(",name=");
		sb.append(getName());
		sb.append(",devmanager=");
		sb.append(getDevmanager());
		sb.append(",testmanager=");
		sb.append(getTestmanager());
		sb.append(",begintime=");
		sb.append(getBegintime());
		sb.append(",endtime=");
		sb.append(getEndtime());
		sb.append(",memo=");
		sb.append(getMemo());
		sb.append(",project_year=");
		sb.append(getYear());
		sb.append(",state=");
		sb.append(getState());
		sb.append(",project_type=");
		sb.append(getProject_type());
		sb.append(",tester=");
		sb.append(getTester());
		sb.append(",isLabProject=");
		sb.append(getIsLabProject());
		return sb.toString();
	}
}
