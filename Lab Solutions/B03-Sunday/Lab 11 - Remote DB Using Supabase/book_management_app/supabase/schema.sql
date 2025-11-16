-- Create Category table
CREATE TABLE IF NOT EXISTS category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

-- Create Books table
CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    year INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,
    CONSTRAINT fk_category
        FOREIGN KEY("categoryId")
        REFERENCES category(id)
        ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_books_categoryId ON books("categoryId");
CREATE INDEX IF NOT EXISTS idx_category_name ON category(name);


-- Initialize database with data from assets/data/
-- Insert categories
INSERT INTO category (id, name, description) VALUES
    (1, 'Classic Literature', 'Timeless works of fiction and non-fiction'),
    (2, 'Science Fiction', 'Futuristic and imaginative stories'),
    (3, 'Mystery', 'Suspenseful detective and crime stories'),
    (4, 'Fantasy', 'Magical and mythical adventures');

-- Insert books
INSERT INTO books (id, title, author, year, "categoryId") VALUES
    (1, '1984', 'George Orwell', 1949, 1),
    (2, 'To Kill a Mockingbird', 'Harper Lee', 1960, 1),
    (3, 'Dune', 'Frank Herbert', 1965, 2),
    (4, 'Foundation', 'Isaac Asimov', 1951, 2),
    (5, 'The Hobbit', 'J.R.R. Tolkien', 1937, 4),
    (6, 'Sherlock Holmes', 'Arthur Conan Doyle', 1892, 3);

-- Reset sequences to continue from the last inserted ID
SELECT setval('category_id_seq', (SELECT MAX(id) FROM category));
SELECT setval('books_id_seq', (SELECT MAX(id) FROM books));
