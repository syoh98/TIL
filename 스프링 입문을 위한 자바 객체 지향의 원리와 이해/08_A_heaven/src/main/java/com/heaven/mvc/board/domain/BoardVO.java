package com.heaven.mvc.board.domain;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Getter;
import lombok.Setter;

@Alias("boardVO")
@Getter
@Setter
public class BoardVO {
	private int seq;
	
	@Length(min=2, max=5, message="제목은 2자 이상, 5자 미만 입력하세요.")
	private String title;
	
	@NotEmpty(message="내용을 입력하세요.")
	private String content;
	
	@NotEmpty(message="작성자를 입력하세요.")
	private String writer;
	
	private int password;
	private Timestamp regDate;
	private int cnt;
	
	public BoardVO() {}
	
	public BoardVO(String title, String content, String writer, int password) {
		super();
		this.title = title;
		this.content = content;
		this.writer = writer;
		this.password = password;
		this.cnt = 0;
	}
}
