USE sys;

-- Create the tables
CREATE TABLE team_rank (
    TEAM_ID INT,
    win INT, 
    draw INT,
    lose INT,
    points INT,
    CONSTRAINT fk_tr_id FOREIGN KEY (TEAM_ID) REFERENCES team_bar(TEAM_ID)
);

CREATE TABLE Register (
    fname VARCHAR(255),
    lname VARCHAR(255),
    pswd VARCHAR(255),
    Confirms_pswd VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE team_bar (
    TEAM_ID INT PRIMARY KEY,
    TEAM_NAME CHAR(20)
);

CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    date_ CHAR(20), 
    venue CHAR(20),
    result CHAR(20),
    hometeam_id INT,
    awayteam_id INT,
    CONSTRAINT fk_h_id FOREIGN KEY (hometeam_id) REFERENCES team_bar(TEAM_ID),
    CONSTRAINT fk_a_id FOREIGN KEY (awayteam_id) REFERENCES team_bar(TEAM_ID)
);

CREATE TABLE players (
    player_id INT PRIMARY KEY,
    team_id INT,
    fname CHAR(20),
    lname CHAR(20),
    position CHAR(20),
    jerseyno INT,
    CONSTRAINT fk_team_id FOREIGN KEY (team_id) REFERENCES team_bar(TEAM_ID)
);

-- Insert data into the team_bar table
INSERT INTO team_bar (TEAM_ID, TEAM_NAME) VALUES
    (3, 'Team A');

-- Insert data into the players table
INSERT INTO players (player_id, team_id, fname, lname, position, jerseyno)
VALUES
    (17, 3, 'Zlatan', 'Ibrahimović', 'CENTER FORWARD', 17);

-- Trigger to check player count per team
DELIMITER //
CREATE TRIGGER check_player_count
BEFORE INSERT ON players
FOR EACH ROW
BEGIN
    DECLARE player_count INT;

    SELECT COUNT(*) INTO player_count
    FROM players
    WHERE team_id = NEW.team_id;

    IF player_count >= 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert more than 11 players in the same team.';
    END IF;
END;
//
DELIMITER ;
