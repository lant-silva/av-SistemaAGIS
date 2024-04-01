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
							<th>Hor�rio de In�cio</th>
							<th>Dia</th>
							<th>Situa��o</th>
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
document.addEventListener('DOMContentLoaded', function() {
	event.preventDefault();
    var listaDisciplinas = document.getElementById('listaDisciplinas');
    var botaoConfirmar = document.querySelector('input[value="Confirmar Matricula"]');
    inicializar();

function verificaPeriodoMatricula() {
    var dataAtual = new Date();
    var mes = dataAtual.getMonth(); 


    if (mes === 0 || mes === 6) {
        var dia = dataAtual.getDate(); // Obt�m o dia do m�s atual

        // Verifica se o dia do m�s est� entre 15 e 21
        if (dia >= 15 && dia <= 21) {
            return true; // A data atual est� dentro do per�odo de matr�cula
        }
    }

    return false;
}

function desabilitarMatricula() {
    // Desabilita as checkboxes na tabela de disciplinas
    var checkboxes = listaDisciplinas.querySelectorAll('input[type="checkbox"]');
    	checkboxes.forEach(function(checkbox) {
        checkbox.disabled = true;
    });

    var botaoConfirmar = document.querySelector('input[value="Confirmar Matricula"]');
    botaoConfirmar.disabled = true;
    botaoConfirmar.hidden = true;
}

function inicializar() {
    if (!verificaPeriodoMatricula()) {
        desabilitarMatricula();
    }
}
});

</script>
</body>
</html>