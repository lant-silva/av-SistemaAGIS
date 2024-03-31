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
	<div align="center" class="container">
		<form action="matricula" method="post">
			<tr>
				<td colspan="3"><input class="input_data" type="number" min="0"
					max="99999999999" id="codigo" name="codigo"
					placeholder="Código Matricula" value=''>
				<td />
				<td><input type="submit" id="botao" name="botao" value="Buscar">
				<td />
			</tr>
			<tr>
				<td colspan="3"><input class="input_data" type="number" min="0"
					max="99999999999" id="cpf" name="cpf" placeholder="CPF" value=''>
				<td />
			</tr>
		</form>
	</div>
	</br>
	<div align="center">
			<c:if test="${not empty saida }">
				<H2>
					<b><c:out value="${saida }"/></b>
				</H2>
			</c:if>
		</div>
	<br />
	<div align="center">
		<c:if test="${not empty erro }">
			<H2>
				<b><c:out value="${erro }" /></b>
			</H2>
		</c:if>
	</div>
	</br>
	<div align="center">
		<!--<c:if test="${not empty disciplinas }">-->
			<table class="table_round">
				<thead>
					<tr>
						<th></th>
						<th>Nome</th>
						<th>Qtd. Aulas</th>
						<th>Horário de Início</th>
						<th>Dia</th>
						<th>Situação</th>
					</tr>
				</thead>
				<tbody>
					<!--<c:forEach var="d" items="${disciplinas }">-->
						<tr>
							<td><input type="checkbox" name="disciplinasSelecionadas" value=""></td>
							<td><c:out value="${c.codigo}" /></td>
							<td><c:out value="${c.codigo}" /></td>
						</tr>
					<!--</c:forEach>-->
				</tbody>
			</table>
		<!--</c:if>-->
	</div>
</body>
</html>