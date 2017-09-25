package cn.sdfi.computer.bean;

import cn.sdfi.framework.bean.Model;

public class Computer  extends Model{
	
	private String pk;//主键
	private String computer_type;//设备类型
	private String code;//设备编号
	private String name;//设备名称
	private String owner;//领用人
	private String serial_number;//序列号
	private String type;//型号
	private String manufactory;//生产厂家
	private String begin_use_time;//领用日期
	private String use_site;//使用地点
	private String status;//状态
	private String configuration;//配置
	private String ip;//当前IP
	private String memo;//备注

	public String getComputer_type() {
		return computer_type;
	}
	public void setComputer_type(String computer_type) {
		this.computer_type = computer_type;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
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
	public String getOwner() {
		return owner;
	}
	public void setOwner(String owner) {
		this.owner = owner;
	}
	public String getSerial_number() {
		return serial_number;
	}
	public void setSerial_number(String serial_number) {
		this.serial_number = serial_number;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getManufactory() {
		return manufactory;
	}
	public void setManufactory(String manufactory) {
		this.manufactory = manufactory;
	}
	public String getBegin_use_time() {
		return begin_use_time;
	}
	public void setBegin_use_time(String begin_use_time) {
		this.begin_use_time = begin_use_time;
	}
	public String getUse_site() {
		return use_site;
	}
	public void setUse_site(String use_site) {
		this.use_site = use_site;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getConfiguration() {
		return configuration;
	}
	public void setConfiguration(String configuration) {
		this.configuration = configuration;
	}
	
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("pk=");
		sb.append(getPk());
		sb.append(",computer_type=");
		sb.append(getComputer_type());
		sb.append(",code=");
		sb.append(getCode());
		sb.append(",name=");
		sb.append(getName());
		sb.append(",owner=");
		sb.append(getOwner());
		sb.append(",serial_number=");
		sb.append(getSerial_number());
		sb.append(",type=");
		sb.append(getType());
		sb.append(",manufactory=");
		sb.append(getManufactory());
		sb.append(",begin_use_time=");
		sb.append(getBegin_use_time());
		sb.append(",use_site=");
		sb.append(getUse_site());
		sb.append(",status=");
		sb.append(getStatus());
		sb.append(",IP=");
		sb.append(getIp());
		sb.append(",configuration=");
		sb.append(getConfiguration());
		sb.append(",memo=");
		sb.append(getMemo());
		return sb.toString();
	}

}
