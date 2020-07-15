create table if not exists todo(
     id MEDIUMINT NOT NULL AUTO_INCREMENT,
     action CHAR(255) NOT NULL,
     date DATETIME DEFAULT CURRENT_TIMESTAMP,
     PRIMARY KEY (id)
);
