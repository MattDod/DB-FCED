
# DB-FCED — Conference Support System - Team 8

## 1. Team Members

| Name | Student Number |
|---|---|
| [Miguel Neri] | [202006475] |
| [Luís Cordeiro] | [202205425] |
| [Afonso Marques] | [202602762] |


## 2. Selected Modules

The project implements the mandatory **Core System** and the following two optional modules:

- **Module E — Sponsorship and Exhibition**
- **Module G — Grants and Awards**

The solution consists of a UML conceptual model, its corresponding relational model, a PostgreSQL database schema, and the six SQL queries required by the assignment.

## 3. Database Management System

The database was implemented using **PostgreSQL**.

The implementation uses primary keys, foreign keys, composite keys, unique constraints, NOT NULL constraints, CHECK constraints, and triggers to enforce the relevant integrity requirements.

## Relevant Modelling Decisions and Explanations

1. **Conference editions.** Each edition is identified by `(conference_id, year)`, since edition years are unique within a conference rather than globally. References to conference editions therefore use composite foreign keys.

2. **Activity duration and dates.** Activities must satisfy `start_date_time < end_date_time`, excluding zero-duration activities. PostgreSQL triggers ensure that activity timestamps fall within the corresponding conference edition's dates, including when those dates are updated.

3. **Activity involvement.** The UML association class *Involvement* is implemented by `activity_involvement`, preserving the participant's `role`. Composite foreign keys ensure that a participant involved in an activity also participates in that activity's conference edition. An additional `UNIQUE (id, conference_id, edition_year)` constraint on `activity` supports this referential structure without changing its primary key.

4. **Sponsorship packages and acquisitions.** A sponsorship package is identified by `(conference_id, edition_year, name)`, reflecting the qualified association in the UML. The ternary UML acquisition association is implemented by `sponsorship_acquisition`, whose primary key allows an organisation to acquire at most one package per conference edition. A composite foreign key ensures that the acquired package belongs to that edition, while allowing multiple organisations to acquire the same package.

5. **Exhibition spaces.** `exhibition_space.organisation_id` is nullable, allowing a space to exist before being reserved. Each space can be reserved by at most one organisation, while an organisation may reserve several spaces.

6. **Grant applications.** The UML association class *Application* is implemented by `grant_application`, preserving `application_date` and `status`. Its primary key `(participant_id, grant_id)` prevents duplicate applications for the same grant. Applications with status `accepted` are considered successful, and a grant's `amount` represents the amount awarded to each successful applicant, not its total budget.

7. **Grants and awards.** The UML class *Grant* is implemented as `conference_grant` to avoid using the reserved SQL keyword `GRANT`. Awards can have multiple recipients or remain unassigned, and their `monetary_value` is optional. No additional conference edition participation requirement is imposed on grant applicants or award recipients, as Module G does not specify one.

8. **Module integrations.** The selected Modules E and G have no additional integration requirements between them. The integration requirements of Module G with Modules A and B do not apply because neither module was selected.