package cn.sdfi.user.bean;

import cn.sdfi.framework.bean.Model;

public class User extends Model{

	private String username;// 用户名
	private String password;// 密码
	private String mylevel;// 级别
	private String skin;// 皮肤
	private String who;//员工姓名
	private String sex;//性别
	private String memo;//备注
	private String entry_time;//入职时间
	private String loginTime;//登陆时间
	private String ip;//登陆机器IP
	private int pigeSize=10;

	
	public int getPigeSize() {
		return pigeSize;
	}
	public void setPigeSize(int pigeSize) {
		this.pigeSize = pigeSize;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getEntry_time() {
		return entry_time;
	}
	public void setEntry_time(String entry_time) {
		this.entry_time = entry_time;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getLoginTime() {
		return loginTime;
	}
	public void setLoginTime(String loginTime) {
		this.loginTime = loginTime;
	}
	public String getWho() {
		return who;
	}
	public void setWho(String who) {
		this.who = who;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getSkin() {
		return skin;
	}
	public void setSkin(String skin) {
		this.skin = skin;
	}
	
	public String getMylevel() {
		return mylevel;
	}
	public void setMylevel(String mylevel) {
		this.mylevel = mylevel;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("username=");
		sb.append(getUsername());
		sb.append(",password=");
		sb.append(getPassword());
		sb.append(",sex=");
		sb.append(getSex());
		sb.append(",level=");
		sb.append(getMylevel());
		sb.append(",who=");
		sb.append(getWho());
		sb.append(",skin=");
		sb.append(getSkin());
		sb.append(",entry_time=");
		sb.append(getEntry_time());
		sb.append(",memo=");
		sb.append(getMemo());
		return sb.toString();
	}
}
