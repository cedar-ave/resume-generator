# resume-generator

Job seekers work hard to customize a resume for every job application. Each bullet is written carefully to include keywords from the job description and follow advised structures like Google's XYZ format ("Accomplished [X] as measured by [Y], by doing [Z]").

Without a way to catalog those carefully written bullets so they can be modified and reused, work is lost and repeated.

Use this tool to capture your best bullets and tag them with keywords, organizations, and roles. To generate a resume, enter keywords from the job description and run a script that populates a template with bullets that match those keywords. The template is output as a Word document. You can then further tailor the Word document to match the job description and refine it.

The tool also generates a personal summary and list of skills if desired.

## How it works

This tool runs on Jekyll, a static-site generator that allows content to be catalogued and populated in templates. However, this tool's purpose isn't to generate a website - it only uses the content management features Jekyll offers.

A `_data` directory in Jekyll contains three files: `bullets.yaml`, `skills.yaml`, and `summary.yaml`. 

A Markdown file in `resumes` is blank except for a customizable metadata header. Enter keywords, separated by a space, for each section of your resume.

Liquid logic in `_layouts/default.html` draws the content tagged with those keywords into the appropriate places in the template. Personalized information (organizations, roles, schools, etc.) are also drawn in from `_includes`.

The Pandoc tool references the Word styles in the `reference.docx` file at root to generate a Word doc with the content in the Jekyll template.

## How to use it

### Install tools

1. Clone this repo.
2. [Install Jekyll](https://jekyllrb.com/docs/installation).
3. [Install Pandoc](https://pandoc.org/installing.html).

### Customize the repo

1. Customize the files in `_includes/1--top`.
2. Add your employers' names as separate files in `_includes/4--organizations`. Following is an example if you've worked for ABC Data, DEF Analytics, and GHI Healthcare:
   - name: `abcData.md` | contents: `### ABC Data, \| Salt Lake City, Utah`
   - name: `defAnalytics.md` | contents: `### DEF Analytics \| Phoenix, Arizona`
   - name: `ghiHealthcare.md` | contents: `### GHI Healthcare \| Denver, Colorado`
3. Add your roles as separate files in `_includes/5--roles`. Following is an example if you've been a Principal Developer and Senior Software Developer for ABC Data, a Software Developer for DEF Analytics, and a Junior Software Engineer for GHI Healthcare:
   - name: `principalDeveloper.md` | contents: `#### Principal Developer \| 2019–Present`
   - name: `seniorSoftwareDeveloper.md` | contents: `#### Senior Software Developer \| 2017–2019`
   - name: `softwareDeveloper.md` | contents: `#### Software Developer \| 2014–2017`
   - name: `juniorSoftwareEngineer.md` | contents: `#### Junior Software Engineer \| 2010–2014`
4. Customize `_includes/6--education/education.md`.


### Add bullets and tags

In `_data/bullets.yaml`, assign tags, an organization, and role to each bullet. You can add multiple organizations or roles to an item but they may be duplicated on output. Add spaces between words, not commas.

For example:

```
- item: >-
    Enable developers to build custom applications on a data platform by providing a REST and .NET API documentation portal, including overviews, tutorials, and reference documentation
  tags: api developers documentation dotnet
  organization: abcData
  role: principalDeveloper

- item: >-
    Enable technical users of a suite of data platform applications to transform, govern, secure, and analyze data by producing and managing technical support content like install and user guides, help articles, tutorials, illustrations, videos, release notes, blog posts, emails, UI announcements, and more
  tags: content guides release-notes documentation
  organization: defAnalytics
  role: softwareDeveloper
```

To automatically generate sections with a summary and technical skills, fill out `_data/summary.yaml` and `_data/skills.yaml`.

### Create a file for your new resume

Create a Markdown file in the `resumes` directory named for the organization and/or role you're applying to (e.g., `jklEyewear.md`), add a metadata header like the following.

Enter the keywords from the description of the job you're applying to next to a variable name for each role (separated by spaces).

For example, if the job description includes a requirement for deep knowledge of Azure products, and assuming you added the `azure` tag next to bullets in `_data/bullets.yaml`, each of those bullets populate in the output file beneath the heading for the role you specified in the variable (and in turn added in the template). If the organization is an Azure shop and you don't want to use up bullets talking about your Atlassian experience, don't include an Atlassian tag.

```
---
layout: default
date: 2023-12-06
summaryTags: api
principalDeveloperTags: api azure .net
seniorSoftwareDeveloperTags: api jira csharp
softwareDeveloperTags: aws javascript
juniorSoftwareEngineerTags: python 
skillsTags: api azure
---
```

### Customize the template file

Following is an example of the code needed in `_layouts/default` under each section for a role.

The logic is:
For bullets in `_data/bullets.yaml` that:
1. Include `abcData` in `organization` (see `item.organization == "abcData"`)
2. Include `principalDeveloper` in `role` (see `item.role == "principalDeveloper"`)
3. Include one or more tags that match tags in the metadata header of `resumes/{resume}.md` (see `for principalDeveloperTag in page.principalDeveloperTags`)
Collect them in a list (see `{{ bullet }}`).

```
{% capture abcData %}{% include 4--organizations/abcData.md %}{% endcapture %}
{{ abcData | markdownify }}

{% capture principalDeveloper %}{% include 5--roles/principalDeveloper.md %}{% endcapture %}
{{ principalDeveloper | markdownify }}

<ul>
    {% assign bullets = "" | split: ',' %}
    {% for item in site.data.bullets %}
    {% if item.organization == "abcData" and item.role == "principalDeveloper" %}
    {% assign a_group = item.tags | split: ' ' %}
    {% for principalDeveloperTag in page.principalDeveloperTags %}
    {% assign b_group = principalDeveloperTag | split: ' ' %}
    {% endfor %}
    {% for a in a_group %}
    {% for b in b_group %}
    {% if a == b %}
    {% assign bullets = bullets | push: item.item %}
    {% endif %}
    {% endfor %}
    {% endfor %}
    {% endif %}
    {% endfor %}
    {% capture list %}
    {% assign array = bullets | uniq %}
    {% for value in array %}
    <li>{{ value | split: "" }}</li>
    {% endfor %}
    {% endcapture %}
    {% for bullet in list %}
    {{ bullet }}
    {% endfor %}
</ul>
```

### Generate the resume

1. Run `bundle exec jekyll serve` at root.

2. Run `./pandoc.sh` at root.

The Word document is output in the `output` directory. To modify the styles, modify `reference.docx`. See `--reference-doc` in the [Pandoc User Guide](https://pandoc.org/MANUAL.html).
