USE master
DROP DATABASE agis

CREATE DATABASE agis
USE agis

-- Cria��o Tabelas
-------------------------------------------------------------------------------

CREATE TABLE aluno(
cpf						CHAR(11)		NOT NULL,
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
ano_limite				CHAR(6)			NOT NULL
PRIMARY KEY(cpf)
)

CREATE TABLE aluno_telefone(
telefone				CHAR(11)		NOT NULL,
aluno_cpf				CHAR(11)		NOT NULL
PRIMARY KEY(telefone, aluno_cpf)
FOREIGN KEY(aluno_cpf) REFERENCES aluno(cpf)
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
qtd_horas				INT				NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE disciplina_curso(
codigo_curso			INT				NOT NULL,
codigo_disciplina		INT				NOT NULL
PRIMARY KEY(codigo_curso, codigo_disciplina)
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo),
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo)
)

CREATE TABLE conteudo(
codigo					INT				NOT NULL,
descricao				VARCHAR(200)	NOT NULL,
codigo_disciplina		INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo)
)

CREATE TABLE matricula(
codigo					INT				NOT NULL	IDENTITY(1001,1),
aluno_cpf				CHAR(11)		NOT NULL,
turno					VARCHAR(20)		NOT NULL,
codigo_curso			INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(aluno_cpf) REFERENCES aluno(cpf),
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo)
)

CREATE TABLE matricula_disciplina(
codigo_disciplina		INT				NOT NULL,
codigo_matricula		INT				NOT NULL,
estado_disciplina		VARCHAR(50)		NOT NULL
PRIMARY KEY(codigo_disciplina, codigo_matricula)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY(codigo_matricula) REFERENCES matricula(codigo)
)


-- Cria��o Procedures
---------------------------------------------------------------------------------
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
	RAISERROR('CPF Inv�lido', 16, 1)
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

------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------

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
	
	-- Verificar se o RA gerado já pertence a um aluno, caso contrário, gere outro
	IF EXISTS(SELECT ra FROM aluno WHERE ra = @ra)
	BEGIN 
		SET @existe = 1
	END
	ELSE 
	BEGIN 
		SET @existe = 0
	END
END

----------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_geraranolimite(@ano CHAR(4), @sem CHAR(1), @anolimite CHAR(6) OUTPUT)
AS
BEGIN
SET @ano = CAST((CAST(@ano AS INT) + 5) AS CHAR)
SET @anolimite = FORMATMESSAGE('%s/%s', @ano, @sem)
END
----------------------------------------------------------------------------------------------

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
				 		     @saida VARCHAR(300) OUTPUT)
AS
DECLARE @cpfvalido BIT = 0
DECLARE @idadevalida BIT = 0

-- Validar CPF

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
	ano_ingresso, semestre_ingresso, semestre_graduacao, ano_limite) VALUES
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
	 @anolimite)
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
		ano_limite = @anolimite
	WHERE cpf = @cpf
	SET @saida = 'Aluno atualizado'
END
ELSE 
BEGIN 
	RAISERROR('Erro desconhecido', 16, 1)
END

DECLARE @saida VARCHAR(200)
EXEC sp_iudaluno 'I', '52169314814', 0, 'fulano', 'fulano', '2000-01-01', 'fulano@email.com', 'fulano@email.com', '2000-01-01', 'instituicao', 800, 10, '2002', '1', '20051', '0', @saida OUTPUT
PRINT @saida

SELECT * FROM aluno 

-- Procedure IUD Cursos
--------------------------------------------------------------------------

CREATE PROCEDURE sp_iudcurso(@acao CHAR(1), @codigo INT, @nome VARCHAR(100), @cargahoraria INT, @sigla VARCHAR(10), @notaenade INT, @saida VARCHAR(300) OUTPUT)
AS
IF(UPPER(@acao) = 'I')
BEGIN
	INSERT INTO curso (codigo, nome, carga_horaria, sigla, nota_enade) VALUES
	(@codigo, @nome, @cargahoraria, @sigla, @notaenade)
	SET @saida = 'Curso inserido'
END
ELSE 
IF(UPPER(@acao) = 'U')
BEGIN 
	UPDATE curso
	SET nome = @nome, carga_horaria = @cargahoraria, sigla = @sigla, nota_enade = @notaenade
	WHERE codigo = @codigo
	SET @saida = 'Curso alterado'
END
ELSE 
IF(UPPER(@acao) = 'D')
BEGIN 
	DELETE curso
	WHERE codigo = @codigo
	SET @saida = 'Curso removido'
END
ELSE 
BEGIN 
	RAISERROR('Operação inválida', 16, 1)
END

DECLARE @saida VARCHAR(300)
EXEC sp_iudcurso 'I', 101, 'Análise e Desenvolvimento de Sistemas', 2800, 'ADS', 5, @saida OUTPUT
PRINT @saida

SELECT * FROM curso
