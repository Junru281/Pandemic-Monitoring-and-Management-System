--         table creation script
CREATE TABLE `bs_information`  (
  `BSID` varchar(100) NOT NULL,
  `BSName` varchar(100) NOT NULL,
  `district_ID` varchar(200) NOT NULL,
  `latitude` varchar(255) NOT NULL,
  `longitude` varchar(255) NOT NULL,
  PRIMARY KEY (`BSID`)
);


CREATE TABLE `district_info`  (
  `district_ID` varchar(200) NOT NULL,
  `district_Name` varchar(200) NOT NULL,
  `region` varchar(200) NOT NULL,
  PRIMARY KEY (`district_ID`)
);

CREATE TABLE `district_risk`  (
  `district_ID` varchar(200) NOT NULL,
  `risk_level_ID` int(11) DEFAULT NULL,
  `announce_time` datetime NOT NULL,
  PRIMARY KEY (`district_ID`, `announce_time`)
);

CREATE TABLE `doctor_info`  (
  `doctor_ID` varchar(200) NOT NULL,
  `doctor_Name` varchar(200) NOT NULL,
  `hospital_Name` varchar(200) NOT NULL,
  PRIMARY KEY (`doctor_ID`)
);

CREATE TABLE `hospital_info`  (
  `hospital_Name` varchar(200) NOT NULL,
  `hospital_districtID` varchar(200) NOT NULL,
  PRIMARY KEY (`hospital_Name`)
);


CREATE TABLE `location`  (
  `BSID` varchar(100) NOT NULL,
  `phoneNum` varchar(100) NOT NULL,
  `connect_time` datetime NOT NULL,
  `disconnect_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` varchar(255) NOT NULL,
  `longitude` varchar(255) NOT NULL,
  PRIMARY KEY (`phoneNum`, `disconnect_time`)
);

CREATE TABLE `patient`  (
  `ID` varchar(100) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Sex` varchar(20) NOT NULL check(Sex IN('Male','Female','Others')),
  `Age` int NOT NULL,
  `MobileNum` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE `peo_info`  (
  `ID` varchar(100) NOT NULL,
  `Name` varchar(200) NOT NULL,
  `phoneNum/SIMID` varchar(200) NOT NULL,
  PRIMARY KEY (`phoneNum/SIMID`)
);

CREATE TABLE `report`  (
  `test_time` datetime NOT NULL,
  `collect_time` datetime NOT NULL,
  `is_positive` tinyint(4) NOT NULL,
  `doctor_ID` varchar(200) NOT NULL,
  `report_time` datetime NULL,
  `patient_ID` varchar(100) NOT NULL,
  `virus_Name` varchar(200) NOT NULL,
  PRIMARY KEY (`collect_time`, `patient_ID`)
);

CREATE TABLE `risk_level`  (
  `risk_level_ID` int(6) NOT NULL,
  `risk_level` varchar(100) NOT NULL,
  `description` text NULL,
   PRIMARY KEY (`risk_level_ID`)
);

CREATE TABLE `virus_type`  (
  `virus_Name` varchar(100) NOT NULL,
  `virus_Description` text NOT NULL,
  PRIMARY KEY (`virus_Name`)
);

ALTER TABLE `bs_information` ADD CONSTRAINT `district_fk` FOREIGN KEY (`district_ID`) REFERENCES `district_info` (`district_ID`);
ALTER TABLE `district_risk` ADD CONSTRAINT `district_ID_fk` FOREIGN KEY (`district_ID`) REFERENCES `district_info` (`district_ID`);
ALTER TABLE `district_risk` ADD CONSTRAINT `risk_level_fk` FOREIGN KEY (`risk_level_ID`) REFERENCES `risk_level` (`risk_level_ID`);
ALTER TABLE `hospital_info` ADD CONSTRAINT `hospital_district_fk` FOREIGN KEY (`hospital_districtID`) REFERENCES `district_info` (`district_ID`);
ALTER TABLE `doctor_info` ADD CONSTRAINT `hospital_Name_fk` FOREIGN KEY (`hospital_Name`) REFERENCES `hospital_info` (`hospital_Name`);
ALTER TABLE `location` ADD CONSTRAINT `phoneNum_fk` FOREIGN KEY (`phoneNum`) REFERENCES `peo_info` (`phoneNum/SIMID`);
ALTER TABLE `location` ADD CONSTRAINT `BSID_fk` FOREIGN KEY (`BSID`) REFERENCES `bs_information` (`BSID`);
ALTER TABLE `patient` ADD CONSTRAINT `MobileNum_fk` FOREIGN KEY (`MobileNum`) REFERENCES `peo_info` (`phoneNum/SIMID`);
ALTER TABLE `report` ADD CONSTRAINT `doctor_ID_fk` FOREIGN KEY (`doctor_ID`) REFERENCES `doctor_info` (`doctor_ID`);
ALTER TABLE `report` ADD CONSTRAINT `patient_ID_fk` FOREIGN KEY (`patient_ID`) REFERENCES `patient` (`ID`);
ALTER TABLE `report` ADD CONSTRAINT `virus_Name_fk` FOREIGN KEY (`virus_Name`) REFERENCES `virus_type` (`virus_Name`);

--         Important use cases
-- ----------------------------
-- Records of location case 1
-- ----------------------------
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES
('A123', 'Centre Lukewarm Hillside', 'NY'),
('A456', 'Lenny town', 'NY'),
('B123', 'Glow Sand district', 'LA'),
('C123', 'Raspberry town', 'KF'),
('C456', 'Bunny Tail district', 'KF');

INSERT INTO `location` VALUES ('1', '13678566', '2021-10-08 19:45:00', '2021-10-09 14:20:00','40°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '233636', '2021-10-06 19:20:00', '2021-10-06 23:55:00','40°41\'58.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '233636', '2021-10-08 23:30:00', '2021-10-09 19:30:00','40°41\'59.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('6', '233636', '2021-10-08 14:30:00', '2021-10-08 19:30:34','67°41\'.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '4576788', '2021-10-06 22:20:00', '2021-10-07 14:30:00','40°46\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('6', '567890', '2021-10-08 19:30:00', '2021-10-09 21:13:00','68°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '777222', '2021-10-01 19:30:00', '2021-10-05 19:30:00','39°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '777222', '2021-10-10 19:30:00', '2021-10-11 19:30:00','41°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('2', '777222', '2021-10-08 19:30:00', '2021-10-09 16:30:00', '39°41\'56.67’‘N', '74° 0\'21.50‘’W');

-- ----------------------------
-- case 1
-- ----------------------------

SELECT DISTINCT B.phoneNum FROM location A, location B
WHERE A.BSID = B.BSID AND A.phoneNum = '233636' AND B.phoneNum != '233636'
AND NOT (B.disconnect_time < A.connect_time)
AND NOT (B.connect_time > A.disconnect_time)
AND A.connect_time BETWEEN '2021-10-07 19:30:00' AND '2021-10-09 19:30:00';

-- ----------------------------
-- Records of location case 2
-- ----------------------------
INSERT INTO `location` VALUES ('1', '13678566', '2021-10-08 19:30:00', '2021-10-08 19:30:00', '40°41\'56.23’‘N', '74° 0\'21.50‘’W');
UPDATE `location` SET  disconnect_time = '2021-10-08 19:32:00',latitude = '40°41\'56.19’‘N',longitude = '74° 0\'21.50‘’W' WHERE `phoneNum` = '13678566' AND connect_time = '2021-10-08 19:30:00';
UPDATE `location` SET  disconnect_time = '2021-10-08 19:35:00',latitude = '40°41\'53.70’‘N',longitude = '74° 0\'21.50‘’W' WHERE `phoneNum` = '13678566' AND connect_time = '2021-10-08 19:30:00';
UPDATE `location` SET  disconnect_time = '2021-10-08 20:30:00',latitude = '40°41\'51.70’‘N',longitude = '74° 0\'21.50‘’W' WHERE `phoneNum` = '13678566' AND connect_time = '2021-10-08 19:30:00';

-- ----------------------------
-- case 2
-- ----------------------------
INSERT INTO `location` VALUES ('1', '13678566', '2021-10-08 19:30:00', '2021-10-08 19:30:00', '40°41\'56.23’‘N', '74° 0\'21.50‘’W');
UPDATE `location` SET  disconnect_time = '2021-10-08 19:32:00',latitude = '40°41\'56.19’‘N',longitude = '74° 0\'21.50‘’W' WHERE `phoneNum` = '13678566' AND connect_time = '2021-10-08 19:30:00';
UPDATE `location` SET  disconnect_time = '2021-10-08 19:35:00',latitude = '40°41\'53.70’‘N',longitude = '74° 0\'21.50‘’W' WHERE `phoneNum` = '13678566' AND connect_time = '2021-10-08 19:30:00';
UPDATE `location` SET  disconnect_time = '2021-10-08 20:30:00',latitude = '40°41\'51.70’‘N',longitude = '74° 0\'21.50‘’W' WHERE `phoneNum` = '13678566' AND connect_time = '2021-10-08 19:30:00';

-- ----------------------------
-- Records of report + doctor_info case 3 
-- ----------------------------
INSERT INTO `doctor_info` VALUES (12345, 'Richard', 'London Centre Hospital');
INSERT INTO `doctor_info` VALUES (23456, 'Dick', 'California Centre Hospital');
INSERT INTO `doctor_info` VALUES (34567, 'Watson ', 'London Centre Hospital');

INSERT INTO `report` VALUES ('2021-10-03 18:09:00', '2021-10-03 05:30:00', 0, '23456', '2021-10-03 20:09:00', '123', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-03 19:30:00', '2021-10-03 15:30:00', 0, '23456', '2021-10-03 22:30:00', '134', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 12:20:00', '2021-10-03 19:30:00', 1, '34567', '2021-10-04 18:20:00', '688', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 22:20:00', '2021-10-04 19:45:00', 0, '23456', '2021-10-05 07:30:00', '123', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00', '688', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-03 22:30:00', '2021-10-03 19:30:00', 0, '34567', '2021-10-04 22:30:00', '134', 'Covid-19');


-- ----------------------------
-- case 3
-- ----------------------------

SELECT
	MIN( generation_time ),hospital_Name
FROM
	( SELECT AVG(UNIX_TIMESTAMP(report_time) - UNIX_TIMESTAMP(test_time)) AS generation_time, hospital_Name FROM report INNER JOIN doctor_info USING ( doctor_ID ) GROUP BY hospital_name ) AS `result`;

-- ----------------------------
-- Records of case 4 + patient
-- ----------------------------
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('123', 'Chandler', 'Male', 31, '13678566');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('134', 'Moncia', 'Female', 29, '4576788');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('145', 'Ross', 'Male', 31, '777222');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('688', 'Mark', 'Male', 22, '233636');

INSERT INTO `report` VALUES ('2021-10-03 18:09:00', '2021-10-03 05:30:00', 0, '23456', '2021-10-03 20:09:00', '123', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-03 19:30:00', '2021-10-03 15:30:00', 0, '23456', '2021-10-03 22:30:00', '134', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 12:20:00', '2021-10-03 19:30:00', 1, '34567', '2021-10-04 18:20:00', '688', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 22:20:00', '2021-10-04 19:45:00', 0, '23456', '2021-10-05 07:30:00', '123', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00', '688', 'Covid-19');
INSERT INTO `report` VALUES ('2021-10-03 22:30:00', '2021-10-03 19:30:00', 0, '34567', '2021-10-04 22:30:00', '134', 'Covid-19');


-- ----------------------------
-- case 4
-- ----------------------------

SELECT
	MobileNum 
FROM
	patient AS p
	INNER JOIN (
	SELECT
		* 
	FROM
		report 
	WHERE
		collect_time <= '2021-10-05 00:00:00' AND collect_time >= '2021-10-03 00:00:00' 
	GROUP BY
		patient_ID 
	HAVING
		COUNT( collect_time ) = '2' 
		AND UNIX_TIMESTAMP(MAX( collect_time ))- UNIX_TIMESTAMP(MIN( collect_time )) > 86400 
	) AS N ON p.ID = N.patient_ID;


-- ----------------------------
-- Records of case 5
-- ----------------------------
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('A123', 'Centre Lukewarm Hillside', 'NY');
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('A456', 'Lenny town', 'NY');
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('B123', 'Glow Sand district', 'LA');
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('C123', 'Raspberry town', 'KF');
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('C456', 'Bunny Tail district', 'KF');

INSERT INTO `risk_level` (`risk_level`, `description`, `risk_level_ID`) VALUES ('low', 'no positive cases within 1 week', 0);
INSERT INTO `risk_level` (`risk_level`, `description`, `risk_level_ID`) VALUES ('mid', 'here are positive cases within 1 week', 1);
INSERT INTO `risk_level` (`risk_level`, `description`, `risk_level_ID`) VALUES ('high', 'There are one or more positive case staying more than 24 hours.', 2);


INSERT INTO `district_risk` (`district_ID`, `announce_time`, `risk_level_ID`) VALUES ('A123', '2021-10-09 00:00:00', 2);
INSERT INTO `district_risk` (`district_ID`, `announce_time`, `risk_level_ID`) VALUES ('A123', '2021-10-09 19:30:00', 1);
INSERT INTO `district_risk` (`district_ID`, `announce_time`, `risk_level_ID`) VALUES ('A456', '2021-10-09 00:00:00', 2);
INSERT INTO `district_risk` (`district_ID`, `announce_time`, `risk_level_ID`) VALUES ('B123', '2021-10-09 00:00:00', 1);
INSERT INTO `district_risk` (`district_ID`, `announce_time`, `risk_level_ID`) VALUES ('C123', '2021-10-09 00:00:00', 0);
INSERT INTO `district_risk` (`district_ID`, `announce_time`, `risk_level_ID`) VALUES ('C456', '2021-10-09 00:00:00', 0);


-- ----------------------------
-- case 5
-- ----------------------------

SELECT
	district_Name,
	risk_level
FROM
	(district_info INNER JOIN district_risk USING (district_ID))INNER JOIN risk_level USING (risk_level_ID)
WHERE announce_time = '2021-10-09 00:00:00'
ORDER BY risk_level_ID DESC, district_Name ASC;

-- ----------------------------
-- Records of case 6
-- ----------------------------
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('A123', 'Centre Lukewarm Hillside', 'NY');
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('A456', 'Lenny town', 'NY');
INSERT INTO `district_info` (`district_ID`, `district_Name`, `region`) VALUES ('B123', 'Glow Sand district', 'LA');

INSERT INTO `hospital_info` VALUES
('London Centre Hospital', 'A123'),
('NY Centre Hospital', 'A123'),
('California Centre Hospital', 'B123');

INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES (12345, 'Richard', 'NY Centre Hospital');
INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES (23456, 'Dick', 'California Centre Hospital');
INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES (34567, 'Watson ', 'London Centre Hospital');

INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('123', 'Chandler', 'Male', 31, '13678566');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('134', 'Moncia', 'Female', 29, '4576788');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('145', 'Ross', 'Male', 31, '777222');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('688', 'Mark', 'Male', 22, '233636');

INSERT INTO `report` VALUES ('2021-10-09 23:34:00', '2021-10-04 15:30:00', 0, '34567', '2021-10-10 15:30:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-03 18:09:00', '2021-10-03 05:30:00', 0, '23456', '2021-10-03 20:09:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 12:20:00', '2021-10-03 19:30:00', 1, '34567', '2021-10-04 18:20:00','123','Covid-19');
INSERT INTO `report` VALUES ('2021-10-14 14:30:00', '2021-10-04 19:34:00', 1, '34567', '2021-10-14 14:30:00','688','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 22:20:00', '2021-10-04 19:45:00', 0, '23456', '2021-10-05 07:30:00','134','Covid-19');

-- ----------------------------
-- case 6
-- ----------------------------
SELECT
	`Name`,
	MobileNum 
FROM
	report
	INNER JOIN patient ON report.patient_ID = patient.ID
    INNER JOIN doctor_info USING ( doctor_ID )
    INNER JOIN hospital_info USING (hospital_Name)
    INNER JOIN district_info ON hospital_info.hospital_districtID = district_info.district_ID
WHERE
	collect_Time BETWEEN '2021-10-04 00:00:00' AND '2021-10-04 23:59:59' 
	AND is_Positive = '1' 
	AND district_Name = 'Centre Lukewarm Hillside';

-- ----------------------------
-- Records of case 7
-- ----------------------------
INSERT INTO `hospital_info` VALUES
('London Centre Hospital', 'A123'),
('NY Centre Hospital', 'A123'),
('California Centre Hospital', 'B123');

INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('123', 'Chandler', 'Male', 31, '13678566');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('134', 'Moncia', 'Female', 29, '4576788');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('145', 'Ross', 'Male', 31, '777222');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('688', 'Mark', 'Male', 22, '233636');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('555', 'Phoebe', 'Female', 23, '555556');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('156', 'Rachel', 'Female', 22, '567890');

INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES (12345, 'Richard', 'NY Centre Hospital');
INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES (23456, 'Dick', 'California Centre Hospital');
INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES (34567, 'Watson ', 'London Centre Hospital');


-- ----------------------------
-- Records of case 7-1: When the increment is negative, this is the INSERT statements in table report.
-- ----------------------------
INSERT INTO `report` VALUES ('2021-10-03 18:09:00', '2021-10-03 05:30:00', 0, '23456', '2021-10-03 20:09:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 12:20:00', '2021-10-03 19:30:00', 1, '34567', '2021-10-04 18:20:00','123','Covid-19');
INSERT INTO `report` VALUES ('2021-10-09 23:34:00', '2021-10-04 15:30:00', 1, '34567', '2021-10-10 15:30:00','134','Covid-19');
INSERT INTO `report` VALUES ('2021-10-14 14:30:00', '2021-10-04 19:34:00', 1, '34567', '2021-10-14 14:30:00','688','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 22:20:00', '2021-10-04 19:45:00', 0, '23456', '2021-10-05 07:30:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-06 13:48:00', '2021-10-05 13:38:00', 0, '34567', '2021-10-07 16:23:00','555','Covid-19');
INSERT INTO `report` VALUES ('2021-10-05 13:23:00', '2021-10-05 17:38:00', 1, '34567', '2021-10-07 13:38:00','156','Covid-19');


-- ----------------------------
-- Records of case 7-2: When the increment is positive, this is the INSERT statements in table report.
-- ----------------------------
INSERT INTO `report` VALUES ('2021-10-03 18:09:00', '2021-10-03 05:30:00', 0, '23456', '2021-10-03 20:09:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 12:20:00', '2021-10-03 19:30:00', 1, '34567', '2021-10-04 18:20:00','123','Covid-19');
INSERT INTO `report` VALUES ('2021-10-09 23:34:00', '2021-10-04 15:30:00', 1, '34567', '2021-10-10 15:30:00','134','Covid-19');
INSERT INTO `report` VALUES ('2021-10-14 14:30:00', '2021-10-04 19:34:00', 0, '34567', '2021-10-14 14:30:00','688','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 22:20:00', '2021-10-04 19:45:00', 0, '23456', '2021-10-05 07:30:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-06 13:48:00', '2021-10-05 13:38:00', 0, '34567', '2021-10-07 16:23:00','555','Covid-19');
INSERT INTO `report` VALUES ('2021-10-05 13:23:00', '2021-10-05 17:38:00', 1, '34567', '2021-10-07 13:38:00','156','Covid-19');
INSERT INTO `report` VALUES ('2021-10-05 19:45:00', '2021-10-05 23:45:00', 1, '34567', '2021-10-06 19:45:00','555','Covid-19');


-- ----------------------------
-- case 7
-- ----------------------------
SELECT (SELECT COUNT(collect_Time)
FROM report INNER JOIN doctor_info USING (doctor_ID) INNER JOIN hospital_info USING (hospital_Name)
    INNER JOIN district_info ON hospital_info.hospital_districtID = district_info.district_ID
WHERE district_Name = 'Centre Lukewarm Hillside' AND report.is_positive = '1' AND collect_Time BETWEEN '2021-10-05 00:00:00' AND '2021-10-05 23:59:59')
- (SELECT COUNT(collect_Time) 
FROM report INNER JOIN doctor_info USING (doctor_ID) INNER JOIN hospital_info USING (hospital_Name)
    INNER JOIN district_info ON hospital_info.hospital_districtID = district_info.district_ID
WHERE district_Name = 'Centre Lukewarm Hillside' AND report.is_positive = '1' AND collect_Time BETWEEN '2021-10-04 00:00:00' AND '2021-10-04 23:59:59') 
AS 'Increment';

-- ----------------------------
-- Records of case 8
-- ----------------------------
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('123', 'Chandler', 'Male', 31, '13678566');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('134', 'Moncia', 'Female', 29, '4576788');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('145', 'Ross', 'Male', 31, '777222');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('688', 'Mark', 'Male', 22, '233636');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('555', 'Phoebe', 'Female', 23, '555556');
INSERT INTO `patient` (`ID`, `Name`, `Sex`, `Age`, `MobileNum`) VALUES ('156', 'Rachel', 'Female', 22, '567890');

INSERT INTO `location` VALUES ('1', '13678566', '2021-10-08 19:45:00', '2021-10-09 14:20:00','40°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '233636', '2021-10-06 19:20:00', '2021-10-06 23:55:00','40°41\'58.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '233636', '2021-10-08 23:30:00', '2021-10-09 19:30:00','40°41\'59.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('6', '233636', '2021-10-08 14:30:00', '2021-10-08 19:30:34','67°41\'.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '4576788', '2021-10-06 22:20:00', '2021-10-07 14:30:00','40°46\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('6', '567890', '2021-10-08 19:30:00', '2021-10-09 21:13:00','68°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '777222', '2021-10-01 19:30:00', '2021-10-05 19:30:00','39°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` VALUES ('1', '777222', '2021-10-10 19:30:00', '2021-10-11 19:30:00','41°41\'56.67’‘N', '74° 0\'21.50‘’W');

INSERT INTO `report` VALUES ('2021-10-03 18:09:00', '2021-10-08 05:30:00', 0, '23456', '2021-10-03 20:09:00','123','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 12:20:00', '2021-10-08 19:30:00', 1, '34567', '2021-10-04 18:20:00','145','Covid-19');
INSERT INTO `report` VALUES ('2021-10-09 23:34:00', '2021-10-09 15:30:00', 1, '34567', '2021-10-10 15:30:00','156','Covid-19');
INSERT INTO `report` VALUES ('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00','688','Covid-19');
INSERT INTO `report` VALUES ('2021-10-04 22:20:00', '2021-10-10 19:45:00', 0, '23456', '2021-10-05 07:30:00','123','Covid-19');
INSERT INTO `report` VALUES ('2021-10-06 13:48:00', '2021-10-10 13:38:00', 0, '34567', '2021-10-07 16:23:00','156','Covid-19');
INSERT INTO `report` VALUES ('2021-10-05 13:23:00', '2021-10-12 17:38:00', 1, '34567', '2021-10-07 13:38:00','156','Covid-19');
INSERT INTO `report` VALUES ('2021-10-05 19:45:00', '2021-10-24 23:45:00', 1, '34567', '2021-10-06 19:45:00','145','Covid-19');

-- ----------------------------
-- case 8
-- ----------------------------
SELECT
    (SELECT COUNT(DISTINCT B.phoneNum) FROM (location A INNER JOIN bs_information B1 USING(BSID)), (location B INNER JOIN bs_information B2 USING (BSID))
WHERE B1.district_ID = B2.district_ID AND A.phoneNum = '233636' AND B.phoneNum != '233636'
AND NOT (B.disconnect_time < A.connect_time)
AND NOT (B.connect_time > A.disconnect_time)
AND A.connect_time BETWEEN '2021-10-07 19:30:00' AND '2021-10-09 19:30:00')
/
(SELECT
		COUNT(DISTINCT patient_ID) AS 'Infected People'
	FROM
		report 
	WHERE
		is_positive = '1' 
		AND collect_time BETWEEN '2021-10-09 19:30:00' AND '2021-10-23 19:30:00'
  	    AND patient_ID IN (
			SELECT patient.ID FROM patient 
            WHERE MobileNum IN (
                SELECT DISTINCT B.phoneNum FROM (location A INNER JOIN bs_information B1 USING(BSID)), (location B INNER JOIN bs_information B2 USING (BSID))
WHERE B1.district_ID = B2.district_ID
    AND A.phoneNum = '233636' AND B.phoneNum != '233636'
	AND NOT (B.disconnect_time < A.connect_time)
	AND NOT (B.connect_time > A.disconnect_time)
	AND A.connect_time BETWEEN '2021-10-07 19:30:00' AND '2021-10-09 19:30:00'))) AS 'rate';




--          Extended use cases
-- ----------------------------
-- Records of My case 1
-- ----------------------------
INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES
('1', '13678566', '2021-10-08 19:45:00', '2021-10-09 14:20:00', '40°41\'56.67’‘N', '74° 0\'21.50‘’W'),
('1', '233636', '2021-10-06 19:20:00', '2021-10-06 23:55:00', '40°41\'58.67’‘N', '74° 0\'21.50‘’W'),
('6', '233636', '2021-10-08 14:30:00', '2021-10-08 19:30:34', '67°41\'.67’‘N', '74° 0\'21.50‘’W'),
('1', '233636', '2021-10-08 23:30:00', '2021-10-09 19:30:00', '40°41\'59.67’‘N', '74° 0\'21.50‘’W'),
('1', '4576788', '2021-10-06 22:20:00', '2021-10-07 14:30:00', '40°46\'56.67’‘N', '74° 0\'21.50‘’W'),
('6', '567890', '2021-10-08 19:30:00', '2021-10-09 21:13:00', '68°41\'56.67’‘N', '74° 0\'21.50‘’W'),
('1', '777222', '2021-10-01 19:30:00', '2021-10-05 19:30:00', '39°41\'56.67’‘N', '74° 0\'21.50‘’W'),
('1', '777222', '2021-10-10 19:30:00', '2021-10-11 19:30:00', '41°41\'56.67’‘N', '74° 0\'21.50‘’W');

-- ----------------------------
-- My case 1
-- ----------------------------
SELECT DISTINCT phoneNum FROM location 
WHERE UNIX_TIMESTAMP(disconnect_time)- UNIX_TIMESTAMP(connect_time) >= 86400;

-- ----------------------------
-- Records of My case 2
-- ----------------------------
INSERT INTO `bs_information` (`BSID`, `BSName`, `district_ID`, `latitude`, `longitude`) VALUES
('1', 'AAA', 'A123', '40°41\'54.67’‘N', '74° 0\'21.50‘’W'),
('15', 'AAB', 'B123', '34°03‘52.53‘’N', '118°15\'23.50‘’W'),
('2', 'BAA', 'A123', '40°42\'54.67‘’N', '74° 0\'23.50‘’W'),
('3', 'CAA', 'A123', '40°42\'51.67‘’N', '74° 0\'22.50‘’W'),
('56', 'AAC', 'C123', '67°15′43.34‘’S', '109°12′21.37‘’E'),
('6', 'ABA', 'A456', '40°42\'58.67‘’N', '74° 0\'25.50‘’W');

INSERT INTO `district_risk` (`district_ID`, `risk_level_ID`, `announce_time`) VALUES
('C123', 0, '2021-10-09 00:00:00'),
('C456', 0, '2021-10-09 00:00:00'),
('A123', 1, '2021-10-10 00:00:00'),
('B123', 1, '2021-10-09 00:00:00'),
('A123', 2, '2021-10-09 00:00:00'),
('A456', 2, '2021-10-09 00:00:00');

INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES
('2', '13678566', '2021-10-08 19:45:00', '2021-10-09 14:20:00', '40°41\'56.67’‘N', '74° 0\'21.50‘’W'),
('3', '233636', '2021-10-06 19:20:00', '2021-10-06 23:55:00', '40°41\'58.67’‘N', '74° 0\'21.50‘’W'),
('6', '233636', '2021-10-08 14:30:00', '2021-10-08 19:30:34', '67°41\'.67’‘N', '74° 0\'21.50‘’W'),
('1', '233636', '2021-10-08 23:30:00', '2021-10-09 19:30:00', '40°41\'59.67’‘N', '74° 0\'21.50‘’W'),
('1', '4576788', '2021-10-06 22:20:00', '2021-10-07 14:30:00', '40°46\'56.67’‘N', '74° 0\'21.50‘’W'),
('15', '567890', '2021-10-08 19:30:00', '2021-10-09 21:13:00', '68°41\'56.67’‘N', '74° 0\'21.50‘’W'),
('2', '777222', '2021-10-01 19:30:00', '2021-10-05 19:30:00', '39°41\'56.67’‘N', '74° 0\'21.50‘’W'),
('6', '777222', '2021-10-10 19:30:00', '2021-10-11 19:30:00', '41°41\'56.67’‘N', '74° 0\'21.50‘’W');

-- ----------------------------
-- My case 2
-- ----------------------------
SELECT DISTINCT phoneNum FROM location INNER JOIN bs_information USING (BSID) INNER JOIN district_risk USING (district_ID) 
WHERE announce_time = '2021-10-09 00:00:00' AND district_risk.risk_level_ID = 2 AND connect_time BETWEEN '2021-10-08 00:00:00' AND '2021-10-08 23:59:59';

-- ----------------------------
-- Records of My case 3
-- ----------------------------
INSERT INTO `risk_level` VALUES
(0, 'low', 'no positive cases within 1 week'),
(1, 'mid', 'here are positive cases within 1 week'),
(2, 'high', 'There are one or more positive case staying more than 24 hours.');

INSERT INTO `bs_information` (`BSID`, `BSName`, `district_ID`, `latitude`, `longitude`) VALUES
('1', 'AAA', 'A123', '40°41\'54.67’‘N', '74° 0\'21.50‘’W'),
('15', 'AAB', 'B123', '34°03‘52.53‘’N', '118°15\'23.50‘’W'),
('2', 'BAA', 'A123', '40°42\'54.67‘’N', '74° 0\'23.50‘’W'),
('3', 'CAA', 'A123', '40°42\'51.67‘’N', '74° 0\'22.50‘’W'),
('56', 'AAC', 'C123', '67°15′43.34‘’S', '109°12′21.37‘’E'),
('6', 'ABA', 'A456', '40°42\'58.67‘’N', '74° 0\'25.50‘’W');

INSERT INTO `district_risk` (`district_ID`, `risk_level_ID`, `announce_time`) VALUES
('C123', 0, '2021-10-09 00:00:00'),
('C456', 0, '2021-10-09 00:00:00'),
('A123', 1, '2021-10-10 00:00:00'),
('B123', 1, '2021-10-09 00:00:00'),
('A123', 2, '2021-10-09 00:00:00'),
('A456', 2, '2021-10-09 00:00:00');

INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES('2', '13678566', '2021-10-08 19:45:00', '2021-10-09 14:20:00', '40°41\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES('3', '233636', '2021-10-06 19:20:00', '2021-10-06 23:55:00', '40°41\'58.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES('6', '233636', '2021-10-08 14:30:00', '2021-10-08 19:30:34', '67°41\'.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES('15', '233636', '2021-10-08 23:30:00', '2021-10-09 19:30:00', '40°41\'59.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES('1', '4576788', '2021-10-06 22:20:00', '2021-10-07 14:30:00', '40°46\'56.67’‘N', '74° 0\'21.50‘’W');
INSERT INTO `location` (`BSID`, `phoneNum`, `connect_time`, `disconnect_time`, `latitude`, `longitude`) VALUES('15', '567890', '2021-10-08 19:30:00', '2021-10-09 21:13:00', '68°41\'56.67’‘N', '74° 0\'21.50‘’W');

-- ----------------------------
-- My case 3
-- ----------------------------
SELECT phoneNum, risk_level FROM location INNER JOIN bs_information USING (BSID) INNER JOIN district_risk USING (district_ID) INNER JOIN risk_level USING(risk_level_ID)
WHERE phoneNum = '233636' AND connect_time BETWEEN '2021-10-08 00:00:00' AND '2021-10-08 23:59:59'AND announce_time = '2021-10-09 00:00:00' 
ORDER BY risk_level_ID DESC;

-- ----------------------------
-- Records of My case 4
-- ----------------------------
INSERT INTO `doctor_info` (`doctor_ID`, `doctor_Name`, `hospital_Name`) VALUES
('12345', 'Richard', 'NY Centre Hospital'),
('23456', 'Dick', 'California Centre Hospital'),
('34567', 'Watson ', 'London Centre Hospital');

INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES
('2021-10-03 18:09:00', '2021-10-08 05:30:00', 1, '23456', '2021-10-03 20:09:00', '123', 'Covid-19'),
('2021-10-04 12:20:00', '2021-10-08 19:30:00', 1, '34567', '2021-10-04 18:20:00', '145', 'Covid-19'),
('2021-10-09 23:34:00', '2021-10-09 15:30:00', 0, '12345', '2021-10-10 15:30:00', '156', 'Covid-19'),
('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00', '688', 'Covid-19'),
('2021-10-11 19:45:00', '2021-10-09 23:45:00', 0, '34567', '2021-10-12 19:45:00', '337', 'Covid-19'),
('2021-10-06 13:48:00', '2021-10-10 13:38:00', 1, '12345', '2021-10-07 16:23:00', '156', 'Covid-19'),
('2021-10-04 22:20:00', '2021-10-10 19:21:00', 1, '23456', '2021-10-05 07:30:00', '156', 'Covid-19'),
('2021-10-04 22:20:00', '2021-10-10 19:45:00', 1, '23456', '2021-10-05 07:30:00', '555', 'Covid-19'),
('2021-10-05 13:23:00', '2021-10-12 17:38:00', 1, '34567', '2021-10-07 13:38:00', '134', 'Covid-19'),
('2021-10-05 19:45:00', '2021-10-12 23:45:00', 1, '12345', '2021-10-06 19:45:00', '688', 'Covid-19'),
('2021-10-05 19:45:00', '2021-10-24 23:45:00', 1, '34567', '2021-10-06 19:45:00', '337', 'Covid-19');

-- ----------------------------
-- My case 4
-- ----------------------------
SELECT doctor_Name,doctor_ID, COUNT(doctor_ID) AS 'times' 
FROM doctor_info LEFT OUTER JOIN report USING (doctor_ID) 
GROUP BY doctor_ID
HAVING COUNT(doctor_ID) =(
SELECT MAX(temp.amount) 
    FROM(
SELECT COUNT(doctor_ID) amount 
FROM report 
GROUP BY doctor_ID)temp);

-- ----------------------------
-- Records of My case 5
-- ----------------------------
INSERT INTO `patient` VALUES
('123', 'Chandler', 'Male', 40, '13678566'),
('134', 'Moncia', 'Female', 29, '4576788'),
('145', 'Ross', 'Male', 35, '777222'),
('156', 'Rachel', 'Female', 26, '567890'),
('337', 'Joey', 'Male', 40, '222222'),
('555', 'Phoebe', 'Female', 23, '555556'),
('688', 'Mark', 'Male', 15, '233636');

INSERT INTO `report` VALUES
('2021-10-03 18:09:00', '2021-10-08 05:30:00', 1, '23456', '2021-10-03 20:09:00', '123', 'Coughid-21 '),
('2021-10-04 12:20:00', '2021-10-08 19:30:00', 1, '34567', '2021-10-04 18:20:00', '145', 'Covid-19'),
('2021-10-09 23:34:00', '2021-10-09 15:30:00', 0, '12345', '2021-10-10 15:30:00', '156', 'MERS'),
('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00', '688', 'SARS'),
('2021-10-11 19:45:00', '2021-10-09 23:45:00', 0, '34567', '2021-10-12 19:45:00', '337', 'Coughid-21 '),
('2021-10-06 13:48:00', '2021-10-10 13:38:00', 1, '12345', '2021-10-07 16:23:00', '156', 'Covid-19'),
('2021-10-04 22:20:00', '2021-10-10 19:21:00', 1, '23456', '2021-10-05 07:30:00', '156', 'MERS'),
('2021-10-04 22:20:00', '2021-10-10 19:45:00', 1, '23456', '2021-10-05 07:30:00', '555', 'Coughid-21 '),
('2021-10-05 13:23:00', '2021-10-12 17:38:00', 1, '34567', '2021-10-07 13:38:00', '134', 'Covid-19'),
('2021-10-05 19:45:00', '2021-10-12 23:45:00', 1, '12345', '2021-10-06 19:45:00', '688', 'Coughid-21 '),
('2021-10-05 19:45:00', '2021-10-24 23:45:00', 1, '34567', '2021-10-06 19:45:00', '337', 'Coughid-21 ');

-- ----------------------------
-- My case 5
-- ----------------------------
SELECT virus_Name FROM patient INNER JOIN report ON patient.ID = report.patient_ID
WHERE report.is_positive = 1
GROUP BY virus_Name
HAVING COUNT(DISTINCT patient_ID) >= 1;

-- ----------------------------
-- Records of My case 6
-- ----------------------------
INSERT INTO `patient` VALUES
('123', 'Chandler', 'Male', 40, '13678566'),
('134', 'Moncia', 'Female', 29, '4576788'),
('145', 'Ross', 'Male', 35, '777222'),
('156', 'Rachel', 'Female', 26, '567890'),
('337', 'Joey', 'Male', 40, '222222'),
('555', 'Phoebe', 'Female', 23, '555556'),
('688', 'Mark', 'Male', 15, '233636');


INSERT INTO `report` VALUES
('2021-10-03 18:09:00', '2021-10-08 05:30:00', 1, '23456', '2021-10-03 20:09:00', '123', 'Covid-19'),
('2021-10-04 12:20:00', '2021-10-08 19:30:00', 1, '34567', '2021-10-04 18:20:00', '145', 'Covid-19'),
('2021-10-09 23:34:00', '2021-10-09 15:30:00', 0, '34567', '2021-10-10 15:30:00', '156', 'Covid-19'),
('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00', '688', 'Covid-19'),
('2021-10-06 13:48:00', '2021-10-10 13:38:00', 0, '34567', '2021-10-07 16:23:00', '156', 'Covid-19'),
('2021-10-04 22:20:00', '2021-10-10 19:45:00', 1, '23456', '2021-10-05 07:30:00', '555', 'Covid-19'),
('2021-10-05 13:23:00', '2021-10-12 17:38:00', 1, '34567', '2021-10-07 13:38:00', '134', 'Covid-19'),
('2021-10-05 19:45:00', '2021-10-24 23:45:00', 1, '34567', '2021-10-06 19:45:00', '337', 'Covid-19');

-- ----------------------------
-- My case 6
-- ----------------------------
SELECT (SELECT COUNT(DISTINCT patient_ID) 
 		FROM report INNER JOIN patient ON report.patient_ID = patient.ID
		WHERE report.is_positive = '1'
 		AND patient.Sex = 'Male'
)/
(SELECT COUNT(DISTINCT patient_ID) 
 		FROM report 
		WHERE report.is_positive = '1') AS 'res';

-- ----------------------------
-- Records of My case 7
-- ----------------------------
INSERT INTO `patient` VALUES
('123', 'Chandler', 'Male', 40, '13678566'),
('134', 'Moncia', 'Female', 29, '4576788'),
('145', 'Ross', 'Male', 35, '777222'),
('156', 'Rachel', 'Female', 26, '567890'),
('337', 'Joey', 'Male', 40, '222222'),
('555', 'Phoebe', 'Female', 23, '555556'),
('688', 'Mark', 'Male', 15, '233636');


INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-03 18:09:00', '2021-10-08 05:30:00', 1, '23456', '2021-10-03 20:09:00', '123', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-04 12:20:00', '2021-10-08 19:30:00', 1, '34567', '2021-10-04 18:20:00', '145', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-09 23:34:00', '2021-10-09 15:30:00', 0, '34567', '2021-10-10 15:30:00', '156', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-14 14:30:00', '2021-10-09 19:34:00', 1, '34567', '2021-10-14 14:30:00', '688', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-06 13:48:00', '2021-10-10 13:38:00', 0, '34567', '2021-10-07 16:23:00', '156', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-04 22:20:00', '2021-10-10 19:45:00', 0, '23456', '2021-10-05 07:30:00', '555', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-05 13:23:00', '2021-10-12 17:38:00', 1, '34567', '2021-10-07 13:38:00', '134', 'Covid-19');
INSERT INTO `report` (`test_time`, `collect_time`, `is_positive`, `doctor_ID`, `report_time`, `patient_ID`, `virus_Name`) VALUES('2021-10-05 19:45:00', '2021-10-24 23:45:00', 1, '34567', '2021-10-06 19:45:00', '337', 'Covid-19');


-- ----------------------------
-- My case 7
-- ----------------------------
SELECT (SELECT COUNT(DISTINCT patient_ID) 
 		FROM report INNER JOIN patient ON report.patient_ID = patient.ID
		WHERE report.is_positive = '1'
 		AND patient.Age >= 20 
 		AND patient.Age < 30
)/
(SELECT COUNT(DISTINCT patient_ID) 
 		FROM report INNER JOIN patient ON report.patient_ID = patient.ID
		WHERE report.is_positive = '1') AS 'res';


-- ----------------------------
-- Records of My case 8
-- ----------------------------
INSERT INTO `risk_level` VALUES
(0, 'low', 'no positive cases within 1 week'),
(1, 'mid', 'here are positive cases within 1 week'),
(2, 'high', 'There are one or more positive case staying more than 24 hours.');

INSERT INTO `district_info` VALUES
('A123', 'Centre Lukewarm Hillside', 'NY'),
('A456', 'Lenny town', 'NY'),
('B123', 'Glow Sand district', 'LA'),
('C123', 'Raspberry town', 'KF'),
('C456', 'Bunny Tail district', 'KF');

INSERT INTO `district_risk` VALUES
('A123', 0, '2021-10-05 00:00:00'),
('A123', 0, '2021-10-06 00:00:00'),
('C123', 0, '2021-10-09 00:00:00'),
('C456', 0, '2021-10-09 00:00:00'),
('A123', 1, '2021-10-07 00:00:00'),
('A123', 1, '2021-10-08 00:00:00'),
('A123', 1, '2021-10-09 00:00:00'),
('B123', 1, '2021-10-09 00:00:00'),
('A123', 2, '2021-10-10 00:00:00'),
('A123', 2, '2021-10-11 00:00:00'),
('A456', 2, '2021-10-09 00:00:00');

-- ----------------------------
-- My case 8
-- ----------------------------
SELECT risk_level, announce_time FROM district_risk INNER JOIN risk_level USING(risk_level_ID) INNER JOIN district_info USING (district_ID)
WHERE district_info.district_Name = 'Centre Lukewarm Hillside';


-- ----------------------------
-- Records of My case 9
-- ----------------------------
INSERT INTO `district_info` VALUES
('A123', 'Centre Lukewarm Hillside', 'NY'),
('A456', 'Lenny town', 'NY'),
('B123', 'Glow Sand district', 'LA'),
('C123', 'Raspberry town', 'KF'),
('C456', 'Bunny Tail district', 'KF');

INSERT INTO `bs_information` (`BSID`, `BSName`, `district_ID`, `latitude`, `longitude`) VALUES
('1', 'AAA', 'A123', '40°41\'54.67’‘N', '74° 0\'21.50‘’W'),
('15', 'AAB', 'B123', '34°03‘52.53‘’N', '118°15\'23.50‘’W'),
('2', 'BAA', 'A123', '40°42\'54.67‘’N', '74° 0\'23.50‘’W'),
('3', 'CAA', 'A123', '40°42\'51.67‘’N', '74° 0\'22.50‘’W'),
('56', 'AAC', 'C123', '67°15′43.34‘’S', '109°12′21.37‘’E'),
('6', 'ABA', 'A456', '40°42\'58.67‘’N', '74° 0\'25.50‘’W');


-- ----------------------------
-- My case 9
-- ----------------------------
SELECT BSID, district_info.district_Name,district_info.region FROM bs_information INNER JOIN district_info USING (district_ID)
WHERE region = 'NY';


-- ----------------------------
-- Records of My case 10
-- ----------------------------
INSERT INTO `patient` VALUES
('123', 'Chandler', 'Male', 40, '13678566'),
('134', 'Moncia', 'Female', 29, '4576788'),
('145', 'Ross', 'Male', 35, '777222'),
('156', 'Rachel', 'Female', 26, '567890'),
('337', 'Joey', 'Male', 40, '222222'),
('555', 'Phoebe', 'Female', 23, '555556'),
('688', 'Mark', 'Male', 15, '233636');

INSERT INTO `report` VALUES
('2021-10-03 18:09:00', '2021-10-08 05:30:00', 1, '23456', '2021-10-03 20:09:00', '123', 'Coughid-21 '),
('2021-10-04 12:20:00', '2021-10-08 19:30:00', 1, '34567', '2021-10-04 18:20:00', '145', 'Covid-19'),
('2021-10-09 23:34:00', '2021-10-09 15:30:00', 0, '34567', '2021-10-10 15:30:00', '156', 'MERS'),
('2021-10-14 14:30:00', '2021-10-09 19:34:00', 0, '34567', '2021-10-14 14:30:00', '688', 'SARS'),
('2021-10-11 19:45:00', '2021-10-09 23:45:00', 0, '34567', '2021-10-12 19:45:00', '337', 'Coughid-21 '),
('2021-10-06 13:48:00', '2021-10-10 13:38:00', 1, '34567', '2021-10-07 16:23:00', '156', 'Covid-19'),
('2021-10-04 22:20:00', '2021-10-10 19:21:00', 1, '23456', '2021-10-05 07:30:00', '555', 'MERS'),
('2021-10-04 22:20:00', '2021-10-10 19:45:00', 1, '23456', '2021-10-05 07:30:00', '555', 'Coughid-21 '),
('2021-10-05 13:23:00', '2021-10-12 17:38:00', 1, '34567', '2021-10-07 13:38:00', '134', 'Covid-19'),
('2021-10-05 19:45:00', '2021-10-12 23:45:00', 0, '34567', '2021-10-06 19:45:00', '688', 'Coughid-21 '),
('2021-10-05 19:45:00', '2021-10-24 23:45:00', 1, '34567', '2021-10-06 19:45:00', '337', 'Coughid-21 ');


-- ----------------------------
-- My case 10
-- ----------------------------
SELECT virus_Name ,COUNT(DISTINCT patient_ID) AS 'times'
 		FROM report 
        WHERE collect_time BETWEEN '2021-10-08 00:00:00' AND '2021-10-12 23:59:59'
        GROUP BY virus_Name
        ORDER BY COUNT(DISTINCT patient_ID) DESC;



