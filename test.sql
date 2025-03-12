-- Create table for storing artist information
CREATE TABLE Artists (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    debut_year INT NOT NULL
);

-- Create table for storing album information
CREATE TABLE Albums (
    album_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    release_year INT NOT NULL,
    artist_id INT REFERENCES Artists(artist_id) ON DELETE CASCADE
);

-- Create table for storing song information
CREATE TABLE Songs (
    song_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    duration INT NOT NULL, -- duration in seconds
    album_id INT REFERENCES Albums(album_id) ON DELETE CASCADE
);

-- Create table for storing user information
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subscription_type VARCHAR(50) CHECK (subscription_type IN ('free', 'premium')) NOT NULL
);

-- Create table for storing playlists
CREATE TABLE Playlists (
    playlist_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create table for storing songs in playlists
CREATE TABLE PlaylistSongs (
    playlist_id INT REFERENCES Playlists(playlist_id) ON DELETE CASCADE,
    song_id INT REFERENCES Songs(song_id) ON DELETE CASCADE,
    position INT NOT NULL,
    PRIMARY KEY (playlist_id, song_id)
);

-- Query to retrieve the top 5 most popular songs based on the number of times they appear in user playlists
SELECT s.song_id, s.name, COUNT(ps.song_id) AS popularity
FROM PlaylistSongs ps
JOIN Songs s ON ps.song_id = s.song_id
GROUP BY s.song_id, s.name
ORDER BY popularity DESC
LIMIT 5;

-- Query to identify artists who released their debut album after the year 2000
SELECT DISTINCT a.artist_id, a.name
FROM Artists a
JOIN Albums al ON a.artist_id = al.artist_id
WHERE a.debut_year > 2000;

-- Query to calculate the average duration of songs in each album
SELECT al.album_id, al.name, AVG(s.duration) AS avg_duration
FROM Albums al
JOIN Songs s ON al.album_id = s.album_id
GROUP BY al.album_id, al.name;

-- Query to retrieve names of all users who have created a playlist that contains a specific song (e.g., song_id = 1)
SELECT DISTINCT u.user_id, u.name
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
WHERE ps.song_id = 1;
