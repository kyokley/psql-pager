CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    email VARCHAR(50),
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    hash VARCHAR(65)
);

INSERT INTO accounts (name, email, is_admin, hash)
VALUES
('John Doe', 'j.doe@example.com', TRUE, '60976712c7f60fa538bcacf402529b41589f589de3058713b4759062cc0110ea'),
('Stephanie Martin', 'steph.martin@example.org', TRUE, '2a9dc9ddd727a03cd0d0168ac44d8a462fa5d970fabdd010b5cba3e3f4a3504b'),
('Lisa Wilson', 'lisa23@example.net', FALSE, 'e258d248fda94c63753607f7c4494ee0fcbe92f1a76bfdac795c9d84101eb317');
