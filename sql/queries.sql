
-- ==========================================
-- FCED - Conference Support System
-- SQL Queries
-- Modules: Core + E + G
-- PostgreSQL
-- ==========================================

-- Example Conference Edition:
-- conference_id = 1
-- edition_year = 2027


-- ==========================================
-- CORE SYSTEM
-- ==========================================

-- Core Q1
-- For a given Conference Edition, list all its
-- Activities, including their title, start/end
-- timestamps, Participants and respective roles.

SELECT
    a.id AS activity_id,
    a.title AS activity_title,
    a.start_date_time,
    a.end_date_time,
    p.id AS participant_id,
    p.name AS participant_name,
    ai.role
FROM activity a
LEFT JOIN activity_involvement ai
    ON a.id = ai.activity_id
LEFT JOIN participant p
    ON ai.participant_id = p.id
WHERE a.conference_id = 1
  AND a.edition_year = 2027
ORDER BY
    a.start_date_time,
    a.id,
    p.name;


-- ==========================================

-- Core Q2
-- For a given Conference Edition, list each
-- Participant involved in at least one Activity
-- and count their distinct Activities.
-- Order by the highest number of Activities.

SELECT
    p.id AS participant_id,
    p.name AS participant_name,
    COUNT(DISTINCT ai.activity_id) AS activity_count
FROM participant p
JOIN activity_involvement ai
    ON p.id = ai.participant_id
JOIN activity a
    ON ai.activity_id = a.id
WHERE a.conference_id = 1
  AND a.edition_year = 2027
GROUP BY
    p.id,
    p.name
ORDER BY
    activity_count DESC,
    p.name;


-- ==========================================
-- MODULE E - SPONSORSHIP AND EXHIBITION
-- ==========================================

-- Module E Q1
-- For a given Conference Edition, list all
-- Sponsorship Packages and Organisations
-- that acquired them, including packages
-- without any Organisation.

SELECT
    sp.name AS package_name,
    sp.price AS package_price,
    o.id AS organisation_id,
    o.name AS organisation_name
FROM sponsorship_package sp
LEFT JOIN sponsorship_acquisition sa
    ON sp.conference_id = sa.conference_id
   AND sp.edition_year = sa.edition_year
   AND sp.name = sa.package_name
LEFT JOIN organisation o
    ON sa.organisation_id = o.id
WHERE sp.conference_id = 1
  AND sp.edition_year = 2027
ORDER BY
    sp.price DESC,
    sp.name,
    o.name;


-- ==========================================

-- Module E Q2
-- For a given Conference Edition, list all
-- Exhibition Spaces and the Organisation
-- that reserved each space.
-- Include spaces without reservations.

SELECT
    es.id AS space_id,
    es.name_or_number AS space_name,
    es.location,
    es.fee,
    o.id AS organisation_id,
    o.name AS organisation_name
FROM exhibition_space es
LEFT JOIN organisation o
    ON es.organisation_id = o.id
WHERE es.conference_id = 1
  AND es.edition_year = 2027
ORDER BY
    es.name_or_number,
    es.id;


-- ==========================================
-- MODULE G - GRANTS AND AWARDS
-- ==========================================

-- Module G Q1
-- For a given Conference Edition, list all
-- successful Grant Applications, including
-- the Grant, Participant and awarded amount.

SELECT
    cg.id AS grant_id,
    cg.name AS grant_name,
    p.id AS participant_id,
    p.name AS participant_name,
    cg.amount AS awarded_amount
FROM conference_grant cg
JOIN grant_application ga
    ON cg.id = ga.grant_id
JOIN participant p
    ON ga.participant_id = p.id
WHERE cg.conference_id = 1
  AND cg.edition_year = 2027
  AND ga.status = 'accepted'
ORDER BY
    cg.name,
    p.name;


-- ==========================================

-- Module G Q2
-- For a given Conference Edition, list all
-- Awards, recipients and monetary values.
-- Include Awards without any recipients.

SELECT
    aw.id AS award_id,
    aw.name AS award_name,
    aw.monetary_value,
    p.id AS participant_id,
    p.name AS recipient_name
FROM award aw
LEFT JOIN award_recipient ar
    ON aw.id = ar.award_id
LEFT JOIN participant p
    ON ar.participant_id = p.id
WHERE aw.conference_id = 1
  AND aw.edition_year = 2027
ORDER BY
    aw.name,
    p.name;


