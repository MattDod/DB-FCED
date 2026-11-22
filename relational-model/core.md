
# Core System — Relational Model

## 1. Conference

Relation:

conference(
    id,
    name,
    acronym,
    description
)

Primary Key:
- id

Foreign Keys:
- None

Constraints:
- id is unique.
- name is mandatory.
- acronym is mandatory.
- description is mandatory.


## 2. Conference Edition

Relation:

conference_edition(
    conference_id,
    year,
    start_date,
    end_date,
    location
)

Primary Key:
- (conference_id, year)

Foreign Keys:
- conference_id REFERENCES conference(id)

Constraints:
- Each edition belongs to exactly one conference.
- The year must be unique within each conference.
- start_date <= end_date
- All attributes are mandatory.

Relationship:
- conference 1:N conference_edition


## 3. Participant

Relation:

participant(
    id,
    name,
    email,
    affiliation
)

Primary Key:
- id

Foreign Keys:
- None

Constraints:
- id is unique.
- name is mandatory.
- email is mandatory.
- affiliation is mandatory.


## 4. Activity

Relation:

activity(
    id,
    title,
    description,
    start_date_time,
    end_date_time,
    conference_id,
    edition_year
)

Primary Key:
- id

Foreign Keys:
- (conference_id, edition_year)
  REFERENCES conference_edition(conference_id, year)

Additional Unique Constraint:
- UNIQUE (id, conference_id, edition_year)

Constraints:
- Each Activity belongs to exactly one Conference Edition.
- start_date_time < end_date_time
- Activity timestamps must fall within the dates
  of the corresponding Conference Edition.
- All attributes are mandatory.

Relationship:
- conference_edition 1:N activity


## 5. Edition Participation

Relation:

edition_participation(
    participant_id,
    conference_id,
    edition_year
)

Primary Key:
- (participant_id, conference_id, edition_year)

Foreign Keys:
- participant_id
  REFERENCES participant(id)

- (conference_id, edition_year)
  REFERENCES conference_edition(conference_id, year)

Constraints:
- A Participant may participate in multiple editions.
- An edition may have multiple Participants.
- Duplicate participation records are not allowed.

Relationship:
- participant N:M conference_edition


## 6. Activity Involvement

Relation:

activity_involvement(
    participant_id,
    activity_id,
    conference_id,
    edition_year,
    role
)

Primary Key:
- (participant_id, activity_id)

Foreign Keys:
- participant_id
  REFERENCES participant(id)

- (activity_id, conference_id, edition_year)
  REFERENCES activity(id, conference_id, edition_year)

- (participant_id, conference_id, edition_year)
  REFERENCES edition_participation(
      participant_id, conference_id, edition_year
  )

Constraints:
- A Participant may be involved in multiple Activities.
- An Activity may involve multiple Participants.
- Each involvement has exactly one role.
- A Participant cannot have duplicate involvements
  in the same Activity.
- An involved Participant must participate in the
  Conference Edition to which the Activity belongs.

Relationship:
- participant N:M activity
- Association Class: Involvement


## 7. General Modelling Decisions

1. ConferenceEdition uses a composite primary key
   (conference_id, year).

2. N:M relationships are represented using
   associative relations.

3. Involvement is represented by activity_involvement,
   which stores the Participant's role in an Activity.

4. Activity uses the unique key
   (id, conference_id, edition_year) to support
   referential integrity in activity_involvement.

5. The activity_involvement relation includes
   conference_id and edition_year to enforce that
   Participants are involved only in Activities
   belonging to editions in which they participate.

6. Activity timestamps must be within their
   Conference Edition's date range. This constraint
   requires additional validation beyond a
   standard row-level CHECK constraint.
