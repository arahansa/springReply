package demo.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Entity
public class Reply {

	@Id
	@GeneratedValue
	private Long id;
	
	private String author;
	
	private String comment;

	public Reply() {

	}

	public Reply(String author, String comment) {
		this.author = author;
		this.comment = comment;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	@Override
	public String toString() {
		return "Reply{" +
				"id=" + id +
				", author='" + author + '\'' +
				", comment='" + comment + '\'' +
				'}';
	}
}
