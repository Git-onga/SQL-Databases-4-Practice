-- Create Database
CREATE DATABASE SongManagementDB;
USE SongManagementDB;

-- ENUM Types
CREATE TYPE UserRole AS ENUM ('LISTENER', 'ARTIST', 'ADMIN', 'MODERATOR');
CREATE TYPE SubscriptionTier AS ENUM ('FREE', 'PREMIUM', 'FAMILY', 'STUDENT');

-- Tables
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role UserRole DEFAULT 'LISTENER',
    subscription_tier SubscriptionTier DEFAULT 'FREE',
    subscription_end_date DATE,
    date_of_birth DATE,
    country_code CHAR(2),
    profile_picture_url VARCHAR(255),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    -- Indexes
    INDEX idx_users_username (username),
    INDEX idx_users_email (email),
    INDEX idx_users_country (country_code)
);

CREATE TABLE Artists (
    artist_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    stage_name VARCHAR(100) NOT NULL,
    real_name VARCHAR(100),
    biography TEXT,
    formed_year INTEGER,
    disbanded_year INTEGER,
    country VARCHAR(50),
    website_url VARCHAR(255),
    social_media_links JSONB,
    verified BOOLEAN DEFAULT FALSE,
    total_listeners INTEGER DEFAULT 0,
    monthly_listeners INTEGER DEFAULT 0,
    -- Indexes
    INDEX idx_artists_stage_name (stage_name),
    INDEX idx_artists_verified (verified)
);

CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    parent_genre_id INTEGER REFERENCES Genres(genre_id),
    popularity_score INTEGER DEFAULT 0,
    -- Indexes
    INDEX idx_genres_name (name),
    INDEX idx_genres_parent (parent_genre_id)
);

CREATE TABLE Albums (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist_id INTEGER REFERENCES Artists(artist_id) ON DELETE CASCADE,
    release_date DATE NOT NULL,
    album_type VARCHAR(20) CHECK (album_type IN ('ALBUM', 'EP', 'SINGLE', 'COMPILATION', 'LIVE')),
    total_tracks INTEGER DEFAULT 0,
    duration INTEGER DEFAULT 0, -- in seconds
    cover_art_url VARCHAR(255),
    label VARCHAR(100),
    copyright_info TEXT,
    upc_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Indexes
    INDEX idx_albums_title (title),
    INDEX idx_albums_artist (artist_id),
    INDEX idx_albums_release_date (release_date),
    INDEX idx_albums_type (album_type)
);

CREATE TABLE Songs (
    song_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist_id INTEGER REFERENCES Artists(artist_id) ON DELETE CASCADE,
    album_id INTEGER REFERENCES Albums(album_id) ON DELETE SET NULL,
    duration INTEGER NOT NULL CHECK (duration > 0), -- in seconds
    release_date DATE,
    isrc_code VARCHAR(12) UNIQUE,
    lyrics TEXT,
    explicit BOOLEAN DEFAULT FALSE,
    bpm SMALLINT,
    key VARCHAR(10),
    time_signature VARCHAR(10),
    audio_file_url VARCHAR(255) NOT NULL,
    preview_url VARCHAR(255),
    track_number INTEGER,
    disc_number INTEGER DEFAULT 1,
    total_streams BIGINT DEFAULT 0,
    total_downloads INTEGER DEFAULT 0,
    total_likes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Indexes
    INDEX idx_songs_title (title),
    INDEX idx_songs_artist (artist_id),
    INDEX idx_songs_album (album_id),
    INDEX idx_songs_release_date (release_date),
    INDEX idx_songs_streams (total_streams),
    INDEX idx_songs_isrc (isrc_code)
);

CREATE TABLE Song_Genres (
    song_genre_id SERIAL PRIMARY KEY,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES Genres(genre_id) ON DELETE CASCADE,
    confidence_score DECIMAL(3,2) DEFAULT 1.0,
    UNIQUE(song_id, genre_id),
    INDEX idx_song_genres_song (song_id),
    INDEX idx_song_genres_genre (genre_id)
);

CREATE TABLE Playlists (
    playlist_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    is_collaborative BOOLEAN DEFAULT FALSE,
    cover_image_url VARCHAR(255),
    total_tracks INTEGER DEFAULT 0,
    total_duration INTEGER DEFAULT 0, -- seconds
    total_followers INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Indexes
    INDEX idx_playlists_user (user_id),
    INDEX idx_playlists_public (is_public)
);

CREATE TABLE Playlist_Tracks (
    playlist_track_id SERIAL PRIMARY KEY,
    playlist_id INTEGER REFERENCES Playlists(playlist_id) ON DELETE CASCADE,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    added_by_user_id INTEGER REFERENCES Users(user_id),
    UNIQUE(playlist_id, song_id),
    INDEX idx_playlist_tracks_playlist (playlist_id),
    INDEX idx_playlist_tracks_song (song_id)
);

CREATE TABLE Song_Streams (
    stream_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE SET NULL,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    duration_listened INTEGER, -- seconds
    device_type VARCHAR(50),
    device_id VARCHAR(100),
    ip_address VARCHAR(45),
    country_code CHAR(2),
    region VARCHAR(100),
    -- Indexes
    INDEX idx_streams_user (user_id),
    INDEX idx_streams_song (song_id),
    INDEX idx_streams_time (start_time),
    INDEX idx_streams_country (country_code)
);

CREATE TABLE User_Likes (
    like_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, song_id),
    INDEX idx_likes_user (user_id),
    INDEX idx_likes_song (song_id)
);

CREATE TABLE Song_Downloads (
    download_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE SET NULL,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    device_type VARCHAR(50),
    quality VARCHAR(20),
    -- Indexes
    INDEX idx_downloads_user (user_id),
    INDEX idx_downloads_song (song_id)
);

CREATE TABLE Collaborations (
    collaboration_id SERIAL PRIMARY KEY,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    artist_id INTEGER REFERENCES Artists(artist_id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'FEATURING', -- FEATURING, PRODUCER, WRITER, etc.
    contribution_percentage DECIMAL(5,2) DEFAULT 0.0,
    UNIQUE(song_id, artist_id),
    INDEX idx_collabs_song (song_id),
    INDEX idx_collabs_artist (artist_id)
);

CREATE TABLE Song_Analytics (
    analytics_id SERIAL PRIMARY KEY,
    song_id INTEGER REFERENCES Songs(song_id) ON DELETE CASCADE,
    date DATE NOT NULL,
    total_streams INTEGER DEFAULT 0,
    unique_listeners INTEGER DEFAULT 0,
    total_duration_listened BIGINT DEFAULT 0,
    downloads INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    skips INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0.0,
    revenue DECIMAL(10,2) DEFAULT 0.0,
    UNIQUE(song_id, date),
    INDEX idx_analytics_song (song_id),
    INDEX idx_analytics_date (date)
);

-- Views for common queries
CREATE VIEW Top_Songs_This_Week AS
SELECT 
    s.song_id,
    s.title,
    a.stage_name as artist,
    al.title as album,
    COUNT(ss.stream_id) as stream_count,
    SUM(ss.duration_listened) as total_duration
FROM Songs s
JOIN Artists a ON s.artist_id = a.artist_id
LEFT JOIN Albums al ON s.album_id = al.album_id
JOIN Song_Streams ss ON s.song_id = ss.song_id
WHERE ss.start_time >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY s.song_id, s.title, a.stage_name, al.title
ORDER BY stream_count DESC
LIMIT 100;

CREATE VIEW Artist_Discography AS
SELECT 
    a.artist_id,
    a.stage_name,
    COUNT(DISTINCT s.song_id) as total_songs,
    COUNT(DISTINCT al.album_id) as total_albums,
    SUM(s.total_streams) as total_streams,
    SUM(s.total_likes) as total_likes,
    MAX(s.release_date) as latest_release
FROM Artists a
LEFT JOIN Songs s ON a.artist_id = s.artist_id
LEFT JOIN Albums al ON a.artist_id = al.artist_id
GROUP BY a.artist_id, a.stage_name;

-- Insert sample data
INSERT INTO Genres (name, description) VALUES
('Pop', 'Popular music characterized by catchy melodies and broad appeal'),
('Rock', 'Music characterized by amplified instruments and strong beats'),
('Hip Hop', 'Music featuring rhythmic speech and electronic beats'),
('Electronic', 'Music created using electronic instruments and technology'),
('Jazz', 'Music characterized by improvisation and syncopation'),
('Classical', 'Traditional art music forms'),
('Country', 'Music originating from rural American folk and Western music'),
('R&B', 'Rhythm and Blues music with soulful vocals'),
('Reggae', 'Music originating from Jamaica with offbeat rhythms'),
('Metal', 'Heavy metal music with distorted guitars and aggressive sounds');
