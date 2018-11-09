/*
 * Actor Ngô Thị Thúy Linh
 * git@github.com:jnp2018/exam-ltm_nhom02_chatbox.git
 * 
 * 
 * */

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Date;

public class Message implements Serializable {
	final static long serialVersionUID = 5586440954473589903L;
	private String form;
	private String to;
	private String message;
	private String filename; 

	private long datetime;
	public long getDatetime() {
		return datetime;
	}

	public Message(String form, String to, String message) {
		super();
		this.form = form;
		this.to = to;
		this.message = message;
	}

	public void setDatetime(long datetime) {
		this.datetime = datetime;
	}

	public Message() {
		// TODO Auto-generated constructor stub
	}
	
	
	@Override
	public String toString() {
		return "Message [form=" + form + ", to=" + to + ", message=" + message + ", datetime=" + datetime + "]";
	}

	public String getForm() {
		return form;
	}
	public void setForm(String form) {
		this.form = form;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	

}
