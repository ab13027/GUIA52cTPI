<%@page contentType="text/html" pageEncoding="iso-8859-1" import="java.sql.*,net.ucanaccess.jdbc.*" %>
 <html>
 <head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%!
public Connection getConnection(String path) throws SQLException {
String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
//String filePath= "c:\\Apache\\Tomcat\\webapps\\GUIA52cTPI\\JSPdatos-grupo07\\data\\datos.mdb";
String filePath= path + "\\datos.mdb";//modificado

String userName="",password="";
String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;

    Connection conn = null;
try{
        Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
 conn = DriverManager.getConnection(fullConnectionString,userName,password);

}
 catch (Exception e) {
System.out.println("Error: " + e);
 }
    return conn;
}
%>
<%

//Nuevo Agregado
ServletContext context = request.getServletContext();
String path = context.getRealPath("/data");
String ls_titulo = request.getParameter("titulo");
String ls_autor = request.getParameter("autor");

Connection conexion = getConnection(path);
   if (!conexion.isClosed()){
 
      Statement st = conexion.createStatement();
      ResultSet rs = st.executeQuery("select * from libros where titulo like " + "'%" +ls_titulo+ "%'" + "or autor like" + "'%"+ ls_autor+"%'");

      // Ponemos los resultados en un table de html
      out.println("<div class='table-container'>");
      out.println("<table border=\"1\"><thead><tr><td>Num.</td><td>ISBN</td><td>Titulo</td><td>Autor</td><td>Accion</td></tr></thead><tbody>");
      int i=1;
      while (rs.next())
      {
         String isbn = rs.getString("isbn");
         String titulo = rs.getString("titulo");
         String autor = rs.getString("autor");
         out.println("<tr>");
         out.println("<td>"+ i +"</td>");
         out.println("<td>"+isbn+"</td>");
         out.println("<td>"+titulo+"</td>");         
         out.println("<td>"+autor+"</td>");  
         //out.println("<td>"+"<a class='blue' onclick=eliminar("+isbn+")>Eliminar</a><br>Actualizar"+"</td>");           
         //out.println('<td>'+'<a class=\"blue\" onclick=eliminar('+i+')>Eliminar</a><br><a class=\"blue\" onclick=actualizaAutor('+i+')>Actualizar</a>'+'</td>');           
         out.println("<td>"+"<div><a class='blue' onclick=actualizar("+i+")>Actualizar</a></div><a class='blue' onclick=eliminar("+i+")>Eliminar</a>"+"</td>");           
         out.println("</tr>");
         i++;
      }
      out.println("</tbody></table>");
      out.println("</div>");

      // cierre de la conexion
      conexion.close();
}

%>