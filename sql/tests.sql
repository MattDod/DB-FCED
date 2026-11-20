
-- ==========================================
-- FCED - Conference Support System
-- Integrity Tests
-- Core + Modules E and G
-- ==========================================

-- Run after schema.sql and data.sql.
-- Expected constraint violations are caught.
-- All test changes are rolled back.

BEGIN;

-- ==========================================
-- T1 - Duplicate Conference Edition
-- ==========================================

DO $$
DECLARE
    rejected BOOLEAN := FALSE;
BEGIN
    BEGIN
        INSERT INTO conference_edition
            (conference_id, year, start_date,
             end_date, location)
        VALUES
            (1, 2027, '2027-07-01',
             '2027-07-03', 'Coimbra');

    EXCEPTION
        WHEN unique_violation THEN
            rejected := TRUE;
    END;

    IF NOT rejected THEN
        RAISE EXCEPTION 'T1 FAILED';
    END IF;

    RAISE NOTICE 'T1 PASSED: Duplicate edition rejected';
END;
$$;


-- ==========================================
-- T2 - Invalid Activity Involvement
-- ==========================================

DO $$
DECLARE
    rejected BOOLEAN := FALSE;
BEGIN
    BEGIN
        -- Participant 5 does not attend edition 2028.
        INSERT INTO activity_involvement
            (participant_id, activity_id,
             conference_id, edition_year, role)
        VALUES
            (5, 4, 1, 2028, 'speaker');

    EXCEPTION
        WHEN foreign_key_violation THEN
            rejected := TRUE;
    END;

    IF NOT rejected THEN
        RAISE EXCEPTION 'T2 FAILED';
    END IF;

    RAISE NOTICE 'T2 PASSED: Invalid involvement rejected';
END;
$$;


-- ==========================================
-- T3 - Duplicate Sponsorship Acquisition
-- ==========================================

DO $$
DECLARE
    rejected BOOLEAN := FALSE;
BEGIN
    BEGIN
        -- Organisation 1 already acquired Gold
        -- for conference 1, edition 2027.
        INSERT INTO sponsorship_acquisition
            (organisation_id, conference_id,
             edition_year, package_name)
        VALUES
            (1, 1, 2027, 'Silver');

    EXCEPTION
        WHEN unique_violation THEN
            rejected := TRUE;
    END;

    IF NOT rejected THEN
        RAISE EXCEPTION 'T3 FAILED';
    END IF;

    RAISE NOTICE 'T3 PASSED: Second package rejected';
END;
$$;


-- ==========================================
-- T4 - Duplicate Grant Application
-- ==========================================

DO $$
DECLARE
    rejected BOOLEAN := FALSE;
BEGIN
    BEGIN
        -- Participant 1 already applied to Grant 1.
        INSERT INTO grant_application
            (participant_id, grant_id,
             application_date, status)
        VALUES
            (1, 1, '2027-04-10', 'submitted');

    EXCEPTION
        WHEN unique_violation THEN
            rejected := TRUE;
    END;

    IF NOT rejected THEN
        RAISE EXCEPTION 'T4 FAILED';
    END IF;

    RAISE NOTICE 'T4 PASSED: Duplicate application rejected';
END;
$$;


-- ==========================================
-- T5 - Activity Outside Edition Dates
-- ==========================================

DO $$
DECLARE
    rejected BOOLEAN := FALSE;
BEGIN
    BEGIN
        -- Edition 2027 ends on May 12.
        INSERT INTO activity
            (title, description,
             start_date_time, end_date_time,
             conference_id, edition_year)
        VALUES
            ('Invalid Workshop',
             'Activity outside edition',
             '2027-05-13 10:00',
             '2027-05-13 12:00',
             1, 2027);

    EXCEPTION
        WHEN raise_exception THEN
            rejected := TRUE;
    END;

    IF NOT rejected THEN
        RAISE EXCEPTION 'T5 FAILED';
    END IF;

    RAISE NOTICE 'T5 PASSED: Invalid activity dates rejected';
END;
$$;


-- ==========================================
-- T6 - Invalid Edition Date Modification
-- ==========================================

DO $$
DECLARE
    rejected BOOLEAN := FALSE;
BEGIN
    BEGIN
        -- Edition has an Activity on May 11.
        -- Attempt to end the edition on May 10.
        UPDATE conference_edition
        SET end_date = '2027-05-10'
        WHERE conference_id = 1
          AND year = 2027;

    EXCEPTION
        WHEN raise_exception THEN
            rejected := TRUE;
    END;

    IF NOT rejected THEN
        RAISE EXCEPTION 'T6 FAILED';
    END IF;

    RAISE NOTICE 'T6 PASSED: Invalid edition update rejected';
END;
$$;

-- ==========================================
-- END OF TESTS
-- ==========================================

ROLLBACK;
