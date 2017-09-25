package cn.sdfi.filecovercontent.bean;

import cn.sdfi.framework.bean.Model;

/*
 * 文件实体bean
 */
public class FileCoverContent  extends Model{

	private String pk;//主键
	private String fk;//外键，对应该文件所在档案袋的主键
	private String file_cover_content_code;//文件编码
	private String file_cover_content_name;//文件名称
	private String memo;//备注
	private String version;//版本
	private String pages;//页数	
	private String file_cover_name;//所属档案袋名称，该字段不对应数据库中表字段，只是在前台展现时用到。
	
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public String getFk() {
		return fk;
	}
	public void setFk(String fk) {
		this.fk = fk;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getPages() {
		return pages;
	}
	public void setPages(String pages) {
		this.pages = pages;
	}
	
	/*
	 * getFile_cover_content_code()
	 */
	public String getFile_cover_content_code() {
		return file_cover_content_code;
	}
	/*
	 * setFile_cover_content_code(String file_cover_content_code)
	 */
	public void setFile_cover_content_code(String file_cover_content_code) {
		this.file_cover_content_code = file_cover_content_code;
	}
	/*
	 * getFile_cover_content_name()
	 */
	public String getFile_cover_content_name() {
		return file_cover_content_name;
	}
	/*
	 * setFile_cover_content_name(String file_cover_content_name)
	 */
	public void setFile_cover_content_name(String file_cover_content_name) {
		this.file_cover_content_name = file_cover_content_name;
	}

	/*
	 * getFile_cover_name()
	 */
	public String getFile_cover_name() {
		return file_cover_name;
	}
	/*
	 * setFile_cover_name(String file_cover_name)
	 */
	public void setFile_cover_name(String file_cover_name) {
		this.file_cover_name = file_cover_name;
	}
	@Override
	public String toString() {
		return "pk="+getPk()
		+ ",fk="+getFk() 
		+",code="+getFile_cover_content_code()
		+ ",name="+getFile_cover_content_name()
		+ ",version="+getVersion() 
		+",pages="+getPages()
		+ ",memo="+getMemo();
	}
}
