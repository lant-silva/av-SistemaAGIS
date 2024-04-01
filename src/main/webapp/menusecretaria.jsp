<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>menu</title>
<link rel="stylesheet" href="./css/styles.css"> 
</head>
<body>
	<nav id="menu">
		<ul>
			<li class="menu-item"><a href="secretaria.jsp">Index</a></li>
			<li class="menu-item"><a href="${pageContext.request.contextPath}/aluno">Aluno</a></li>
			<li class="menu-item"><a href="matricula.jsp">Curso</a></li>
			<li class="menu-item right"><a href="viewchoose.jsp">Sair</a></li>
			<!--<li class="menu-item"><a href="${pageContext.request.contextPath}/disciplina">Disciplina</a></li>-->
		</ul>
	</nav>
	<footer>Desenvolvido por Davi De Queiroz e Luiz Antonio</footer>
</body>
</html>
