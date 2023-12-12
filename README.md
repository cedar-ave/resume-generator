# resume-generator

Job seekers work hard to customize a resume for every job application. Each bullet that describes what you accomplished in a role is written carefully to include keywords from the job description and follow advised structures like Google's XYZ format ("Accomplished [X] as measured by [Y], by doing [Z]").

Without a way to catalog those carefully written bullets so they can be modified and reused, work is lost and repeated.

Use this tool to capture your best bullets and assign them keywords, organizations, and roles. To generate a resume, enter keywords from the job description and run a script that populates a template with bullets that match those keywords. The template is output as a Word document. You can then further tailor the Word document to match the job description.

The tool also generates a personal summary and list of skills if desired.

## How it works

### Jekyll

This tool runs on Jekyll, a static-site generator that allows content to be catalogued and populated in templates. However, this tool's purpose isn't to generate a website - it only uses the content management features Jekyll offers.

### Data files

A `_data` directory in Jekyll contains these YAML files:

| File | Description |
|------|-------------|
| `bullets.yaml` | Bullets that describe what you accomplished in a role and at which organization and in which role you accomplished it |
| `education.yaml` | Schools, locations, and degrees |
| `experience.yaml` | Organizations where you've worked and job titles |
| `personal.yaml` | Name, contact information, links |
| `skills.yaml` (optional) | Skills like programming languages, software, stacks, etc., to be included in the resume in a **Skills** section |
| `summary.yaml` (optional) | Introductory sentences about yourself to be included in the resume in a **Summary** section |

### Metadata header

One Markdown file per resume in the `resumes` directory is blank except for a customizable metadata header:

```
---
layout: default
fileDate: 2023-12-06
tagKeys:
  - tagKey: summary
    tags: <tags for sentences to include in your personal summary, separated by spaces, that match tags in `summary.yaml` >
  - tagKey: <a tag representing the name of your most recent role>
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>
  - tagKey: <a tag representing the name of your second most recent role>
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>
  - tagKey: <a tag representing the name of your third most recent role>
    tags: <tags representing what you did in the role, separated by spaces, that match tags in `bullets.yaml`>
  - tagKey: skills
    tags: <tags for your skills, separated by spaces, that match tags in `skills.yaml` >
---
```

### Liquid logic in a template file

Liquid logic in `_layouts/default.html` draws the tagged content into the appropriate places in the template.

| Resume section | How it's populated |
|----------------|--------------------|
| Personal information | Logic at the top of the file pulls in data from `personal.yaml` to add your name, location, and phone. |
| Portfolio (optional) | Data from `personal.yaml` is pulled in to add a link and password. |
| Summary | Logic pulls in items that match the tags set in the [Metadata header](#metadata-header) under `tagKey: summary`. |
| Experience | For each organization you've worked at, a heading is created for it. For each of one or more roles you've held at each organization, a heading is created for it. Bullets are added beneath each role that align with the organization, role, and tag(s) set in `bullets.yaml`. |
| Skills | Logic pulls in items that match the tags set in the [Metadata header](#metadata-header) under `tagKey: skills`. |

### Pandoc

The Pandoc tool uses the customizable Word styles in the `reference.docx` file at root to generate a Word doc with the content generated by the Jekyll template.

## How to use it

### Install tools

1. Clone this repo.
2. [Install Jekyll](https://jekyllrb.com/docs/installation).
3. [Install Pandoc](https://pandoc.org/installing.html).

### Customize the data files

Customize the files in `_data`. Each file can have as many or few items as you want. See [Data files](#data-files) for details on each file.

Important:
- Add spaces between tags, not commas.
- Use the exact same character string to represent the same information across files, like organizations and titles. The string can have spaces.

For example, in `bullets.yaml`:

```
- item: >-
    Enable developers to build custom applications on a data platform by providing a REST and .NET API documentation portal, including overviews, tutorials, and reference documentation
  tags: api developers documentation dotnet
  organization: My Current Organization
  title: Content Developer

- item: >-
    Enable technical users of a suite of data platform applications to transform, govern, secure, and analyze data by producing and managing technical support content like install and user guides, help articles, tutorials, illustrations, videos, release notes, blog posts, emails, UI announcements, and more
  tags: content guides release-notes documentation
  organization: My Current Organization
  title: Technical Editor
```

### Create a file for your new resume

Create a Markdown file in the `resumes` directory named for the organization and/or role you're applying to (e.g., `XYZ_Eyewear.md`), add a metadata header like the example below. What to enter is documented in [Metadata header](#metadata-header).

Enter the keywords from the description of the job you're applying to next to a variable name for each role (separated by spaces). Note that items for `summary` and `skills` already exist.

---
layout: default
fileDate: 2023-12-06
tagKeys:
  - tagKey: summary
    tags: api azure frontEnd
  - tagKey: My Current Organization
    tags: fullStack typescript sql
  - tagKey: My Previous Organization
    tags: jira python .net
  - tagKey: skills
    tags: sql security okta
---

### Customize the template file

Customize code in `_layouts/default` to change section titles and the order of information.

### Generate the resume

1. Run `bundle exec jekyll serve` at root.

2. Run `./pandoc.sh` at root.

The Word document is output in the `output` directory. To modify the styles, modify `reference.docx`. See `--reference-doc` in the [Pandoc User Guide](https://pandoc.org/MANUAL.html).
