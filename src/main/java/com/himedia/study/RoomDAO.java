package com.himedia.study;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RoomDAO {
	ArrayList<SelectDTO> list();
	ArrayList<RoomDTO> rlist();
	int add(int type,String name,int presonnel,int price);
	int modify(int type,String name,int personnel,int price,int id);
	int remove(int id);
	ArrayList<RoomDTO> find(int personnel,String start,String end);
	ArrayList<BookDTO> ylist();
	int date(String start,String end);
	int yRemove(int id);
	int yModify(String start,String end,int id,int people,String name,int mobile,int price,int hidden);
	String getType(int id);
	int yeyak(String start,String end,int id,int people,String name,int mobile,int price);
}
