-- 📝 Table Structures:

--  Actors Table 🌟

-- id: A unique ID for each actor 🎭

-- name: The actor’s name ✨

-- age: The actor's age 🎂

CREATE DATABASE IF NOT EXISTS Movie_DB;

USE Movie_DB;

CREATE TABLE IF NOT EXISTS Actors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    yr_of_birth INT NOT NULL,
    gender ENUM('male','famale','other') NOT NULL
);

-- Movies Tables 🎥

-- id: A unique ID for each movie 🎟️

-- title: The name of the movie 🎬

-- Year: The release year of the movie📅

DROP TABLE IF EXISTS Movies;

CREATE TABLE IF NOT EXISTS Movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    gener VARCHAR(100) NOT NULL
);

INSERT INTO Actors(name, yr_of_birth, gender) VALUES
('Robert Jr. Downey', 1969, 'male'),
('Chris Evans', 1981, 'male'),
('Anna De Armas', 1990, 'famale'),
('Zendaya Coleman', 1998, 'famale'),
('Tom Holland', 1996, 'male');


INSERT INTO Movies(title, year, gener) VALUES
('Avengers: Endgame', 2019, 'Action'),
('Fantastic 4', 2005, 'Action'),
('Love Island', 2022, 'Reality TV'),
('The Amazing Spiderman', 2012, 'Action'),
('The Magicians', 2015, 'Fantasy'),
('Snow White', 2024, 'Musical');

-- Queries

SELECT * FROM Actors
WHERE gender = 'famale';

SELECT * FROM actors
WHERE yr_of_birth BETWEEN 1990 AND 2000;

SELECT * FROM Movies
WHERE gener = 'Fantasy';

SELECT * FROM Movies 
WHERE title = 'Snow White';

SELECT title, year FROM movies
ORDER BY year DESC;