package cn.sdfi.framework.bean;

/*
 * bean的模板类，包含每个实体bean都存在的公共属性。
 */
public class Model {
	
	private String sort;//排序字段
	private String sortType;//排序类型（ASC DESC）
	private int pageCount;//页数
	private int recordCount;//符合条件的总记录数
	private int pageSize;//每页显示的记录数
	private int showPage;//当前显示页数
	
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getSortType() {
		return sortType;
	}
	public void setSortType(String sortType) {
		this.sortType = sortType;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getPageCount() {
		return pageCount;
	}
	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}
	public int getRecordCount() {
		return recordCount;
	}
	public void setRecordCount(int recordCount) {
		this.recordCount = recordCount;
	}
	public int getShowPage() {
		return showPage;
	}
	public void setShowPage(int showPage) {
		this.showPage = showPage;
	}
	
}
