CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    height_cm DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE workout_activities (
    activity_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    activity_type VARCHAR(50) NOT NULL,
    activity_name VARCHAR(100) NOT NULL,
    duration_minutes INTEGER NOT NULL,
    calories_burned INTEGER,
    distance_km DECIMAL(8,2),
    notes TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workout_user ON workout_activities(user_id);
CREATE INDEX idx_workout_date ON workout_activities(start_time);

CREATE TABLE exercise_types (
    exercise_type_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    average_calories_per_minute DECIMAL(5,2)
);

CREATE TABLE workout_exercises (
    workout_exercise_id SERIAL PRIMARY KEY,
    activity_id INTEGER REFERENCES workout_activities(activity_id),
    exercise_type_id INTEGER REFERENCES exercise_types(exercise_type_id),
    sets INTEGER,
    reps INTEGER,
    weight_kg DECIMAL(6,2),
    duration_minutes INTEGER,
    distance_km DECIMAL(8,2),
    order_index INTEGER
);

CREATE TABLE fitness_goals (
    goal_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    goal_type VARCHAR(50) NOT NULL,
    target_value DECIMAL(10,2) NOT NULL,
    current_value DECIMAL(10,2) DEFAULT 0,
    unit VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    target_date DATE NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Completed', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_goals_user ON fitness_goals(user_id);

CREATE TABLE fitness_measurements (
    measurement_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    measurement_type VARCHAR(50) NOT NULL,
    value DECIMAL(8,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    measured_at TIMESTAMP NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_measurements_user ON fitness_measurements(user_id);
CREATE INDEX idx_measurements_date ON fitness_measurements(measured_at);

CREATE TABLE progress_photos (
    photo_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    image_url VARCHAR(255) NOT NULL,
    caption VARCHAR(200),
    taken_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE workout_templates (
    template_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    template_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE template_exercises (
    template_exercise_id SERIAL PRIMARY KEY,
    template_id INTEGER REFERENCES workout_templates(template_id),
    exercise_type_id INTEGER REFERENCES exercise_types(exercise_type_id),
    sets INTEGER,
    reps INTEGER,
    weight_kg DECIMAL(6,2),
    duration_minutes INTEGER,
    order_index INTEGER
);

-- Simple data insertion
INSERT INTO exercise_types (name, category, description, average_calories_per_minute) VALUES
('Running', 'Cardio', 'Outdoor or treadmill running', 10.5),
('Weight Lifting', 'Strength', 'General weight training', 5.0),
('Cycling', 'Cardio', 'Stationary or outdoor cycling', 8.0),
('Swimming', 'Cardio', 'Pool or open water swimming', 9.5),
('Yoga', 'Flexibility', 'Various yoga practices', 3.0),
('Push-ups', 'Strength', 'Bodyweight chest exercise', 4.0);

INSERT INTO workout_activities (user_id, activity_type, activity_name, duration_minutes, calories_burned, start_time, end_time)
VALUES (1, 'Strength', 'Chest Day', 60, 300, '2024-01-15 10:00:00', '2024-01-15 11:00:00');

-- Sql Queries
SELECT 
    wa.activity_name,
    wa.duration_minutes,
    wa.calories_burned,
    wa.start_time
FROM workout_activities wa
WHERE wa.user_id = 1
ORDER BY wa.start_time DESC
LIMIT 10;

SELECT 
    goal_type,
    target_value,
    current_value,
    unit,
    (current_value / target_value * 100) as progress_percentage
FROM fitness_goals
WHERE user_id = 1 AND status = 'Active';

SELECT 
    value,
    unit,
    measured_at
FROM fitness_measurements
WHERE user_id = 1 AND measurement_type = 'Weight'
ORDER BY measured_at DESC;
