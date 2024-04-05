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
email_pessoal			VARCHAR(200)	NOT NULL,
email_corporativo		VARCHAR(200)	NOT NULL,
data_segundograu		DATE			NOT NULL,
instituicao_segundograu	VARCHAR(100)	NOT NULL,
pontuacao_vestibular	INT				NOT NULL,
posicao_vestibular		INT				NOT NULL,
ano_ingresso			CHAR(4)			NOT NULL,
semestre_ingresso		CHAR(1)			NOT NULL,
semestre_graduacao		CHAR(6)			NOT NULL,
ano_limite				CHAR(6)			NOT NULL,
curso_codigo			INT				NOT NULL
PRIMARY KEY(ra)
FOREIGN KEY(curso_codigo) REFERENCES curso(codigo)
)

CREATE TABLE aluno_telefone(
telefone				CHAR(11)		NOT NULL,
aluno_ra				CHAR(9)		NOT NULL
PRIMARY KEY(telefone, aluno_ra)
FOREIGN KEY(aluno_ra) REFERENCES aluno(ra)
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
aluno_ra				CHAR(9)			NOT NULL
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

-- Procedure IUD Aluno
----------------------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_iudaluno(@acao CHAR(1),
				 		     @cpf CHAR(11),
				 			 @ra CHAR(9) OUTPUT,
				 		     @nome VARCHAR(100),
				 		     @nomesocial VARCHAR(100),
				 		     @datanasc DATE,
				 		     @emailpessoal VARCHAR(200),
				 		     @emailcorporativo VARCHAR(200),
				 		     @datasegundograu DATE,
				 		     @instituicaosegundograu VARCHAR(100),
				 		     @pontuacaovestibular INT,
				 		     @posicaovestibular INT,
				 		     @anoingresso CHAR(4),
				 		     @semestreingresso CHAR(1),
				 		     @semestregraduacao CHAR(6),
				 		     @anolimite CHAR(6) OUTPUT,
							 @cursocodigo INT,
				 		     @saida VARCHAR(300) OUTPUT)
AS
DECLARE @cpfvalido BIT = 0
DECLARE @idadevalida BIT = 0
DECLARE @codigomatricula INT = 0

-- Validar CPF

-- Se o cpf é válido
EXEC sp_validarcpf @cpf, @cpfvalido OUTPUT 
PRINT @cpfvalido
IF(@cpfvalido = 0)
BEGIN 
	RAISERROR('CPF inválido', 16, 1)
	RETURN
END

-- Se já existe um cpf igual ao inserido no sistema
IF EXISTS(SELECT cpf FROM aluno WHERE cpf = @cpf)
BEGIN
	RAISERROR('O CPF inserido já existe dentro do sistema', 16, 1)
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

-- Gerar o RA do aluno
EXEC sp_gerarra @anoingresso, @semestreingresso, @ra OUTPUT 
PRINT @ra

-- Gerar o semestre e ano limite do aluno
EXEC sp_geraranolimite @anoingresso, @semestreingresso, @anolimite OUTPUT 
PRINT @anolimite

-- PROCEDIMENTO IUD

IF(UPPER(@acao) = 'I')
BEGIN
	INSERT INTO aluno (cpf, ra, nome, nome_social, data_nasc, email_pessoal, email_corporativo,
	data_segundograu, instituicao_segundograu, pontuacao_vestibular, posicao_vestibular,
	ano_ingresso, semestre_ingresso, semestre_graduacao, ano_limite, curso_codigo) VALUES
	(@cpf,
	 @ra,
	 @nome,
	 @nomesocial,
	 @datanasc,
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
	 @cursocodigo)

	 EXEC sp_gerarmatricula @ra, @codigomatricula
	SET @saida = 'Aluno inserido'
END
ELSE 
IF(UPPER(@acao) = 'U')
BEGIN 
	UPDATE aluno
	SET ra = @ra,
		nome = @nome,
		nome_social = @nomesocial,
		data_nasc = @datanasc,
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
		curso_codigo = @cursocodigo
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

DECLARE @saida VARCHAR(200)
EXEC sp_inserirmatricula '52169314814', 1000001, 1001, @saida OUTPUT
PRINT @saida

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

DECLARE @horarioinicio TIME = '14:50'
DECLARE @horariofial TIME = '18:10'
DECLARE @conflito BIT = 0
IF('13:00' >= @horarioinicio OR '13:00' <= @horariofial)
BEGIN
	SET @conflito = 1
END
ELSE
BEGIN
	SET @conflito = 0
END
PRINT @conflito


-- Início da procedure
CREATE PROCEDURE sp_gerarmatricula(@ra CHAR(9), @codigomatricula INT OUTPUT)
AS
BEGIN
	DECLARE @cont INT
	DECLARE @novocodigo INT = 0

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
		(@novocodigo, @ra)


		-- Como a lógica para atualização da matricula será realizada por outra procedure,
		-- eu apenas reinsiro a ultima matricula feita pelo aluno
		INSERT INTO matricula_disciplina
		SELECT @novocodigo, codigo_disciplina, situacao FROM dbo.fn_ultimamatricula(@codigomatricula)

		-- Retorno o novo codigo
		SET @codigomatricula = @novocodigo
	END
	ELSE -- A primeira matricula do aluno
	BEGIN
		IF NOT EXISTS(SELECT * FROM matricula) --Se nenhuma outra matrícula existir (garante que o primeiro aluno a ser inserido 
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
		(@codigomatricula, @ra)

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

PRINT @horariofim
SELECT @conflitoexiste = COUNT(*)
FROM matricula_disciplina md, disciplina d
WHERE md.codigo_matricula = @codigomatricula
	AND md.codigo_disciplina = d.codigo
	AND d.dia = @diasemana
	AND	(md.situacao = 'Em curso')
	AND ((@horarioinicio BETWEEN d.horario_inicio AND d.horario_fim) OR (@horariofim BETWEEN d.horario_inicio AND d.horario_fim) OR (d.horario_inicio BETWEEN @horarioinicio AND @horariofim) OR (d.horario_fim BETWEEN @horarioinicio AND @horariofim))

	--AND ((@horarioinicio >= d.horario_inicio) AND (@horarioinicio <= d.horario_fim) AND (@horariofim >= d.horario_inicio) AND (@horariofim <= d.horario_fim))

print @conflitoexiste
																	
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
	FROM matricula_disciplina md, matricula m
	WHERE md.codigo_matricula = @codigomatricula	
		AND m.codigo = @codigomatricula
	RETURN
END


	DECLARE @codigomatricula INT = 1000001
SELECT * FROM dbo.fn_ultimamatricula(@codigomatricula)

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
situacao VARCHAR(50)
)
AS
BEGIN
	DECLARE @codigomatricula INT

	SELECT TOP 1 @codigomatricula = codigo 
	FROM matricula WHERE aluno_ra = @ra 
	ORDER BY codigo DESC

	INSERT INTO @tabela (codigo_matricula, codigo, nome, qtd_aulas, horario_inicio, horario_fim, dia, curso_codigo, situacao)
	SELECT CAST(md.codigo_matricula AS VARCHAR), CAST(d.codigo AS VARCHAR),
		   d.nome, CAST(d.qtd_aulas AS VARCHAR),
		   d.horario_inicio, d.horario_fim, d.dia AS dia, 
		   CAST(d.curso_codigo AS VARCHAR), md.situacao
	FROM matricula_disciplina md, disciplina d, aluno a, matricula m
	WHERE m.codigo = @codigomatricula
		AND m.codigo = md.codigo_matricula
		AND d.codigo = md.codigo_disciplina
		AND m.aluno_ra = @ra
	RETURN
END
-- View Alunos
--------------------------------------------------------------------------

CREATE VIEW v_alunos
AS
SELECT a.cpf AS cpf, a.ra AS ra, a.nome AS nome, a.nome_social AS nome_social, a.data_nasc AS data_nasc, a.email_pessoal AS email_pessoal, a.email_corporativo AS email_corporativo, a.data_segundograu AS data_segundograu, 
	   a.instituicao_segundograu AS instituicao_segundograu, a.pontuacao_vestibular AS pontuacao_vestibular, a.posicao_vestibular AS posicao_vestibular, a.ano_ingresso AS ano_ingresso, a.semestre_ingresso AS semestre_ingresso,
	   a.semestre_graduacao AS semestre_graduacao, a.ano_limite AS ano_limite, c.sigla AS curso_sigla, a.curso_codigo AS curso_codigo
FROM aluno a, curso c
WHERE a.curso_codigo = c.codigo

SELECT * FROM v_alunos

-- View Disciplinas
------------------------------------------------------------------------------

CREATE VIEW v_disciplinas
AS
SELECT d.codigo AS codigo, d.nome AS nome, d.qtd_aulas AS qtd_aulas, SUBSTRING(CAST(d.horario AS VARCHAR), 1, 5) AS horario, d.dia AS dia, d.curso_codigo AS curso_codigo
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

SELECT * FROM v_conteudos

-- IND04 - Inserções para teste
--------------------------------------------------------------------------------------

delete aluno
delete matricula
where codigo = 1000002

delete matricula_disciplina
where codigo_matricula = 1000002

SELECT * FROM aluno
SELECT * FROM matricula
select * from matricula_disciplina



DECLARE @saida VARCHAR(200)
EXEC sp_iudaluno 'I', '52169314814', 0, 'fulano', 'fulano', '2000-01-01', 'fulano@email.com', 'fulano@email.com', '2000-01-01', 'instituicao', 800, 10, '2002', '1', '20051', '0', 101, @saida OUTPUT
PRINT @saida

DECLARE @conflito BIT
EXEC sp_verificarconflitohorario 1000002, 4, 'Segunda', '16:40', '18:20', @conflito OUTPUT
PRINT @conflito

UPDATE matricula_disciplina
SET situacao = 'Em curso'
WHERE codigo_matricula = 1000002
	AND codigo_disciplina = 1003

DECLARE @saida VARCHAR(200)
EXEC sp_inserirmatricula '200214519', 1000002, 1001, @saida OUTPUT
PRINT @saida

DECLARE @codigomatricula INT
EXEC sp_gerarmatricula '200214519', @codigomatricula OUTPUT
PRINT @codigomatricula

SELECT * FROM matricula_disciplina WHERE codigo_matricula = 1000001

UPDATE matricula_disciplina
SET situacao = 'Em curso'
WHERE codigo_disciplina = 1001

select * from curso
select * from curso c, disciplina d where d.curso_codigo = c.codigo

-- Valores de teste para tabela Curso
INSERT INTO curso VALUES
(101, 'Análise e Desenvolvimento de Sistemas', 2800, 'ADS', 5),
(102, 'Desenvolvimento de Software Multiplataforma', 1400, 'DSM', 5),
(103, 'Recursos Humanos', 1400, 'GRH', 4)

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
(1041, 'Programação DSM', 4, '13:00', '16:30', 'Segunda', 102)


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
(100015, 'Fluxograma e Teste de mesa', 1003)




'

SELECT d.nome, d.qtd_aulas, CONVERT(varchar, d.horario, 8) AS horario, d.dia
FROM disciplina d, curso c
WHERE d.curso_codigo = c.codigo
ORDER BY nome ASC