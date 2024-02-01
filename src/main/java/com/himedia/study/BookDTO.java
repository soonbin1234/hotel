package com.himedia.study;

import lombok.Data;

@Data
public class BookDTO {
	int id;
	String checkin;
	String checkout;
	int room_id;
	int howmany;
	int howmuch;
	String name;
	int mobile;
	String roomname;
}
