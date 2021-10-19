<%@page contentType="text/html" pageEncoding="iso-8859-1" import="java.sql.*,net.ucanaccess.jdbc.*" %>
 <html>
 <head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title>Actualizar, Eliminar, Crear registros.</title>
 </head>
 <body>

<H1> <a href='libros.jsp?titulo sort=a-z'>MANTENIMIENTO DE LIBROS</a></H1>
<form action="matto.jsp" method="post" name="Actualizar">
	<table>
		<tr>
			<td>ISBN<input type="text" id="isbn" name="isbn" value="" size="40"/></td>
		</tr>
		<tr>
			<td>Título<input type="text" id="titulo" name="titulo" value="" size="50"/></td>
		</tr>
		<tr>
			<td>Autor<input type="text" id="autor" name="autor" value="" size="50"/></td>
		</tr>
 
		<tr>
			<td> Action: 
				<input type="radio" name="Action" value="Actualizar" /> Actualizar
				<input type="radio" name="Action" value="Eliminar" /> Eliminar
				<input type="radio" name="Action" value="Crear" checked /> Crear
			</td>
			<td><input type="SUBMIT" value="ACEPTAR" /></td>
		</tr>
	</table>
</form>
<br>

<%-- Para busqueda --%>

<label>Filtro de busqueda por titulo y autor</label><br>
<input type="text"  id="tituloB" placeholder="ingrese un titulo">
<input type="text"  id="autorB" placeholder="ingrese un autor">
<button class="button is-dark" id="filtro" onclick="filtrar()">Filtrar</button>
<%-- Fin --%>
<br>

<div id="contenidoTabla"><%-- DIV para encerrar la tabla --%>

<%!
public Connection getConnection() throws SQLException {
	String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
	
	//String filePath= "c:\\Apache\\Tomcat\\webapps\\GUIA52cTPI\\JSPdatos-grupo07\\data\\datos.mdb";
	String userName="libros",password="books";
	String fullConnectionString = "jdbc:odbc:"registro";

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
ServletContext context = request.getServletContext();

Connection conexion = getConnection();
	if (!conexion.isClosed()){
		out.write("OK");
 
      Statement st = conexion.createStatement();
      ResultSet rs = st.executeQuery("select * from libros" );

      // Ponemos los resultados en un table de html
      out.println("<table border=\"1\"><tr><td>Num.</td><td>ISBN</td><td>Titulo</td>><td>Autor</td><td>Acci�n</td></tr>");
      int i=1;
      while (rs.next())
      {
		  	
         String isbn=rs.getString("isbn") ;
         String titulo=rs.getString("titulo") ;
		 String autor = rs.getString("autor");
         out.println("<tr>");
         out.println("<td>"+ i +"</td>");
         out.println("<td>"+isbn+"</td>");
         out.println("<td>"+titulo+"</td>");
		 out.println("<td>"+autor+"</td>");
         out.println("<td>Actualizar<br><a href='libros.jsp'> Eliminar </a></td>");
         out.println("</tr>");
         i++;
      }
      out.println("</table>");

      // cierre de la conexion
      conexion.close();
}

%>

</div>

	<script>
		const limpiarInput = () =>{
            document.getElementById("tituloB").value = ""
            document.getElementById("autorB").value = ""
         }

         limpiarInput()
         document.getElementById("filtro").disabled = true

         const desactivar = () => {
            let titulo = document.getElementById("tituloB").value;
            let autor = document.getElementById("autorB").value;
            if (titulo === "" && autor ==="") {
               document.getElementById("filtro").disabled = true
               cargarTabla()
            } else {
               document.getElementById("filtro").disabled = false
            }
         }

         document.getElementById("tituloB").addEventListener('keyup', function (e) {
            desactivar()
         })

         document.getElementById("autorB").addEventListener('keyup', function (e) {
            desactivar()
         })


   const cargarTabla = () => {
            let url = new URL("http://localhost:8080/GUIA52cTPI/JSPdatos-grupo07/tabla.jsp");
            url.searchParams.append("titulo", "");
            url.searchParams.append("autor", "");
            fetch(url, { method: 'GET' })
               .then(response => {
                  if (!response.ok) {
                     throw new Error('Network response was not ok.');
                  }
                  else {
                     return response.text();
                  }
               }).then(data => {
                  document.getElementById("contenidoTabla").innerHTML = data
               }).catch((err) => {
                  console.log(err);
               });
               limpiarInput()
         }

   const filtrar = () => {
            let url = new URL("http://localhost:8080/GUIA52cTPI/JSPdatos-grupo07/tabla.jsp");
            url.searchParams.append("titulo", document.getElementById("tituloB").value);
            url.searchParams.append("autor", document.getElementById("autorB").value);
            fetch(url, { method: 'get' })
               .then(response => {
                  if (!response.ok) {
                     throw new Error('Network response was not ok.');
                  }
                  else {
                     return response.text();
                  }
               }).then(data => {
                  document.getElementById("contenidoTabla").innerHTML = data
               }).catch((err) => {
                  console.log(err);
               });
         } 
	
	
	
	
	
	</script>

 </body>