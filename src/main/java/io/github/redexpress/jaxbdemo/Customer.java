package io.github.redexpress.jaxbdemo;

import java.util.Set;

import javax.xml.bind.annotation.XmlAttribute;  
import javax.xml.bind.annotation.XmlElement;  
import javax.xml.bind.annotation.XmlRootElement;  
  
@XmlRootElement  
public class Customer {  
    private String name;  
    private int age;  
    private int id;
    private Set<Book> book;
  
    @XmlElement  
    public String getName() {  
        return name;  
    }  
    public void setName(String name) {  
        this.name = name;  
    }  
      
    @XmlElement  
    public int getAge() {  
        return age;  
    }  
    public void setAge(int age) {  
        this.age = age;  
    }  
      
    @XmlAttribute  
    public int getId() {  
        return id;  
    }  
    public void setId(int id) {  
        this.id = id;  
    }
    
    @XmlElement
    public Set<Book> getBook() {
		return book;
	}
	public void setBook(Set<Book> book) {
		this.book = book;
	}
	@Override
	public String toString() {
		return "Customer [name=" + name + ", age=" + age + ", id=" + id
				+ ", book=" + book + "]";
	}
	
	
} 
