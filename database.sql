-- ======================================================
-- Database: GEI Certificate of Inspection System
-- Class: CSE2102 (Database Systems Design and Information Management)
-- Author: Tarico Henry, Serina Garret, Shemar Holder, Leandro Rodriguez
-- Prepared for: Miss Amrita Ramnauth and Mr Phillip Gajadhar
-- Date: 22nd October 2025
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
INSERT INTO Region (RegionID, RegionName) VALUES 
(1, 'Region 1 - Barima-Waini'),
(2, 'Region 2 - Pomeroon-Supenaam'),
(3, 'Region 3 - Essequibo Islands-West Demerara'),
(4, 'Region 4 - Demerara-Mahaica'),
(5, 'Region 5 - Mahaica-Berbice'),
(6, 'Region 6 - East Berbice-Corentyne'),
(7, 'Region 7 - Cuyuni-Mazaruni'),
(8, 'Region 8 - Potaro-Siparuni'),
(9, 'Region 9 - Upper Takutu-Upper Essequibo'),
(10, 'Region 10 - Upper Demerara-Berbice');

-- Licenses
INSERT INTO License (issue_date, expiry_date) VALUES
('2024-01-15', '2026-01-15'),
('2023-06-10', '2025-06-10'),
('2024-03-01', '2026-03-01');

-- Contractors
INSERT INTO Contractor (first_name, last_name, lot_number, street_name, village, city, region_number, license_id, status) VALUES
('John', 'Persaud', '12', 'King Street', 'Anna Regina', 'Essequibo', 2, 1, 'Active'),
('Ravi', 'Singh', '23', 'Water Street', 'Charity', 'Pomeroon', 2, 2, 'Active'),
('Deon', 'James', '45', 'Main Street', 'Tuschen', 'Parika', 3, 3, 'Suspended');

-- Owners
INSERT INTO Owner (first_name, last_name, phone, email) VALUES
('Mark', 'Adams', '5926001111', 'mark.adams@gmail.com'),
('Lisa', 'Duncan', '5926002222', 'lisa.duncan@yahoo.com'),
('Andre', 'Mohamed', '5926003333', 'andre.mohamed@gmail.com');

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
