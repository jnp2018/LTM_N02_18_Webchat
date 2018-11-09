/*
 * Actor Ngô Thị Thúy Linh
 * git@github.com:jnp2018/exam-ltm_nhom02_chatbox.git
 * 
 * 
 * */

import java.io.BufferedReader;
import java.io.EOFException;
import java.io.File;
import java.util.*;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class Main {

	public static void main(String[] args) {
		ArrayList<Message> aNV = new ArrayList<>();
        BufferedReader br = null;
        try {
            br = new BufferedReader(new InputStreamReader(new FileInputStream("D:\\r_d.txt"), "UTF-8"));
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
            System.out.println(aNV);
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

	}
}
