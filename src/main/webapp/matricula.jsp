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
	<form action="matricula" method="post">
		<div align="center" class="container">
			<tr>
				<td colspan="3"><input class="input_data" type="text" id="cpf"
					name="cpf" placeholder="CPF" value='' maxlength="11"
					oninput="this.value = this.value.replace(/[^0-9]/g, '')">
				<td />
				<td><input type="submit" id="botao" name="botao"
					value="Iniciar Matricula">
				<td />
			</tr>

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
			<c:if test="${not empty disciplinas }">
				<table id="listaDisciplinas" class="table_round" align="center">
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
						<c:forEach var="d" items="${disciplinas }">
							<tr>
								<td>
									<div>
										<input type="checkbox" name="disciplinasSelecionadas"
											value="${d.disciplina.codigo}">
									</div>
								</td>
								<td><c:out value="${d.disciplina.nome}" /></td>
								<td><c:out value="${d.disciplina.qtdAulas}" /></td>
								<td><c:out value="${d.disciplina.horario}" /></td>
								<td><c:out value="${d.disciplina.diaSemana}" /></td>
								<td><c:out value="${d.situacao}" /></td>
							</tr>
						</c:forEach>
						</br>
						<td><input type="submit" id="botao" name="botao"
							value="Confirmar Matricula">
						<td />
					</tbody>
				</table>
			</c:if>
		</div>
	</form>
<script>


</script>
</body>
</html>