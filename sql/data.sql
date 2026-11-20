
-- ==========================================
-- FCED - Conference Support System
-- Sample Data
-- Modules: Core + E + G
-- ==========================================

BEGIN;

-- ==========================================
-- 1. CORE SYSTEM
-- ==========================================

-- 1.1 Conferences

INSERT INTO conference
    (id, name, acronym, description)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'International Conference on Data Science',
    'ICDS', 'Conference focused on Data Science and AI'),

(2, 'European Conference on Artificial Intelligence',
    'ECAI', 'Conference focused on Artificial Intelligence');


-- 1.2 Conference Editions

INSERT INTO conference_edition
    (conference_id, year, start_date, end_date, location)
VALUES
(1, 2027, '2027-05-10', '2027-05-12', 'Porto'),
(1, 2028, '2028-06-15', '2028-06-17', 'Lisbon'),
(2, 2027, '2027-09-03', '2027-09-04', 'Madrid');


-- 1.3 Participants

INSERT INTO participant
    (id, name, email, affiliation)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Miguel Silva', 'miguel@example.com', 'FEUP'),
(2, 'Ana Costa', 'ana@example.com', 'UP'),
(3, 'Joao Pereira', 'joao@example.com', 'IST'),
(4, 'Maria Santos', 'maria@example.com', 'UMinho'),
(5, 'Pedro Oliveira', 'pedro@example.com', 'FEUP'),
(6, 'Sofia Almeida', 'sofia@example.com', 'UC');


-- 1.4 Activities

INSERT INTO activity
    (id, title, description, start_date_time,
     end_date_time, conference_id, edition_year)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Machine Learning Workshop',
    'Introduction to Machine Learning',
    '2027-05-10 09:00', '2027-05-10 11:00', 1, 2027),

(2, 'Deep Learning Keynote',
    'Recent advances in Deep Learning',
    '2027-05-10 14:00', '2027-05-10 15:30', 1, 2027),

(3, 'Data Science Panel',
    'Discussion on the future of Data Science',
    '2027-05-11 10:00', '2027-05-11 12:00', 1, 2027),

(4, 'Big Data Workshop',
    'Processing large datasets',
    '2028-06-15 09:00', '2028-06-15 11:00', 1, 2028),

(5, 'AI Ethics Panel',
    'Ethical challenges in AI',
    '2027-09-03 10:00', '2027-09-03 12:00', 2, 2027);


-- 1.5 Edition Participation

INSERT INTO edition_participation
    (participant_id, conference_id, edition_year)
VALUES
(1, 1, 2027),
(2, 1, 2027),
(3, 1, 2027),
(4, 1, 2027),
(5, 1, 2027),

(1, 1, 2028),
(3, 1, 2028),
(6, 1, 2028),

(2, 2, 2027),
(4, 2, 2027),
(6, 2, 2027);


-- 1.6 Activity Involvement

INSERT INTO activity_involvement
    (participant_id, activity_id, conference_id,
     edition_year, role)
VALUES
(1, 1, 1, 2027, 'speaker'),
(2, 1, 1, 2027, 'chair'),
(3, 1, 1, 2027, 'attendee'),

(2, 2, 1, 2027, 'speaker'),
(1, 2, 1, 2027, 'attendee'),

(3, 3, 1, 2027, 'speaker'),
(4, 3, 1, 2027, 'chair'),
(1, 3, 1, 2027, 'attendee'),

(6, 4, 1, 2028, 'speaker'),
(1, 4, 1, 2028, 'attendee'),

(4, 5, 2, 2027, 'speaker'),
(6, 5, 2, 2027, 'chair');


-- ==========================================
-- 2. MODULE E - SPONSORSHIP AND EXHIBITION
-- ==========================================

-- 2.1 Organisations

INSERT INTO organisation
    (id, name, website, contact_info)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Google', 'https://google.com',
    'contact@google.com'),

(2, 'Microsoft', 'https://microsoft.com',
    'contact@microsoft.com'),

(3, 'IBM', 'https://ibm.com',
    'contact@ibm.com');


-- 2.2 Sponsorship Packages

INSERT INTO sponsorship_package
    (conference_id, edition_year, name, price, description)
VALUES
(1, 2027, 'Gold', 5000.00, 'Premium sponsorship'),
(1, 2027, 'Silver', 2500.00, 'Standard sponsorship'),
(1, 2027, 'Bronze', 1000.00, 'Basic sponsorship'),
(1, 2028, 'Bronze', 1200.00, 'Basic sponsorship');


-- 2.3 Sponsorship Acquisitions

INSERT INTO sponsorship_acquisition
    (organisation_id, conference_id,
     edition_year, package_name)
VALUES
(1, 1, 2027, 'Gold'),
(2, 1, 2027, 'Silver'),
(1, 1, 2028, 'Bronze');


-- 2.4 Exhibition Spaces

INSERT INTO exhibition_space
    (id, name_or_number, location, fee,
     conference_id, edition_year, organisation_id)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Stand A1', 'Main Hall', 500.00, 1, 2027, 1),
(2, 'Stand A2', 'Main Hall', 500.00, 1, 2027, 2),
(3, 'Stand B1', 'Exhibition Hall', 300.00, 1, 2027, NULL),
(4, 'Stand C1', 'Main Hall', 400.00, 1, 2028, 3);


-- ==========================================
-- 3. MODULE G - GRANTS AND AWARDS
-- ==========================================

-- 3.1 Conference Grants

INSERT INTO conference_grant
    (id, name, description, application_deadline,
     amount, conference_id, edition_year)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Student Travel Grant',
    'Financial support for student travel',
    '2027-04-15', 500.00, 1, 2027),

(2, 'Participation Grant',
    'Support for conference participation',
    '2027-04-20', 300.00, 1, 2027),

(3, 'Research Travel Grant',
    'Travel support for researchers',
    '2028-05-20', 700.00, 1, 2028);


-- 3.2 Grant Applications

INSERT INTO grant_application
    (participant_id, grant_id, application_date, status)
VALUES
(1, 1, '2027-04-01', 'accepted'),
(2, 1, '2027-04-05', 'rejected'),
(3, 1, '2027-04-08', 'accepted'),
(4, 2, '2027-04-10', 'submitted'),
(6, 3, '2028-05-10', 'accepted');


-- 3.3 Awards

INSERT INTO award
    (id, name, description, monetary_value,
     conference_id, edition_year)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Best Researcher Award',
    'Recognition for outstanding research',
    1000.00, 1, 2027),

(2, 'Young Researcher Award',
    'Recognition for young researchers',
    NULL, 1, 2027),

(3, 'Innovation Award',
    'Recognition for innovative contributions',
    750.00, 1, 2028);


-- 3.4 Award Recipients

INSERT INTO award_recipient
    (award_id, participant_id)
VALUES
(1, 1),
(1, 2),
(3, 6);


-- ==========================================
-- 4. SYNCHRONIZE IDENTITY SEQUENCES
-- ==========================================

SELECT setval(pg_get_serial_sequence('conference', 'id'),
              (SELECT MAX(id) FROM conference));

SELECT setval(pg_get_serial_sequence('participant', 'id'),
              (SELECT MAX(id) FROM participant));

SELECT setval(pg_get_serial_sequence('activity', 'id'),
              (SELECT MAX(id) FROM activity));

SELECT setval(pg_get_serial_sequence('organisation', 'id'),
              (SELECT MAX(id) FROM organisation));

SELECT setval(pg_get_serial_sequence('exhibition_space', 'id'),
              (SELECT MAX(id) FROM exhibition_space));

SELECT setval(pg_get_serial_sequence('conference_grant', 'id'),
              (SELECT MAX(id) FROM conference_grant));

SELECT setval(pg_get_serial_sequence('award', 'id'),
              (SELECT MAX(id) FROM award));

COMMIT;
