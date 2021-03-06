SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Devices/Component` (
  `idDevices/Component` INT UNSIGNED NOT NULL,
  `Name` VARCHAR(45) NOT NULL COMMENT 'device/component name',
  `Functional` TINYINT NOT NULL COMMENT 'is it working or is it damaged',
  `UnitCount` INT NULL COMMENT 'how may units are there',
  `State_` TINYINT NULL COMMENT 'borrowed(1) or in lab(0)',
  `picture_URL` VARCHAR(45) NULL,
  `Datasheet_URL` VARCHAR(45) NULL,
  PRIMARY KEY (`idDevices/Component`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Users` (
  `userID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL COMMENT 'Name',
  `MiddleName` VARCHAR(45) NULL COMMENT 'Name',
  `LastName` VARCHAR(45) NOT NULL COMMENT 'Name',
  `UserName` VARCHAR(45) NOT NULL,
  `PasswordHash` VARCHAR(45) NOT NULL,
  `PictureURL` VARCHAR(45) NULL,
  `about` VARCHAR(300) NULL,
  `lastActiveTime` DATETIME NULL,
  `collegeRole` ENUM('student', 'Professor', 'TA', 'Employee', 'Alumni') NOT NULL COMMENT 'can only choose one and only one of the following: student, professor or TA.\nthe choice must be one of them.\n---------------------------------------------------------\nif you want to choose more than one of student, professor or TA then use SET() instead of ENUM()',
  PRIMARY KEY (`userID`),
  UNIQUE INDEX `userID_UNIQUE` (`userID` ASC))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Projects` (
  `idProjects` INT UNSIGNED NOT NULL,
  `Supervisor` INT UNSIGNED NOT NULL COMMENT 'the professor who supervises this project',
  `Idea` VARCHAR(450) NULL COMMENT 'idea of the project',
  `name` VARCHAR(45) NULL COMMENT 'name of the project',
  `abstract` VARCHAR(1000) NULL COMMENT 'a brief description of the project',
  `Picture_URL` VARCHAR(45) NULL COMMENT 'picture of the project',
  `dateStarted` DATETIME NOT NULL COMMENT 'date on which the project started',
  `dateEnded` DATETIME NULL COMMENT 'date on which the project ended, if the project is still incomplete this leave it NULL',
  `tag` INT UNSIGNED NULL COMMENT '#tag for this project',
  PRIMARY KEY (`idProjects`, `Supervisor`),
  CONSTRAINT `professor`
    FOREIGN KEY (`Supervisor`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Courses` (
  `idCourses` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL COMMENT 'name if the course',
  `about` VARCHAR(45) NULL COMMENT 'a brief description of the course',
  `department` VARCHAR(45) NULL COMMENT 'the department that this course falls under its categories',
  `Grading Schema` VARCHAR(45) NULL COMMENT 'how many points are assigned for this course (150,200 ....etc)',
  PRIMARY KEY (`idCourses`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Researches` (
  `idResearches` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(45) NOT NULL COMMENT 'title or name of the research',
  `Idea` VARCHAR(45) NULL COMMENT 'idea of the research',
  PRIMARY KEY (`idResearches`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Labs` (
  `labID` INT UNSIGNED NOT NULL,
  `Lab Name` VARCHAR(45) NOT NULL COMMENT 'name of the lab',
  `idGuardian` INT UNSIGNED NOT NULL COMMENT 'the employee who is responsible for this lab',
  `Contents` INT UNSIGNED NULL COMMENT 'what is inside this lab',
  `location` VARCHAR(45) NULL COMMENT 'the loaction of the lab',
  `about` VARCHAR(45) NULL COMMENT 'a brief description for the lab',
  `picture` VARCHAR(45) NULL COMMENT 'a picture for the lab',
  PRIMARY KEY (`labID`),
  UNIQUE INDEX `Contents_UNIQUE` (`Contents` ASC),
  CONSTRAINT `guardian`
    FOREIGN KEY (`idGuardian`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Safe` (
  `idSafe` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Content` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idSafe`, `Content`),
  INDEX `fk_Safe_Device/Component_idx` (`Content` ASC),
  CONSTRAINT `fk_Safe_Labs1`
    FOREIGN KEY (`idSafe`)
    REFERENCES `mydb`.`Labs` (`Contents`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Safe_Device/Component`
    FOREIGN KEY (`Content`)
    REFERENCES `mydb`.`Devices/Component` (`idDevices/Component`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Student_have_Courses` (
  `Student_idStudent` INT UNSIGNED NOT NULL COMMENT 'we can use\" Professor/Teacher_Can_Teach_Courses\" table to represent this relationship',
  `Project/Course_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Student_idStudent`, `Project/Course_id`),
  CONSTRAINT `fk_Student_have_Courses1`
    FOREIGN KEY (`Project/Course_id`)
    REFERENCES `mydb`.`Courses` (`idCourses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Student_have_User1`
    FOREIGN KEY (`Student_idStudent`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Professor/Teacher_Can_Teach_Courses` (
  `Professor/Teacher_idProfessor` INT UNSIGNED NOT NULL,
  `Courses_idCourses` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Courses_idCourses`, `Professor/Teacher_idProfessor`),
  INDEX `fk_Professor_has_Courses_Courses1_idx` (`Courses_idCourses` ASC),
  CONSTRAINT `fk_Professor_has_Courses_Courses1`
    FOREIGN KEY (`Courses_idCourses`)
    REFERENCES `mydb`.`Courses` (`idCourses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Professor/Teacher_Can_Teach_Courses_User1`
    FOREIGN KEY (`Professor/Teacher_idProfessor`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Professor_Working_On_Researches` (
  `Professor/Teacher_id` INT UNSIGNED NOT NULL,
  `Researches_idResearches` INT UNSIGNED NOT NULL,
  INDEX `fk_Professor_has_Researches_Researches1_idx` (`Researches_idResearches` ASC),
  PRIMARY KEY (`Professor/Teacher_id`, `Researches_idResearches`),
  CONSTRAINT `fk_Professor_has_Researches_Researches1`
    FOREIGN KEY (`Researches_idResearches`)
    REFERENCES `mydb`.`Researches` (`idResearches`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Professor_Working_On_Researches_User1`
    FOREIGN KEY (`Professor/Teacher_id`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Admin` (
  `userID` INT UNSIGNED NOT NULL COMMENT 'id of admin',
  PRIMARY KEY (`userID`),
  CONSTRAINT `userID`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`skills` (
  `skillID` INT UNSIGNED NOT NULL,
  `skill` VARCHAR(45) NULL COMMENT 'skill name',
  PRIMARY KEY (`skillID`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`User_has_skills` (
  `Users_userID` INT UNSIGNED NOT NULL,
  `skills_skillID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Users_userID`, `skills_skillID`),
  INDEX `fk_Users_has_skills_skills1_idx` (`skills_skillID` ASC),
  INDEX `fk_Users_has_skills_Users1_idx` (`Users_userID` ASC),
  CONSTRAINT `fk_Users_has_skills_Users1`
    FOREIGN KEY (`Users_userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Users_has_skills_skills1`
    FOREIGN KEY (`skills_skillID`)
    REFERENCES `mydb`.`skills` (`skillID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`position` (
  `userID` INT UNSIGNED NOT NULL,
  `positionName` VARCHAR(45) NOT NULL COMMENT 'name of the position (ex: construction consultant)',
  `company` VARCHAR(45) NOT NULL COMMENT 'that company that he/she works in',
  PRIMARY KEY (`userID`, `positionName`),
  UNIQUE INDEX `positionName_UNIQUE` (`positionName` ASC),
  CONSTRAINT `fk_position_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`projectFiles` (
  `projectID` INT UNSIGNED NOT NULL,
  `uploaderID` INT UNSIGNED NOT NULL COMMENT 'the id of the user who uploaded this file',
  `uploadedTime` DATETIME NOT NULL COMMENT 'date on which the file was uploaded',
  `URL` VARCHAR(45) NULL COMMENT 'url of the file (used it if someone wants to download the file)',
  `descreption` VARCHAR(45) NULL COMMENT 'a brief description of the file',
  PRIMARY KEY (`projectID`),
  CONSTRAINT `releated to project`
    FOREIGN KEY (`projectID`)
    REFERENCES `mydb`.`Projects` (`idProjects`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`header_user_user` (
  `header_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user1_id` INT UNSIGNED NOT NULL,
  `user2_id` INT UNSIGNED NOT NULL,
  `timeCreated` DATETIME NOT NULL,
  PRIMARY KEY (`header_id`, `user1_id`, `user2_id`),
  INDEX `fk_messages_sender_idx` (`user1_id` ASC, `user2_id` ASC),
  UNIQUE INDEX `reciverID_UNIQUE` (`user2_id` ASC),
  UNIQUE INDEX `timeSent_UNIQUE` (`timeCreated` ASC),
  UNIQUE INDEX `senderID_UNIQUE` (`user1_id` ASC),
  UNIQUE INDEX `messageID_UNIQUE` (`header_id` ASC),
  CONSTRAINT `fk_messages_users`
    FOREIGN KEY (`user1_id`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE CASCADE
	ON UPDATE NO ACTION,
  CONSTRAINT `fk_messages_users2`
	FOREIGN KEY (`user2_id`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`group/header` (
  `groupID` INT UNSIGNED NOT NULL,
  `groupName` VARCHAR(45) NOT NULL DEFAULT 'Group' COMMENT 'name of the group',
  `timeCreated` DATETIME NOT NULL,
  PRIMARY KEY (`groupID`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`User_has(in)_group` (
  `User_userID` INT UNSIGNED NOT NULL,
  `group_groupID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`User_userID`, `group_groupID`),
  INDEX `fk_User_has_group_group1_idx` (`group_groupID` ASC),
  INDEX `fk_User_has_group_User1_idx` (`User_userID` ASC),
  CONSTRAINT `fk_User_has_group_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_group_group1`
    FOREIGN KEY (`group_groupID`)
    REFERENCES `mydb`.`group/header` (`groupID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Notification_header` (
  `header_id` INT UNSIGNED NOT NULL,
  `to_userID` INT UNSIGNED NOT NULL COMMENT 'notification of user whose id is\n\n-- each user has a header that contains all of his/hers notifications',
  `time_created` DATETIME NULL,
  PRIMARY KEY (`header_id`, `to_userID`),
  INDEX `to_idx` (`to_userID` ASC),
  UNIQUE INDEX `header_id_UNIQUE` (`header_id` ASC),
  UNIQUE INDEX `to_userID_UNIQUE` (`to_userID` ASC),
  CONSTRAINT `user_id_user_id_Notification`
    FOREIGN KEY (`to_userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`posts` (
  `postID` INT UNSIGNED NOT NULL,
  `userID` INT UNSIGNED NOT NULL COMMENT 'the OP (original poster)',
  `post` VARCHAR(1000) NULL COMMENT 'the post itself',
  `tag` INT UNSIGNED NULL COMMENT '#tages that might be in the post',
  `description` VARCHAR(45) NULL COMMENT 'no clue what this is, ask Mahmoud Shaheen (back end team leader)',
  `time` DATETIME NOT NULL COMMENT 'time on which the post was posted',
  PRIMARY KEY (`postID`, `userID`),
  INDEX `fk_posts_User1_idx` (`userID` ASC),
  CONSTRAINT `fk_posts_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Comments` (
  `postID` INT UNSIGNED NOT NULL,
  `userID` INT UNSIGNED NOT NULL COMMENT 'user who made the comment\n',
  `time` DATETIME NOT NULL COMMENT 'time on which the comment was posted',
  `comment` VARCHAR(45) NULL COMMENT 'the comment itself\n',
  INDEX `post_idx` (`postID` ASC),
  PRIMARY KEY (`postID`, `userID`),
  CONSTRAINT `post`
    FOREIGN KEY (`postID`)
    REFERENCES `mydb`.`posts` (`postID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`tags` (
  `tagID` INT UNSIGNED NOT NULL,
  `tag` VARCHAR(45) NOT NULL COMMENT 'the tag itself',
  PRIMARY KEY (`tagID`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`borrows` (
  `userID` INT UNSIGNED NOT NULL COMMENT 'borrower\n',
  `device/comp` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`userID`, `device/comp`),
  INDEX `fk_borrows_Devices1_idx` (`device/comp` ASC),
  CONSTRAINT `borrower`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_borrows_Devices1`
    FOREIGN KEY (`device/comp`)
    REFERENCES `mydb`.`Devices/Component` (`idDevices/Component`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`messages_user_group` (
  `message_id` INT UNSIGNED NOT NULL,
  `group_id` INT UNSIGNED NOT NULL COMMENT 'id of the reciver (group)',
  `sender_id` INT UNSIGNED NOT NULL COMMENT 'id of the sender (user)',
  `message` TEXT NULL COMMENT 'message itself',
  `time_sent` DATETIME NULL COMMENT 'time on which the message was sent',
  PRIMARY KEY (`message_id`, `group_id`, `sender_id`),
  INDEX `send_to_group_idx` (`sender_id` ASC),
  INDEX `reciver_group_idx` (`group_id` ASC),
  CONSTRAINT `send_to_group_`
    FOREIGN KEY (`sender_id`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `reciver_group_`
    FOREIGN KEY (`group_id`)
    REFERENCES `mydb`.`group/header` (`groupID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`student_has_Projects` (
  `User_userID` INT UNSIGNED NOT NULL,
  `Projects_idProjects` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`User_userID`, `Projects_idProjects`),
  INDEX `fk_User_has_Projects_Projects1_idx` (`Projects_idProjects` ASC),
  INDEX `fk_User_has_Projects_User1_idx` (`User_userID` ASC),
  CONSTRAINT `fk_User_has_Projects_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_Projects_Projects1`
    FOREIGN KEY (`Projects_idProjects`)
    REFERENCES `mydb`.`Projects` (`idProjects`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Projects_has_tags` (
  `Projects_idProjects` INT UNSIGNED NOT NULL,
  `tags_tagID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Projects_idProjects`, `tags_tagID`),
  INDEX `fk_Projects_has_tags_tags1_idx` (`tags_tagID` ASC),
  INDEX `fk_Projects_has_tags_Projects1_idx` (`Projects_idProjects` ASC),
  CONSTRAINT `fk_Projects_has_tags_Projects1`
    FOREIGN KEY (`Projects_idProjects`)
    REFERENCES `mydb`.`Projects` (`idProjects`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Projects_has_tags_tags1`
    FOREIGN KEY (`tags_tagID`)
    REFERENCES `mydb`.`tags` (`tagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`posts_has_tags` (
  `posts_postID` INT UNSIGNED NOT NULL,
  `tags_tagID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`posts_postID`, `tags_tagID`),
  INDEX `fk_posts_has_tags_tags1_idx` (`tags_tagID` ASC),
  INDEX `fk_posts_has_tags_posts1_idx` (`posts_postID` ASC),
  CONSTRAINT `fk_posts_has_tags_posts1`
    FOREIGN KEY (`posts_postID`)
    REFERENCES `mydb`.`posts` (`postID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_posts_has_tags_tags1`
    FOREIGN KEY (`tags_tagID`)
    REFERENCES `mydb`.`tags` (`tagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`emails` (
  `user_id` INT UNSIGNED NOT NULL COMMENT 'id of owner',
  `email` VARCHAR(45) NOT NULL COMMENT 'email itself',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_emails_User1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`phone_numbers` (
  `user_id` INT UNSIGNED NOT NULL COMMENT 'id of user who has this phone number',
  `phone_number` VARCHAR(11) NOT NULL COMMENT 'phone number itself',
  PRIMARY KEY (`user_id`, `phone_number`),
  UNIQUE INDEX `phone_number_UNIQUE` (`phone_number` ASC),
  CONSTRAINT `fk_phones_User1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`messages_user_user` (
  `_header_id` INT UNSIGNED NOT NULL COMMENT 'this message belongs to header ..',
  `message_id` INT NOT NULL,
  `owner` BIT NULL COMMENT 'owner is user1(bit = 0)\nowner is user2(bit = 1)',
  `is_read` BIT NULL COMMENT 'if message not read (0)\nif message read (1)',
  `message` TEXT NULL,
  `timeSent` DATETIME NULL,
  PRIMARY KEY (`_header_id`, `message_id`),
  CONSTRAINT `header_id_header_id_message`
    FOREIGN KEY (`_header_id`)
    REFERENCES `mydb`.`header_user_user` (`header_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `mydb`.`Notification` (
  `_header_id` INT UNSIGNED NOT NULL COMMENT 'this notification belongs to header ..',
  `notification_id` INT UNSIGNED NOT NULL,
  `read?` BIT NULL COMMENT 'did the reciver read it or not',
  `payload` TEXT NULL COMMENT 'what does the notification say',
  `time` DATETIME NULL COMMENT 'time on which this notification was sent',
  `redirection_url` TEXT NULL COMMENT 'URL of the action(post,comment ...etc) that caused the notification to be sent',
  PRIMARY KEY (`_header_id`, `notification_id`),
  CONSTRAINT `header_id_header_id_notification`
    FOREIGN KEY (`_header_id`)
    REFERENCES `mydb`.`Notification_header` (`header_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
