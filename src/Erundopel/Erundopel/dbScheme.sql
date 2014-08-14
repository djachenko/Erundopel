CREATE TABLE IF NOT EXISTS languages (
    id INTEGER PRIMARY KEY,
    id_object TEXT,
    name TEXT
);

CREATE TABLE IF NOT EXISTS meanings (
    id INTEGER PRIMARY KEY,
    id_object TEXT,
    meaning TEXT,
    id_language TEXT,
    sync INTEGER,
    FOREIGN KEY(id_language) REFERENCES languages(id_object)
);

CREATE TABLE IF NOT EXISTS words (
    id INTEGER PRIMARY KEY,
    id_object TEXT,
    word TEXT,
    id_language TEXT,
    id_meaning TEXT,
    sync INTEGER,
    FOREIGN KEY(id_language) REFERENCES languages(id_object),
    FOREIGN KEY(id_meaning) REFERENCES meanings(id_object)
);


CREATE TABLE IF NOT EXISTS cards (
    id INTEGER PRIMARY KEY,
    id_object TEXT,
    id_word INTEGER,
    id_meaning_false_1 INTEGER,
    id_meaning_false_2 INTEGER,
    FOREIGN KEY(id_word) REFERENCES words(id),
    FOREIGN KEY(id_meaning_false_1) REFERENCES meanings(id),
    FOREIGN KEY(id_meaning_false_2) REFERENCES meanings(id)
);

CREATE TABLE IF NOT EXISTS meaning_popularity (
    id_word INTEGER,
    id_meaning INTEGER,
    count INTEGER,
    FOREIGN KEY(id_word) REFERENCES words(id),
    FOREIGN KEY(id_meaning) REFERENCES meanings(id)
);
