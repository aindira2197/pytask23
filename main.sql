CREATE TABLE Subject (
  id INT PRIMARY KEY,
  state VARCHAR(255)
);

CREATE TABLE Observer (
  id INT PRIMARY KEY,
  subject_id INT,
  FOREIGN KEY (subject_id) REFERENCES Subject(id)
);

CREATE TABLE Notification (
  id INT PRIMARY KEY,
  observer_id INT,
  message VARCHAR(255),
  FOREIGN KEY (observer_id) REFERENCES Observer(id)
);

INSERT INTO Subject (id, state) VALUES (1, 'state1');
INSERT INTO Subject (id, state) VALUES (2, 'state2');

INSERT INTO Observer (id, subject_id) VALUES (1, 1);
INSERT INTO Observer (id, subject_id) VALUES (2, 1);
INSERT INTO Observer (id, subject_id) VALUES (3, 2);

CREATE TRIGGER trg_notify_on_subject_update
AFTER UPDATE ON Subject
FOR EACH ROW
BEGIN
  INSERT INTO Notification (observer_id, message) 
  SELECT o.id, CONCAT('Subject ', NEW.id, ' updated to ', NEW.state) 
  FROM Observer o 
  WHERE o.subject_id = NEW.id;
END;

CREATE TRIGGER trg_notify_on_subject_insert
AFTER INSERT ON Subject
FOR EACH ROW
BEGIN
  INSERT INTO Notification (observer_id, message) 
  SELECT o.id, CONCAT('Subject ', NEW.id, ' inserted with state ', NEW.state) 
  FROM Observer o 
  WHERE o.subject_id = NEW.id;
END;

CREATE VIEW vw_notifications AS
SELECT n.id, n.observer_id, n.message, s.state 
FROM Notification n 
JOIN Observer o ON n.observer_id = o.id 
JOIN Subject s ON o.subject_id = s.id;

CREATE PROCEDURE sp_update_subject_state(IN subject_id INT, IN new_state VARCHAR(255))
BEGIN
  UPDATE Subject SET state = new_state WHERE id = subject_id;
END;

CREATE PROCEDURE sp_insert_subject_state(IN subject_id INT, IN new_state VARCHAR(255))
BEGIN
  INSERT INTO Subject (id, state) VALUES (subject_id, new_state);
END;

CALL sp_update_subject_state(1, 'new_state1');
CALL sp_insert_subject_state(3, 'state3');

SELECT * FROM vw_notifications;