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
