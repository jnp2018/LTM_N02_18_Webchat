
/*
 * Actor Ngô Thị Thúy Linh
 * git@github.com:jnp2018/exam-ltm_nhom02_chatbox.git
 * 
 * 
 * */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@ServerEndpoint(value = "/chatRoomServer/{type}")
public class Server {
	static Map<Custorm, Session> cus = Collections.synchronizedMap(new HashMap<>());
	static Integer count = 0;
	static Map<Manager, Session> ads = Collections.synchronizedMap(new HashMap<>());
	private String uc;
	static FileOutputStream fos = null;
	String filenameUpload = null;
	String fileTo = null;
	String fileFrom = null;
//Đọc dữ liệu file
	private ArrayList<Message> outfile(String filename) {
		ArrayList<Message> aNV = new ArrayList<>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(
					new FileInputStream("C:\\Users\\ASUS\\Documents\\File\\" + filename + ".txt"), "UTF-8"));
			String s = br.readLine();
			while (s != null) {
				String[] a = s.split("\t");
				Message nv = new Message();
				nv.setForm(a[0]);
				nv.setMessage(a[1]);
				nv.setTo(a[2]);
				nv.setDatetime(Long.parseLong(a[3]));
				aNV.add(nv);
				s = br.readLine();
			}
			br.close();
			return aNV;
		} catch (IOException ex) {
			ex.getMessage();
		} catch (ArrayIndexOutOfBoundsException e) {
			System.out.println("Vượt quá chỉ số mảng!" + e.getMessage());
		} catch (Exception e) {
			System.out.println("Lỗi gì đó!!!");
		} finally {
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException ex) {
				ex.getMessage();
			}
		}
		return null;
	}
//Ghi tin nhắn vào file của admin
	private void infile(Message mes, String filename) {
		// TODO Auto-generated method stub
		System.out.println(mes);
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter("C:\\Users\\ASUS\\Documents\\File\\" + filename + ".txt", true));

			bw.write(mes.getForm() + "\t");
			bw.write(mes.getMessage() + "\t");
			bw.write(mes.getTo() + "\t");
			bw.write(mes.getDatetime() + "\n");

		} catch (IOException ex) {
			ex.getMessage();
		} finally {
			try {
				if (bw != null) {
					bw.close();
				}
			} catch (IOException ex) {
				ex.getMessage();
			}
		}

	}

	@OnOpen
	public void handleOpen(Session session, @PathParam("username") String message) {
		session.setMaxBinaryMessageBufferSize(1024 * 1024);
		System.out.println(message);
	}
//Ghi dữ liệu của file khách hàng gửi vào file 
	@OnMessage
	public void processUpload(ByteBuffer msg, boolean last, Session session) {
		System.out.println("Binary message");
		File file = new File("C:\\Users\\ASUS\\Documents\\File\\img\\" + filenameUpload);

		System.out.println(msg);

		try {
			FileChannel channel = new FileOutputStream(file).getChannel();
			channel.write(msg);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			session.getBasicRemote().sendText("FILE_UPLOAD=" + filenameUpload);
			System.out.println("TOOOOO="+fileTo);
			for (Manager mm : ads.keySet()) {
				Session ss = ads.get(mm);

				if (mm.getUsername().equals(fileTo)) {

					ss.getBasicRemote().sendText("FILE_UPLOAD=" + filenameUpload);
					/*ArrayList<String> list = mm.getConnect();
					if (list == null) {
						list = new ArrayList<>();
					}
					list.add(fileTo.trim());
					mm.setConnect(list);*/
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@OnMessage
	public void handleMessage(String message, Session userSession, @PathParam("type") String type) throws IOException {

		System.out.println("type= " + type);
		System.out.println("mess= " + message);
		Gson gson = new Gson();
		HashMap<String, String> map = gson.fromJson(message, new TypeToken<HashMap<String, String>>() {
		}.getType());
		String action = map.get("action");
//		Khách hàng gửi file
		if (action.equalsIgnoreCase("UPLOAD_FILE")) {
			filenameUpload = map.get("filename");
			fileTo = map.get("to");
			fileFrom = map.get("from");
		}
//		Gửi tên file cho admin(để lấy dữ liệu ở file làm lịch sử chat)
		if (action.equalsIgnoreCase("FILE")) {
			String filename = map.get("filename");
			userSession.getBasicRemote().sendText("LIST=" + new Gson().toJson(outfile(filename)));
		}
		if (action.equalsIgnoreCase("LOGIN")) {
			String username = map.get("username");
			String password = map.get("password");

			if (username.equalsIgnoreCase(password)) {
				userSession.getBasicRemote().sendText("LOGIN=" + username);
				if (type.equals("cus")) {
					Custorm c = new Custorm();
					c.setActive(false);
					c.setUsername(username);
					cus.put(c, userSession);
				} else {
					Manager m = new Manager();
					m.setActive(false);
					m.setUsername(username);
					ads.put(m, userSession);

				}
			} else {
				userSession.getBasicRemote().sendText("LOGIN=false");
			}
		}
		System.out.println(userSession);
		// Người dùng gửi tin nhắn
		if (action.equalsIgnoreCase("MESSAGE")) {
			String mes = map.get("text");
			String from = map.get("from");
			String to = map.get("to");
			Custorm cuss = null;
			for (Custorm cc : cus.keySet()) {
				if (cc.getUsername().equals(from)) {
					cuss = cc;
				}
			}
			
			if (type.equals("cus")) {
//				Khách hàng gửi tin nhắn
				for (Manager mm : ads.keySet()) {
					Session session = ads.get(mm);
//Kiểm tra để phân biệt khách hàng nhắn tin mới hay đã nhắn tin với admin rồi
					if (mm.getActive().equals(true) && mm.getConnect().contains(from)
							&& cuss.getActive().equals(true)) {
						Message m = new Message();
						m.setForm(from);
						m.setDatetime(new Date().getTime());
						m.setTo(to);
						m.setMessage(mes);
						infile(m, from.trim() + "_" + to.trim());
						session.getBasicRemote().sendText("MESSAGE=" + new Gson().toJson(m));
					} else if (mm.getUsername() != null && cuss.getActive().equals(false)) {
						// Message m1= new Message();
						// m1.setForm(from);
						// m1.setDatetime(new Date().getTime());
						// m1.setMessage(mes);
						session.getBasicRemote().sendText("PP=" + from + " : " + mes);
						// session.getBasicRemote().sendText("PP="+new Gson().toJson(m1));
					}
				}
			} else if (type.equals("ad")) {
//				Admin gửi tin nhắn
				for (Custorm cc : cus.keySet()) {
					Session s = cus.get(cc);
					if (cc.getUsername().equals(to.trim())) {
						Message m = new Message();
						m.setDatetime(new Date().getTime());
						m.setForm(from);
						m.setTo(to);
						m.setMessage(mes);
						infile(m, to.trim() + "_" + from.trim());
						s.getBasicRemote().sendText("MESSAGE=" + new Gson().toJson(m));
					}
				}
			}
		}
//		Sự kiện typing
		if (action.equalsIgnoreCase("KEY")) {
			String to = map.get("to");
			String form = map.get("from");
			Session s = null;
			for (Manager mm : ads.keySet()) {
				Session ss = ads.get(mm);
				System.out.println(mm.getActive().equals(false));
				if (mm.getUsername().equals(form)) {

					ss.getBasicRemote().sendText("KEY=true");
					ArrayList<String> list = mm.getConnect();
					if (list == null) {
						list = new ArrayList<>();
					}
					list.add(to.trim());
					mm.setConnect(list);
					for (Custorm cc : cus.keySet()) {
						if (cc.getUsername().equals(to.trim())) {
							Session sss = cus.get(cc);
							sss.getBasicRemote().sendText("KEY=" + to);
						}
					}
				} else {
					ss.getBasicRemote().sendText("KEY=" + form);
				}
			}
		}
//		Sự kiện khi admin click vào thông báo tin nhắn mới của khách hàng
		if (action.equalsIgnoreCase("CLICKED")) {
			String userclick = map.get("userclick");
			String to = map.get("to");
			Session s = null;
			for (Manager mm : ads.keySet()) {
				Session ss = ads.get(mm);
				System.out.println(mm.getActive().equals(false));
				if (mm.getUsername().equals(userclick)) {

					ss.getBasicRemote().sendText("CLICKED=true");
					mm.setActive(true);
//					Add khách hàng nhắn tin vào list người nhắn tin tới admin
					ArrayList<String> list = mm.getConnect();
					if (list == null) {
						list = new ArrayList<>();
					}
					list.add(to.trim());
					mm.setConnect(list);
					for (Custorm cc : cus.keySet()) {
						if (cc.getUsername().equals(to.trim())) {
							cc.setActive(true);
							Session sss = cus.get(cc);
							sss.getBasicRemote().sendText("CLICKED=" + userclick);
						}
					}
				} else {
					ss.getBasicRemote().sendText("CLICKED=" + to);
				}
			}

		}

	}

	@OnClose
	public void handleClose(Session session) {
		for (Manager mm : ads.keySet()) {
			Session s = ads.get(mm);
			if (s.equals(session)) {
				ads.values().remove(s);
				ads.remove(mm);
			}
		}
		for (Custorm cc : cus.keySet()) {
			Session s = cus.get(cc);
			if (s.equals(session)) {
				cus.values().remove(s);
				cus.remove(cc);
			}
		}

	}

	@OnError
	public void handleError(Throwable t) {
		t.printStackTrace();
	}

}
