CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    email VARCHAR(50),
    is_admin BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO accounts (name, email, is_admin)
VALUES
('John Doe', 'j.doe@example.com', TRUE),
('Stephanie Martin', 'steph.martin@example.org', TRUE),
('Lisa Wilson', 'lisa23@example.net', FALSE);
