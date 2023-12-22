# resume-generator

Job seekers work hard to customize a resume for every job application. Each bullet that describes what you accomplished in a role is written carefully to include keywords from the job description and follow advised structures like Google's XYZ format ("Accomplished [X] as measured by [Y] by doing [Z]").

Without a way to catalog those carefully written bullets so they can be modified and reused, work is lost and repeated.

Use this tool to capture your best bullets by organizing them with keywords and classifying them by role.

To generate a resume, enter keywords from the job description in the metadata header of a Markdown file and run a script that populates a template with bullets that match those keywords. The template is output as a Word document. You then can tailor and refine the Word document further to match the job description.

The tool also generates a personal summary and list of skills if desired.

## How it works

### Jekyll

This tool runs on Jekyll, a static-site generator that allows content to be catalogued and populated in templates. However, this tool's purpose isn't to generate a website. Rather it only leverages the content management features Jekyll offers.

### Data files

A `_data` directory in Jekyll contains these YAML files:

| File                      | Description                                                                                                           |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------|
| `bullets.yaml`            | Bullets that describe what you accomplished in a role and at which organization and in which role you accomplished it |
| `education.yaml`          | Schools, locations, and degrees                                                                                       |
| `experience.yaml`         | Organizations you've worked at and job titles with an optional emphasis                                               |
| `personal.yaml`           | Name, contact information, links                                                                                      |
| `skills.yaml` (optional)  | Skills like programming languages, software, stacks, etc., to be included in the resume in a **Skills** section       |
| `summary.yaml` (optional) | Introductory sentences about yourself to be included in the resume in a **Summary** section                           |

### Metadata header

One Markdown file per resume in the `resumes` directory is blank except for a customizable metadata header.

The `titleId` fields represent your roles in order. `1`is for your current role, `2` is for your most recent role before that, `3` is for your next most recent role, etc. In the instructions below, these IDs are matched to IDs in `titleId` fields in `_data/experience.yaml` and `data_bullets.yaml`.

Entering `all` in a `tags` field returns all bullets associated with that role regardless of their tags.

```
---
layout: default
fileDate: 2023-12-06
summaryTags: <tags for sentences to include in your personal summary, separated by spaces, that match tags in `summary.yaml`>
skillsTags: <tags for your skills, separated by spaces, that match tags in `skills.yaml`>
experienceTags:
  - titleId: 1
    emphasis: true
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>
  - titleId: 2
    emphasis: false
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>
  - titleId: 3
    emphasis: false
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>
  - titleId: 4
    emphasis: false
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>

---
```

### Liquid logic in a template file

Liquid logic in `_layouts/default.html` draws the tagged content into the appropriate places in the template.

| Resume section | How it's populated |
|----------------|--------------------|
| Personal information | Logic at the top of the file pulls in data from `personal.yaml` to add your name, location, and phone. |
| Portfolio (optional) | Data from `personal.yaml` is pulled in to add a link and password. |
| Summary | Logic pulls in items that match the tags set in the [Metadata header](#metadata-header) in `summaryTags`. |
| Experience | For each organization you've worked at, a heading is created for it. For each of one or more roles you've held at each organization, a heading is created for it. If you add `emphasis: true` in the [Metadata header](#metadata-header), the role's emphasis (designated in `_data/experience.yaml`) is appended. Bullets are added beneath each role that align with the organization, role, and tag(s) set in `bullets.yaml`. |
| Skills | Logic pulls in items that match the tags set in the [Metadata header](#metadata-header) in `skillsTags`. |

### Pandoc

The Pandoc tool uses the customizable Word styles in the `reference.docx` file at root to generate a Word doc with the content generated by the Jekyll template.

## How to use it

### Install tools

1. Clone this repo.
2. [Install Jekyll](https://jekyllrb.com/docs/installation).
3. [Install Pandoc](https://pandoc.org/installing.html).

### Customize the data files

Customize the files in `_data`. Each file can have as many or few items as you want. See [Data files](#data-files) for details on each file. See [Metadata header](#metadata-header) for details on what to enter in the `titleId` fields in `_data/experience.yaml` and `_data/bullets.yaml`.

Important:

- Add spaces between tags, not commas.
- Use the same character string to represent the same information across files, like organizations. The string can have spaces.
- Bullets do not have to be grouped by role or stand in any order.

For example, in `bullets.yaml`:

```
- item: >-
    My resume bullet...
  tags: fullStack sql
  organization: My Current Organization
  titleId: 1

- item: >-
    Another resume bullet...
  tags: security okta javascript
  organization: My Current Organization
  titleId: 1

- item: >-
    Another resume bullet...
  tags: documentation guides release-notes 
  organization: My Current Organization
  titleId: 2

- item: >-
    Another resume bullet...
  tags: jira python dotnet documentation
  organization: My Previous Organization
  titleId: 3
```

### Create a file for your new resume

Create a Markdown file in the `resumes` directory named for the organization and/or role you're applying to (e.g., `Company-Name.md`) and add a metadata header like the example below. What to enter is documented in [Metadata header](#metadata-header).

Enter keywords from the description of the job you're applying to:

- Next to `summaryTags` and `skillsTags` to pull in content relevant to that job
- Next to `tags` beneath each `titleId` (separated by spaces) to pull in bullets that relate most closely to the job

```
---
layout: default
fileDate: 2023-12-06
summaryTags: collaboration learning
skillsTags: azure editorial coding
experienceTags:
  - titleId: 1
    emphasis: true
    tags: fullStack typescript sql javascript
  - titleId: 2
    emphasis: false
    tags: all
  - titleId: 3
    emphasis: false
    tags: jira python dotnet
---
```

### Customize the template file

Customize code in `_layouts/default.html` to change section titles and the order of information.

### Generate the resume

1. Run `bundle exec jekyll serve` at root.
2. Run `./pandoc.sh` at root.

The Word document is output in the `output` directory. The document's styles are drawn from `reference.docx`. To modify the styles, modify `reference.docx`. See `--reference-doc` in the [Pandoc User Guide](https://pandoc.org/MANUAL.html).
