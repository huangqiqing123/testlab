package cn.sdfi.product.bean;

import cn.sdfi.framework.bean.Model;

public class Product extends Model{
private String pk;//主键
private int sortCode;//产品编码
private String name;//产品名称
private String dept;//产品所属部门
public String getPk() {
	return pk;
}
public void setPk(String pk) {
	this.pk = pk;
}

public int getSortCode() {
	return sortCode;
}
public void setSortCode(int sortCode) {
	this.sortCode = sortCode;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getDept() {
	return dept;
}
public void setDept(String dept) {
	this.dept = dept;
}
@Override
	public String toString() {
		StringBuffer bf = new StringBuffer();
		bf.append("pk=");
		bf.append(this.getPk());
		bf.append(",name=");
		bf.append(this.getName());
		bf.append(",sortCode=");
		bf.append(this.getSortCode());
		bf.append(",dept=");
		bf.append(this.getDept());
		return bf.toString();
	}

}
