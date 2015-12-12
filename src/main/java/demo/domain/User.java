package demo.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(of="id")
@Entity
public class User {
	
	@Id
	@GeneratedValue
	private Long id;
	
	private String name;
	private String password;
	
	private String faceId;
	private String twitId;
	private String kakaoId;
	
	
	
}
