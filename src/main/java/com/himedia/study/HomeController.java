package com.himedia.study;

import java.util.ArrayList;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class HomeController {

	@Autowired
	private RoomDAO rdao;

	@GetMapping("/room")
	public String room() {
		return "room";
	}

	@GetMapping("/")
	public String home() {
		return "home";
	}

	@PostMapping("/select")
	@ResponseBody
	public String doSelect() {
		ArrayList<SelectDTO> alSelect = rdao.list();
		JSONArray ja = new JSONArray();
		for (int i = 0; i < alSelect.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id", alSelect.get(i).getId());
			jo.put("typename", alSelect.get(i).getTypename());
			ja.add(jo);
		}

		return ja.toJSONString();
	}

	@PostMapping("/list")
	@ResponseBody
	public String doList() {
		ArrayList<RoomDTO> alList = rdao.rlist();
		JSONArray ja = new JSONArray();
		for (int i = 0; i < alList.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id", alList.get(i).getId());
			jo.put("name", alList.get(i).getName());
			jo.put("typename", alList.get(i).getTypename());
			jo.put("personnel", alList.get(i).getPersonnel());
			jo.put("price", alList.get(i).getPrice());
			ja.add(jo);
		}

		return ja.toJSONString();
	}

	@GetMapping("/remove")
	@ResponseBody
	public String doRemove(HttpServletRequest req) {
		String id = req.getParameter("id");
		if (id == null || id.equals("")) {
			return "0";
		} else {
			int n = rdao.remove(Integer.parseInt(id));
			return "" + n;
		}
	}

	@PostMapping("/add")
	@ResponseBody
	public String doAdd(HttpServletRequest req) {
		String id = req.getParameter("id");
		String type = req.getParameter("type");
		String name = req.getParameter("name");
		String personnel = req.getParameter("personnel");
		String price = req.getParameter("price");
		int n = 0;
		if (id == null || id.equals("")) {
			System.out.println("add들어옴");
			n = rdao.add(Integer.parseInt(type), name, Integer.parseInt(personnel), Integer.parseInt(price));
			return "" + n;
		} else {
			System.out.println("modify 들어옴");
			n = rdao.modify(Integer.parseInt(type), name, Integer.parseInt(personnel), Integer.parseInt(price),
					Integer.parseInt(id));
			return "" + n;
		}
	}

	@PostMapping("/getDate")
	@ResponseBody
	public String getDate(HttpServletRequest req) {
		String start = req.getParameter("start");
		System.out.println(start);
		String end = req.getParameter("end");
		System.out.println(end);
		int day = rdao.date(end, start);
		System.out.println(day);
		return "" + day;
	}

	@PostMapping("/yeyak")
	@ResponseBody
	public String doYeyak(HttpServletRequest req) {
		String hidden = req.getParameter("hidden");
		String start = req.getParameter("start");
		String end = req.getParameter("end");
		String id = req.getParameter("id");
		String people = req.getParameter("people");
		String name = req.getParameter("name");
		String mobile = req.getParameter("mobile");
		String price = req.getParameter("price");
		System.out.println("h="+hidden);
		int n = 0;
		if (hidden == null || hidden.equals("")) {
			n = rdao.yeyak(start, end, Integer.parseInt(id), Integer.parseInt(people), name, Integer.parseInt(mobile),
					Integer.parseInt(price));
		} else {
			n = rdao.yModify(start, end, Integer.parseInt(id), Integer.parseInt(people), name, Integer.parseInt(mobile),
					Integer.parseInt(price), Integer.parseInt(hidden));
		}
		return "" + n;
	}

	@PostMapping("/yeyaklist")
	@ResponseBody
	public String doYeakList() {
		ArrayList<BookDTO> albook = rdao.ylist();
		JSONArray ja = new JSONArray();
		for (int i = 0; i < albook.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id", albook.get(i).getId());
			jo.put("room_id", albook.get(i).getRoom_id());
			jo.put("start", albook.get(i).getCheckin());
			jo.put("end", albook.get(i).getCheckout());
			jo.put("roomname", albook.get(i).getRoomname());
			jo.put("people", albook.get(i).getHowmany());
			jo.put("price", albook.get(i).getHowmuch());
			jo.put("name", albook.get(i).getName());
			jo.put("mobile", albook.get(i).getMobile());
			ja.add(jo);
		}

		return ja.toJSONString();
	}

	@PostMapping("/getType")
	@ResponseBody
	public String doGetType(HttpServletRequest req) {
		String id = req.getParameter("id");

		String name = rdao.getType(Integer.parseInt(id));
		return name;
	}

	@GetMapping("/yeyakRemove")
	@ResponseBody
	public String doRemove2(HttpServletRequest req) {
		String id = req.getParameter("id");

		int n = rdao.yRemove(Integer.parseInt(id));
		return "" + n;

	}
	
	  @PostMapping("/find")
	  @ResponseBody 
	  public String doFind(HttpServletRequest req) { 
		  int personnel =Integer.parseInt(req.getParameter("personnel"));
		  String start = req.getParameter("start");
		  String end=req.getParameter("end");
	  
		  ArrayList<RoomDTO> list = rdao.find(personnel,start,end); 
		  JSONArray ja = new JSONArray(); 
		  for(int i=0;i<list.size();i++) { 
			  JSONObject jo = new JSONObject();
			  jo.put("id", list.get(i).getId()); 
			  jo.put("name",list.get(i).getName());
			  jo.put("typename", list.get(i).getTypename());
			  jo.put("personnel", list.get(i).getPersonnel());
			  jo.put("price",list.get(i).getPrice()); ja.add(jo); 
			  }
		  
		  return ja.toJSONString();
		  
	  }
	 
}
