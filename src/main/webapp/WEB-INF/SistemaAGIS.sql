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
ano_limite				CHAR(6)			NOT NULL,
curso_codigo			INT				NOT NULL
PRIMARY KEY(cpf)
FOREIGN KEY(curso_codigo) REFERENCES curso(codigo)
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
qtd_aulas				INT				NOT NULL,
horario					TIME			NOT NULL,
dia						VARCHAR(20)		NOT NULL,
curso_codigo				INT				NOT NULL
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
aluno_cpf				CHAR(11)		NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(aluno_cpf) REFERENCES aluno(cpf)
)

CREATE TABLE matricula_disciplina(
codigo_matricula		INT				NOT NULL,
codigo_disciplina		INT				NOT NULL,
situacao				VARCHAR(50)		NOT NULL
PRIMARY KEY(codigo_disciplina, codigo_matricula)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY(codigo_matricula) REFERENCES matricula(codigo)
)


-- Stored Procedures
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

	 EXEC sp_matricula @cpf
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
IF(UPPER(@acao) = 'D')	
BEGIN
	DELETE aluno
	WHERE cpf = @cpf
	SET @saida = 'Aluno removido'
END
ELSE
BEGIN 
	RAISERROR('Erro desconhecido', 16, 1)
END

delete aluno
delete matricula
delete matricula_disciplina

SELECT * FROM aluno
SELECT * FROM matricula
SELECT * FROM matricula_disciplina 

DECLARE @saida VARCHAR(200)
EXEC sp_iudaluno 'I', '52169314814', 0, 'fulano', 'fulano', '2000-01-01', 'fulano@email.com', 'fulano@email.com', '2000-01-01', 'instituicao', 800, 10, '2002', '1', '20051', '0', 101, @saida OUTPUT
PRINT @saida
-- Fim da procedure

SELECT d.codigo AS codigo, d.nome AS nome, d.qtd_aulas AS qtd_aulas
d.horario AS horario, d.dia AS dia, md.situacao AS situacao, d.curso_codigo AS curso_codigo
FROM matricula_disciplina md, disciplina d, aluno a, matricula m
WHERE m.codigo = md.codigo_matricula
AND d.codigo = md.codigo_disciplina
AND m.aluno_cpf = ?


-- Procedure IUD Cursos
--------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_iudcurso(@acao CHAR(1), @codigo INT, @nome VARCHAR(100), @cargahoraria INT, @sigla VARCHAR(10), @notaenade INT, @saida VARCHAR(300) OUTPUT)
AS
IF(UPPER(@acao) = 'I') --Operação de inserção
BEGIN
	INSERT INTO curso (codigo, nome, carga_horaria, sigla, nota_enade) VALUES
	(@codigo, @nome, @cargahoraria, @sigla, @notaenade)
	SET @saida = 'Curso inserido'
END
ELSE 
IF(UPPER(@acao) = 'U') --Operação de atualização
BEGIN 
	UPDATE curso
	SET nome = @nome, carga_horaria = @cargahoraria, sigla = @sigla, nota_enade = @notaenade
	WHERE codigo = @codigo
	SET @saida = 'Curso alterado'
END
ELSE 
IF(UPPER(@acao) = 'D') --Operação de exclusão
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

-- Procedure IUD Disciplina
----------------------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_iuddisciplina (@acao CHAR(1), @codigo INT, @nome VARCHAR(100), @qtdaulas INT, @horario TIME, @diasemana VARCHAR(20), @cursocodigo INT, @saida VARCHAR(200) OUTPUT)
AS
IF(UPPER(@acao) = 'I') --Operação de inserção
BEGIN
	
	--Verificar se a disciplina não é duplicada com outro curso
	IF EXISTS(SELECT curso_codigo FROM disciplina WHERE curso_codigo = @cursocodigo AND nome = @nome)
	BEGIN
		RAISERROR('A disciplina já existe em um curso, remova a disciplina desse curso ou crie uma semelhante.', 16, 1)
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO disciplina VALUES
		(@codigo, @nome, @qtdaulas, @horario, @diasemana, @cursocodigo)
		SET @saida = 'Curso inserido'
	END
END
ELSE
IF(UPPER(@acao) = 'U') --Operação de atualização
BEGIN
	--Verificar se a disciplina não é duplicada com outro curso
	IF EXISTS(SELECT curso_codigo FROM disciplina WHERE curso_codigo = @cursocodigo AND nome = @nome)
	BEGIN
		RAISERROR('A disciplina já existe em um curso, remova a disciplina desse curso ou crie uma semelhante.', 16, 1)
		RETURN
	END
	ELSE
	BEGIN
		UPDATE disciplina
		SET nome = @nome, qtd_aulas = @qtdaulas, horario = @horario, dia = @diasemana, curso_codigo = @cursocodigo
		WHERE codigo = @codigo
		SET @saida = 'Curso atualizado'
	END
END
ELSE
IF(UPPER(@acao) = 'D') --Operação de exclusão
BEGIN
	DELETE disciplina
	WHERE codigo = @codigo
	SET @saida = 'Disciplina removida'
END
ELSE
BEGIN
	RAISERROR('Operação inválida', 16, 1)
END
-- Fim da procedure

-- Procedure IUD Matrícula 
------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_inserirmatricula
-- Fim da procedure

CREATE FUNCTION fn_codigomatricula()
RETURNS INT
AS
BEGIN
	DECLARE @cod INT
	IF NOT EXISTS(SELECT * FROM matricula)
	BEGIN
		SET @cod = 1000001
	END
	ELSE
	BEGIN
		SET @cod = (SELECT TOP 1 codigo FROM matricula ORDER BY codigo ASC) + 1
	END
	RETURN @cod
END

INSERT INTO matricula VALUES
(1009002, '52169314814')

DELETE matricula

SELECT * FROM matricula

SELECT dbo.fn_codigomatricula() AS codigo

-- Procedimento Gerar matricula inicial de um aluno
-----------------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_matricula(@cpf CHAR(11))
AS
BEGIN
	DECLARE @codigomatricula INT
	SET @codigomatricula = dbo.fn_codigomatricula()

	INSERT INTO matricula VALUES
	(@codigomatricula, @cpf)
	
	INSERT INTO matricula_disciplina (codigo_matricula, codigo_disciplina, situacao)
	SELECT * FROM dbo.fn_matriculainicial(@codigomatricula)
END


-- Inicio da função
CREATE FUNCTION fn_matriculainicial(@codigomatricula INT)
RETURNS @tabela TABLE(
codigo_matricula INT,
codigo_disciplina INT,
situacao VARCHAR(50)
)
AS
BEGIN
	INSERT INTO @tabela (codigo_matricula, codigo_disciplina, situacao)
	SELECT m.codigo, d.codigo, 'Não cursado' AS situacao
	FROM matricula m, curso c, disciplina d, aluno a
	WHERE d.curso_codigo = c.codigo
		AND a.curso_codigo = c.codigo
		AND m.codigo = @codigomatricula
		RETURN
END
-- Fim da função
-- Fim da procedure

-- Procedure Conteudo
-------------------------------------------------------------------------

-- Início da procedure
CREATE PROCEDURE sp_iudconteudo (@acao CHAR(1), @codigo INT, @descricao VARCHAR(200), @codigodisciplina INT, @saida VARCHAR(200) OUTPUT)
AS
IF(UPPER(@acao) = 'I')
BEGIN
	INSERT INTO conteudo VALUES
	(@codigo, @descricao, @codigodisciplina)
	SET @saida = 'Conteudo inserido'
END
ELSE
IF(UPPER(@acao) = 'U')
BEGIN
	UPDATE conteudo
	SET descricao = @descricao, codigo_disciplina = @codigodisciplina
	WHERE codigo = @codigo
	SET @saida = 'Conteudo atualizado'
END
ELSE
IF(UPPER(@acao) = 'D')
BEGIN
	DELETE conteudo
	WHERE codigo = @codigo
	SET @saida = 'Conteudo removido'
END
ELSE
BEGIN
	RAISERROR('Operação inválida', 16, 1)
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

-- Testes
--------------------------------------------------------------------------------------

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
(1001, 'Laboratório de Banco de Dados', 4, '14:50', 'Segunda', 101),
(1002, 'Banco de Dados', 4, '14:50', 'Terça', 101),
(1003, 'Algorítmos e Lógica de Programação', 4, '14:50', 'Segunda', 101),
(1004, 'Matemática Discreta', 4, '13:00', 'Quinta', 101),
(1005, 'Linguagem de Programação', 4, '14:50', 'Terça', 101),
(1006, 'Estruturas de Dados', 2, '13:00', 'Terça', 101),
(1007, 'Programação Mobile', 4, '13:00', 'Sexta', 101),
(1008, 'Empreendedorismo', 2, '13:00', 'Quarta', 101),
(1009, 'Ética e Responsabilidade', 2, '16:50', 'Segunda', 101),
(1010, 'Administração Geral', 4, '14:50', 'Terça', 101),
(1011, 'Sistemas de Informação', 4, '13:00', 'Terça', 101),
(1012, 'Gestão e Governança de TI', 4, '14:50', 'Sexta', 101),
(1013, 'Redes de Computadores', 4, '14:50', 'Quinta', 101),
(1014, 'Contabilidade', 2, '13:00', 'Quarta', 101),
(1015, 'Economia e Finanças', 4, '13:00', 'Quarta', 101),
(1016, 'Arquitetura e Organização de Computadores', 4, '13:00', 'Segunda', 101),
(1017, 'Laboratório de Hardware', 4, '13:00', 'Segunda', 101),
(1018, 'Sistemas Operacionais', 4, '14:50', 'Quinta', 101),
(1019, 'Sistemas Operacionais 2', 4, '14:50', 'Sexta', 101),
(1020, 'Programação Web', 4, '13:00', 'Terça', 101),
(1021, 'Programação em Microinformática', 2, '13:00', 'Sexta', 101),
(1022, 'Programação Linear', 2, '13:00', 'Segunda', 101),
(1023, 'Cálculo', 4, '13:00', 'Segunda', 101),
(1024, 'Teste de Software', 2, '13:00', 'Quinta', 101),
(1025, 'Engenharia de Software 1', 4, '13:00', 'Segunda', 101),
(1026, 'Engenharia de Software 2', 4, '13:00', 'Terça', 101),
(1027, 'Engenharia de Software 3', 4, '14:50', 'Segunda', 101),
(1028, 'Laboratório de Engenharia de Software', 4, '14:50', 'Quarta', 101),
(1029, 'Inglês 1', 4, '14:50', 'Sexta', 101),
(1030, 'Inglês 2', 2, '14:50', 'Terça', 101),
(1031, 'Inglês 3', 2, '13:00', 'Sexta', 101),
(1032, 'Inglês 4', 2, '13:00', 'Segunda', 101),
(1033, 'Inglês 5', 2, '13:00', 'Terça', 101),
(1034, 'Inglês 6', 2, '13:00', 'Quinta', 101),
(1035, 'Sociedade e Tecnologia', 2, '14:50', 'Terça', 101),
(1036, 'Interação Humano Computador', 4, '14:50', 'Terça', 101),
(1037, 'Estatística Aplicada', 4, '14:50', 'Quarta', 101),
(1038, 'Laboratório de Redes de Computadores', 4, '14:50', 'Sexta', 101),
(1039, 'Inteligência Artificial', 4, '13:00', 'Quarta', 101),
(1040, 'Programação para Mainframes', 4, '14:50', 'Quarta', 101)

INSERT INTO disciplina VALUES
(1041, 'Programação DSM', 4, '13:00', 'Segunda', 102)


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