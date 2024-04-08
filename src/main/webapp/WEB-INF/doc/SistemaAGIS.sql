USE master
DROP DATABASE agis

CREATE DATABASE agis
USE agis

/*
 Banco de Dados - Sistema AGIS
 Todas as queries SQL do sistema

 ÍNDICE:
 IND00 - Criação de Tabelas
 IND01 - Stored Procedures
 IND02 - User Defined Functions
 IND03 - Views
 IND04 - Inserções para teste

*/
--  IND00 - Criação de Tabelas
-------------------------------------------------------------------------------

CREATE TABLE aluno(
cpf						CHAR(11)		NOT NULL	UNIQUE,
ra						CHAR(9)			NOT NULL,
nome					VARCHAR(100)	NOT NULL,
nome_social				VARCHAR(100)	NULL,
data_nasc				DATE			NOT NULL,
telefone_celular		CHAR(11)		NOT NULL,
telefone_residencial	CHAR(11)		NULL,
email_pessoal			VARCHAR(200)	NOT NULL,
email_corporativo		VARCHAR(200)	NULL,
data_segundograu		DATE			NOT NULL,
instituicao_segundograu	VARCHAR(100)	NOT NULL,
pontuacao_vestibular	INT				NOT NULL,
posicao_vestibular		INT				NOT NULL,
ano_ingresso			CHAR(4)			NOT NULL,
semestre_ingresso		CHAR(1)			NOT NULL,
semestre_graduacao		CHAR(6)			NOT NULL,
ano_limite				CHAR(6)			NOT NULL,
curso_codigo			INT				NOT NULL,
turno					VARCHAR(10)		NOT NULL	DEFAULT('Tarde')
PRIMARY KEY(ra)
FOREIGN KEY(curso_codigo) REFERENCES curso(codigo)
)

CREATE TABLE curso(
codigo					INT				NOT NULL,
nome					VARCHAR(100)	NOT NULL,
carga_horaria			INT				NOT NULL,
sigla					VARCHAR(10)		NOT NULL,
nota_enade				INT				NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE disciplina(
codigo					INT				NOT NULL,
nome					VARCHAR(100)	NOT NULL,
qtd_aulas				INT				NOT NULL,
horario_inicio			TIME			NOT NULL,
horario_fim				TIME			NOT NULL,
dia						VARCHAR(20)		NOT NULL,
curso_codigo			INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(curso_codigo) REFERENCES curso(codigo)
)

CREATE TABLE conteudo(
codigo					INT				NOT NULL,
descricao				VARCHAR(200)	NOT NULL,
codigo_disciplina		INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo)
)

CREATE TABLE matricula(
codigo					INT				NOT NULL,
aluno_ra				CHAR(9)			NOT NULL,
data_matricula			DATE			NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(aluno_ra) REFERENCES aluno(ra)
)

CREATE TABLE matricula_disciplina(
codigo_matricula		INT				NOT NULL,
codigo_disciplina		INT				NOT NULL,
situacao				VARCHAR(50)		NOT NULL
PRIMARY KEY(codigo_matricula, codigo_disciplina)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY(codigo_matricula) REFERENCES matricula(codigo)
)


-- IND01 - Stored Procedures
---------------------------------------------------------------------------------

-- Procedure de validação do cpf
---------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_validarcpf(@cpf CHAR(11), @valido BIT OUTPUT)
AS
DECLARE @soma1 INT,
	@soma2 INT,
	@cont INT,
	@digito1 INT,
	@digito2 INT

SET @cont = 1
SET @soma1 = 0
SET @soma2 = 0

IF LEN(@cpf) <> 11
BEGIN
	SET @valido = 0
	RAISERROR('CPF Inválido', 16, 1)
	RETURN
END

WHILE(@cont <= 9)	
BEGIN 
	SET @soma1 = @soma1 + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * (11 - @cont))
	SET @cont = @cont + 1
END
SET @cont = 1
WHILE(@cont <= 10)
BEGIN
	SET @soma2 = @soma2 + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * (12 - @cont))
	SET @cont = @cont + 1
END
IF((@soma1 % 11) <  2)
BEGIN
	SET @digito1 = 0
END
ELSE
BEGIN
	SET @digito1 = 11 - (@soma1 % 11)
END

IF((@soma2 % 11) < 2)
BEGIN
	SET @digito2 = 0
END
ELSE
BEGIN
	SET @digito2 = 11 - (@soma2 % 11)
END
IF @digito1 = CAST(SUBSTRING(@cpf, 10, 1) AS INT) AND @digito2 = CAST(SUBSTRING(@cpf, 11, 1) AS INT)
BEGIN
	SET @valido = 1
END
ELSE
BEGIN
	SET @valido = 0
END

-- Procedure de validação da idade
------------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_validaridade(@dtnasc DATE, @valido BIT OUTPUT)
AS
IF(DATEDIFF(YEAR,@dtnasc,GETDATE()) < 16)
BEGIN
	SET @valido = 0
END
ELSE
IF(DATEDIFF(YEAR,@dtnasc,GETDATE())> 120)
BEGIN
	SET @valido = 0
END
ELSE
BEGIN
	SET @valido = 1
END
-- Fim da procedure

-- Procedure de geração do RA
--------------------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_gerarra(@ano CHAR(4), @sem CHAR(1), @ra CHAR(9) OUTPUT)
AS

DECLARE @existe BIT = 1
WHILE(@existe = 1)
BEGIN
	DECLARE @n1 CHAR(1) = CAST(RAND()*10+1 AS CHAR)
	DECLARE @n2 CHAR(1) = CAST(RAND()*10+1 AS CHAR)
	DECLARE @n3 CHAR(1) = CAST(RAND()*10+1 AS CHAR)
	DECLARE @n4 CHAR(1) = CAST(RAND()*10+1 AS CHAR)
	
	SET @ra = @ano + @sem + @n1 + @n2 + @n3 + @n4
	
	-- Verifica se o RA gerado já pertence a um aluno, caso contrário, outro RA vai ser gerado
	IF EXISTS(SELECT ra FROM aluno WHERE ra = @ra)
	BEGIN 
		SET @existe = 1
	END
	ELSE 
	BEGIN 
		SET @existe = 0
	END
END

-- Procedure de geração do Ano e Semestre limite
----------------------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_geraranolimite(@ano CHAR(4), @sem CHAR(1), @anolimite CHAR(6) OUTPUT)
AS
BEGIN
SET @ano = CAST((CAST(@ano AS INT) + 5) AS CHAR)

IF(@sem = '1')
BEGIN
	SET @sem = '2'
END
ELSE
BEGIN
	SET @sem = '1'
END
SET @anolimite = FORMATMESSAGE('%s/%s', @ano, @sem)
END

-- Procedure de geração do ano e semestre de ingresso
---------------------------------------------------------------------------------
CREATE PROCEDURE sp_geraringresso(@ano CHAR(4) OUTPUT, @sem CHAR(1) OUTPUT)
AS
DECLARE @mes INT

SELECT @ano = YEAR(GETDATE())
SELECT @mes = MONTH(GETDATE()) 
IF(@mes <= 6)
BEGIN
	SET @sem = 1
END
ELSE
BEGIN
	SET @sem = 2
END

-- Procedure IUD Aluno
----------------------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_iudaluno(@acao CHAR(1),
				 		     @cpf CHAR(11),
				 			 @ra CHAR(9) OUTPUT,
				 		     @nome VARCHAR(100),
				 		     @nomesocial VARCHAR(100),
				 		     @datanasc DATE,
							 @telefonecelular CHAR(11),
							 @telefoneresidencial CHAR(11),
				 		     @emailpessoal VARCHAR(200),
				 		     @emailcorporativo VARCHAR(200),
				 		     @datasegundograu DATE,
				 		     @instituicaosegundograu VARCHAR(100),
				 		     @pontuacaovestibular INT,
				 		     @posicaovestibular INT,
				 		     @semestregraduacao CHAR(6),
				 		     @anolimite CHAR(6) OUTPUT,
							 @cursocodigo INT,
							 @turno VARCHAR(10),
				 		     @saida VARCHAR(300) OUTPUT)
AS
DECLARE @cpfvalido BIT = 0
DECLARE @idadevalida BIT = 0
DECLARE @codigomatricula INT = 0
DECLARE @anoingresso CHAR(4) = 0
DECLARE @semestreingresso CHAR(1) = 0

SET @turno = 'Tarde'
-- Validar CPF

-- Se o cpf é válido
EXEC sp_validarcpf @cpf, @cpfvalido OUTPUT 
PRINT @cpfvalido
IF(@cpfvalido = 0)
BEGIN 
	RAISERROR('CPF inválido', 16, 1)
	RETURN
END

-- Validar Idade

EXEC sp_validaridade @datanasc, @idadevalida OUTPUT 
PRINT @idadevalida
IF(@idadevalida = 0)
BEGIN 
	RAISERROR('Idade inválida', 16 ,1)
	RETURN
END

-- Gerar o ano/semestre de ingresso do aluno
EXEC sp_geraringresso @anoingresso OUTPUT, @semestreingresso OUTPUT

-- Gerar o RA do aluno
EXEC sp_gerarra @anoingresso, @semestreingresso, @ra OUTPUT 
PRINT @ra

-- Gerar o semestre e ano limite do aluno
EXEC sp_geraranolimite @anoingresso, @semestreingresso, @anolimite OUTPUT 
PRINT @anolimite

-- PROCEDIMENTO IUD

IF(UPPER(@acao) = 'I')
BEGIN
	IF EXISTS(SELECT cpf FROM aluno WHERE cpf = @cpf)
	BEGIN
		RAISERROR('O CPF inserido já existe dentro do sistema', 16, 1)
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO aluno (cpf, ra, nome, nome_social, data_nasc, telefone_celular, telefone_residencial, email_pessoal, email_corporativo,
		data_segundograu, instituicao_segundograu, pontuacao_vestibular, posicao_vestibular,
		ano_ingresso, semestre_ingresso, semestre_graduacao, ano_limite, curso_codigo, turno) VALUES
		(@cpf,
		 @ra,
		 @nome,
		 @nomesocial,
		 @datanasc,
		 @telefonecelular,
		 @telefoneresidencial,
		 @emailpessoal,
		 @emailcorporativo,
		 @datasegundograu,
		 @instituicaosegundograu,
		 @pontuacaovestibular,
		 @posicaovestibular,
		 @anoingresso,
		 @semestreingresso,
		 @semestregraduacao,
		 @anolimite,
		 @cursocodigo,
		 @turno)

		 EXEC sp_gerarmatricula @ra, @codigomatricula
		 SET @saida = 'Aluno inserido'
	END
END
ELSE 
IF(UPPER(@acao) = 'U')
BEGIN 
	UPDATE aluno
	SET nome = @nome,
		nome_social = @nomesocial,
		data_nasc = @datanasc,
		telefone_celular = @telefonecelular,
		telefone_residencial = @telefoneresidencial,
		email_pessoal = @emailpessoal,
		email_corporativo = @emailcorporativo,
		data_segundograu = @datasegundograu,
		instituicao_segundograu = @instituicaosegundograu,
		pontuacao_vestibular = @pontuacaovestibular,
		posicao_vestibular = @posicaovestibular,
		ano_ingresso = @anoingresso,
		semestre_ingresso = @semestreingresso,
		semestre_graduacao = @semestregraduacao,
		ano_limite = @anolimite,
		curso_codigo = @cursocodigo,
		turno = @turno
	WHERE cpf = @cpf
	SET @saida = 'Aluno atualizado'
END
ELSE
BEGIN 
	RAISERROR('Erro desconhecido', 16, 1)
END

-- Fim da procedure

-- Procedure IUD Matrícula 
------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_inserirmatricula(@ra CHAR(9), @codigomatricula INT, @codigodisciplina INT, @saida VARCHAR(200) OUTPUT)
AS
DECLARE @conflito BIT,
		@qtdaula INT,
		@horarioinicio TIME,
		@horariofim TIME,
		@diasemana VARCHAR(50)

SELECT @qtdaula = d.qtd_aulas, @horarioinicio = d.horario_inicio, @horariofim = d.horario_fim, @diasemana = d.dia
FROM disciplina d, matricula_disciplina md, matricula m
WHERE d.codigo = @codigodisciplina
	ANd md.codigo_disciplina = d.codigo
	AND md.codigo_matricula = m.codigo
	AND m.codigo = @codigomatricula
	AND m.aluno_ra = @ra

EXEC sp_verificarconflitohorario @codigomatricula, @qtdaula, @diasemana, @horarioinicio, @horariofim, @conflito OUTPUT

PRINT @conflito
IF(@conflito = 0)
BEGIN
	UPDATE matricula_disciplina 
	SET situacao = 'Em curso'
	WHERE codigo_matricula = @codigomatricula 
		AND codigo_disciplina = @codigodisciplina
	SET @saida = 'Matricula finalizada.'
END
ELSE
BEGIN
	DELETE matricula_disciplina
	WHERE codigo_matricula = @codigomatricula

	DELETE matricula
	WHERE codigo = @codigomatricula

	RAISERROR('Matricula cancelada: Existe conflito de horários', 16, 1)
	RETURN
END
-- Fim da procedure

-- Procedimento Gerar matricula de um aluno
-----------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_gerarmatricula(@ra CHAR(9), @codigomatricula INT OUTPUT)
AS
BEGIN
	DECLARE @cont INT
	DECLARE @novocodigo INT = 0
	DECLARE @ano CHAR(4)
	DECLARE @sem CHAR(1)

	EXEC sp_geraringresso @ano OUTPUT, @sem OUTPUT

	SELECT @cont = COUNT(*)
	FROM matricula
	WHERE aluno_ra = @ra

	IF(@cont >= 1) -- Caso o aluno já seja matriculado
	BEGIN
		SELECT TOP 1 @codigomatricula = codigo 
		FROM matricula WHERE aluno_ra = @ra 
		ORDER BY codigo DESC
		-- Insiro o aluno em uma nova matricula

		SELECT TOP 1 @novocodigo = codigo + 1
		FROM matricula
		ORDER BY codigo DESC

		INSERT INTO matricula VALUES
		(@novocodigo, @ra, GETDATE())


		-- Como a lógica para atualização da matricula será realizada por outra procedure,
		-- eu apenas reinsiro a ultima matricula feita pelo aluno
		INSERT INTO matricula_disciplina
		SELECT @novocodigo, codigo_disciplina, situacao FROM dbo.fn_ultimamatricula(@codigomatricula)

		-- Retorno o novo codigo
		SET @codigomatricula = @novocodigo
	END
	ELSE -- A primeira matricula do aluno
	BEGIN
		IF NOT EXISTS(SELECT * FROM matricula) --Se nenhuma outra matrícula existir (garante que tenha um codigo para ser inserido)
		BEGIN
			SET @codigomatricula = 1000001
		END
		ELSE
		BEGIN
			SELECT TOP 1 @codigomatricula = codigo + 1
			FROM matricula
			ORDER BY codigo DESC
		END

		INSERT INTO matricula VALUES
		(@codigomatricula, @ra, '01-01-2024')

		INSERT INTO matricula_disciplina (codigo_matricula, codigo_disciplina, situacao)
		SELECT * FROM dbo.fn_matriculainicial(@codigomatricula)
	END
END
-- Fim da procedure

-- Procedure de verificação de conflito de horarios em uma matricula
------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_verificarconflitohorario(@codigomatricula INT, @qtdaulas INT, @diasemana VARCHAR(50), @horarioinicio TIME, @horariofim TIME, @conflito BIT OUTPUT)
AS
DECLARE @conflitoexiste INT

SELECT @conflitoexiste = COUNT(*)
FROM matricula_disciplina md, disciplina d
WHERE md.codigo_matricula = @codigomatricula
	AND md.codigo_disciplina = d.codigo
	AND d.dia = @diasemana
	AND	(md.situacao = 'Em curso')
	AND ((@horarioinicio BETWEEN d.horario_inicio AND d.horario_fim) 
	OR (@horariofim BETWEEN d.horario_inicio AND d.horario_fim) 
	OR (d.horario_inicio BETWEEN @horarioinicio AND @horariofim) 
	OR (d.horario_fim BETWEEN @horarioinicio AND @horariofim))

																	
IF (@conflitoexiste >= 1)
BEGIN
	SET @conflito = 1
END
ELSE
BEGIN
	SET @conflito = 0
END
-- Fim da procedure

-- IND02 - User Defined Functions
---------------------------------------------------------------------------

-- Função Matrícula Inicial: Retorna uma tabela com todas as disciplinas determinadas como não cursadas
--------------------------------------------------------------------------
CREATE FUNCTION fn_matriculainicial(@codigomatricula INT)
RETURNS @tabela TABLE(
codigo_matricula INT,
codigo_disciplina INT,
situacao VARCHAR(50)
)
AS
BEGIN
	INSERT INTO @tabela (codigo_matricula, codigo_disciplina, situacao)
	SELECT @codigomatricula, d.codigo, 'Não cursado' AS situacao
	FROM matricula m, curso c, disciplina d, aluno a
	WHERE d.curso_codigo = c.codigo
		AND a.curso_codigo = c.codigo
		AND m.codigo = @codigomatricula
		AND m.aluno_ra = a.ra
	RETURN
END

-- Função Ultima Matrícula: Retorna uma tabela com a ultima matricula feita por um aluno
------------------------------------------------------------------------
CREATE FUNCTION fn_ultimamatricula(@codigomatricula INT)
RETURNS @tabela TABLE(
codigo_matricula INT,
codigo_disciplina INT,
situacao VARCHAR(50)
)
AS
BEGIN
	INSERT INTO @tabela (codigo_matricula, codigo_disciplina, situacao)
	SELECT @codigomatricula AS codigo_matricula, md.codigo_disciplina, md.situacao 
	FROM matricula_disciplina md, matricula m, aluno a, curso c
	WHERE md.codigo_matricula = @codigomatricula	
		AND m.codigo = @codigomatricula
		AND a.curso_codigo = c.codigo
		AND m.aluno_ra = a.ra
	RETURN
END


	DECLARE @codigomatricula INT = 202419871
SELECT * FROM dbo.fn_listarultimamatricula(@codigomatricula)

-- Função Listar Ultima Matrícula
------------------------------------------------------------------------
CREATE FUNCTION fn_listarultimamatricula(@ra char(9))
RETURNS @tabela TABLE(
codigo_matricula INT,
codigo INT,
nome VARCHAR(100),
qtd_aulas INT,
horario_inicio TIME,
horario_fim TIME,
dia VARCHAR(20),
curso_codigo INT,
data_matricula CHAR(6),
situacao VARCHAR(50)
)
AS
BEGIN
	DECLARE @codigomatricula INT
	DECLARE @ano CHAR(4)
	DECLARE @sem CHAR(1)
	DECLARE @data CHAR(6)

	SELECT @ano = YEAR(data_matricula) FROM matricula WHERE aluno_ra = @ra
	SELECT @sem = MONTH(data_matricula) FROM matricula WHERE aluno_ra = @ra
	IF(@sem <= 6)
	BEGIN
		SET @sem = 1
	END
	ELSE
	BEGIN
		SET @sem = 2
	END
	SET @data = FORMATMESSAGE('%s/%s', @ano, @sem)

	SELECT TOP 1 @codigomatricula = codigo 
	FROM matricula WHERE aluno_ra = @ra
	ORDER BY codigo DESC

	INSERT INTO @tabela (codigo_matricula, codigo, nome, qtd_aulas, horario_inicio, horario_fim, dia, curso_codigo, data_matricula, situacao)	
	SELECT CAST(md.codigo_matricula AS VARCHAR), CAST(d.codigo AS VARCHAR),
		   d.nome, CAST(d.qtd_aulas AS VARCHAR),
		   d.horario_inicio, d.horario_fim, d.dia AS dia, 
		   CAST(d.curso_codigo AS VARCHAR), @data, md.situacao
	FROM matricula_disciplina md, disciplina d, aluno a, matricula m, curso c
	WHERE m.codigo = @codigomatricula
		AND m.aluno_ra = a.ra
		AND md.codigo_matricula = @codigomatricula
		AND md.codigo_disciplina = d.codigo
		AND a.curso_codigo = c.codigo
		AND d.curso_codigo = c.codigo
	RETURN
END
-- View Alunos
--------------------------------------------------------------------------

CREATE VIEW v_alunos
AS
SELECT a.cpf AS cpf, a.ra AS ra, a.nome AS nome, a.nome_social AS nome_social, a.data_nasc AS data_nasc, a.telefone_celular AS telefone_celular, a.telefone_residencial AS telefone_residencial, a.email_pessoal AS email_pessoal, a.email_corporativo AS email_corporativo, a.data_segundograu AS data_segundograu, 
	   a.instituicao_segundograu AS instituicao_segundograu, a.pontuacao_vestibular AS pontuacao_vestibular, a.posicao_vestibular AS posicao_vestibular, a.ano_ingresso AS ano_ingresso, a.semestre_ingresso AS semestre_ingresso,
	   a.semestre_graduacao AS semestre_graduacao, a.ano_limite AS ano_limite, c.sigla AS curso_sigla, a.curso_codigo AS curso_codigo, a.turno AS turno
FROM aluno a, curso c
WHERE a.curso_codigo = c.codigo

SELECT * FROM v_alunos

-- View Disciplinas
------------------------------------------------------------------------------

CREATE VIEW v_disciplinas
AS
SELECT d.codigo AS codigo, d.nome AS nome, d.qtd_aulas AS qtd_aulas, SUBSTRING(CAST(d.horario_inicio AS VARCHAR), 1, 5) AS horario_inicio, d.dia AS dia, d.curso_codigo AS curso_codigo
FROM disciplina d, curso c
WHERE d.curso_codigo = c.codigo

SELECT * FROM v_disciplinas

-- View Conteudo
-------------------------------------------------------------------------------------

CREATE VIEW v_conteudos
AS
SELECT c.codigo AS codigo, c.descricao AS descricao, c.codigo_disciplina AS codigo_disciplina
FROM conteudo c, disciplina d
WHERE c.codigo_disciplina = d.codigo

SELECT * FROM v_conteudos WHERE codigo_disciplina = 1003

-- View Cursos
--------------------------------------------------------------------------------------

CREATE VIEW v_cursos
AS
SELECT c.codigo AS codigo, c.nome AS nome, c.carga_horaria AS carga_horaria, c.sigla AS sigla, c.nota_enade AS nota_enade
FROM curso c

SELECT * FROM v_cursos

-- IND04 - Inserções para teste
--------------------------------------------------------------------------------------

-- Valores de teste para tabela Curso
INSERT INTO curso VALUES
(101, 'Análise e Desenvolvimento de Sistemas', 2800, 'ADS', 5),
(102, 'Desenvolvimento de Software Multiplataforma', 1400, 'DSM', 5)

-- Valores de teste para tabela Disciplina
-- Curso 101
INSERT INTO disciplina VALUES
(1001, 'Laboratório de Banco de Dados', 4, '14:50', '18:20', 'Segunda', 101),
(1002, 'Banco de Dados', 4, '14:50', '18:20', 'Terça', 101),
(1003, 'Algorítmos e Lógica de Programação', 4, '14:50', '18:20', 'Segunda', 101),
(1004, 'Matemática Discreta', 4, '13:00', '16:30','Quinta', 101),
(1005, 'Linguagem de Programação', 4, '14:50', '18:20', 'Terça', 101),
(1006, 'Estruturas de Dados', 2, '13:00', '14:40', 'Terça', 101),
(1007, 'Programação Mobile', 4, '13:00', '16:30', 'Sexta', 101),
(1008, 'Empreendedorismo', 2, '13:00', '14:40', 'Quarta', 101),
(1009, 'Ética e Responsabilidade', 2, '16:50', '18:20', 'Segunda', 101),
(1010, 'Administração Geral', 4, '14:50', '18:20', 'Terça', 101),
(1011, 'Sistemas de Informação', 4, '13:00', '16:30', 'Terça', 101),
(1012, 'Gestão e Governança de TI', 4, '14:50', '18:20', 'Sexta', 101),
(1013, 'Redes de Computadores', 4, '14:50', '18:20', 'Quinta', 101),
(1014, 'Contabilidade', 2, '13:00', '14:40', 'Quarta', 101),
(1015, 'Economia e Finanças', 4, '13:00', '16:30', 'Quarta', 101),
(1016, 'Arquitetura e Organização de Computadores', 4, '13:00', '16:30', 'Segunda', 101),
(1017, 'Laboratório de Hardware', 4, '13:00', '16:30', 'Segunda', 101),
(1018, 'Sistemas Operacionais', 4, '14:50', '18:20', 'Quinta', 101),
(1019, 'Sistemas Operacionais 2', 4, '14:50', '18:20', 'Sexta', 101),
(1020, 'Programação Web', 4, '13:00', '16:30', 'Terça', 101),
(1021, 'Programação em Microinformática', 2, '13:00', '14:40', 'Sexta', 101),
(1022, 'Programação Linear', 2, '13:00', '14:40', 'Segunda', 101),
(1023, 'Cálculo', 4, '13:00', '16:30', 'Segunda', 101),
(1024, 'Teste de Software', 2, '13:00', '14:40', 'Quinta', 101),
(1025, 'Engenharia de Software 1', 4, '13:00', '16:30', 'Segunda', 101),
(1026, 'Engenharia de Software 2', 4, '13:00', '16:30', 'Terça', 101),
(1027, 'Engenharia de Software 3', 4, '14:50', '18:20', 'Segunda', 101),
(1028, 'Laboratório de Engenharia de Software', 4, '14:50', '18:20', 'Quarta', 101),
(1029, 'Inglês 1', 4, '14:50', '18:20', 'Sexta', 101),
(1030, 'Inglês 2', 2, '14:50', '16:30', 'Terça', 101),
(1031, 'Inglês 3', 2, '13:00', '14:40', 'Sexta', 101),
(1032, 'Inglês 4', 2, '13:00', '14:40', 'Segunda', 101),
(1033, 'Inglês 5', 2, '13:00', '14:40', 'Terça', 101),
(1034, 'Inglês 6', 2, '13:00', '14:40', 'Quinta', 101),
(1035, 'Sociedade e Tecnologia', 2, '14:50', '16:30', 'Terça', 101),
(1036, 'Interação Humano Computador', 4, '14:50', '18:20', 'Terça', 101),
(1037, 'Estatística Aplicada', 4, '14:50', '18:20', 'Quarta', 101),
(1038, 'Laboratório de Redes de Computadores', 4, '14:50', '18:20', 'Sexta', 101),
(1039, 'Inteligência Artificial', 4, '13:00', '16:30', 'Quarta', 101),
(1040, 'Programação para Mainframes', 4, '14:50', '18:20', 'Quarta', 101)

INSERT INTO disciplina VALUES
(1041, 'Programação DSM', 4, '13:00', '16:30', 'Segunda', 102),
(1042, 'Programação Front-end', 4, '13:00', '16:30', 'Quarta', 102),
(1043, ''


-- Valores de teste para tabela Conteudo
-- Disciplinas 1001, 1002, 1003
INSERT INTO conteudo VALUES
(100001, 'Stored Procedures', 1001),
(100002, 'Union e Views', 1001),
(100003, 'Projeto Maven', 1001),
(100004, 'Dynamic Queries', 1001),
(100005, 'User Defined Functions', 1001),
(100006, 'Diagrama de Entidade e Relacionamento', 1002),
(100007, 'Modelagem de Entidade e Relacionamento', 1002),
(100008, 'Normas Formais', 1002),
(100009, 'Fundamentos SQL', 1002),
(100010, 'Criando o Banco SQL', 1002),
(100011, 'Estrutura Sequencial', 1003),
(100012, 'Estrutura de Decisão', 1003),
(100013, 'Estrutura de Repetição', 1003),
(100014, 'Programação Estruturada', 1003),
(100015, 'Fluxograma e Teste de mesa', 1003),
(100016, 'Introdução à Matemática Discreta', 1004),
(100017, 'Conceitos Fundamentais de Matemática Discreta', 1004),
(100018, 'Teoria dos Conjuntos', 1004),
(100019, 'Álgebra Booleana', 1004),
(100020, 'Aplicações de Matemática Discreta em Computação', 1004),
(100021, 'Introdução à Linguagem de Programação', 1005),
(100022, 'Estruturas de Controle em Java', 1005),
(100023, 'Funções e Procedimentos', 1005),
(100024, 'Estruturas de Dados em Linguagem de Programação', 1005),
(100025, 'Programação Orientada a Objetos', 1005),
(100026, 'Introdução aos Algoritmos e Lógica de Programação', 1006),
(100027, 'Estruturas de Dados Básicas', 1006),
(100028, 'Algoritmos de Ordenação e Busca', 1006),
(100029, 'Algoritmos Recursivos', 1006),
(100030, 'Complexidade de Algoritmos', 1006),
(100031, 'Introdução ao Desenvolvimento Mobile', 1007),
(100032, 'Interfaces de Usuário em Dispositivos Móveis', 1007),
(100033, 'Acesso a Dados em Dispositivos Móveis', 1007),
(100034, 'Desenvolvimento de Aplicações Móveis Nativas', 1007),
(100035, 'Desenvolvimento de Aplicações Móveis Multiplataforma', 1007),
(100036, 'Conceitos Básicos de Empreendedorismo', 1008),
(100037, 'Identificação de Oportunidades de Negócio', 1008),
(100038, 'Plano de Negócios', 1008),
(100039, 'Marketing e Vendas', 1008),
(100040, 'Aspectos Legais e Financeiros do Empreendedorismo', 1008),
(100041, 'Ética Profissional e Responsabilidade Social', 1009),
(100042, 'Princípios Éticos na Área de Tecnologia', 1009),
(100043, 'Impacto Social da Tecnologia', 1009),
(100044, 'Desafios Éticos em TI', 1009),
(100045, 'Sustentabilidade na Área de Tecnologia', 1009),
(100046, 'Introdução à Administração', 1010),
(100047, 'Funções Administrativas', 1010),
(100048, 'Planejamento Estratégico', 1010),
(100049, 'Organização e Controle', 1010),
(100050, 'Gestão de Pessoas', 1010),
(100051, 'Conceitos de Sistemas de Informação', 1011),
(100052, 'Análise de Sistemas', 1011),
(100053, 'Projeto de Sistemas de Informação', 1011),
(100054, 'Desenvolvimento de Sistemas de Informação', 1011),
(100055, 'Implementação e Manutenção de Sistemas de Informação', 1011),
(100056, 'Governança de Tecnologia da Informação', 1012),
(100057, 'Modelos de Governança de TI', 1012),
(100058, 'Frameworks de Governança de TI', 1012),
(100059, 'Implementação de Governança de TI', 1012),
(100060, 'Avaliação de Governança de TI', 1012),
(100061, 'Introdução às Redes de Computadores', 1013),
(100062, 'Protocolos de Comunicação', 1013),
(100063, 'Topologias de Redes', 1013),
(100064, 'Administração de Redes', 1013),
(100065, 'Segurança em Redes de Computadores', 1013),
(100066, 'Princípios de Sistemas Operacionais', 1014),
(100067, 'Gerenciamento de Processos', 1014),
(100068, 'Gerenciamento de Memória', 1014),
(100069, 'Sistemas de Arquivos', 1014),
(100070, 'Segurança em Sistemas Operacionais', 1014),
(100071, 'Administração Financeira', 1015),
(100072, 'Matemática Financeira', 1015),
(100073, 'Análise de Investimentos', 1015),
(100074, 'Mercado Financeiro', 1015),
(100075, 'Gestão de Riscos Financeiros', 1015),
(100076, 'Arquitetura de Computadores', 1016),
(100077, 'Organização de Computadores', 1016),
(100078, 'Sistemas de Numeração e Codificação', 1016),
(100079, 'Unidade Central de Processamento', 1016),
(100080, 'Memória Principal', 1016),
(10081, 'Componentes de Hardware', 1017),
(10082, 'Periféricos de Entrada e Saída', 1017),
(10083, 'Arquiteturas de Computadores', 1017),
(10084, 'Manutenção e Montagem de Computadores', 1017),
(10085, 'Diagnóstico e Solução de Problemas de Hardware', 1017),
(10086, 'Conceitos Básicos de Sistemas Operacionais', 1018),
(10087, 'Processos e Threads', 1018),
(10088, 'Gerenciamento de Memória e Dispositivos', 1018),
(10089, 'Sistemas de Arquivos e Diretórios', 1018),
(10090, 'Redes em Sistemas Operacionais', 1018),
