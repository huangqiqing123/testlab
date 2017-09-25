package cn.sdfi.filecover.bean;

import java.util.List;

import cn.sdfi.filecovercontent.bean.FileCoverContent;
import cn.sdfi.framework.bean.Model;

/*
 * 档案袋信息
 */
public class FileCover extends Model{

	private String pk;
	private String file_cover_code;//档案袋编码
	private String file_cover_name;//档案袋名称
	private String file_cover_year;//年度
	private String file_cover_type;//档案袋类型
	private String memo;//备注
	private List<FileCoverContent> list;//档案袋内文件列表
		
	public String getFile_cover_type() {
		return file_cover_type;
	}
	public void setFile_cover_type(String file_cover_type) {
		this.file_cover_type = file_cover_type;
	}
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public FileCover(){}
	public FileCover(String file_cover_year){
		this.file_cover_year=file_cover_year;
	}
	public List<FileCoverContent> getList() {
		return list;
	}
	public void setList(List<FileCoverContent> list) {
		this.list = list;
	}
	public String getFile_cover_code() {
		return file_cover_code;
	}
	public void setFile_cover_code(String file_cover_code) {
		this.file_cover_code = file_cover_code;
	}
	public String getFile_cover_name() {
		return file_cover_name;
	}
	public void setFile_cover_name(String file_cover_name) {
		this.file_cover_name = file_cover_name;
	}
	public String getFile_cover_year() {
		return file_cover_year;
	}
	public void setFile_cover_year(String file_cover_year) {
		this.file_cover_year = file_cover_year;
	}
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("pk=");
		sb.append(getPk());
		sb.append(",file_cover_code=");
		sb.append(getFile_cover_code());
		sb.append(",file_cover_name=");
		sb.append(getFile_cover_name());
		sb.append(",file_cover_type=");
		sb.append(getFile_cover_type());
		sb.append(",file_cover_year=");
		sb.append(getFile_cover_year());
		sb.append(",memo=");
		sb.append(getMemo());
		return sb.toString();
	}
}
