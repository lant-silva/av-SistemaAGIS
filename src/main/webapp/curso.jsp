<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="./css/styles.css">
<title>AGIS - Curso</title>
<header>
	<h1 align="center">Gerenciamento de Cursos</h1>
	<div>
		<jsp:include page="menusecretaria.jsp" />
	</div>
</header>
</head>
<body>
	<div align="center" class="container">
		<form action="curso" method="post">
			<table>
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="codigo" name="codigo" placeholder="Código Curso"
						value='<c:out value="${curso.codigo}"></c:out>'>
					<td />
					<td><input type="submit" id="botao" name="botao"
						value="Buscar">
					<td />
				</tr>
				<tr>
					<td colspan="3"><input class="input_data" type="text"
						maxlength="100" id="nome" name="nome" placeholder="Nome Curso"
						value='<c:out value="${curso.nome}"></c:out>'>
					<td />
				</tr>
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="cargaHoraria" name="cargaHoraria" placeholder="Carga horária"
						value='<c:out value="${curso.cargaHoraria}"></c:out>'>
					<td />
				</tr>
				<tr>
					<td colspan="3"><input class="input_data" type="text"
						maxlength="10" id="sigla" name="sigla" placeholder="Sigla Curso"
						value='<c:out value="${curso.sigla}"></c:out>'>
					<td />
				</tr>
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="notaEnade" name="notaEnade" placeholder="Nota ENADE"
						value='<c:out value="${curso.notaEnade}"></c:out>'>
					<td />
				</tr>
				<tr>
					<td><input type="submit" id="botao" name="botao"
						value="Cadastrar"></td>
					<td><input type="submit" id="botao" name="botao"
						value="Alterar"></td>
					<td><input type="submit" id="botao" name="botao"
						value="Excluir"></td>
					<td><input type="submit" id="botao" name="botao"
						value="Listar"></td>
				</tr>
			</table>
		</form>
	</div>
	</br>
		<div align="center">
		<c:if test="${not empty saida }">
			<H2>
				<b><c:out value="${saida }" /></b>
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
		<c:if test="${not empty cursos }">
			<table class="table_round">
				<thead>
					<tr>
						<th>Codigo</th>
						<th>Nome</th>
						<th>Carga Horária</th>
						<th>Sigla</th>
						<th>Nota Enade</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="c" items="${cursos }">
						<tr>
							<td><c:out value="${c.codigo}" /></td>
							<td><c:out value="${c.nome}" /></td>
							<td><c:out value="${c.cargaHoraria}" /></td>
							<td><c:out value="${c.sigla}" /></td>
							<td><c:out value="${c.notaEnade}" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>