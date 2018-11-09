package FileController;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/file")
public class DownloadFile extends HttpServlet{
	private static final long serialVersionUID = 1L;
	 
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DownloadFile() {
		super();
	}
 
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
 
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		String fileName = request.getParameter("file"); 
		
			OutputStream out = response.getOutputStream();
			String my_file = "C:\\Users\\ASUS\\Documents\\File\\img\\" + fileName;
			response.setContentType("APPLICATION/OCTET-STREAM");
			response.setHeader("Content-Disposition",
					"attachment; filename="+fileName);
			FileInputStream in = new FileInputStream(my_file);
			byte[] buffer = new byte[4096];
			int length;
			while ((length = in.read(buffer)) > 0) {
				out.write(buffer, 0, length);
			}
			in.close();
			out.flush();
	}
}
