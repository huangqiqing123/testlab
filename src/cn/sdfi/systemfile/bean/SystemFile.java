package cn.sdfi.systemfile.bean;

import cn.sdfi.framework.bean.Model;

//实验室体系文件实体类
public class SystemFile  extends Model{

	private String pk;//主键
	private String code;//文件编号
	private String name;//文件名称
	private String pages;//页数
	private String version;//版本号
	private String controlledNumber;//受控号
	private String state;//状态（已作废、有效）
	private String memo;//备注
	
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
	public String getPages() {
		return pages;
	}
	public void setPages(String pages) {
		this.pages = pages;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getControlledNumber() {
		return controlledNumber;
	}
	public void setControlledNumber(String controlledNumber) {
		this.controlledNumber = controlledNumber;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
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
		sb.append(",pages=");
		sb.append(getPages());
		sb.append(",memo=");
		sb.append(getMemo());
		sb.append(",version=");
		sb.append(getVersion());
		sb.append(",controlled_number=");
		sb.append(getControlledNumber());
		sb.append(",state=");
		sb.append(getState());
		return sb.toString();
	}
	
}
