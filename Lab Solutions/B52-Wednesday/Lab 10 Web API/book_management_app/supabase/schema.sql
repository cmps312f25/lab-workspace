-- Create Category table
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

-- Create Books table
CREATE TABLE books (
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
CREATE INDEX idx_books_categoryId ON books("categoryId");
CREATE INDEX idx_category_name ON category(name);

-- Optional: Insert some sample data
-- INSERT INTO category (name, description) VALUES
--     ('Fiction', 'Fictional stories and novels'),
--     ('Science', 'Science and technology books'),
--     ('History', 'Historical books and biographies');

-- INSERT INTO books (title, author, year, "categoryId") VALUES
--     ('1984', 'George Orwell', 1949, 1),
--     ('To Kill a Mockingbird', 'Harper Lee', 1960, 1),
--     ('A Brief History of Time', 'Stephen Hawking', 1988, 2);
