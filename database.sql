-- ======================================================================
-- Database: GEI Certificate of Inspection System
-- Class: CSE2102
-- Author: Tarico Henry, Serina Garrett, Shemar Holder, Leandro Rodriguez
-- Prepared for: Professor Amrita Ramnauth and Professor Phillip Gajadhar
-- Date: October 2025
-- ======================================================================

CREATE DATABASE gei_certificate_db;
USE gei_certificate_db;

-- ======================================================
-- TABLE: License
-- ======================================================
CREATE TABLE License (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_date DATE NOT NULL,
    expiry_date DATE AS (DATE_ADD(issue_date, INTERVAL 5 YEAR)) PERSISTENT
);

-- ======================================================
-- TABLE: Region
-- ======================================================
CREATE TABLE Region (
    region_number INT PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL
);

-- ======================================================
-- TABLE: Contractor
-- ======================================================
CREATE TABLE Contractor (
    contractor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    lot_number INT(4),
    street_name VARCHAR(100),
    village VARCHAR(100),
    city VARCHAR(100),
    region_number INT,
    license_id INT,
    status VARCHAR(20) CHECK (status IN ('Active', 'Suspended')),
    FOREIGN KEY (region_number) REFERENCES Region(region_number),
    FOREIGN KEY (license_id) REFERENCES License(license_id)
);

-- ======================================================
-- TABLE: Owner
-- ======================================================
CREATE TABLE Owner (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- ======================================================
-- TABLE: Building
-- ======================================================
CREATE TABLE Building (
    building_id INT PRIMARY KEY AUTO_INCREMENT,
    lot_number INT(4),
    street_name VARCHAR(100),
    village VARCHAR(100),
    city VARCHAR(100),
    region_number INT,
    building_type VARCHAR(50),
    owner_id INT,
    FOREIGN KEY (region_number) REFERENCES Region(region_number),
    FOREIGN KEY (owner_id) REFERENCES Owner(owner_id)
);

-- ======================================================
-- TABLE: Application
-- ======================================================
CREATE TABLE Application (
    application_number INT PRIMARY KEY AUTO_INCREMENT,
    date_submitted DATE NOT NULL,
    type VARCHAR(20) CHECK (type IN ('New Wiring', 'Upgrade', 'Repair')),
    status VARCHAR(20) CHECK (status IN ('Pending', 'Inspected', 'Approved', 'Rejected')),
    contractor_id INT,
    building_id INT,
    FOREIGN KEY (contractor_id) REFERENCES Contractor(contractor_id),
    FOREIGN KEY (building_id) REFERENCES Building(building_id)
);

-- ======================================================
-- TABLE: Inspection
-- ======================================================
CREATE TABLE Inspection (
    inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    inspection_date DATE NOT NULL,
    outcome VARCHAR(20) CHECK (outcome IN ('Pass', 'Fail', 'Pending')),
    remarks TEXT,
    application_number INT,
    FOREIGN KEY (application_number) REFERENCES Application(application_number)
);

-- ======================================================
-- TABLE: Inspector
-- ======================================================
CREATE TABLE Inspector (
    inspector_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    assigned_region_number INT,
    FOREIGN KEY (assigned_region_number) REFERENCES Region(region_number)
);

-- ======================================================
-- TABLE: Inspection_Assignment
-- ======================================================
CREATE TABLE Inspection_Assignment (
    inspection_id INT,
    inspector_id INT,
    role_of_inspector VARCHAR(50),
    PRIMARY KEY (inspection_id, inspector_id),
    FOREIGN KEY (inspection_id) REFERENCES Inspection(inspection_id),
    FOREIGN KEY (inspector_id) REFERENCES Inspector(inspector_id)
);

-- ======================================================
-- TABLE: Certificate
-- ======================================================
CREATE TABLE Certificate (
    certificate_number INT PRIMARY KEY AUTO_INCREMENT,
    issue_date DATE NOT NULL,
    expiry_date DATE AS (DATE_ADD(issue_date, INTERVAL 1 YEAR)) PERSISTENT,
    status VARCHAR(20) CHECK (status IN ('Valid', 'Expired', 'Revoked')),
    application_number INT,
    FOREIGN KEY (application_number) REFERENCES Application(application_number)
);

-- ======================================================
-- TABLE: Incident_Report
-- ======================================================
CREATE TABLE Incident_Report (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_date DATE NOT NULL,
    description TEXT,
    building_id INT,
    inspector_id INT,
    FOREIGN KEY (building_id) REFERENCES Building(building_id),
    FOREIGN KEY (inspector_id) REFERENCES Inspector(inspector_id)
);

-- ================
-- Data Population
-- ================

-- Regions
INSERT INTO Region VALUES 
(1, 'Region 1 - Barima-Waini'),
(2, 'Region 2 - Pomeroon-Supenaam'),
(3, 'Region 3 - Essequibo Islands-West Demerara'),
(4, 'Region 4 - Demerara-Machica'),
(5, 'Region 5 - Machica-Berbice'),
(6, 'Region 6 - East Berbice-Corentyne'),
(7, 'Region 7 - Cuyurni-Mazaruni'),
(8, 'Region 8 - Potaro-Siparuni'),
(9, 'Region 9 - Upper Takutu-Upper Essequibo'),
(10, 'Region 10 - Upper Demerara-Berbice');

-- Licenses
INSERT INTO License (issue_date) VALUES
('2024-01-15'),
('2023-06-10'),
('2024-03-01'),
('2025-09-10'),
('2025-05-06'),
('2023-12-12'),
('2024-01-29'),
('2023-03-11'),
('2025-08-01'),
('2025-02-08'),
('2025-04-24'),
('2024-09-24'),
('2024-07-26'),
('2023-05-22'),
('2024-06-01'),
('2024-01-29'),
('2025-05-06'),
('2024-01-15'),
('2024-01-15'),
('2025-10-20'),
('2025-10-19'),
('2025-10-07'),
('2023-04-17'),
('2023-11-11'),
('2024-03-21'),
('2024-12-28'),
('2024-12-28'),
('2023-10-07'),
('2023-12-29'),
('2024-07-09'),
('2025-02-28'),
('2024-05-22');

-- Contractors
INSERT INTO Contractor (first_name, last_name, lot_number, street_name, village, city, region_number, license_id, status) VALUES
('John', 'Lion', 12, 'Stiff Street', 'York', 'East Coast Demerara', 4, 1, 'Active'),
('Ravi', 'Bee', 23, 'Water Street', 'New Town', 'Georgetown', 4, 2, 'Active'),
('Deon', 'Cummings', 45, 'Robb Street', 'Queenstown', 'Georgetown', 4, 3, 'Suspended'),
('Jane', 'Doe', 5680, 'Ham Street', 'Kingston', 'Georgetown', 4, 4, 'Active'),
('King', 'June', 99, 'East Street', 'Pine Ville', 'Essequibo', 2, 5, 'Active'),
('Ram', 'Singh', 1, 'West Road', 'Xan', 'West Bank Demerara', 3, 6, 'Active'),
('Christan', 'Grey', 94, '', 'Brothers Village', 'West Bank Demerara', 3, 7, 'Active'),
('Kellyann', 'Manchester', 465, 'Win Road', 'Anna Regina', 'Essequibo', 2, 8, 'Active'),
('Juke', 'Singh', 45, 'Diamond Street', 'Queenstown', 'Georgetown', 4, 9, 'Active'),
('Michael', 'Woods', 10, 'Jewl Road', 'Bagwatt', 'East Bank Demerara', 4, 10, 'Active'),
('Joshua', 'Patrick', 1479, '', 'Ick', 'Southtown', 4, 11, 'Active'),
('Mark', 'Quin', 614, 'Middle Street', 'Victory', 'East Coast Demerara', 4, 12, 'Active'),
('Luke', 'Morris', 4120, 'Front Road', 'Apple Hill', 'West Coast Demerara', 3, 13, 'Active'),
('John', 'Fay', 704, 'Back Road', 'New Town', 'Georgetown', 4, 14, 'Active'),
('Adam', 'Hamshire', 1111, 'Singh Street', 'Anna Regina', 'Essequibo', 2, 15, 'Active'),
('Eve', 'Williams', 52, '', 'Diamond', 'Georgetown', 4, 16, 'Active'),
('Marilyn', 'Monroe', 81, '', 'Good Intent', 'West Bank Demerara', 3, 17, 'Active'),
('Keisha', 'Lord', 40, 'South Road', '', 'Georgetown', 4, 18, 'Active'),
('Nicholas', 'August', 74, 'Alexander Road', '', 'West Bank Demerara', 3, 19, 'Active'),
('Cassie', 'Ramsingh', 33, 'Bourda Road', 'Miles', 'Essequibo', 2, 20, 'Active'),
('Frank', 'Origin', NULL , 'Light Street', 'Xan', 'Georgetown', 4, 21, 'Active'),
('George', 'Cummings', 2088, 'Camp Street', 'Kitty', 'Georgetown', 4, 22, 'Active'),
('Kenny', 'Pine', 200, 'Cummings Street', 'Xan', 'East Bank Demerara', 4, 23, 'Active'),
('Vanessa', 'King', 450, 'Wellington Street', 'Bagwatt', 'East Bank Demerara', 4, 24, 'Active'),
('Ashley', 'Benjamin', 592, 'Fifth Street', 'Lodge', 'Georgetown', 4, 25, 'Active'),
('Rod', 'Wave', 38, 'First Street', 'Wales', 'West Bank Demerara', 3, 26, 'Active'),
('Luke', 'Persaud', NULL, 'Middle Street', 'Patienta', 'West Bank Demerara', 3, 27, 'Active'),
('Henry', 'August', NULL, 'Well Road', 'Bikini Bottom', 'Undersea', 6, 28, 'Active'),
('Matthew', 'Blue', 12, 'Purple Street', 'Forks', 'East Coast Demerara', 4, 19, 'Active'),
('Nara', 'Smith', 1330, 'Dune Lane', 'Beacon Hills', 'South Coast Demerara', 9, 30, 'Active'),
('Lucky', 'Smith', 110, 'King Street', 'Mystic Falls', 'North', 1, 31, 'Active'),
('Slim', 'Easy', 116, 'King Street', 'Mystic Falls', 'North', 1, 32, 'Active');


-- Owners
INSERT INTO Owner (first_name, last_name, phone, email) VALUES
('Mark', 'Vander', '5926001111', 'mark.vander@gmail.com'),
('Lisa', 'Martins', '5926002222', 'lisa.martins@yahoo.com'),
('Linden', 'Forbes', '5926003333', 'linden.forbes@gmail.com'),
('Anthony', 'May', '5926658412', 'anthonymay@hotmail.com'),
('Andre', 'Playton', '5926879851', 'andre.playton@gmail.com'),
('Phillip', 'Jersey', '5926011580', 'phillipjjersey@gmail.com'),
('Evan', 'Smith', '5926142019', 'evan.smith@gmail.com'),
('Charles', 'Handover', '5922225782', 'charles.handover63@gmail.com'),
('Karl', 'Nick', '5927048127', 'nickkarl@gmail.com'),
('Shanty', 'Samuels', '5927194120', 'shantysamuels@yahoo.com'),
('Dawn', 'Mohan', '5926544433', 'dawnmohan@outlook.com'),
('Lawrence', 'Upperman', '5926904120', 'renceman32@outlook.com'),
('Andrew', 'Niles', '5926110404', 'andrew.niles@outlook.com'),
('Stefon', 'Barrack', '5922258743', 'stefon.barrack@yahoo.com'),
('Lily', 'Forth', '5926289091', 'lily.forth@gmail.com'),
('Linda', 'Noman', '5922275433', 'lovelylinda@yahoo.com'),
('Michelle', 'Meter', '5922223333', 'michelle.meter@gmail.com'),
('Zander', 'Singh', '5922221012', 'zander123@gmail.com'),
('Ian', 'Mohamed', '59222296175', 'ianmohamed@hotmail.com'),
('Ali', 'Jackson', '5925512942', 'ali.jackson@gmail.com'),
('Dre', 'Patterson', '5922225782', 'dretheone2@gmail.com'),
('June', 'Karter', '5925069466', 'junekarter@gmail.com'),
('Amy', 'Srom', '5927046565', 'amy.srom592@gmail.com'),
('Selena', 'Gomez', '5927444350', 'selena.gomez@gmail.com'),
('Hendrick', 'Lane', '5927101186', 'hendrick.lane@gmail.com'),
('Karen', 'Caldon', '5926984120', 'karen.caldon@gmail.com'),
('Kurt', 'Jupiter', '5926013650', 'kurt.jupiter@gmail.com'),
('Natasha', 'Graham', '5926058463', 'natasha.graham@gmail.com'),
('Alex', 'Karter', '5927985625', 'alex.karter@gmail.com'),
('Daniel', 'Mohamed', '5926224443', 'daniel.mohamed19@gmail.com'),
('Jacob', 'Smith', '5926223032', 'jacob.smith@gmail.com'),
('Bob', 'Miller', '5926403038', 'bobmiller09@gmail.com'),
('Nervana', 'Ceaser', '5926614587', 'nervana.ceaser@gmail.com'),
('Willard', 'Mohammed', '5926795213', 'willard.mohammed@gmail.com'),
('Pam', 'Onick', '5926132027', 'pam.onick@gmail.com'),
('Patsy', 'Michaelson', '5922239546', 'patsy.k.michaelson@gmail.com');


-- Buildings
INSERT INTO Building (lot_number, street_name, village, city, region_number, building_type, owner_id) VALUES
(10, 'First Avenue', 'Charity', 'Pomeroon', 2, 'Residential', 1),
(22, 'Water Street', 'Anna Regina', 'Essequibo', 2, 'Commercial', 2),
(8, 'Main Road', 'Tuschen', 'Parika', 3, 'Industrial', 3),
(12,'Camp Street','Cummingsburg','Georgetown',4,'Residential',1),
(45,'Regent Street','Bourda','Georgetown',4,'Commercial',2),
(7,'Hadfield Street','Werk-en-Rust','Georgetown',4,'Residential',3),
(101,'Vlissengen Rd','Kitty','Georgetown',4,'Commercial',4),
(22,'Sherriff Street','Prashad Nagar','Georgetown',4,'Residential',5),
(3,'Duncan Street','Bel Air','Georgetown',4,'Industrial',6),
(33,'Mackenzie Main','Mackenzie','Linden',10,'Commercial',8),
(18,'Wisroc Rd','Wisroc','Linden',10,'Residential',9),
(60,'Blueberry Hill Rd','Blueberry Hill','Linden',10,'Industrial',10),
(15,'Main Street','Central','New Amsterdam',6,'Commercial',11),
(4,'Strand','Courtland','New Amsterdam',6,'Residential',12),
(28,'Kent Street','Stanleytown','New Amsterdam',6,'Residential',13),
(5,'Rose Hall Main','Clifton','Rose Hall',6,'Residential',14),
(88,'Arch Road','Williamsburg','Rose Hall',6,'Commercial',15),
(17,'Second Street','Hampshire','Rose Hall',6,'Residential',16),
(2,'Number 79 Village Rd','No.79 Village','Corriverton',6,'Commercial',17),
(39,' Number 78 Public Rd','No.78','Corriverton',6,'Residential',18),
(6,'Springlands Main','Springlands','Corriverton',6,'Residential',19),
(21,'Cotton Field Rd','Cotton Field','Anna Regina',2,'Residential',20),
(9,'Mainstay Rd','Mainstay/Whyaka','Anna Regina',2,'Commercial',21),
(70,'Essequibo Coast Rd','Suddie','Anna Regina',2,'Residential',22),
(11,'First Ave','Central','Bartica',7,'Commercial',23),
(52,'Third Street','Byderabo','Bartica',7,'Residential',24),
(8,'Potaro Rd','One Mile','Bartica',7,'Residential',25),
(100,'Mahdia Main','Central','Mahdia',8,'Commercial',26),
(7,'7 Mile Rd','Seven Mile','Mahdia',8,'Residential',27),
(3,'Airstrip Rd','Campbelltown','Mahdia',8,'Residential',28),
(14,'Barrack Retreat','Tabatinga','Lethem',9,'Residential',29),
(1,'Commercial Zone','Central','Lethem',9,'Commercial',30);

-- Applications
INSERT INTO Application (date_submitted, type, status, contractor_id, building_id) VALUES
('2025-09-01','New Wiring','Pending',1,1),
('2025-09-02','Upgrade','Inspected',2,2),
('2025-09-03','Repair','Approved',3,3),
('2025-09-04','New Wiring','Pending',4,4),
('2025-09-05','Upgrade','Inspected',5,5),
('2025-09-06','Repair','Approved',6,6),
('2025-09-07','New Wiring','Pending',7,7),
('2025-09-08','Upgrade','Inspected',8,8),
('2025-09-09','Repair','Approved',9,9),
('2025-09-10','New Wiring','Pending',10,10),
('2025-09-11','Upgrade','Inspected',11,11),
('2025-09-12','Repair','Approved',12,12),
('2025-09-13','New Wiring','Pending',13,13),
('2025-09-14','Upgrade','Inspected',14,14),
('2025-09-15','Repair','Approved',15,15),
('2025-09-16','New Wiring','Pending',16,16),
('2025-09-17','Upgrade','Inspected',17,17),
('2025-09-18','Repair','Approved',18,18),
('2025-09-19','New Wiring','Pending',19,19),
('2025-09-20','Upgrade','Inspected',20,20),
('2025-09-21','Repair','Approved',21,21),
('2025-09-22','New Wiring','Pending',22,22),
('2025-09-23','Upgrade','Inspected',23,23),
('2025-09-24','Repair','Approved',24,24),
('2025-09-25','New Wiring','Pending',25,25),
('2025-09-26','Upgrade','Inspected',26,26),
('2025-09-27','Repair','Approved',27,27),
('2025-09-28','New Wiring','Pending',28,28),
('2025-09-29','Upgrade','Inspected',29,29),
('2025-09-30','Repair','Approved',30,30);

-- Inspections
INSERT INTO Inspection (inspection_date, outcome, remarks, application_number) VALUES
('2025-10-01','Pass','Meets code',1),
('2025-10-02','Fail','Ground fault at panel',2),
('2025-10-03','Pass','Minor corrections done',3),
('2025-10-04','Pending','Revisit scheduled',4),
('2025-10-05','Pass','Proper labeling',5),
('2025-10-06','Pass','Tests within tolerance',6),
('2025-10-07','Fail','Improper bonding',7),
('2025-10-08','Pass','Insulation resistance good',8),
('2025-10-09','Pass','Earthing verified',9),
('2025-10-10','Pending','Awaiting materials',10),
('2025-10-11','Pass','Service entrance compliant',11),
('2025-10-12','Pass','No hazards observed',12),
('2025-10-13','Fail','Overloaded circuit found',13),
('2025-10-14','Pass','As-built matches plan',14),
('2025-10-15','Pass','Panel schedule updated',15),
('2025-10-16','Pass','Detectors functional',16),
('2025-10-17','Pending','Access issues',17),
('2025-10-18','Pass','Fixtures grounded',18),
('2025-10-19','Pass','GFCI locations correct',19),
('2025-10-20','Fail','Loose neutral in subpanel',20),
('2025-10-21','Pass','Clearances OK',21),
('2025-10-22','Pass','RCD tests passed',22),
('2025-10-23','Pass','Conduit support adequate',23),
('2025-10-24','Pending','Weather delay',24),
('2025-10-25','Pass','Final check complete',25),
('2025-10-26','Pass','Deviations resolved',26),
('2025-10-27','Pass','Site tidy',27),
('2025-10-28','Pass','All documents filed',28),
('2025-10-29','Pass','Sign-off granted',29),
('2025-10-30','Pass','Handover complete',30);

-- Inspectors
INSERT INTO Inspector (first_name, last_name, assigned_region_number) VALUES
('Kevin','Davis',2),
('Maria','Ali',3),
('Sean','Thomas',1),
('Alicia','Persaud',4),
('Robert','Jordan',6),
('Priya','Ramotar',10),
('Jason','Peters',7),
('Hannah','James',8),
('Omar','Khan',9),
('Sasha','Singh',1),
('David','Adams',2),
('Kurt','Joseph',4),
('Bianca','Henry',6),
('Terrence','Williams',7),
('Nadia','Ali',8),
('Gavin','Moore',9),
('Renee','Thomas',10),
('Joel','Fraser',4),
('Anika','Roberts',6),
('Rishi','Chand',1),
('Kim','Douglas',2),
('Andre','Murray',7),
('Farah','Hassan',8),
('Kevin','Persaud',9),
('Emily','Gonsalves',10),
('Mohammed','Yusuf',6),
('Tanya','Bacchus',4),
('Shawn','Pollard',1),
('Leah','Hinds',2),
('Marcus','Rodrigues',7);

-- Inspection Assignments
INSERT INTO Inspection_Assignment VALUES
(1, 1, 'Lead Inspector'),
(2, 2, 'Lead Inspector'),
(2, 3, 'Assistant Inspector'),
(3, 3, 'Lead Inspector'),
(3, 4, 'Assistant Inspector'),
(3, 5, 'Observer'),
(4, 4, 'Lead Inspector'),
(5, 5, 'Lead Inspector'),
(5, 6, 'Assistant Inspector'),
(6, 6, 'Lead Inspector'),
(6, 7, 'Assistant Inspector'),
(6, 8, 'Observer'),
(7, 7, 'Lead Inspector'),
(8, 8, 'Lead Inspector'),
(8, 9, 'Assistant Inspector'),
(9, 9, 'Lead Inspector'),
(9, 10, 'Assistant Inspector'),
(9, 11, 'Observer'),
(10, 10, 'Lead Inspector'),
(11, 11, 'Lead Inspector'),
(11, 12, 'Assistant Inspector'),
(12, 12, 'Lead Inspector'),
(12, 13, 'Assistant Inspector'),
(12, 14, 'Observer'),
(13, 13, 'Lead Inspector'),
(14, 14, 'Lead Inspector'),
(14, 15, 'Assistant Inspector'),
(15, 15, 'Lead Inspector'),
(15, 16, 'Assistant Inspector'),
(15, 17, 'Observer'),
(16, 16, 'Lead Inspector'),
(17, 17, 'Lead Inspector'),
(17, 18, 'Assistant Inspector'),
(18, 18, 'Lead Inspector'),
(18, 19, 'Assistant Inspector'),
(18, 20, 'Observer'),
(19, 19, 'Lead Inspector'),
(20, 20, 'Lead Inspector'),
(20, 21, 'Assistant Inspector'),
(21, 21, 'Lead Inspector'),
(21, 22, 'Assistant Inspector'),
(21, 23, 'Observer'),
(22, 22, 'Lead Inspector'),
(23, 23, 'Lead Inspector'),
(23, 24, 'Assistant Inspector'),
(24, 24, 'Lead Inspector'),
(24, 25, 'Assistant Inspector'),
(24, 26, 'Observer'),
(25, 25, 'Lead Inspector'),
(26, 26, 'Lead Inspector'),
(26, 27, 'Assistant Inspector'),
(27, 27, 'Lead Inspector'),
(27, 28, 'Assistant Inspector'),
(27, 29, 'Observer'),
(28, 28, 'Lead Inspector'),
(29, 29, 'Lead Inspector'),
(29, 30, 'Assistant Inspector'),
(30, 30, 'Lead Inspector'),
(30, 1, 'Assistant Inspector'),
(30, 2, 'Observer');

-- Certificates
INSERT INTO Certificate (issue_date, status, application_number) VALUES
('2025-10-02','Valid',1),
('2025-10-04','Valid',3),
('2025-10-06','Valid',5),
('2025-10-07','Valid',6),
('2025-10-09','Valid',8),
('2025-10-10','Valid',9),
('2025-10-12','Valid',11),
('2025-10-13','Valid',12),
('2025-10-15','Valid',14),
('2025-10-16','Valid',15),
('2025-10-17','Valid',16),
('2025-10-19','Valid',18),
('2025-10-20','Valid',19),
('2025-10-22','Valid',21),
('2025-10-23','Valid',22),
('2025-10-24','Valid',23),
('2025-10-26','Valid',25),
('2025-10-27','Valid',26),
('2025-10-28','Valid',27),
('2025-10-29','Valid',28),
('2025-10-30','Valid',29),
('2025-10-31','Valid',30);

-- Incident_Report
INSERT INTO Incident_Report (incident_date, description, building_id, inspector_id) VALUES
('2025-08-21', 'Minor electrical fire due to overload', 1, 1),
('2025-09-25', 'Faulty wiring caused short circuit', 2, 2);

-- ======================================================
-- END OF FILE
-- ======================================================
