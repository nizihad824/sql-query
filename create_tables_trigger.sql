

CREATE TABLE Benutzer (
  	benutzername VARCHAR(20) NOT NULL,
  	name VARCHAR(50) NOT NULL,
  	eintrittsdatum timestamp DEFAULT CURRENT TIMESTAMP, 
  	PRIMARY KEY (benutzername)
);

CREATE TABLE Anzeige (
  	id SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY,
	titel VARCHAR(100) NOT NULL,
  	text CLOB(1M) NOT NULL,
	preis DECIMAL(5,2) CHECK (preis >=0),
  	erstellungsdatum timestamp DEFAULT CURRENT TIMESTAMP, 
  	ersteller VARCHAR(20) NOT NULL,
	status CHAR(8) CHECK (status IN ('aktiv','verkauft')),
  	PRIMARY KEY (id),
  	FOREIGN KEY (ersteller) REFERENCES Benutzer(benutzername) ON DELETE CASCADE
);

CREATE TABLE Nachricht (
  	id SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY,
  	text CLOB(1M),
  	absender VARCHAR(20) NOT NULL,
	empfaenger VARCHAR(20) NOT NULL,
  	FOREIGN KEY (absender) REFERENCES Benutzer(benutzername) ON DELETE CASCADE,
	FOREIGN KEY (empfaenger) REFERENCES Benutzer(benutzername) ON DELETE CASCADE,
  	PRIMARY KEY (id)
);

CREATE TABLE Kommentar (
  	id SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY,
  	text CLOB(1M),
  	erstellungsdatum timestamp DEFAULT CURRENT TIMESTAMP, 
    	PRIMARY KEY (id)
);

CREATE TABLE Kategorie (
  	name VARCHAR(50) NOT NULL CHECK (name IN ('Digitale Waren','Haus & Garten', 'Mode & Kosmetik', 'Multimedia & Elektronik')),
    PRIMARY KEY (name)
);


CREATE TABLE HatKommentar (
	kommentarID SMALLINT NOT NULL, 
	benutzername VARCHAR(20) NOT NULL, 
	anzeigeID SMALLINT NOT NULL, 
	PRIMARY KEY (kommentarID, benutzername, anzeigeID),
	FOREIGN KEY (kommentarID) REFERENCES Kommentar(id) ON DELETE CASCADE,
	FOREIGN KEY (benutzername) REFERENCES Benutzer(benutzername) ON DELETE CASCADE, 
	FOREIGN KEY (anzeigeID) REFERENCES Anzeige(id) ON DELETE CASCADE 
);

CREATE TABLE HatKategorie(
 	anzeigeID SMALLINT NOT NULL, 
	kategorie VARCHAR(50) NOT NULL, 
 	PRIMARY KEY (anzeigeID, kategorie),
	FOREIGN KEY (anzeigeID) REFERENCES Anzeige(id) ON DELETE CASCADE, 
	FOREIGN KEY (kategorie) REFERENCES Kategorie(name) ON DELETE CASCADE
);

CREATE TABLE Kauft (
	benutzername VARCHAR(50) NOT NULL,
	anzeigeID SMALLINT NOT NULL, 
  	kaufdatum timestamp DEFAULT CURRENT TIMESTAMP, 
    	PRIMARY KEY (benutzername, anzeigeID),
	FOREIGN KEY (benutzername) REFERENCES Benutzer(benutzername) ON DELETE CASCADE, 
	FOREIGN KEY (anzeigeID) REFERENCES Anzeige(id) ON DELETE CASCADE 

);


CREATE TRIGGER change_Status
AFTER INSERT ON Kauft
REFERENCING NEW AS neu
FOR EACH ROW MODE DB2SQL
UPDATE Anzeige a
        SET status = 'verkauft'
	WHERE neu.anzeigeID = a.id;

