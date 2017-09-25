package cn.sdfi.audit.bean;

import cn.sdfi.framework.bean.Model;

public class Audit extends Model{
	
	private String pk;//主键
	private String username;//登录用户名
	private String url;//url
	private String accessTime;//时间
	private String ip;//用户IP
	
	//拼装查询条件用
	private String accessTimeBegin;
	private String accessTimeEnd;
	
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getAccessTime() {
		return accessTime;
	}
	public void setAccessTime(String accessTime) {
		this.accessTime = accessTime;
	}
	public String getAccessTimeBegin() {
		return accessTimeBegin;
	}
	public void setAccessTimeBegin(String accessTimeBegin) {
		this.accessTimeBegin = accessTimeBegin;
	}
	public String getAccessTimeEnd() {
		return accessTimeEnd;
	}
	public void setAccessTimeEnd(String accessTimeEnd) {
		this.accessTimeEnd = accessTimeEnd;
	}
		
}
