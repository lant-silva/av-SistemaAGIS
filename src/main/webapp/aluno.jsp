<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="./css/styles.css">
<title>AGIS - Aluno</title>
<header>
	<h1 align="center">Gerenciamento de Alunos</h1>
	<div>
		<jsp:include page="menu.jsp" />
	</div>
</header>
</head>
<body>
<div>
		<div align="center" class="container">
			<form action="aluno" method="post">
				<table>
					<tr>
						<td colspan="3"><input class="input_data" type="number"
							min="0" max="99999999999" id="cpf" name="cpf" placeholder="CPF"
							value=''>
						<td />
						<td><input type="submit" id="botao" name="botao"
							value="Buscar">
						<td />
					<tr />
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="100" id="nome" name="nome" placeholder="Nome"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="100" id="nomeSocial" name="nomeSocial" placeholder="Nome Social"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="date"
							id="dataNasc" name="dataNasc"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="0" max="999999999" id="telefone" name="telefone" placeholder="Telefone" 
							value=''></td>
						<td><input type="submit" id="botao" name="botao"
							value="Add">
						<td />
						<td><input type="submit" id="botao" name="botao"
							value="Remover">
						<td />
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="200" id="emailPessoal" name="emailPessoal"
							placeholder="Email Pessoal" value='<c:out value="${aluno.emailPessoal}"></c:out>'></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="200" id="emailCorporativo" name="emailCorporativo"
							placeholder="Email Corporativo" value='<c:out value="${aluno.emailCorporativo}"></c:out>'></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="date"
							id="dataSegundoGrau" name="dataSegundoGrau"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="100" id="instituicaoSegundoGrau" name="instituicaoSegundoGrau" 
							placeholder="Instituição Segundo Grau"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="0" max="1000" id="pontuacaoVestibular" name="pontuacaoVestibular"
							placeholder="Pontuação no Vestibular" 
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="0" max="999999999" id="posicaoVestibular" name="posicaoVestibular"
							placeholder="Pontuação no Vestibular" 
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="2000" max="2025" id="anoIngresso" name="anoIngresso" 
							placeholder="Ano de Ingresso"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="1" max="2" id="semestreIngresso" name="semestreIngresso" 
							placeholder="Semestre de Ingresso"
							value=''></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="1" max="2" id="semestreGraduacao" name="semestreGraduacao" 
							placeholder="Semestre de Graduação"
							value=''></td>
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
	</div>
	<br />
	<div align="center">
		<c:if test="${not empty erro }">
			<H2>
				<b><c:out value="${erro }" /></b>
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
	
	<!-- Botão Consultar Aluno -->
	<div align="center">
		<c:if test="${not empty listar}">
			<table class="table_round">
				<thead>
					<tr>
						<th>CPF</th>
						<th>RA</th>
						<th>Nome</th>
						<th>Nome Social</th>
						<th>Data Nasc.</th>
						<th>Telefones</th>
						<th>Email Pessoal</th>
						<th>Email Corporativo</th>
						<th>Data Segundo Grau</th>
						<th>Inst. Segundo Grau</th>
						<th>Pontuação Vestibular</th>
						<th>Posição Vestibular</th>
						<th>Ano de Ingresso</th>
						<th>Semestre de Ingresso</th>
						<th>Semestre de Graduação</th>
						<th>Semestre Limite</th>
					</tr>
				</thead>
				<tbody>
						<tr>
							<td><c:out value="${aluno.cpf}" /></td>
							<td><c:out value="${aluno.ra}" /></td>
							<td><c:out value="${aluno.nome}" /></td>
							<td><c:out value="${aluno.nomeSocial}" /></td>
							<td><c:out value="${aluno.dataNasc}" /></td>
							<c:forEach var="t" items="${aluno.telefones }">
								<td><c:out value="${t.telefone}" /></td>
							</c:forEach>
							<td><c:out value="${aluno.emailPessoal}" /></td>
							<td><c:out value="${aluno.emailCorporativo}" /></td>
							<td><c:out value="${aluno.dataSegundoGrau}" /></td>
							<td><c:out value="${aluno.instituicaoSegundoGrau}" /></td>
							<td><c:out value="${aluno.pontuacaoVestibular}" /></td>
							<td><c:out value="${aluno.posicaoVestibular}" /></td>
							<td><c:out value="${aluno.anoIngresso}" /></td>
							<td><c:out value="${aluno.semestreIngresso}" /></td>
							<td><c:out value="${aluno.semestreGraduacao}" /></td>
							<td><c:out value="${aluno.anoLimite}" /></td>
						</tr>
				</tbody>
			</table>
		</c:if>
	</div>
	
	
	<!-- Botão Listar Alunos -->
	<div align="center">
		<c:if test="${not empty alunos }">
			<table class="table_round">
				<thead>
					<tr>
						<th>CPF</th>
						<th>RA</th>
						<th>Nome</th>
						<th>Nome Social</th>
						<th>Data Nasc.</th>
						<th>Telefones</th>
						<th>Email Pessoal</th>
						<th>Email Corporativo</th>
						<th>Data Segundo Grau</th>
						<th>Inst. Segundo Grau</th>
						<th>Pontuação Vestibular</th>
						<th>Posição Vestibular</th>
						<th>Ano de Ingresso</th>
						<th>Semestre de Ingresso</th>
						<th>Semestre de Graduação</th>
						<th>Semestre Limite</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="a" items="${alunos}">
						<tr>
							<td><c:out value="${a.cpf}" /></td>
							<td><c:out value="${a.ra}" /></td>
							<td><c:out value="${a.nome}" /></td>
							<td><c:out value="${a.nomeSocial}" /></td>
							<td><c:out value="${a.dataNasc}" /></td>
							<c:forEach var="t" items="${a.telefones }">
								<td><c:out value="${t.telefone}" /></td>
							</c:forEach>
							<td><c:out value="${a.emailPessoal}" /></td>
							<td><c:out value="${a.emailCorporativo}" /></td>
							<td><c:out value="${a.dataSegundoGrau}" /></td>
							<td><c:out value="${a.instituicaoSegundoGrau}" /></td>
							<td><c:out value="${a.pontuacaoVestibular}" /></td>
							<td><c:out value="${a.posicaoVestibular}" /></td>
							<td><c:out value="${a.anoIngresso}" /></td>
							<td><c:out value="${a.semestreIngresso}" /></td>
							<td><c:out value="${a.semestreGraduacao}" /></td>
							<td><c:out value="${a.anoLimite}" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	
</body>
</html>