CREATE TABLE category
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category VARCHAR(100) NOT NULL,
    deleted BOOLEAN DEFAULT 0 NOT NULL
);
CREATE TABLE posts
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content VARCHAR(1000),
    deleted BOOLEAN DEFAULT 0 NOT NULL,
    category INTEGER(100),
    CONSTRAINT category FOREIGN KEY (id) REFERENCES category (id)
);
CREATE TABLE sqlite_master
(
    type text,
    name text,
    tbl_name text,
    rootpage integer,
    sql text
);
CREATE TABLE sqlite_sequence
(
    name ,
    seq 
)