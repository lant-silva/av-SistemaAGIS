<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="./css/styles.css">
<title>Bem-Vindo ao AGIS</title>
<header> <!-- Cabe�alho pra dar boas vindas pro usuario -->
	<h1 align="center">Bem Vindo ao AGIS</h1>
</header>
</head>
<body>
<div align="center"> 
<!--
Essa div tem dois bot�es, um para acessar a �rea da secretaria,
onde estar�o todos os CRUDs, e a matr�cula, onde o aluno
poder� realizar a matricula 
-->
	</br>
	</br>
	<h1 class="texto">Acesso ao sistema</h1>
	</br>
	</br>
	<div class="menu">
		<li><a href="secretaria.jsp">Vis�o Secretaria</a></li>
		<li><a href="${pageContext.request.contextPath}/matricula">Vis�o Aluno</a></li>
	</div>
</div>
</body>
	<footer><b>Desenvolvido por Davi De Queiroz e Luiz Antonio</b></footer>
</html>