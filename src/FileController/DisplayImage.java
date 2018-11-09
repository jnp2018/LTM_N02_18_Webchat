package FileController;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DisplayImage
 */
@WebServlet("/image")
public class DisplayImage extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try{
	         String fileName = request.getParameter("image");             
	         FileInputStream fis = new FileInputStream(new File("C:\\Users\\ASUS\\Documents\\File\\img\\"+fileName));
	         BufferedInputStream bis = new BufferedInputStream(fis);             
	         response.setContentType("image/*");
	         BufferedOutputStream output = new BufferedOutputStream(response.getOutputStream());
	         for (int data; (data = bis.read()) > -1;) {
	           output.write(data);
	         }             
	      }
	      catch(IOException e){

	      }finally{
	          // close the streams
	      }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
