# Conference Support System — Team 8

## Team Members

| Name | Student Number |
|---|---|
| Miguel Neri | 202006475 |
| Luís Cordeiro | 202205425 |
| Afonso Relvas | 202602762 |

## Selected Modules

The project implements the mandatory **Core System** and exactly two optional modules:

- **Module E — Sponsorship and Exhibition**
- **Module G — Grants and Awards**

There are no additional integration requirements between these two modules. Integrations with unselected modules do not apply.

## Database Management System

**PostgreSQL**. The implementation uses primary, foreign, composite and unique keys, `NOT NULL` and `CHECK` constraints, and triggers for date validation across tables.

## Relevant Modelling Decisions

1. **Conference editions.** In the UML, `year` qualifies the Conference–ConferenceEdition association. In SQL, `(conference_id, year)` is the edition's composite primary key, allowing different conferences to have editions in the same year.

2. **Activity dates.** Each activity has timestamps satisfying `start_date_time < end_date_time` (zero-duration activities are excluded). Edition start/end dates are inclusive. Triggers ensure activities fall within their edition's dates, including after updates to those dates.

3. **Activity involvement.** The unnamed UML Participant–Activity association class, with attribute `role`, becomes `activity_involvement`. Composite foreign keys ensure that involved participants also participate in the activity's edition. `UNIQUE (id, conference_id, edition_year)` on `activity` supports this referential constraint; `id` remains its primary key.

4. **Sponsorship packages.** The UML `name` qualifier expresses uniqueness within an edition. Thus, the relational primary key is `(conference_id, edition_year, name)`.

5. **Sponsorship acquisitions.** The UML ternary association is implemented by `sponsorship_acquisition`. The primary key `(organisation_id, conference_id, edition_year)` limits each organisation to one package per edition. A composite foreign key ensures that the acquired package belongs to that edition. Different organisations may acquire the same package.

6. **Exhibition spaces.** The nullable `organisation_id` in `exhibition_space` permits unreserved spaces; each space has at most one reserving organisation. Sponsorship and exhibition are independent, so an organisation may do both in the same edition.

7. **Grant applications.** The UML association class `Application` becomes `grant_application`. Its primary key `(participant_id, grant_id)` prevents duplicate applications. We adopted the example statuses `submitted`, `accepted` and `rejected` as the allowed states; `accepted` indicates a successful application. Each grant's `amount` is awarded per successful applicant.

8. **Awards and grants.** The SQL table is called `conference_grant` to avoid the PostgreSQL keyword `GRANT`. An award may have no recipients or several recipients, and `monetary_value` is optional. The specification does not require grant applicants or award recipients to participate in the award/grant's conference edition, so no such restriction was added.

9. **Monetary values.** Package prices, exhibition fees, grant amounts and non-null award monetary values must be non-negative. This is an additional modelling assumption.

10. **Required attributes and NULL handling.** The UML explicitly marks the main identifiers as `«not null»`, while the PostgreSQL schema additionally applies `NOT NULL` to descriptive and association attributes that we have chosen to treat as mandatory (such as names, descriptions, dates, `role`, and application `status`). These additional constraints are implementation decisions and do not introduce new conceptual associations. Primary-key attributes are inherently non-null, including the qualified `year` and sponsorship-package `name`; foreign-key attributes required by mandatory relationships are also non-null. The explicitly optional `award.monetary_value` and `exhibition_space.organisation_id` remain nullable.
