
# Module E — Sponsorship and Exhibition

## 1. Organisation

Relation:

organisation(
    id,
    name,
    website,
    contact_info
)

Primary Key:
- id

Foreign Keys:
- None

Constraints:
- id is unique.
- name is mandatory.
- website is mandatory.
- contact_info is mandatory.


## 2. Sponsorship Package

Relation:

sponsorship_package(
    conference_id,
    edition_year,
    name,
    price,
    description
)

Primary Key:
- (conference_id, edition_year, name)

Foreign Keys:
- (conference_id, edition_year)
  REFERENCES conference_edition(conference_id, year)

Constraints:
- Each Sponsorship Package belongs to exactly
  one Conference Edition.
- Package names must be unique within each
  Conference Edition.
- price >= 0
- All attributes are mandatory.

Relationship:
- conference_edition 1:N sponsorship_package


## 3. Sponsorship Acquisition

Relation:

sponsorship_acquisition(
    organisation_id,
    conference_id,
    edition_year,
    package_name
)

Primary Key:
- (organisation_id, conference_id, edition_year)

Foreign Keys:
- organisation_id
  REFERENCES organisation(id)

- (conference_id, edition_year, package_name)
  REFERENCES sponsorship_package(
      conference_id, edition_year, name
  )

Constraints:
- An Organisation may acquire at most one
  Sponsorship Package per Conference Edition.
- A Sponsorship Package may be acquired
  by multiple Organisations.
- All attributes are mandatory.

Relationships:
- organisation 1:N sponsorship_acquisition
- sponsorship_package 1:N sponsorship_acquisition

Original UML relationship:
- Ternary association: Organisation,
  ConferenceEdition and SponsorshipPackage.


## 4. Exhibition Space

Relation:

exhibition_space(
    id,
    name_or_number,
    location,
    fee,
    conference_id,
    edition_year,
    organisation_id
)

Primary Key:
- id

Foreign Keys:
- (conference_id, edition_year)
  REFERENCES conference_edition(conference_id, year)

- organisation_id
  REFERENCES organisation(id)

Constraints:
- Each Exhibition Space belongs to exactly
  one Conference Edition.
- Each Exhibition Space may be reserved by
  at most one Organisation.
- An Organisation may reserve multiple
  Exhibition Spaces.
- organisation_id is optional (NULL).
- fee >= 0
- All attributes except organisation_id
  are mandatory.

Relationships:
- conference_edition 1:N exhibition_space
- organisation 1:N exhibition_space
  (optional on the exhibition_space side)


## 5. General Modelling Decisions

1. SponsorshipPackage is identified by the
   composite primary key:
   (conference_id, edition_year, name).

2. The sponsorship_acquisition relation
   represents the N:M relationship between
   Organisation and SponsorshipPackage.

3. The primary key of sponsorship_acquisition
   ensures that an Organisation can acquire
   at most one package per Conference Edition.

4. ExhibitionSpace uses an optional
   organisation_id foreign key because
   each space can be reserved by at most
   one Organisation.

5. An Organisation can be both a sponsor
   and an exhibitor in the same edition.

6. Sponsorship and exhibition fees are
   recorded but are not processed through
   registration payments.
