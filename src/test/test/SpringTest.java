package test.test;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SpringTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		ClassPathXmlApplicationContext context=new ClassPathXmlApplicationContext("/applicationContext.xml");
		Book book=(Book)context.getBean("book");
		book.setId("11");
		book.setName("计算机");
		System.out.println(book.toString());
	}

}
