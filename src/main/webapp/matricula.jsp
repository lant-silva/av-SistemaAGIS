<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="./css/styles.css">
<title>AGIS - Matricula</title>
<header>
	<h1 align="center">Menu Aluno - Gerenciamento de Matricula</h1>
	<div>
		<jsp:include page="menualuno.jsp" />
	</div>
</header>
</head>
<body>
	<div>
		<div align="center" class="container">
			<form action="matricula" method="post">
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" max="99999999999" id="cpf" name="cpf" placeholder="CPF"
						value=''>
					<td />
					<td><input type="submit" id="botao" name="botao"
						value="Buscar">
					<td />
				</tr>
			</form>
		</div>
	</div>
</body>
</html>