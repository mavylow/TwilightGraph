USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TwilightGraph')
BEGIN
    ALTER DATABASE TwilightGraph SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TwilightGraph;
END
GO

CREATE DATABASE TwilightGraph;
GO

USE TwilightGraph;
GO


--Персонажи
CREATE TABLE Character (
    id INT PRIMARY KEY,
    name NVARCHAR(100),
    species NVARCHAR(50),
    birth_year INT
) AS NODE;

--Артефакты
CREATE TABLE Artifact (
    id INT PRIMARY KEY,
    name NVARCHAR(100),
    origin NVARCHAR(100)
) AS NODE;

--Места
CREATE TABLE Place (
    id INT PRIMARY KEY,
    name NVARCHAR(100),
    region NVARCHAR(100)
) AS NODE;

--Отношения
CREATE TABLE RelatedTo (
    relation NVARCHAR(50)
) AS EDGE;

--ПроживаютВ
CREATE TABLE LivedIn AS EDGE;

--ОбладаютАртефактом
CREATE TABLE Owns AS EDGE;

--Битвы
CREATE TABLE Fought (
    date DATE,
    location NVARCHAR(100)
) AS EDGE;
GO

-- Вставка персонажей
INSERT INTO Character VALUES
(1, 'Edward Cullen', 'Vampire', 1901),
(2, 'Bella Swan', 'Human', 1987),
(3, 'Jacob Black', 'Werewolf', 1990),
(4, 'Alice Cullen', 'Vampire', 1901),
(5, 'Aro', 'Vampire', 1000),
(6, 'Carlisle Cullen', 'Vampire', 1640),
(7, 'Renesmee Cullen', 'Hybrid', 2007),
(8, 'Jane', 'Vampire', 1500),
(9, 'Rosalie Hale', 'Vampire', 1915),
(10, 'Emmett Cullen', 'Vampire', 1915);

-- Вставка артефактов
INSERT INTO Artifact VALUES
(1, 'Aro''s ring', 'Volterra'),
(2, 'Bella''s shield', 'Forks'),
(3, 'Cullen family crest', 'Forks'),
(4, 'Jacob''s charm', 'La Push'),
(5, 'Renesmee''s locket', 'Forks'),
(6, 'Carlisle''s ring', 'Forks'),
(7, 'Alice''s vision pendant', 'Forks'),
(8, 'Jane''s cloak pin', 'Volterra'),
(9, 'Emmett''s chain', 'Forks'),
(10, 'Rosalie''s mirror', 'Forks');

-- Вставка мест
INSERT INTO Place VALUES
(1, 'Forks', 'Washington'),
(2, 'La Push', 'Washington'),
(3, 'Volterra', 'Italy'),
(4, 'Cullen House', 'Forks'),
(5, 'High School', 'Forks'),
(6, 'Forest', 'Washington'),
(7, 'Bella''s House', 'Forks'),
(8, 'Volturi Hall', 'Volterra'),
(9, 'Wolf Camp', 'La Push'),
(10, 'Denali', 'Alaska');

-- Связи: родственные, партнёрские
INSERT INTO RelatedTo ($from_id, $to_id, relation) VALUES
((SELECT $node_id FROM Character WHERE name='Edward Cullen'),
 (SELECT $node_id FROM Character WHERE name='Bella Swan'), 'Partner'),

((SELECT $node_id FROM Character WHERE name='Edward Cullen'),
 (SELECT $node_id FROM Character WHERE name='Renesmee Cullen'), 'Father'),

((SELECT $node_id FROM Character WHERE name='Bella Swan'),
 (SELECT $node_id FROM Character WHERE name='Renesmee Cullen'), 'Mother'),

((SELECT $node_id FROM Character WHERE name='Carlisle Cullen'),
 (SELECT $node_id FROM Character WHERE name='Edward Cullen'), 'Adoptive Father'),

((SELECT $node_id FROM Character WHERE name='Carlisle Cullen'),
 (SELECT $node_id FROM Character WHERE name='Rosalie Hale'), 'Adoptive Father'),

((SELECT $node_id FROM Character WHERE name='Carlisle Cullen'),
 (SELECT $node_id FROM Character WHERE name='Emmett Cullen'), 'Adoptive Father'),
 
((SELECT $node_id FROM Character WHERE name='Rosalie Hale'),
 (SELECT $node_id FROM Character WHERE name='Emmett Cullen'), 'Partner');

-- Связи: проживание
INSERT INTO LivedIn ($from_id, $to_id) VALUES
((SELECT $node_id FROM Character WHERE name='Edward Cullen'),
 (SELECT $node_id FROM Place WHERE name='Cullen House')),

((SELECT $node_id FROM Character WHERE name='Carlisle Cullen'),
 (SELECT $node_id FROM Place WHERE name='Cullen House')),

((SELECT $node_id FROM Character WHERE name='Alice Cullen'),
 (SELECT $node_id FROM Place WHERE name='Cullen House')),

((SELECT $node_id FROM Character WHERE name='Emmett Cullen'),
 (SELECT $node_id FROM Place WHERE name='Cullen House')),

((SELECT $node_id FROM Character WHERE name='Rosalie Hale'),
 (SELECT $node_id FROM Place WHERE name='Cullen House')),

((SELECT $node_id FROM Character WHERE name='Bella Swan'),
 (SELECT $node_id FROM Place WHERE name='Bella''s House')),

((SELECT $node_id FROM Character WHERE name='Jacob Black'),
 (SELECT $node_id FROM Place WHERE name='La Push')),

((SELECT $node_id FROM Character WHERE name='Jane'),
 (SELECT $node_id FROM Place WHERE name='Volturi Hall')),

((SELECT $node_id FROM Character WHERE name='Aro'),
 (SELECT $node_id FROM Place WHERE name='Volturi Hall')),

((SELECT $node_id FROM Character WHERE name='Renesmee Cullen'),
 (SELECT $node_id FROM Place WHERE name='Cullen House'));

-- Связи: владение артефактами
INSERT INTO Owns ($from_id, $to_id) VALUES
((SELECT $node_id FROM Character WHERE name='Aro'),
 (SELECT $node_id FROM Artifact WHERE name='Aro''s ring')),

((SELECT $node_id FROM Character WHERE name='Jane'),
 (SELECT $node_id FROM Artifact WHERE name='Jane''s cloak pin')),

((SELECT $node_id FROM Character WHERE name='Bella Swan'),
 (SELECT $node_id FROM Artifact WHERE name='Bella''s shield')),

((SELECT $node_id FROM Character WHERE name='Carlisle Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Cullen family crest')),

((SELECT $node_id FROM Character WHERE name='Carlisle Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Carlisle''s ring')),

((SELECT $node_id FROM Character WHERE name='Emmett Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Emmett''s chain')),

((SELECT $node_id FROM Character WHERE name='Emmett Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Cullen family crest')),

((SELECT $node_id FROM Character WHERE name='Rosalie Hale'),
 (SELECT $node_id FROM Artifact WHERE name='Cullen family crest')),

((SELECT $node_id FROM Character WHERE name='Rosalie Hale'),
 (SELECT $node_id FROM Artifact WHERE name='Rosalie''s mirror')),

((SELECT $node_id FROM Character WHERE name='Renesmee Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Cullen family crest')),

((SELECT $node_id FROM Character WHERE name='Alice Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Cullen family crest')),

((SELECT $node_id FROM Character WHERE name='Alice Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Alice''s vision pendant')),

((SELECT $node_id FROM Character WHERE name='Edward Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Cullen family crest')),

((SELECT $node_id FROM Character WHERE name='Jacob Black'),
 (SELECT $node_id FROM Artifact WHERE name='Jacob''s charm')),

((SELECT $node_id FROM Character WHERE name='Renesmee Cullen'),
 (SELECT $node_id FROM Artifact WHERE name='Renesmee''s locket'));

-- Связи: битвы
INSERT INTO Fought ($from_id, $to_id, date, location) VALUES
((SELECT $node_id FROM Character WHERE name='Edward Cullen'),
 (SELECT $node_id FROM Character WHERE name='Aro'), '2010-01-01', 'Volterra'),

((SELECT $node_id FROM Character WHERE name='Jacob Black'),
 (SELECT $node_id FROM Character WHERE name='Jane'), '2009-12-12', 'Forest'),

((SELECT $node_id FROM Character WHERE name='Alice Cullen'),
 (SELECT $node_id FROM Character WHERE name='Jane'), '2009-10-10', 'Volturi Hall');
GO

-- Исправленные запросы на Match
--1. Найти всех персонажей, которые являются вампирами и их места проживания
SELECT c.name AS Vampire, p.name AS Place
FROM Character c, LivedIn li, Place p
WHERE MATCH(c-(li)->p)
    AND c.species = 'Vampire';

--2. Найти все артефакты, которые принадлежат персонажам
SELECT c.name AS Character, a.name AS Artifact
FROM Character c, Owns o, Artifact a
WHERE MATCH(c-(o)->a);

--3. Найти все персонажи, которые являются родителями или партнерами Ренесме
SELECT c1.name AS ParentOrPartner, rt.relation
FROM Character c1, RelatedTo rt, Character c2
WHERE MATCH(c1-(rt)->c2)
    AND c2.name = 'Renesmee Cullen';

--4. Найти битвы, которые произошли в определенном месте (используем location из Fought)
SELECT c1.name AS Character1, c2.name AS Character2, f.date, f.location
FROM Character c1, Fought f, Character c2
WHERE MATCH(c1-(f)->c2)
    AND f.location = 'Volterra';

--5. Найти персонажей, которые жили в одном месте и являются партнерами
SELECT c1.name AS Character1, c2.name AS Character2, p.name AS Place
FROM Character c1, Character c2, Place p, LivedIn li1, LivedIn li2, RelatedTo rt
WHERE MATCH(c1-(li1)->p AND c2-(li2)->p)
    AND MATCH(c1-(rt)->c2)
    AND rt.relation = 'Partner'
    AND c1.id < c2.id;


---------

--Пример: Найти кратчайшие пути от "Edward Cullen" ко всем другим персонажам через родственные/партнёрские связи:
SELECT 
    N'Edward Cullen' AS StartCharacter,
    STRING_AGG(Target.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Path,
    COUNT(Target.name) WITHIN GROUP (GRAPH PATH) AS Steps
FROM 
    Character AS Start,
    Character FOR PATH AS Target,
    RelatedTo FOR PATH AS rel
WHERE 
    MATCH(SHORTEST_PATH(Start(-(rel)->Target)+))
    AND Start.name = N'Edward Cullen'
ORDER BY 
    Steps;



-- Альтернатива: Через Fought (битвы между персонажами)
SELECT 
    N'Jacob Black' AS StartCharacter,
    STRING_AGG(Target.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Path,
    COUNT(Target.name) WITHIN GROUP (GRAPH PATH) AS Steps
FROM 
    Character AS Start,
    Character FOR PATH AS Target,
    Fought FOR PATH AS fight
WHERE 
    MATCH(SHORTEST_PATH(Start(-(fight)->Target){1,}))
    AND Start.name = N'Jacob Black'
ORDER BY 
    Steps;


