
# Module G — Grants and Awards

## 1. Grant

Relation:

conference_grant(
    id,
    name,
    description,
    application_deadline,
    amount,
    conference_id,
    edition_year
)

Primary Key:
- id

Foreign Keys:
- (conference_id, edition_year)
  REFERENCES conference_edition(conference_id, year)

Constraints:
- Each Grant belongs to exactly one Conference Edition.
- Each Grant has a unique ID.
- name is mandatory.
- description is mandatory.
- application_deadline is mandatory.
- amount is mandatory.
- amount >= 0
- conference_id and edition_year are mandatory.

Relationship:
- conference_edition 1:N conference_grant


## 2. Grant Application

Relation:

grant_application(
    participant_id,
    grant_id,
    application_date,
    status
)

Primary Key:
- (participant_id, grant_id)

Foreign Keys:
- participant_id
  REFERENCES participant(id)

- grant_id
  REFERENCES conference_grant(id)

Constraints:
- A Participant may apply for multiple Grants.
- A Grant may receive applications from multiple
  Participants.
- A Participant may apply at most once
  for the same Grant.
- application_date is mandatory.
- status is mandatory.
- Example statuses:
  submitted, accepted, rejected.

Relationships:
- participant 1:N grant_application
- conference_grant 1:N grant_application

Original UML relationship:
- participant N:M grant

Association attributes:
- application_date
- status


## 3. Award

Relation:

award(
    id,
    name,
    description,
    monetary_value,
    conference_id,
    edition_year
)

Primary Key:
- id

Foreign Keys:
- (conference_id, edition_year)
  REFERENCES conference_edition(conference_id, year)

Constraints:
- Each Award belongs to exactly one Conference Edition.
- Each Award has a unique ID.
- name is mandatory.
- description is mandatory.
- monetary_value is optional (NULL).
- monetary_value >= 0 when specified.
- conference_id and edition_year are mandatory.

Relationship:
- conference_edition 1:N award


## 4. Award Recipient

Relation:

award_recipient(
    award_id,
    participant_id
)

Primary Key:
- (award_id, participant_id)

Foreign Keys:
- award_id
  REFERENCES award(id)

- participant_id
  REFERENCES participant(id)

Constraints:
- An Award may be given to multiple Participants.
- A Participant may receive multiple Awards.
- Duplicate Award-Participant associations
  are not allowed.
- An Award may have zero recipients before
  it is assigned.

Relationships:
- award 1:N award_recipient
- participant 1:N award_recipient

Original UML relationship:
- award N:M participant


## 5. General Modelling Decisions

1. Grant and Award use independent unique IDs
   as their primary keys.

2. Each Grant and Award references its
   Conference Edition through the composite
   foreign key (conference_id, edition_year).

3. GrantApplication represents the N:M
   relationship between Participant and Grant,
   including application_date and status.

4. The composite primary key
   (participant_id, grant_id) prevents
   duplicate applications for the same Grant.

5. AwardRecipient represents the N:M
   relationship between Award and Participant.

6. monetary_value is nullable because
   an Award may have no monetary value.

7. A Grant's amount represents the amount
   awarded to each successful applicant,
   not the total budget of the Grant.

8. Only applications with status = 'accepted'
   are considered successful.

9. The Module A and Module B integration
   requirements do not apply because
   neither module was selected.

10. No additional formal Conference Edition
    participation requirement is imposed on
    Grant applicants or Award recipients,
    as this is not specified in Module G.
