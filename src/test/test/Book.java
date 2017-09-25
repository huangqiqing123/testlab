package test.test;

public class Book {

	@Override
	public String toString() {
		
		return id+"\t"+name;
	}

	private String name,id;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
}
