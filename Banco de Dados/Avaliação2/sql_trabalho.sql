-----------------------------------
-- Criação ------------------------
-----------------------------------
PRAGMA foreign_keys = ON; 


-- 1. Informe o SQL para criação da tabela aluno (4 pontos):
CREATE TABLE aluno(
matricula integer PRIMARY KEY AUTOINCREMENT NOT NULL,
nome text,
email text,
turma integer
)


-- 2. Informe o SQL para criação da tabela disciplina (4 pontos):
CREATE TABLE disciplina(
id_disciplina integer PRIMARY KEY AUTOINCREMENT NOT NULL,
nome text,
carga_horaria integer
)


-- 3. Informe o SQL para criação da tabela pauta (4 pontos):
CREATE TABLE pauta(
id_pauta integer PRIMARY KEY AUTOINCREMENT NOT NULL,
matricula integer NOT NULL,
id_disciplina integer NOT NULL,
nota_1 decimal,
nota_2 decimal,
nota_3 decimal,
FOREIGN KEY(matricula) REFERENCES aluno(matricula),
FOREIGN KEY(id_disciplina) REFERENCES disciplina(id_disciplina)
)


-- 4. Com o comando ALTER TABLE mude o nome das colunas nota_1, nota_2 e nota_3 para avaliacao_1, avaliacao_2 e avaliacao_3 (2 pontos):
ALTER TABLE pauta RENAME COLUMN nota_1 TO avaliacao_1;
ALTER TABLE pauta RENAME COLUMN nota_2 TO avaliacao_2;
ALTER TABLE pauta RENAME COLUMN nota_3 TO avaliacao_3;


-----------------------------------
-- Inserção dos dados -------------
-----------------------------------
-- Planilha com os dados a serem inseridos: https://tinyurl.com/y3ngdd5s
-- 1. Informe o SQL para inserção na tabela alunos (3 pontos):
INSERT INTO aluno (nome, email, turma) VALUES
('Ana Paula Silva','aps@residencia.com.br',1),
('João Souza','js@residencia.com.br',1),
('Maria Moreira','mm@residencia.com.br',1),
('Daiane Costa','dc@residencia.com.br',2),
('Guilherme Silva','gs@residencia.com.br',1),
('Júlia Almeida','ja@residencia.com.br',2),
('Diogo Andrade','da@residencia.com.br',2),
('Manuela Botelho','mb@gmail.com',1),
('Thiago Tavares','tt@residencia.com',2),
('João Pedro Carvalho','jpc@residencia.com.br',1);


-- 2. Informe o SQL para inserção na tabela disciplina (3 pontos):
INSERT INTO disciplina (nome,carga_horaria) VALUES
('Banco de dados',24),
('Lógica de programação',40),
('Programação backend',44);


-- 3. Informe o SQL para inserção dos dados na tabela pauta
-- (note que devem ser inseridos os respectivos identificadores de
-- alunos e disciplinas, não os nomes) (3 pontos):
INSERT INTO pauta (matricula,id_disciplina,avaliacao_1,avaliacao_2,avaliacao_3)VALUES
(1,	1,	10,	9,	10),
(1,	2,	9,	8,	7),
(1,	3,	7,	7,	9),
(2,	1,	9,	6,	7),
(2,	2,	10,	10,	10),
(2,	3,	9,	8,	9),
(3,	1,	10,	7,	7),
(4,	2,	8,	6,	9),
(4,	3,	6,	6,	8),
(5,	3,	8,	6,	9),
(7,	1,	8,	8,	10),
(8,	2,	5,	7,	7),
(9,	3,	5,	5,	4),
(9,	2,	7,	7,	6),
(10,1,	5,	5,	2);

-----------------------------------
-- Atualização dos dados ----------
-----------------------------------
-- 1. Atualizar o e-mail da aluna Manuela Botelho para mb@residencia.com.br (3 pontos):
UPDATE aluno SET email = 'mb@residencia.com.br' WHERE email = 'mb@gmail.com'


-- 2. Atualizar a nota 3 do aluno João Pedro Carvalho em Banco de dados para 7 (3 pontos):
UPDATE pauta SET avaliacao_3 = 7 WHERE pauta.matricula = 10 
-----------------------------------
-- Consultas ----------------------
-----------------------------------
-- 1. Selecionar o nome e a turma dos alunos (1 ponto):
SELECT nome, turma FROM aluno


-- 2. Selecionar a quantidade total de alunos cadastrados (2 pontos):
SELECT COUNT(nome) as TotalAlunos FROM aluno


-- 3. Selecionar a quantidade total de alunos em cada disciplina (4pontos):
SELECT d.nome, COUNT(p.matricula) as 'Quantidade' FROM pauta p, aluno a, disciplina d
WHERE p.matricula = a.matricula AND d.id_disciplina = p.id_disciplina
GROUP BY p.id_disciplina


-- 4. Selecionar o nome do aluno, disciplina e as três notas de cada aluno (usando INNER JOIN ou WHERE) (4 pontos):
SELECT a.nome, d.nome, p.avaliacao_1, p.avaliacao_2, p.avaliacao_3 
FROM aluno a, disciplina d, pauta p
WHERE a.matricula = p.matricula AND d.id_disciplina = p.id_disciplina


-- 5. Selecionar o nome dos alunos e a quantidade de disciplinas que cada um cursa (4 pontos):
SELECT a.nome, COUNT(p.id_disciplina) as QTD_Disciplina
FROM aluno a, pauta p
WHERE a.matricula = p.matricula
GROUP BY 1


-- 6. Selecionar o nome, disciplina e a média das três notas de cada aluno (4 pontos):
SELECT a.nome, d.nome, round((p.avaliacao_1 + p.avaliacao_2 + p.avaliacao_3)/3.0,2) as Media
FROM aluno a, disciplina d, pauta p
WHERE a.matricula = p.matricula AND d.id_disciplina = p.id_disciplina


-- 7. Selecionar o nome, disciplina e a média das três notas dosalunos que tenham média menor que 6 (4 pontos):
SELECT a.nome, d.nome, round((p.avaliacao_1 + p.avaliacao_2 + p.avaliacao_3)/3.0,2) as Media
FROM aluno a, disciplina d, pauta p
WHERE a.matricula = p.matricula 
AND d.id_disciplina = p.id_disciplina 
AND (p.avaliacao_1 + p.avaliacao_2 + p.avaliacao_3)/3.0 < 6


-- 8. Selecionar o nome da disciplina e as médias das 3 notas(separadamente) de todos os alunos para cada disciplina (4 pontos):
SELECT d.nome, AVG(p.avaliacao_1), AVG(p.avaliacao_2), AVG(p.avaliacao_3) 
FROM disciplina d, pauta p
WHERE d.id_disciplina = p.id_disciplina
GROUP BY d.nome


-- 9. Selecione o aluno com maior nota na avaliação 1 de banco de dados, mostrando qual foi a nota (4 pontos):
SELECT a.nome, d.nome, MAX(p.avaliacao_1) as Maior_Nota
FROM aluno a, pauta p, disciplina d
WHERE p.matricula = a.matricula 
AND p.id_disciplina = (SELECT d.id_disciplina WHERE d.nome LIKE '%Dados')
AND p.avaliacao_1 = (SELECT MAX(p.avaliacao_1) FROM pauta p)
GROUP BY a.nome


