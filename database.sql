-- ======================================================
-- Database: GEI Certificate of Inspection System
-- Class: CSE2102
-- Author: Tarico Henry, Serina Garrett, Shemar Holder, Leandro Rodriguez
-- Prepared for: Professor Amrita Ramnauth and Professor Phillip Gajadhar
-- Date: October 2025
-- ======================================================

CREATE DATABASE gei_certificate_db;
USE gei_certificate_db;

-- ======================================================
-- TABLE: License
-- ======================================================
CREATE TABLE License (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL
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
    lot_number VARCHAR(10),
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
    lot_number VARCHAR(10),
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
    expiry_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Valid', 'Expired', 'Revoked')),
    application_number INT,
    FOREIGN KEY (application_number) REFERENCES Application(application_number)
);

-- ======================================================
-- TABLE: Incident
-- ======================================================
CREATE TABLE Incident (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_date DATE NOT NULL,
    description TEXT,
    building_id INT,
    inspector_id INT,
    FOREIGN KEY (building_id) REFERENCES Building(building_id),
    FOREIGN KEY (inspector_id) REFERENCES Inspector(inspector_id)
);

-- =======================================================================================================================
-- SAMPLE DATA INSERTS (this is just a random gpt generated set for testing purposes). We can clean it up before we submit
-- =======================================================================================================================

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
INSERT INTO License (issue_date, expiry_date) VALUES
('2024-01-15', '2026-01-15'),
('2023-06-10', '2025-06-10'),
('2024-03-01', '2026-03-01'),
('2025-09-10', '2027-09-10'),
('2025-05-06', '2027-05-06'),
('2023-12-12', '2025-12-12'),
('2024-01-29', '2026-01-29'),
('2023-03-11', '2025-03-11'),
('2025-08-01', '2027-08-01'),
('2025-02-08', '2027-02-08'),
('2025-04-24', '2027-04-24'),
('2024-09-24', '2026-09-24'),
('2024-07-26', '2026-07-26'),
('2023-05-22', '2025-05-22'),
('2024-06-01', '2026-06-01'),
('2024-01-29', '2026-01-29'),
('2025-05-06', '2027-05-06'),
('2024-01-15', '2026-01-15'),
('2024-01-15', '2026-01-15'),
('2025-10-20', '2027-10-20'),
('2025-10-19', '2027-10-19'),
('2025-10-07', '2027-10-07'),
('2023-04-17', '2025-04-07'),
('2023-11-11', '2025-11-11'),
('2024-03-21', '2026-03-21'),
('2024-12-28', '2026-12-28'),
('2024-12-28', '2026-12-28'),
('2023-10-07', '2025-10-07'),
('2023-12-29', '2025-12-29'),
('2024-07-09', '2026-07-09'),
('2025-02-28', '2027-02-28'),
('2024-05-22', '2026-05-22');

-- Contractors
INSERT INTO Contractor (first_name, last_name, lot_number, street_name, village, city, region_number, license_id, status) VALUES
('John', 'Lion', '12', 'Stiff Street', 'York', 'East Coast Demerara', 4, 1, 'Active'),
('Ravi', 'Bee', '23', 'Water Street', 'New Town', 'Georgetown', 4, 2, 'Active'),
('Deon', 'Cummings', '45', 'Robb Street', 'Queenstown', 'Georgetown', 4, 3, 'Suspended'),
('Jane', 'Doe', '5680', 'Ham Street', 'Kingston', 'Georgetown', 4, 1, 'Active'),
('King', 'June', '99', 'East Street', 'Pine Ville', 'Essequibo', 2, 1, 'Active'),
('Ram', 'Singh', '1', 'West Road', 'Xan', 'West Bank Demerara', 3, 1, 'Active'),
('Christan', 'Grey', '94', '', 'Brothers Village', 'West Bank Demerara', 3, 1, 'Active'),
('Kellyann', 'Manchester', '465', 'Win Road', 'Anna Regina', 'Essequibo', 2, 1, 'Active'),
('Juke', 'Singh', '45', 'Diamond Street', 'Queenstown', 'Georgetown', 4, 1, 'Active'),
('Michael', 'Woods', '10', 'Jewl Road', 'Bagwatt', 'East Bank Demerara', 4, 1, 'Active'),
('Joshua', 'Patrick', '1479', '', 'Ick', 'Southtown', 4, 1, 'Active'),
('Mark', 'Quin', '614', 'Middle Street', 'Victory', 'East Coast Demerara', 4, 1, 'Active'),
('Luke', 'Morris', '4120', 'Front Road', 'Apple Hill', 'West Coast Demerara', 3, 1, 'Active'),
('John', 'Fay', '704', 'Back Road', 'New Town', 'Georgetown', 4, 1, 'Active'),
('Adam', 'Hamshire', '1111', 'Singh Street', 'Anna Regina', 'Essequibo', 2, 1, 'Active'),
('Eve', 'Williams', '52', '', 'Diamond', 'Georgetown', 4, 1, 'Active'),
('Marilyn', 'Monroe', '81', '', 'Good Intent', 'West Bank Demerara', 3, 1, 'Active'),
('Keisha', 'Lord', '40', 'South Road', '', 'Georgetown', 4, 1, 'Active'),
('Nicholas', 'August', '74', 'Alexander Road', '', 'West Bank Demerara', 3, 1, 'Active'),
('Cassie', 'Ramsingh', '33', 'Bourda Road', 'Miles', 'Essequibo', 2, 1, 'Active'),
('Frank', 'Origin', '', 'Light Street', 'Xan', 'Georgetown', 4, 1, 'Active'),
('George', 'Cummings', '2088', 'Camp Street', 'Kitty', 'Georgetown', 4, 1, 'Active'),
('Kenny', 'Pine', '200', 'Cummings Street', 'Xan', 'East Bank Demerara', 4, 1, 'Active'),
('Vanessa', 'King', '450', 'Wellington Street', 'Bagwatt', 'East Bank Demerara', 4, 1, 'Active'),
('Ashley', 'Benjamin', '592', 'Fifth Street', 'Lodge', 'Georgetown', 4, 1, 'Active'),
('Rod', 'Wave', '38', 'First Street', 'Wales', 'West Bank Demerara', 3, 1, 'Active'),
('Luke', 'Persaud', '', 'Middle Street', 'Patienta', 'West Bank Demerara', 3, 1, 'Active'),
('Henry', 'August', '', 'Well Road', 'Bikini Bottom', 'Undersea', 6, 1, 'Active'),
('Matthew', 'Blue', '12', 'Purple Street', 'Forks', 'East Coast Demerara', 4, 1, 'Active'),
('Nara', 'Smith', '1330', 'Dune Lane', 'Beacon Hills', 'South Coast Demerara', 9, 1, 'Active'),
('Lucky', 'Smith', '110', 'King Street', 'Mystic Falls', 'North', 1, 1, 'Active'),
('Slim', 'Easy', '116', 'King Street', 'Mystic Falls', 'North', 1, 1, 'Active');


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
('10', 'First Avenue', 'Charity', 'Pomeroon', 2, 'Residential', 1),
('22', 'Water Street', 'Anna Regina', 'Essequibo', 2, 'Commercial', 2),
('8', 'Main Road', 'Tuschen', 'Parika', 3, 'Industrial', 3);

-- Applications
INSERT INTO Application (date_submitted, type, status, contractor_id, building_id) VALUES
('2025-09-01', 'New Wiring', 'Pending', 1, 1),
('2025-09-05', 'Upgrade', 'Inspected', 2, 2),
('2025-09-10', 'Repair', 'Approved', 3, 3);

-- Inspections
INSERT INTO Inspection (inspection_date, outcome, remarks, application_number) VALUES
('2025-09-08', 'Pass', 'All wiring compliant', 1),
('2025-09-12', 'Fail', 'Incomplete grounding', 2),
('2025-09-14', 'Pass', 'Safety check complete', 3);

-- Inspectors
INSERT INTO Inspector (first_name, last_name, assigned_region_number) VALUES
('Kevin', 'Davis', 2),
('Maria', 'Ali', 3),
('Sean', 'Thomas', 1);

-- Inspection Assignments
INSERT INTO Inspection_Assignment VALUES
(1, 1, 'Lead Inspector'),
(2, 2, 'Assistant Inspector'),
(3, 3, 'Lead Inspector');

-- Certificates
INSERT INTO Certificate (issue_date, expiry_date, status, application_number) VALUES
('2025-09-15', '2026-09-15', 'Valid', 3),
('2025-09-09', '2026-09-09', 'Valid', 1);

-- Incidents
INSERT INTO Incident (incident_date, description, building_id, inspector_id) VALUES
('2025-08-21', 'Minor electrical fire due to overload', 1, 1),
('2025-09-25', 'Faulty wiring caused short circuit', 2, 2),
('2025-10-03', 'Inspection revealed safety hazard', 3, 3);

-- ======================================================
-- END OF FILE
-- ======================================================
