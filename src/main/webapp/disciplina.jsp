<!--  tenta fazer esse aqui davi, esse tem o combobox do video 3 do colevati -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="./css/styles.css">
<title>AGIS - Disciplina</title>
<header>
	<h1 align="center">Gerenciamento de Disciplinas</h1>
	<div>
		<jsp:include page="menusecretaria.jsp" />
	</div>
</header>
</head>
<body>
	<div align="center" class"container">
		<form action="disciplina" method="post">
			<table>
				<tr>
					<td colspan="3">
						<select class="input_data" id="curso" name="curso">
							<option value="0">Escolha um curso</option>
							<c:forEach var="c" items="${cursos }">
								<option value="${c.codigo }">
									<c:out value="${c.nome }"/>
								</option>
							</c:forEach>
						</select>
					<td />
				<tr />
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="codigo" name="codigo" placeholder="Código Disciplina"
						value='<c:out value="${disciplina.codigo}"></c:out>'>
					<td />
					<td><input type="submit" id="botao" name="botao"
						value="Buscar">
					<td />
				<tr />
				<tr>
					<td colspan="3"><input class="input_data" type="text"
						maxlength="100" id="nome" name="nome" placeholder="Nome Disciplina"
						value='<c:out value="${disciplina.nome}"></c:out>'>
					<td />
				<tr />
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="codigo" name="codigo" placeholder="Duração da aula"
						value='<c:out value="${disciplina.qtdHoras}"></c:out>'>
					<td />
				<tr />
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="codigo" name="codigo" placeholder="Código Disciplina"
						value='<c:out value="${disciplina.horario}"></c:out>'>
					<td />
				<tr />
				<tr>
					<td colspan="3"><input class="input_data" type="number"
						min="0" id="codigo" name="codigo" placeholder="Dia da semana"
						value='<c:out value="${disciplina.dia}"></c:out>'>
					<td />
				<tr />
			</table>
		</form>
	</div>
</body>
</html>