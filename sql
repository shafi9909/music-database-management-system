-- =====================================================
-- Music Database Management System
-- Relational Database Project
-- =====================================================

-- =========================
-- 1. DROP TABLES
-- =========================

DROP TABLE IF EXISTS spieltin;
DROP TABLE IF EXISTS song;
DROP TABLE IF EXISTS musiker;
DROP TABLE IF EXISTS band;

-- =========================
-- 2. CREATE TABLES
-- =========================

CREATE TABLE band (
    B_Name VARCHAR(100) PRIMARY KEY,
    B_GrJahr INT NOT NULL CHECK (B_GrJahr BETWEEN 1900 AND 2100),
    B_Genre VARCHAR(50) NOT NULL
);

CREATE TABLE musiker (
    M_Name VARCHAR(100) PRIMARY KEY,
    M_Ausdauer INT CHECK (M_Ausdauer BETWEEN 1 AND 100),
    M_Instrument VARCHAR(50) NOT NULL,
    M_Inspiration VARCHAR(100)
);

CREATE TABLE song (
    S_ID INT PRIMARY KEY,
    S_Name VARCHAR(100) NOT NULL,
    S_Genre VARCHAR(50) NOT NULL,
    S_Jahr INT NOT NULL CHECK (S_Jahr BETWEEN 1900 AND 2100),
    B_Name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_song_band
        FOREIGN KEY (B_Name)
        REFERENCES band(B_Name)
        ON DELETE CASCADE
);

CREATE TABLE spieltin (
    B_Name VARCHAR(100),
    M_Name VARCHAR(100),
    PRIMARY KEY (B_Name, M_Name),
    CONSTRAINT fk_spieltin_band
        FOREIGN KEY (B_Name)
        REFERENCES band(B_Name)
        ON DELETE CASCADE,
    CONSTRAINT fk_spieltin_musiker
        FOREIGN KEY (M_Name)
        REFERENCES musiker(M_Name)
        ON DELETE CASCADE
);

-- =========================
-- 3. SAMPLE ANALYTICAL QUERIES
-- =========================

-- 1. Band with the most songs
SELECT B_Name, COUNT(*) AS Anzahl_Songs
FROM song
GROUP BY B_Name
ORDER BY Anzahl_Songs DESC
LIMIT 1;

-- 2. Average release year per genre
SELECT S_Genre, AVG(S_Jahr) AS Durchschnittsjahr
FROM song
GROUP BY S_Genre;

-- 3. Musicians playing in multiple bands
SELECT M_Name, COUNT(B_Name) AS Anzahl_Bands
FROM spieltin
GROUP BY M_Name
HAVING COUNT(B_Name) > 1;

-- 4. Songs per year (trend analysis)
SELECT S_Jahr, COUNT(*) AS Songs_pro_Jahr
FROM song
GROUP BY S_Jahr
ORDER BY S_Jahr;

-- 5. Top genre by number of songs
SELECT S_Genre, COUNT(*) AS Anzahl
FROM song
GROUP BY S_Genre
ORDER BY Anzahl DESC
LIMIT 1;

-- =========================
-- 4. VIEWS
-- =========================

CREATE VIEW v_song_overview AS
SELECT s.S_Name, s.S_Jahr, s.S_Genre, b.B_Name, b.B_Genre
FROM song s
JOIN band b ON s.B_Name = b.B_Name;

CREATE VIEW v_band_statistics AS
SELECT b.B_Name,
       COUNT(s.S_ID) AS Anzahl_Songs,
       MIN(s.S_Jahr) AS Erstes_Lied,
       MAX(s.S_Jahr) AS Letztes_Lied
FROM band b
LEFT JOIN song s ON b.B_Name = s.B_Name
GROUP BY b.B_Name;

-- =====================================================
-- End of Project
-- =====================================================
