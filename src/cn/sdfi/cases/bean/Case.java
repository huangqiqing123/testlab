package cn.sdfi.cases.bean;

import cn.sdfi.framework.bean.Model;

public class Case extends Model{
	
	private String pk;//主键
	private String title;//标题
	private String summary;//摘要
	private String detail;//详细描述
	private String analyze;//分析过程
	private String solve;//解决方案
	private String result;//结果
	private String type;//类型
	private String status;//状态
	private String upload_person;//上传人
	private String upload_time;//上传时间
	private String last_update_time;//最后更新时间
	private String blob_name;//附件名称
	private String version;//版本

	public String getUpload_person() {
		return upload_person;
	}
	public void setUpload_person(String upload_person) {
		this.upload_person = upload_person;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public String getAnalyze() {
		return analyze;
	}
	public void setAnalyze(String analyze) {
		this.analyze = analyze;
	}
	public String getSolve() {
		return solve;
	}
	public void setSolve(String solve) {
		this.solve = solve;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getUpload_time() {
		return upload_time;
	}
	public void setUpload_time(String upload_time) {
		this.upload_time = upload_time;
	}
	public String getLast_update_time() {
		return last_update_time;
	}
	public void setLast_update_time(String last_update_time) {
		this.last_update_time = last_update_time;
	}
	public String getBlob_name() {
		return blob_name;
	}
	public void setBlob_name(String blob_name) {
		this.blob_name = blob_name;
	}
	@Override
	public String toString() {
		StringBuffer toStr = new StringBuffer();
		toStr.append("pk=");
		toStr.append(pk);
		toStr.append(",title=");
		toStr.append(title);
		toStr.append(",summary=");
		toStr.append(summary);
		toStr.append(",detail=");
		toStr.append(detail);
		toStr.append(",analyze=");
		toStr.append(analyze);
		toStr.append(",solve=");
		toStr.append(solve);
		toStr.append(",result=");
		toStr.append(result);
		toStr.append(",type=");
		toStr.append(type);
		toStr.append(",status=");
		toStr.append(status);
		toStr.append(",upload_time=");
		toStr.append(upload_time);
		toStr.append(",last_update_time=");
		toStr.append(last_update_time);
		toStr.append(",blob_name=");
		toStr.append(blob_name);
		toStr.append(",version=");
		toStr.append(version);
		return toStr.toString();
	}


}
