
-- ==========================================
-- FCED - Conference Support System
-- Database: PostgreSQL
-- Modules: Core + E + G
-- ==========================================

-- ==========================================
-- 1. CORE SYSTEM
-- ==========================================

-- 1.1 Conference

CREATE TABLE conference (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    acronym VARCHAR(30) NOT NULL,
    description TEXT NOT NULL
);


-- 1.2 Conference Edition

CREATE TABLE conference_edition (
    conference_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    location VARCHAR(150) NOT NULL,

    PRIMARY KEY (conference_id, year),

    FOREIGN KEY (conference_id)
        REFERENCES conference(id),

    CHECK (start_date <= end_date)
);


-- 1.3 Participant

CREATE TABLE participant (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    affiliation VARCHAR(150) NOT NULL
);


-- 1.4 Activity

CREATE TABLE activity (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    start_date_time TIMESTAMP NOT NULL,
    end_date_time TIMESTAMP NOT NULL,
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,

    FOREIGN KEY (conference_id, edition_year)
        REFERENCES conference_edition(conference_id, year),

    UNIQUE (id, conference_id, edition_year),

    CHECK (start_date_time < end_date_time)
);


-- 1.5 Edition Participation

CREATE TABLE edition_participation (
    participant_id INTEGER NOT NULL,
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,

    PRIMARY KEY (
        participant_id,
        conference_id,
        edition_year
    ),

    FOREIGN KEY (participant_id)
        REFERENCES participant(id),

    FOREIGN KEY (conference_id, edition_year)
        REFERENCES conference_edition(conference_id, year)
);


-- 1.6 Activity Involvement

CREATE TABLE activity_involvement (
    participant_id INTEGER NOT NULL,
    activity_id INTEGER NOT NULL,
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,
    role VARCHAR(50) NOT NULL,

    PRIMARY KEY (participant_id, activity_id),

    FOREIGN KEY (participant_id)
        REFERENCES participant(id),

    FOREIGN KEY (
        activity_id,
        conference_id,
        edition_year
    )
        REFERENCES activity(
            id,
            conference_id,
            edition_year
        ),

    FOREIGN KEY (
        participant_id,
        conference_id,
        edition_year
    )
        REFERENCES edition_participation(
            participant_id,
            conference_id,
            edition_year
        )
);



-- ==========================================
-- 2. MODULE E - SPONSORSHIP AND EXHIBITION
-- ==========================================

-- 2.1 Organisation

CREATE TABLE organisation (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    website VARCHAR(255) NOT NULL,
    contact_info TEXT NOT NULL
);


-- 2.2 Sponsorship Package

CREATE TABLE sponsorship_package (
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    description TEXT NOT NULL,

    PRIMARY KEY (conference_id, edition_year, name),

    FOREIGN KEY (conference_id, edition_year)
        REFERENCES conference_edition(conference_id, year),

    CHECK (price >= 0)
);


-- 2.3 Sponsorship Acquisition

CREATE TABLE sponsorship_acquisition (
    organisation_id INTEGER NOT NULL,
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,
    package_name VARCHAR(100) NOT NULL,

    PRIMARY KEY (
        organisation_id,
        conference_id,
        edition_year
    ),

    FOREIGN KEY (organisation_id)
        REFERENCES organisation(id),

    FOREIGN KEY (
        conference_id,
        edition_year,
        package_name
    )
        REFERENCES sponsorship_package(
            conference_id,
            edition_year,
            name
        )
);


-- 2.4 Exhibition Space

CREATE TABLE exhibition_space (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name_or_number VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL,
    fee NUMERIC(10, 2) NOT NULL,
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,
    organisation_id INTEGER,

    FOREIGN KEY (conference_id, edition_year)
        REFERENCES conference_edition(conference_id, year),

    FOREIGN KEY (organisation_id)
        REFERENCES organisation(id),

    CHECK (fee >= 0)
);




-- ==========================================
-- 3. MODULE G - GRANTS AND AWARDS
-- ==========================================

-- 3.1 Conference Grant

CREATE TABLE conference_grant (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    application_deadline DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,

    FOREIGN KEY (conference_id, edition_year)
        REFERENCES conference_edition(conference_id, year),

    CHECK (amount >= 0)
);


-- 3.2 Grant Application

CREATE TABLE grant_application (
    participant_id INTEGER NOT NULL,
    grant_id INTEGER NOT NULL,
    application_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,

    PRIMARY KEY (participant_id, grant_id),

    FOREIGN KEY (participant_id)
        REFERENCES participant(id),

    FOREIGN KEY (grant_id)
        REFERENCES conference_grant(id),

    CHECK (
        status IN ('submitted', 'accepted', 'rejected')
    )
);


-- 3.3 Award

CREATE TABLE award (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    monetary_value NUMERIC(10, 2),
    conference_id INTEGER NOT NULL,
    edition_year INTEGER NOT NULL,

    FOREIGN KEY (conference_id, edition_year)
        REFERENCES conference_edition(conference_id, year),

    CHECK (
        monetary_value IS NULL
        OR monetary_value >= 0
    )
);


-- 3.4 Award Recipient

CREATE TABLE award_recipient (
    award_id INTEGER NOT NULL,
    participant_id INTEGER NOT NULL,

    PRIMARY KEY (award_id, participant_id),

    FOREIGN KEY (award_id)
        REFERENCES award(id),

    FOREIGN KEY (participant_id)
        REFERENCES participant(id)
);
