-- Sample Data for AskDarcel Database
-- This script inserts representative fake data into all tables with proper relationships

-- Clear existing data (if needed)
-- Disable foreign key constraints temporarily for easier data deletion
SET session_replication_role = 'replica';

TRUNCATE TABLE sites CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE keywords CASCADE;
TRUNCATE TABLE groups CASCADE;
TRUNCATE TABLE permissions CASCADE;
TRUNCATE TABLE admins CASCADE;
TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE eligibilities CASCADE;
TRUNCATE TABLE languages CASCADE;
TRUNCATE TABLE fundings CASCADE;
TRUNCATE TABLE resources CASCADE;
TRUNCATE TABLE contacts CASCADE;
TRUNCATE TABLE addresses CASCADE;
TRUNCATE TABLE phones CASCADE;
TRUNCATE TABLE services CASCADE;
TRUNCATE TABLE programs CASCADE;
TRUNCATE TABLE schedules CASCADE;
TRUNCATE TABLE schedule_days CASCADE;
TRUNCATE TABLE notes CASCADE;
TRUNCATE TABLE documents CASCADE;
TRUNCATE TABLE accessibilities CASCADE;
TRUNCATE TABLE synonym_groups CASCADE;
TRUNCATE TABLE synonyms CASCADE;
TRUNCATE TABLE news_articles CASCADE;
TRUNCATE TABLE folders CASCADE;
TRUNCATE TABLE bookmarks CASCADE;
TRUNCATE TABLE saved_searches CASCADE;
TRUNCATE TABLE texting_recipients CASCADE;
TRUNCATE TABLE reviews CASCADE;
TRUNCATE TABLE feedbacks CASCADE;
TRUNCATE TABLE volunteers CASCADE;
TRUNCATE TABLE instructions CASCADE;

-- Re-enable constraints
SET session_replication_role = 'origin';

-- Sites
INSERT INTO sites (id, site_code) VALUES 
(1, 'sfsg'),
(2, 'oakla'),
(3, 'soclc');

-- Admins
INSERT INTO admins (id, provider, uid, encrypted_password, email, tokens, created_at, updated_at) VALUES
(1, 'email', 'admin1', '$2a$10$KGahXRDRXa.CI8YaEV3lYeOtZ5gGQ7XLb4Wz5gVOw8d50h7EIcjPm', 'admin1@example.com', '{}', NOW(), NOW()),
(2, 'email', 'admin2', '$2a$10$KGahXRDRXa.CI8YaEV3lYeOtZ5gGQ7XLb4Wz5gVOw8d50h7EIcjPm', 'admin2@example.com', '{}', NOW(), NOW());

-- Users
INSERT INTO users (id, name, organization, user_external_id, email) VALUES
(1, 'Jane Davis', 'Community Help Center', 'ext-jane-1', 'jane@example.com'),
(2, 'Robert Kim', 'Housing Advocates', 'ext-rob-2', 'robert@example.com'),
(3, 'Maria Lopez', 'Health Services Org', 'ext-maria-3', 'maria@example.com');

-- Groups
INSERT INTO groups (id, name, created_at, updated_at) VALUES
(1, 'Administrators', NOW(), NOW()),
(2, 'Service Providers', NOW(), NOW()),
(3, 'Editors', NOW(), NOW());

-- User Groups
INSERT INTO user_groups (user_id, group_id) VALUES
(1, 2),
(2, 2),
(2, 3),
(3, 3);

-- Permissions
INSERT INTO permissions (id, action, resource_id, service_id, created_at, updated_at) VALUES
(1, 0, 1, NULL, NOW(), NOW()),
(2, 1, 2, NULL, NOW(), NOW()),
(3, 2, 3, NULL, NOW(), NOW()),
(4, 0, NULL, 1, NOW(), NOW()),
(5, 1, NULL, 2, NOW(), NOW());

-- Group Permissions
INSERT INTO group_permissions (group_id, permission_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(3, 1),
(3, 4),
(2, 4),
(2, 5);

-- Categories
INSERT INTO categories (id, name, top_level, vocabulary, featured, created_at, updated_at) VALUES
(1, 'Housing', true, 'service_categories', true, NOW(), NOW()),
(2, 'Food', true, 'service_categories', true, NOW(), NOW()),
(3, 'Health', true, 'service_categories', true, NOW(), NOW()),
(4, 'Emergency Shelter', false, 'service_categories', false, NOW(), NOW()),
(5, 'Permanent Housing', false, 'service_categories', false, NOW(), NOW()),
(6, 'Food Pantry', false, 'service_categories', false, NOW(), NOW()),
(7, 'Mental Health', false, 'service_categories', true, NOW(), NOW()),
(8, 'Primary Care', false, 'service_categories', false, NOW(), NOW());

-- Category Relationships
INSERT INTO category_relationships (parent_id, child_id, child_priority_rank) VALUES
(1, 4, 1),
(1, 5, 2),
(2, 6, 1),
(3, 7, 1),
(3, 8, 2);

-- Categories Sites
INSERT INTO categories_sites (category_id, site_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(3, 3),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1);

-- Keywords
INSERT INTO keywords (id, name) VALUES
(1, 'homeless'),
(2, 'shelter'),
(3, 'food bank'),
(4, 'groceries'),
(5, 'counseling'),
(6, 'therapy'),
(7, 'doctor'),
(8, 'apartment'),
(9, 'housing assistance'),
(10, 'meals');

-- Categories Keywords
INSERT INTO categories_keywords (category_id, keyword_id) VALUES
(1, 1),
(1, 2),
(1, 8),
(1, 9),
(2, 3),
(2, 4),
(2, 10),
(3, 5),
(3, 6),
(3, 7),
(4, 1),
(4, 2),
(5, 8),
(5, 9),
(6, 3),
(6, 4),
(7, 5),
(7, 6),
(8, 7);

-- Eligibilities
INSERT INTO eligibilities (id, name, feature_rank, is_parent, parent_id, created_at, updated_at) VALUES
(1, 'Low-Income', 1, true, NULL, NOW(), NOW()),
(2, 'Homeless', 2, true, NULL, NOW(), NOW()),
(3, 'Seniors', 3, true, NULL, NOW(), NOW()),
(4, 'Veterans', 4, true, NULL, NOW(), NOW()),
(5, 'Youth', 5, true, NULL, NOW(), NOW()),
(6, 'Below Federal Poverty Line', 6, false, 1, NOW(), NOW()),
(7, 'At Risk of Homelessness', 7, false, 2, NOW(), NOW()),
(8, 'Age 65+', 8, false, 3, NOW(), NOW()),
(9, 'Combat Veterans', 9, false, 4, NOW(), NOW()),
(10, 'Age 18-24', 10, false, 5, NOW(), NOW());

-- Eligibility Relationships
INSERT INTO eligibility_relationships (parent_id, child_id) VALUES
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- Languages
INSERT INTO languages (id, language, created_at, updated_at) VALUES
(1, 'English', NOW(), NOW()),
(2, 'Spanish', NOW(), NOW()),
(3, 'Chinese (Mandarin)', NOW(), NOW()),
(4, 'Tagalog', NOW(), NOW()),
(5, 'Russian', NOW(), NOW());

-- Fundings
INSERT INTO fundings (id, source, created_at, updated_at) VALUES
(1, 'Government Grant', NOW(), NOW()),
(2, 'Private Donations', NOW(), NOW()),
(3, 'Foundation Support', NOW(), NOW()),
(4, 'Mixed Funding', NOW(), NOW());

-- Resources (Organizations)
INSERT INTO resources (id, name, short_description, long_description, website, verified_at, email, status, certified, alternate_name, legal_status, contact_id, funding_id, featured, source_attribution, internal_note, created_at, updated_at) VALUES
(1, 'Bay Area Housing Coalition', 'Affordable housing and emergency shelter services', 'The Bay Area Housing Coalition provides comprehensive housing services for low-income individuals and families, including emergency shelter, transitional housing, and permanent housing placement. We also offer housing counseling and eviction prevention services.', 'https://bahc-example.org', NOW(), 'info@bahc-example.org', 1, true, 'BAHC', 'Nonprofit 501(c)(3)', NULL, 1, true, 0, 'Verified by phone 2025-03-15', NOW(), NOW()),

(2, 'Community Food Bank', 'Food pantry and meal services', 'Community Food Bank distributes food to those in need through our weekly pantry service. We also provide hot meals three times a week and offer nutrition education programs.', 'https://communityfoodbank-example.org', NOW(), 'contact@communityfoodbank-example.org', 1, true, 'CFB', 'Nonprofit 501(c)(3)', NULL, 2, true, 0, 'Updated hours 2025-04-01', NOW(), NOW()),

(3, 'Wellness Clinic', 'Primary care and mental health services', 'Wellness Clinic offers affordable healthcare services including primary care, mental health counseling, and health education. We serve uninsured and underinsured populations.', 'https://wellnessclinic-example.org', NOW(), 'info@wellnessclinic-example.org', 1, true, 'City Wellness Clinic', 'Nonprofit 501(c)(3)', NULL, 3, false, 0, '', NOW(), NOW()),

(4, 'Veterans Support Services', 'Comprehensive services for veterans', 'Veterans Support Services provides housing assistance, employment services, healthcare navigation, and peer support for veterans and their families.', 'https://vss-example.org', NOW(), 'vss@example.org', 1, true, 'VSS', 'Nonprofit 501(c)(3)', NULL, 1, false, 0, '', NOW(), NOW()),

(5, 'Youth Empowerment Center', 'Services for at-risk youth', 'Youth Empowerment Center offers educational support, job training, counseling, and recreational activities for youth ages 12-24.', 'https://yec-example.org', NOW(), 'info@yec-example.org', 1, true, 'YEC', 'Nonprofit 501(c)(3)', NULL, 3, false, 0, '', NOW(), NOW());

-- Connect resources to sites
INSERT INTO resources_sites (resource_id, site_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1),
(3, 3),
(4, 1),
(4, 2),
(4, 3),
(5, 1);

-- Connect resources to categories
INSERT INTO categories_resources (category_id, resource_id) VALUES
(1, 1),
(4, 1),
(5, 1),
(2, 2),
(6, 2),
(3, 3),
(7, 3),
(8, 3),
(1, 4),
(3, 4),
(3, 5),
(7, 5);

-- Connect resources to keywords
INSERT INTO keywords_resources (resource_id, keyword_id) VALUES
(1, 1),
(1, 2),
(1, 8),
(1, 9),
(2, 3),
(2, 4),
(2, 10),
(3, 5),
(3, 6),
(3, 7),
(4, 2),
(4, 9),
(5, 5),
(5, 6);

-- Contacts
INSERT INTO contacts (id, name, title, email, resource_id, service_id, created_at, updated_at) VALUES
(1, 'Sarah Johnson', 'Executive Director', 'sarah@bahc-example.org', 1, NULL, NOW(), NOW()),
(2, 'Michael Wong', 'Intake Coordinator', 'mwong@bahc-example.org', 1, NULL, NOW(), NOW()),
(3, 'David Lee', 'Food Bank Manager', 'david@communityfoodbank-example.org', 2, NULL, NOW(), NOW()),
(4, 'Dr. Rebecca Patel', 'Medical Director', 'rpatel@wellnessclinic-example.org', 3, NULL, NOW(), NOW()),
(5, 'James Wilson', 'Program Director', 'jwilson@vss-example.org', 4, NULL, NOW(), NOW()),
(6, 'Lisa Chen', 'Youth Services Coordinator', 'lchen@yec-example.org', 5, NULL, NOW(), NOW());

-- Update resource contact_id
UPDATE resources SET contact_id = 1 WHERE id = 1;
UPDATE resources SET contact_id = 3 WHERE id = 2;
UPDATE resources SET contact_id = 4 WHERE id = 3;
UPDATE resources SET contact_id = 5 WHERE id = 4;
UPDATE resources SET contact_id = 6 WHERE id = 5;

-- Addresses
INSERT INTO addresses (id, attention, address_1, address_2, city, state_province, postal_code, resource_id, latitude, longitude, online, region, name, description, transportation, created_at, updated_at) VALUES
(1, 'Main Office', '123 Howard Street', 'Suite 400', 'San Francisco', 'CA', '94105', 1, 37.7897, -122.3972, false, 'Downtown', 'Downtown Office', 'Main administrative office and housing services center', 'Two blocks from Powell BART station. MUNI lines 5, 7, and 21 stop nearby.', NOW(), NOW()),

(2, 'Shelter Location', '456 Ellis Street', NULL, 'San Francisco', 'CA', '94102', 1, 37.7837, -122.4167, false, 'Tenderloin', 'Emergency Shelter', 'Our emergency overnight shelter accommodates up to 60 individuals', 'MUNI lines 19, 27, and 31 stop within 1 block.', NOW(), NOW()),

(3, NULL, '789 Mission Street', 'Lower Level', 'San Francisco', 'CA', '94103', 2, 37.7841, -122.4052, false, 'SOMA', 'Food Distribution Center', 'Food pantry and meal service location', 'Montgomery BART station is 2 blocks away. MUNI lines 14 and 49 stop nearby.', NOW(), NOW()),

(4, 'Medical Center', '234 Valencia Street', NULL, 'San Francisco', 'CA', '94103', 3, 37.7694, -122.4221, false, 'Mission', 'Main Clinic', 'Full-service health clinic', '16th Street BART station is 3 blocks away. MUNI lines 14, 22, and 33 stop nearby.', NOW(), NOW()),

(5, NULL, '567 McAllister Street', 'Suite 200', 'San Francisco', 'CA', '94102', 4, 37.7795, -122.4212, false, 'Civic Center', 'Veterans Center', 'Service center for veterans', 'Civic Center BART station is 2 blocks away. Multiple MUNI lines available.', NOW(), NOW()),

(6, 'Youth Center', '890 Bryant Street', NULL, 'San Francisco', 'CA', '94103', 5, 37.7751, -122.4050, false, 'SOMA', 'Youth Services', 'Drop-in center for youth services', 'Near the Hall of Justice. MUNI lines 8, 19, and 47 stop nearby.', NOW(), NOW());

-- Phones
INSERT INTO phones (id, number, service_type, resource_id, description, service_id, contact_id, language_id, created_at, updated_at) VALUES
(1, '(415) 555-1000', 'Main Office', 1, 'Main administrative line', NULL, NULL, 1, NOW(), NOW()),
(2, '(415) 555-1001', 'Shelter Intake', 1, 'For emergency shelter intake and referrals', NULL, NULL, 1, NOW(), NOW()),
(3, '(415) 555-1002', 'Spanish Hotline', 1, 'Spanish language assistance', NULL, NULL, 2, NOW(), NOW()),
(4, '(415) 555-2000', 'Food Bank', 2, 'Food pantry information', NULL, NULL, 1, NOW(), NOW()),
(5, '(415) 555-2001', 'Meal Program', 2, 'Hot meal program information', NULL, NULL, 1, NOW(), NOW()),
(6, '(415) 555-3000', 'Medical Reception', 3, 'Main clinic line', NULL, NULL, 1, NOW(), NOW()),
(7, '(415) 555-3001', 'Mental Health', 3, 'Mental health services', NULL, NULL, 1, NOW(), NOW()),
(8, '(415) 555-3002', 'Chinese Services', 3, 'Mandarin and Cantonese language assistance', NULL, NULL, 3, NOW(), NOW()),
(9, '(415) 555-4000', 'Veterans Hotline', 4, '24-hour assistance line for veterans', NULL, NULL, 1, NOW(), NOW()),
(10, '(415) 555-5000', 'Youth Hotline', 5, '24-hour crisis line for youth', NULL, NULL, 1, NOW(), NOW()),
(11, '(415) 555-5001', 'Spanish Youth Line', 5, 'Spanish language youth services', NULL, NULL, 2, NOW(), NOW());

-- Connect contact phones
INSERT INTO phones (id, number, service_type, resource_id, description, service_id, contact_id, language_id, created_at, updated_at) VALUES
(12, '(415) 555-1100', 'Direct Line', 1, 'Executive Director direct line', NULL, 1, 1, NOW(), NOW()),
(13, '(415) 555-1101', 'Intake Direct', 1, 'Intake Coordinator direct line', NULL, 2, 1, NOW(), NOW()),
(14, '(415) 555-2100', 'Manager Line', 2, 'Food Bank Manager direct line', NULL, 3, 1, NOW(), NOW()),
(15, '(415) 555-3100', 'Medical Director', 3, 'Medical Director direct line', NULL, 4, 1, NOW(), NOW()),
(16, '(415) 555-4100', 'Program Director', 4, 'Program Director direct line', NULL, 5, 1, NOW(), NOW()),
(17, '(415) 555-5100', 'Youth Coordinator', 5, 'Youth Services Coordinator direct line', NULL, 6, 1, NOW(), NOW());

-- Programs
INSERT INTO programs (id, name, alternate_name, description, resource_id, created_at, updated_at) VALUES
(1, 'Emergency Shelter Program', 'Night Shelter', 'Overnight emergency shelter services with case management', 1, NOW(), NOW()),
(2, 'Permanent Housing Program', 'Housing First', 'Permanent supportive housing with ongoing case management', 1, NOW(), NOW()),
(3, 'Food Pantry Program', 'Weekly Food Distribution', 'Weekly grocery distribution for individuals and families', 2, NOW(), NOW()),
(4, 'Hot Meals Program', 'Community Kitchen', 'Hot meal service three times per week', 2, NOW(), NOW()),
(5, 'Primary Care Program', 'Medical Clinic', 'Comprehensive primary care services', 3, NOW(), NOW()),
(6, 'Mental Health Program', 'Counseling Services', 'Individual and group mental health services', 3, NOW(), NOW()),
(7, 'Veterans Housing Program', 'Vets Home', 'Housing assistance specific to veterans', 4, NOW(), NOW()),
(8, 'Youth Mentoring Program', 'Youth Mentors', 'One-on-one mentoring for at-risk youth', 5, NOW(), NOW());

-- Services
INSERT INTO services (id, name, short_description, long_description, eligibility, required_documents, fee, application_process, resource_id, verified_at, email, status, certified, program_id, interpretation_services, url, wait_time, contact_id, funding_id, alternate_name, featured, source_attribution, internal_note, boosted_category_id, created_at, updated_at) VALUES
(1, 'Emergency Shelter Beds', 'Overnight shelter beds', 'We provide emergency overnight shelter with clean beds, showers, and meals. Case management services are available to help connect clients with additional resources.', 'Adults 18+ experiencing homelessness', 'Photo ID if available, not required', 'Free', 'Walk-in starting at 4pm daily for same-night stay. Arrive early as beds are first-come, first-served. Can also call shelter hotline for availability.', 1, NOW(), 'shelter@bahc-example.org', 1, true, 1, 'Spanish, Tagalog, and Chinese interpreters available', 'https://bahc-example.org/shelter', '0-1 days depending on bed availability', 2, 1, 'Night Shelter', true, 0, 'Always call to confirm availability before sending clients', 4, NOW(), NOW()),

(2, 'Permanent Supportive Housing', 'Long-term affordable housing with support', 'Our permanent supportive housing program provides affordable apartments with ongoing case management and support services to help formerly homeless individuals maintain stable housing.', 'Chronically homeless individuals with disabilities', 'Photo ID, proof of income, documentation of homelessness, disability verification', 'Rent is 30% of income', 'Apply through Coordinated Entry System. Assessment and prioritization required. Application process takes 2-3 weeks once selected from waitlist.', 1, NOW(), 'housing@bahc-example.org', 1, true, 2, 'Spanish and Chinese interpretation available', 'https://bahc-example.org/housing', '3-6 months waitlist', 2, 1, 'Housing First Program', false, 0, 'Waitlist currently closed as of March 2025', 5, NOW(), NOW()),

(3, 'Weekly Food Pantry', 'Free groceries distribution', 'Our weekly food pantry provides fresh produce, canned goods, and other groceries to individuals and families facing food insecurity. Distributions occur every Tuesday and Thursday.', 'San Francisco residents, priority for low-income households', 'Photo ID, proof of address, self-declaration of income', 'Free', 'Registration opens at 9am, distribution from 10am-1pm. First-time clients should arrive by 9am to complete intake.', 2, NOW(), 'pantry@communityfoodbank-example.org', 1, true, 3, 'Spanish and Chinese (Cantonese) interpretation available', 'https://communityfoodbank-example.org/pantry', 'Same-day service', 3, 2, 'Food Distribution', true, 0, '', 6, NOW(), NOW()),

(4, 'Community Meals', 'Hot meal service', 'We serve hot, nutritious meals three times per week in our community dining room. Menu varies and accommodates common dietary restrictions.', 'Open to all', 'None required', 'Free', 'Walk-in during meal hours: Monday, Wednesday, Friday 5pm-7pm.', 2, NOW(), 'meals@communityfoodbank-example.org', 1, true, 4, 'Spanish interpretation available', 'https://communityfoodbank-example.org/meals', 'Same-day service', 3, 2, 'Hot Meal Program', false, 0, '', 6, NOW(), NOW()),

(5, 'Primary Healthcare', 'Basic medical care', 'Our clinic provides comprehensive primary care services including preventive care, chronic disease management, and acute care for common illnesses and injuries.', 'Uninsured and underinsured individuals', 'Photo ID, proof of insurance if applicable, income verification for sliding scale', 'Sliding scale based on income, Medi-Cal accepted', 'Call to schedule an appointment. New patients need to complete intake forms.', 3, NOW(), 'clinic@wellnessclinic-example.org', 1, true, 5, 'Spanish, Chinese (Mandarin and Cantonese), and Russian interpretation available', 'https://wellnessclinic-example.org/primary-care', '1-2 weeks for non-urgent appointments', 4, 3, 'Medical Clinic', true, 0, '', 8, NOW(), NOW()),

(6, 'Mental Health Counseling', 'Individual and group therapy', 'We offer individual and group counseling services for a range of mental health concerns including depression, anxiety, trauma, and substance use disorders.', 'Adults 18+, some specialized services for youth 14-17', 'Photo ID, insurance information if applicable', 'Sliding scale based on income, some insurance accepted', 'Call our mental health line to schedule an initial assessment.', 3, NOW(), 'mentalhealth@wellnessclinic-example.org', 1, true, 6, 'Spanish interpretation available', 'https://wellnessclinic-example.org/mental-health', '2-3 weeks for initial assessment', 4, 3, 'Counseling Program', true, 0, '', 7, NOW(), NOW()),

(7, 'Veterans Housing Assistance', 'Housing support for veterans', 'We provide housing assistance specifically for veterans, including help with finding affordable housing, security deposit assistance, and supportive services to maintain housing stability.', 'Veterans with discharge status other than dishonorable', 'DD-214 or other proof of military service, photo ID, proof of income', 'Free', 'Call to schedule an initial assessment with our veterans housing specialist.', 4, NOW(), 'housing@vss-example.org', 1, true, 7, 'Spanish interpretation available', 'https://vss-example.org/housing', '1-2 weeks for initial appointment', 5, 1, 'Vets Housing Program', true, 0, '', 5, NOW(), NOW()),

(8, 'Youth Counseling', 'Mental health services for youth', 'We provide individual and group counseling specifically designed for young people dealing with depression, anxiety, trauma, family issues, and other concerns.', 'Youth ages 12-24', 'Parental consent required for minors under 18 except in specific circumstances', 'Free', 'Walk-in hours Monday-Friday 3pm-7pm or call to schedule an appointment.', 5, NOW(), 'youthservices@yec-example.org', 1, true, 8, 'Spanish and Chinese interpretation available', 'https://yec-example.org/counseling', 'Walk-in same day or 1 week for scheduled appointments', 6, 3, 'Youth Mental Health', true, 0, '', 7, NOW(), NOW());

-- Connect services to addresses
INSERT INTO addresses_services (service_id, address_id) VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 3),
(5, 4),
(6, 4),
(7, 5),
(8, 6);

-- Connect services to categories
INSERT INTO categories_services (service_id, category_id, feature_rank) VALUES
(1, 1, 1),
(1, 4, 1),
(2, 1, 2),
(2, 5, 1),
(3, 2, 1),
(3, 6, 1),
(4, 2, 2),
(5, 3, 1),
(5, 8, 1),
(6, 3, 2),
(6, 7, 1),
(7, 1, 3),
(7, 5, 2),
(8, 3, 3),
(8, 7, 2);

-- Connect services to eligibilities
INSERT INTO eligibilities_services (service_id, eligibility_id) VALUES
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(5, 1),
(6, 1),
(7, 4),
(7, 9),
(8, 5),
(8, 10);

-- Connect services to keywords
INSERT INTO keywords_services (service_id, keyword_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 8),
(2, 9),
(3, 3),
(3, 4),
(4, 10),
(5, 7),
(6, 5),
(6, 6),
(7, 8),
(7, 9),
(8, 5),
(8, 6);

-- Schedules
INSERT INTO schedules (id, resource_id, service_id, hours_known, created_at, updated_at) VALUES
(1, 1, NULL, true, NOW(), NOW()),
(2, NULL, 1, true, NOW(), NOW()),
(3, NULL, 2, true, NOW(), NOW()),
(4, 2, NULL, true, NOW(), NOW()),
(5, NULL, 3, true, NOW(), NOW()),
(6, NULL, 4, true, NOW(), NOW()),
(7, 3, NULL, true, NOW(), NOW()),
(8, NULL, 5, true, NOW(), NOW()),
(9, NULL, 6, true, NOW(), NOW()),
(10, 4, NULL, true, NOW(), NOW()),
(11, NULL, 7, true, NOW(), NOW()),
(12, 5, NULL, true, NOW(), NOW()),
(13, NULL, 8, true, NOW(), NOW());

-- Schedule Days
INSERT INTO schedule_days (id, day, open_time, close_time, open_day, close_day, schedule_id, created_at, updated_at) VALUES
-- Resource 1 (Bay Area Housing Coalition) main hours
(1, 'Monday', '09:00:00', '17:00:00', 'Monday', 'Monday', 1, NOW(), NOW()),
(2, 'Tuesday', '09:00:00', '17:00:00', 'Tuesday', 'Tuesday', 1, NOW(), NOW()),
(3, 'Wednesday', '09:00:00', '17:00:00', 'Wednesday', 'Wednesday', 1, NOW(), NOW()),
(4, 'Thursday', '09:00:00', '17:00:00', 'Thursday', 'Thursday', 1, NOW(), NOW()),
(5, 'Friday', '09:00:00', '17:00:00', 'Friday', 'Friday', 1, NOW(), NOW()),

-- Service 1 (Emergency Shelter) hours
(6, 'Monday', '16:00:00', '08:00:00', 'Monday', 'Tuesday', 2, NOW(), NOW()),
(7, 'Tuesday', '16:00:00', '08:00:00', 'Tuesday', 'Wednesday', 2, NOW(), NOW()),
(8, 'Wednesday', '16:00:00', '08:00:00', 'Wednesday', 'Thursday', 2, NOW(), NOW()),
(9, 'Thursday', '16:00:00', '08:00:00', 'Thursday', 'Friday', 2, NOW(), NOW()),
(10, 'Friday', '16:00:00', '08:00:00', 'Friday', 'Saturday', 2, NOW(), NOW()),
(11, 'Saturday', '16:00:00', '08:00:00', 'Saturday', 'Sunday', 2, NOW(), NOW()),
(12, 'Sunday', '16:00:00', '08:00:00', 'Sunday', 'Monday', 2, NOW(), NOW()),

-- Service 2 (Permanent Housing) hours - matches office hours
(13, 'Monday', '09:00:00', '17:00:00', 'Monday', 'Monday', 3, NOW(), NOW()),
(14, 'Tuesday', '09:00:00', '17:00:00', 'Tuesday', 'Tuesday', 3, NOW(), NOW()),
(15, 'Wednesday', '09:00:00', '17:00:00', 'Wednesday', 'Wednesday', 3, NOW(), NOW()),
(16, 'Thursday', '09:00:00', '17:00:00', 'Thursday', 'Thursday', 3, NOW(), NOW()),
(17, 'Friday', '09:00:00', '17:00:00', 'Friday', 'Friday', 3, NOW(), NOW()),

-- Resource 2 (Community Food Bank) main hours
(18, 'Monday', '08:00:00', '18:00:00', 'Monday', 'Monday', 4, NOW(), NOW()),
(19, 'Tuesday', '08:00:00', '18:00:00', 'Tuesday', 'Tuesday', 4, NOW(), NOW()),
(20, 'Wednesday', '08:00:00', '18:00:00', 'Wednesday', 'Wednesday', 4, NOW(), NOW()),
(21, 'Thursday', '08:00:00', '18:00:00', 'Thursday', 'Thursday', 4, NOW(), NOW()),
(22, 'Friday', '08:00:00', '18:00:00', 'Friday', 'Friday', 4, NOW(), NOW()),

-- Service 3 (Food Pantry) hours
(23, 'Tuesday', '09:00:00', '13:00:00', 'Tuesday', 'Tuesday', 5, NOW(), NOW()),
(24, 'Thursday', '09:00:00', '13:00:00', 'Thursday', 'Thursday', 5, NOW(), NOW()),

-- Service 4 (Community Meals) hours
(25, 'Monday', '17:00:00', '19:00:00', 'Monday', 'Monday', 6, NOW(), NOW()),
(26, 'Wednesday', '17:00:00', '19:00:00', 'Wednesday', 'Wednesday', 6, NOW(), NOW()),
(27, 'Friday', '17:00:00', '19:00:00', 'Friday', 'Friday', 6, NOW(), NOW()),

-- Resource 3 (Wellness Clinic) main hours
(28, 'Monday', '08:00:00', '20:00:00', 'Monday', 'Monday', 7, NOW(), NOW()),
(29, 'Tuesday', '08:00:00', '20:00:00', 'Tuesday', 'Tuesday', 7, NOW(), NOW()),
(30, 'Wednesday', '08:00:00', '20:00:00', 'Wednesday', 'Wednesday', 7, NOW(), NOW()),
(31, 'Thursday', '08:00:00', '20:00:00', 'Thursday', 'Thursday', 7, NOW(), NOW()),
(32, 'Friday', '08:00:00', '17:00:00', 'Friday', 'Friday', 7, NOW(), NOW()),
(33, 'Saturday', '09:00:00', '13:00:00', 'Saturday', 'Saturday', 7, NOW(), NOW()),

-- Service 5 (Primary Healthcare) hours
(34, 'Monday', '08:00:00', '17:00:00', 'Monday', 'Monday', 8, NOW(), NOW()),
(35, 'Tuesday', '08:00:00', '17:00:00', 'Tuesday', 'Tuesday', 8, NOW(), NOW()),
(36, 'Wednesday', '08:00:00', '17:00:00', 'Wednesday', 'Wednesday', 8, NOW(), NOW()),
(37, 'Thursday', '08:00:00', '17:00:00', 'Thursday', 'Thursday', 8, NOW(), NOW()),
(38, 'Friday', '08:00:00', '17:00:00', 'Friday', 'Friday', 8, NOW(), NOW()),

-- Service 6 (Mental Health Counseling) hours
(39, 'Monday', '09:00:00', '20:00:00', 'Monday', 'Monday', 9, NOW(), NOW()),
(40, 'Tuesday', '09:00:00', '20:00:00', 'Tuesday', 'Tuesday', 9, NOW(), NOW()),
(41, 'Wednesday', '09:00:00', '20:00:00', 'Wednesday', 'Wednesday', 9, NOW(), NOW()),
(42, 'Thursday', '09:00:00', '20:00:00', 'Thursday', 'Thursday', 9, NOW(), NOW()),
(43, 'Friday', '09:00:00', '17:00:00', 'Friday', 'Friday', 9, NOW(), NOW()),
(44, 'Saturday', '09:00:00', '13:00:00', 'Saturday', 'Saturday', 9, NOW(), NOW()),

-- Resource 4 (Veterans Support Services) main hours
(45, 'Monday', '09:00:00', '17:00:00', 'Monday', 'Monday', 10, NOW(), NOW()),
(46, 'Tuesday', '09:00:00', '17:00:00', 'Tuesday', 'Tuesday', 10, NOW(), NOW()),
(47, 'Wednesday', '09:00:00', '17:00:00', 'Wednesday', 'Wednesday', 10, NOW(), NOW()),
(48, 'Thursday', '09:00:00', '17:00:00', 'Thursday', 'Thursday', 10, NOW(), NOW()),
(49, 'Friday', '09:00:00', '17:00:00', 'Friday', 'Friday', 10, NOW(), NOW()),

-- Service 7 (Veterans Housing) hours
(50, 'Monday', '09:00:00', '17:00:00', 'Monday', 'Monday', 11, NOW(), NOW()),
(51, 'Tuesday', '09:00:00', '17:00:00', 'Tuesday', 'Tuesday', 11, NOW(), NOW()),
(52, 'Wednesday', '09:00:00', '17:00:00', 'Wednesday', 'Wednesday', 11, NOW(), NOW()),
(53, 'Thursday', '09:00:00', '17:00:00', 'Thursday', 'Thursday', 11, NOW(), NOW()),
(54, 'Friday', '09:00:00', '17:00:00', 'Friday', 'Friday', 11, NOW(), NOW()),

-- Resource 5 (Youth Empowerment Center) main hours
(55, 'Monday', '10:00:00', '20:00:00', 'Monday', 'Monday', 12, NOW(), NOW()),
(56, 'Tuesday', '10:00:00', '20:00:00', 'Tuesday', 'Tuesday', 12, NOW(), NOW()),
(57, 'Wednesday', '10:00:00', '20:00:00', 'Wednesday', 'Wednesday', 12, NOW(), NOW()),
(58, 'Thursday', '10:00:00', '20:00:00', 'Thursday', 'Thursday', 12, NOW(), NOW()),
(59, 'Friday', '10:00:00', '20:00:00', 'Friday', 'Friday', 12, NOW(), NOW()),
(60, 'Saturday', '12:00:00', '18:00:00', 'Saturday', 'Saturday', 12, NOW(), NOW()),

-- Service 8 (Youth Counseling) hours
(61, 'Monday', '15:00:00', '19:00:00', 'Monday', 'Monday', 13, NOW(), NOW()),
(62, 'Tuesday', '15:00:00', '19:00:00', 'Tuesday', 'Tuesday', 13, NOW(), NOW()),
(63, 'Wednesday', '15:00:00', '19:00:00', 'Wednesday', 'Wednesday', 13, NOW(), NOW()),
(64, 'Thursday', '15:00:00', '19:00:00', 'Thursday', 'Thursday', 13, NOW(), NOW()),
(65, 'Friday', '15:00:00', '19:00:00', 'Friday', 'Friday', 13, NOW(), NOW());

-- Notes
INSERT INTO notes (id, note, resource_id, service_id, created_at, updated_at) VALUES
(1, 'Main office may close early on holidays - call ahead to confirm hours.', 1, NULL, NOW(), NOW()),
(2, 'Shelter intake begins at 4pm but it is recommended to arrive by 3pm to secure a spot.', NULL, 1, NOW(), NOW()),
(3, 'Housing applications currently being accepted but waitlist is approximately 3-6 months.', NULL, 2, NOW(), NOW()),
(4, 'Food pantry often reaches capacity - arrive early for best selection.', 2, NULL, NOW(), NOW()),
(5, 'Bring your own bags for food pantry if possible.', NULL, 3, NOW(), NOW()),
(6, 'Community meals can accommodate vegetarian diets - please inform staff of dietary restrictions.', NULL, 4, NOW(), NOW()),
(7, 'Clinic offers telehealth appointments for established patients.', 3, NULL, NOW(), NOW()),
(8, 'Walk-in hours for urgent care available Monday-Friday 8am-10am.', NULL, 5, NOW(), NOW()),
(9, 'Group therapy sessions require pre-registration.', NULL, 6, NOW(), NOW()),
(10, 'Veterans housing program currently has funds available for security deposits.', NULL, 7, NOW(), NOW()),
(11, 'Drop-in center may be closed for staff training on the first Tuesday of each month.', 5, NULL, NOW(), NOW()),
(12, 'Youth under 18 may need parental consent for ongoing counseling but can access crisis services without consent.', NULL, 8, NOW(), NOW());

-- Documents
INSERT INTO documents (id, name, url, description, created_at, updated_at) VALUES
(1, 'Housing Application Form', 'https://bahc-example.org/documents/housing-application.pdf', 'Application form for permanent supportive housing program', NOW(), NOW()),
(2, 'Shelter Rules and Guidelines', 'https://bahc-example.org/documents/shelter-guidelines.pdf', 'Rules and expectations for emergency shelter guests', NOW(), NOW()),
(3, 'Food Bank Registration Form', 'https://communityfoodbank-example.org/documents/pantry-registration.pdf', 'Registration form for food pantry services', NOW(), NOW()),
(4, 'Medical Records Release Form', 'https://wellnessclinic-example.org/documents/records-release.pdf', 'Authorization for release of medical records', NOW(), NOW()),
(5, 'Veterans Benefits Guide', 'https://vss-example.org/documents/veterans-benefits.pdf', 'Guide to accessing VA and other benefits for veterans', NOW(), NOW()),
(6, 'Youth Program Consent Form', 'https://yec-example.org/documents/youth-consent.pdf', 'Parental/guardian consent form for youth program participation', NOW(), NOW());

-- Documents Services
INSERT INTO documents_services (service_id, document_id) VALUES
(1, 2),
(2, 1),
(3, 3),
(5, 4),
(7, 5),
(8, 6);

-- Accessibilities
INSERT INTO accessibilities (id, accessibility, details, created_at, updated_at) VALUES
(1, 'Wheelchair accessible', 'Ramp entrance and elevator available', NOW(), NOW()),
(2, 'ADA compliant restrooms', 'Fully accessible restrooms on all floors', NOW(), NOW()),
(3, 'Sign language interpretation', 'Available with 48 hours notice', NOW(), NOW()),
(4, 'Service animals welcome', 'All service animals allowed in all areas', NOW(), NOW()),
(5, 'Accessible parking', 'Designated accessible parking spaces available', NOW(), NOW());

-- Instructions (service usage instructions)
INSERT INTO instructions (id, instruction, service_id, created_at, updated_at) VALUES
(1, 'For emergency shelter, arrive between 4pm-7pm for intake. Bring ID if available but not required. Check-out time is 8am.', 1, NOW(), NOW()),
(2, 'For housing applications, complete all sections of the application form and provide supporting documentation. Incomplete applications will delay processing.', 2, NOW(), NOW()),
(3, 'For food pantry, bring proof of address and ID if available. You can visit once per week. Food is distributed on a first-come, first-served basis.', 3, NOW(), NOW()),
(4, 'For community meals, no registration required. Doors open at 5pm and meals are served until 7pm or until food runs out.', 4, NOW(), NOW()),
(5, 'For primary care, new patients should arrive 15 minutes early to complete paperwork. Bring insurance card and ID if available.', 5, NOW(), NOW()),
(6, 'For mental health services, initial assessment takes approximately 60-90 minutes. Please bring any previous mental health records if available.', 6, NOW(), NOW()),
(7, 'For veterans housing assistance, bring DD-214 or other proof of military service to your first appointment if possible.', 7, NOW(), NOW()),
(8, 'For youth counseling, drop-in hours are Monday-Friday 3pm-7pm for immediate assistance. Scheduled appointments available for ongoing counseling.', 8, NOW(), NOW());

-- Synonym Groups
INSERT INTO synonym_groups (id, group_type, created_at, updated_at) VALUES
(1, 0, NOW(), NOW()), -- Housing synonyms
(2, 0, NOW(), NOW()), -- Food synonyms
(3, 0, NOW(), NOW()); -- Healthcare synonyms

-- Synonyms
INSERT INTO synonyms (id, word, synonym_group_id, created_at, updated_at) VALUES
(1, 'housing', 1, NOW(), NOW()),
(2, 'shelter', 1, NOW(), NOW()),
(3, 'lodging', 1, NOW(), NOW()),
(4, 'apartment', 1, NOW(), NOW()),
(5, 'accommodation', 1, NOW(), NOW()),
(6, 'food', 2, NOW(), NOW()),
(7, 'meal', 2, NOW(), NOW()),
(8, 'pantry', 2, NOW(), NOW()),
(9, 'groceries', 2, NOW(), NOW()),
(10, 'nutrition', 2, NOW(), NOW()),
(11, 'healthcare', 3, NOW(), NOW()),
(12, 'medical', 3, NOW(), NOW()),
(13, 'doctor', 3, NOW(), NOW()),
(14, 'clinic', 3, NOW(), NOW()),
(15, 'health', 3, NOW(), NOW());

-- News Articles
INSERT INTO news_articles (id, headline, effective_date, body, priority, expiration_date, url, created_at, updated_at) VALUES
(1, 'New Emergency Shelter Opening Next Month', '2025-06-01 00:00:00', 'A new emergency shelter with 50 additional beds will be opening next month to serve the growing need for emergency housing in our community.', 1, '2025-07-01 00:00:00', 'https://bahc-example.org/news/new-shelter', NOW(), NOW()),
(2, 'Food Bank Seeking Volunteers for Summer Program', '2025-05-15 00:00:00', 'Our food bank is seeking volunteers to help with our expanded summer meal program for children and families.', 2, '2025-06-15 00:00:00', 'https://communityfoodbank-example.org/news/summer-volunteers', NOW(), NOW()),
(3, 'Free Health Screenings This Weekend', '2025-05-25 00:00:00', 'Wellness Clinic will be offering free health screenings this Saturday from 10am-2pm. No appointment necessary.', 1, '2025-05-26 00:00:00', 'https://wellnessclinic-example.org/news/free-screenings', NOW(), NOW());

-- Folders (for user bookmarks)
INSERT INTO folders (id, name, order, user_id, created_at, updated_at) VALUES
(1, 'Housing Resources', 1, 1, NOW(), NOW()),
(2, 'Medical Services', 2, 1, NOW(), NOW()),
(3, 'Veterans Services', 1, 2, NOW(), NOW()),
(4, 'Youth Services', 2, 2, NOW(), NOW()),
(5, 'Food Resources', 1, 3, NOW(), NOW());

-- Bookmarks
INSERT INTO bookmarks (id, order, folder_id, service_id, resource_id, user_id, name, created_at, updated_at) VALUES
(1, 1, 1, 1, NULL, 1, 'Emergency Shelter', NOW(), NOW()),
(2, 2, 1, 2, NULL, 1, 'Permanent Housing', NOW(), NOW()),
(3, 1, 2, 5, NULL, 1, 'Primary Care', NOW(), NOW()),
(4, 2, 2, 6, NULL, 1, 'Mental Health Services', NOW(), NOW()),
(5, 1, 3, 7, NULL, 2, 'Veterans Housing', NOW(), NOW()),
(6, 1, 3, NULL, 4, 2, 'Veterans Support Services', NOW(), NOW()),
(7, 1, 4, 8, NULL, 2, 'Youth Counseling', NOW(), NOW()),
(8, 2, 4, NULL, 5, 2, 'Youth Empowerment Center', NOW(), NOW()),
(9, 1, 5, 3, NULL, 3, 'Food Pantry', NOW(), NOW()),
(10, 2, 5, 4, NULL, 3, 'Community Meals', NOW(), NOW());

-- Saved Searches
INSERT INTO saved_searches (id, user_id, name, search, created_at, updated_at) VALUES
(1, 1, 'Emergency Housing', '{"categories": [1,4], "eligibilities": [2]}', NOW(), NOW()),
(2, 2, 'Veterans Services', '{"categories": [1,3], "eligibilities": [4,9]}', NOW(), NOW()),
(3, 3, 'Food Resources for Families', '{"categories": [2,6], "eligibilities": [1]}', NOW(), NOW());

-- Texting Recipients
INSERT INTO texting_recipients (id, recipient_name, phone_number, created_at, updated_at) VALUES
(1, 'John Smith', '(415) 555-9001', NOW(), NOW()),
(2, 'Maria Garcia', '(415) 555-9002', NOW(), NOW()),
(3, 'David Wong', '(415) 555-9003', NOW(), NOW()),
(4, 'Sarah Johnson', '(415) 555-9004', NOW(), NOW()),
(5, 'James Wilson', '(415) 555-9005', NOW(), NOW());

-- Textings
INSERT INTO textings (id, texting_recipient_id, service_id, resource_id, created_at, updated_at) VALUES
(1, 1, 1, NULL, NOW(), NOW()),
(2, 1, 2, NULL, NOW(), NOW()),
(3, 2, 3, NULL, NOW(), NOW()),
(4, 3, 5, NULL, NOW(), NOW()),
(5, 4, NULL, 1, NOW(), NOW()),
(6, 5, NULL, 4, NOW(), NOW());

-- Feedbacks
INSERT INTO feedbacks (id, rating, resource_id, service_id, created_at, updated_at) VALUES
(1, '5', 1, NULL, NOW(), NOW()),
(2, '4', NULL, 1, NOW(), NOW()),
(3, '5', NULL, 2, NOW(), NOW()),
(4, '4', 2, NULL, NOW(), NOW()),
(5, '5', NULL, 3, NOW(), NOW()),
(6, '3', NULL, 5, NOW(), NOW()),
(7, '5', 3, NULL, NOW(), NOW()),
(8, '4', NULL, 6, NOW(), NOW()),
(9, '5', NULL, 7, NOW(), NOW()),
(10, '4', 4, NULL, NOW(), NOW());

-- Reviews
INSERT INTO reviews (id, review, tags, feedback_id, created_at, updated_at) VALUES
(1, 'Great organization with compassionate staff. They really helped me when I was in a difficult situation.', ARRAY['helpful', 'caring'], 1, NOW(), NOW()),
(2, 'The shelter was clean and staff were respectful. I felt safe during my stay.', ARRAY['clean', 'safe'], 2, NOW(), NOW()),
(3, 'The housing program changed my life. I now have stable housing after years of homelessness.', ARRAY['life-changing', 'effective'], 3, NOW(), NOW()),
(4, 'Food bank has a good variety of fresh produce and staff are friendly.', ARRAY['good-quality', 'friendly'], 4, NOW(), NOW()),
(5, 'The food pantry provides healthy options and the process is efficient.', ARRAY['efficient', 'healthy-options'], 5, NOW(), NOW()),
(6, 'Had to wait longer than expected for my appointment, but the care was good once I was seen.', ARRAY['long-wait', 'quality-care'], 6, NOW(), NOW()),
(7, 'Excellent healthcare facility with caring providers who take time to listen.', ARRAY['attentive', 'professional'], 7, NOW(), NOW()),
(8, 'The counselor was very helpful and provided practical strategies for managing anxiety.', ARRAY['helpful', 'practical'], 8, NOW(), NOW()),
(9, 'The veterans housing assistance program was straightforward and the staff really understood my needs.', ARRAY['veteran-friendly', 'efficient'], 9, NOW(), NOW()),
(10, 'This organization really knows how to support veterans with respect and dignity.', ARRAY['respectful', 'supportive'], 10, NOW(), NOW());

-- Volunteers
INSERT INTO volunteers (id, description, url, resource_id, created_at, updated_at) VALUES
(1, 'We welcome volunteers to help with our shelter operations, administrative tasks, and meal service. Training provided.', 'https://bahc-example.org/volunteer', 1, NOW(), NOW()),
(2, 'Food Bank volunteers needed for food sorting, distribution, and delivery to homebound clients.', 'https://communityfoodbank-example.org/volunteer', 2, NOW(), NOW()),
(3, 'Volunteer opportunities include reception, patient navigation, and healthcare support roles.', 'https://wellnessclinic-example.org/volunteer', 3, NOW(), NOW()),
(4, 'Veterans with experience are especially encouraged to volunteer as peer mentors.', 'https://vss-example.org/volunteer', 4, NOW(), NOW()),
(5, 'Adult volunteers needed to serve as mentors, tutors, and activity leaders for youth programs.', 'https://yec-example.org/volunteer', 5, NOW(), NOW());

SELECT 'Data import complete: ' || NOW() AS status;
