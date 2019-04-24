
DROP TABLE IF EXISTS `taskmembership`;
DROP TABLE IF EXISTS `task`;
DROP TABLE IF EXISTS `orgmembership`;
DROP TABLE IF EXISTS `account`;
DROP TABLE IF EXISTS `accountcategory`;
DROP TABLE IF EXISTS `taskdepartment`;
DROP TABLE IF EXISTS `tasktype`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `organization`;

--
-- Table structure for table `organization`
--
CREATE TABLE `organization` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` int(11) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

--
-- Table structure for table `user`
--
CREATE TABLE `user` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(256) NOT NULL,
  `Name` varchar(256) NOT NULL,
  `IconFileUrl` varchar(100) DEFAULT NULL,
  `IconFileId` varchar(50) DEFAULT NULL,
  `LastLogin` datetime DEFAULT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` int(11) DEFAULT NULL,
  `FirstName` varchar(256) NOT NULL,
  `LastName` varchar(256) NOT NULL,
  `SID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `SID_UNIQUE` (`SID`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;

--
-- Table structure for table `tasktype`
--
CREATE TABLE `tasktype` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `OrgId` int(11) NOT NULL,
  `Name` varchar(120) CHARACTER SET latin1 NOT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `idx_tasktype_unique_orgid_tasktype` (`OrgId`,`Name`),
  CONSTRAINT `FK_Organization_tasktype` FOREIGN KEY (`OrgId`) REFERENCES `organization` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;



--
-- Table structure for table `taskdepartment`
--
CREATE TABLE `taskdepartment` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `OrgId` int(11) NOT NULL,
  `DepartmentName` varchar(120) CHARACTER SET latin1 NOT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `idx_taskdepartment_unique_orgid_department` (`OrgId`,`DepartmentName`),
  CONSTRAINT `FK_Organization_TaskDepartment` FOREIGN KEY (`OrgId`) REFERENCES `organization` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8;


--
-- Table structure for table `account`
--
CREATE TABLE `account` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `OrgId` int(11) NOT NULL,
  `AccountName` varchar(100) DEFAULT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` int(11) DEFAULT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Organization_Account` (`OrgId`),
  CONSTRAINT `FK_Organization_Account` FOREIGN KEY (`OrgId`) REFERENCES `organization` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=549 DEFAULT CHARSET=utf8;


--
-- Table structure for table `orgmembership`
--
CREATE TABLE `orgmembership` (
  `UserId` int(11) NOT NULL,
  `OrgId` int(11) NOT NULL,
  `Enabled` int(1) NOT NULL DEFAULT '1',
  `JoinedOn` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateCreated` datetime DEFAULT NULL,
  `DateModified` datetime DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  UNIQUE KEY `OrgId_UserId_UNIQUE` (`OrgId`,`UserId`),
  PRIMARY KEY (`UserId`, `OrgId`),
  KEY `FK_User_Membership_idx` (`UserId`),
  CONSTRAINT `FK_Organization_Membership` FOREIGN KEY (`OrgId`) REFERENCES `organization` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_User_Membership` FOREIGN KEY (`UserId`) REFERENCES `user` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `task`
--
CREATE TABLE `task` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `OwnerId` int(11) NOT NULL,
  `AccountId` int(11) DEFAULT NULL,
  `OrgId` int(11) DEFAULT NULL,
  `Subject` varchar(200) DEFAULT NULL,
  `TaskType` int(11) DEFAULT NULL,
  `Department` int(11) DEFAULT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `DueDate` datetime DEFAULT NULL,
  `CompletedOn` datetime DEFAULT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` int(11) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_User_Task_idx` (`OwnerId`),
  KEY `FK_Account_Task_idx` (`AccountId`),
  CONSTRAINT `FK_Account_Task` FOREIGN KEY (`AccountId`) REFERENCES `account` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Organization_Task` FOREIGN KEY (`OrgId`) REFERENCES `organization` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_User_Task` FOREIGN KEY (`OwnerId`) REFERENCES `user` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1058 DEFAULT CHARSET=utf8;

--
-- Table structure for table `taskmembership`
--
CREATE TABLE `taskmembership` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `TaskId` int(11) NOT NULL,
  `AccountId` int(11) DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `OrgId` int(11) DEFAULT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` int(11) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `UNIQUE_TaskId_UserId` (`TaskId`,`UserId`),
  KEY `FK_Organization_TaskMembership` (`OrgId`),
  KEY `FK_Account_TaskMembership_idx` (`AccountId`),
  KEY `FK_User_TaskMembership_idx` (`UserId`),
  CONSTRAINT `FK_Account_TaskMembership` FOREIGN KEY (`AccountId`) REFERENCES `account` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Organization_TaskMembership` FOREIGN KEY (`OrgId`) REFERENCES `organization` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Task_TaskMembership` FOREIGN KEY (`TaskId`) REFERENCES `task` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_User_TaskMembership` FOREIGN KEY (`UserId`) REFERENCES `user` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3040 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `file`;
CREATE TABLE `file` (
  `FileId` varchar(50) NOT NULL,
  `AccountId` varchar(50) DEFAULT NULL,
  `TaskId` varchar(50) DEFAULT NULL,
  `Title` varchar(200) DEFAULT NULL,
  `MimeType` varchar(50) DEFAULT NULL,
  `Size` int(11) DEFAULT NULL,
  `FileName` varchar(200) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `FileKey` varchar(50) DEFAULT NULL,
  `Url` varchar(200) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateModified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(200) DEFAULT NULL,
  `CreatedById` int(11) DEFAULT NULL,
  PRIMARY KEY (`FileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


