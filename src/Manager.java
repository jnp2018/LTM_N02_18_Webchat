/*
 * Actor Ngô Thị Thúy Linh
 * git@github.com:jnp2018/exam-ltm_nhom02_chatbox.git
 * 
 * 
 * */

import java.util.ArrayList;

import javax.websocket.Session;

public class Manager {
	private String username;
	private ArrayList<String> connect;

	public ArrayList<String> getConnect() {
		return connect;
	}
	public void setConnect(ArrayList<String> connect) {
		this.connect = connect;
	}
	private Boolean active;
	public Manager() {
		// TODO Auto-generated constructor stub
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Boolean getActive() {
		return active;
	}
	public void setActive(Boolean active) {
		this.active = active;
	}
	
}
