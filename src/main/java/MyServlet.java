import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



/**
 * Servlet implementation class MyServlet
 */
@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Float myLongitude = Float.parseFloat(request.getParameter("myFloat1"));
	    Float myLatitude = Float.parseFloat(request.getParameter("myFloat2"));
	    
	    Connection connection = null;
	    PreparedStatement statement = null;
	    Statement st = null;
	    ResultSet rs = null;
	    
	    try
	    {
	    	String url = "jdbc:postgresql://localhost:5432/gis_test";
		    String user = "postgres";
		    String password = "1234";
	    	String driver = "org.postgresql.Driver";
	    	Class.forName(driver);
	    	
	    	// PostgreSQL 연동
	    	connection = DriverManager.getConnection(url,user,password);
	    	st = connection.createStatement();
	    	
	    	// index.jsp 로 부터 받은 위도, 경도의 값을 SQL에 갱신
	    	String query = "UPDATE gis_point SET geom = ST_SetSRID(ST_MakePoint(?,?), 4326) WHERE id = 1";
	    	statement = connection.prepareStatement(query);
	    	
	    	statement.setFloat(1, myLongitude);
	    	statement.setFloat(2, myLatitude);
	    	statement.executeUpdate();
	       
	    	
	    } catch (SQLException ex){
	    	ex.printStackTrace();
	    } catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
		    if (statement != null) {
		        try {
		            statement.close();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		    }
		    if (connection != null) {
		        try {
		            connection.close();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		    }
		}
	    
	}
}
