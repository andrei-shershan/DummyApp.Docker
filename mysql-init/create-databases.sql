CREATE DATABASE IF NOT EXISTS `dummy_identity`;
CREATE DATABASE IF NOT EXISTS `dummy_db`;
GRANT ALL PRIVILEGES ON `dummy_identity`.* TO 'dummyapp'@'%';
GRANT ALL PRIVILEGES ON `dummy_db`.* TO 'dummyapp'@'%';
FLUSH PRIVILEGES;
