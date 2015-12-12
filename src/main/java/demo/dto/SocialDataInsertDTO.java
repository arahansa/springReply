package demo.dto;

import lombok.Data;

@Data
public class SocialDataInsertDTO {
	private Long userId;
	private String socialId;
	private String socialType;
}
