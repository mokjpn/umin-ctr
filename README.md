# umin-ctr: a npm package to retrieve UMIN-CTR(Clinical Trial Registry) information by trial id.

## Description

UMIN-CTR is a part of Japanese primary clinical trial registry. This is an unofficial UMIN-CTR client that can be used to obtain trial information by its ID.

For more information of Clinical Trial Registry, please refer to WHO International Clinical Trials Registry Platform (ICTRP): http://www.who.int/ictrp/en/

UMIN-CTR is located at http://www.umin.ac.jp/ctr/index.htm

## Installation

```
$ npm install mokjpn/umin-ctr
```

## Usage

1. Create CTR object by loading umin-ctr npm package from this GitHub repository.

```
$ node
> ctr = require('umin-ctr')
```

2. Call CTR to search a clinical trial information from its identifier.

CTR object takes three arguments: 'trial identifier', 'registration number', and 'callback function'.

The first argument of the function should be identifier given by UMIN-CTR (this should begin from "UMIN" prefix).

If you have 'Receipt number' given by UMIN-CTR (this should begin from "R" prefix), you can specify it as the second argument. Either the identifier or the receipt number is required.

Because the server-side script directly accepts receipt number, the result will be obtained faster when called by receipt number.

Since this script retrieves trial information via HTTP, the result will be passed as the argument of callback function which should be given as the third argument.

3. The information for the specified trial will be passed to the callback function as a JSON object.

By the example below, the trial that has 'UMIN000001159' as the identifier (I made some of statistics work for this trial) will be retrieved, then the information will be dumped to console.

```
> ctr('UMIN000001159', '', function(trial) { console.log(JSON.stringify(trial));});
```

## Trial object

The information of trials will be retrieved as a JSON object. This table describes its properties.
Some of properties are corresponding to [WHO Trial Registration Data Set](http://www.who.int/ictrp/network/trds/en/).

 Name of property | Field Description in UMIN-CTR | Corresponding item of WHO Trial Data set
------------------|-------------------------------|----------------------------------------
title | Official scientific title of the study (In Japanese) | N/A
title_en | Official scientific title of the study (In English) | Public title
subtitle | Title of the study (Brief title) (In Japanese) | N/A
subtitle_en | Title of the study (Brief title) (In English) | N/A
id | Unique ID issued by UMIN | Trial Identifying Number(Main ID): Register ID(JPRN) is prefixed
URL | Link to view the Japanese page | N/A
URL_en | Link to view the English page | N/A
rid | Receipt No. of UMIN-CTR | N/A
pubdate | Date of disclosure of the study information | Date of Registration in Primary Registry
progress | Recruitment status | Recruitment Status
contact.mail | Public Contact (Email) | Contact for Public Queries (Email)
contact.name | Public Contact (Name of contact person, in Japanese) | N/A
contact.name_en | Public Contact (Name of contact person, in English) | Contact for Public Queries (Name)
contact.org | Public Contact (Organization, in Japanese) | N/A
contact.org_en | Public Contact (Organization, in English) | Contact for Public Queries (Affiliation)
objective.objective1 | Narrative objectives1 (In Japanese) | N/A
objective.objective1_en | Narrative objectives1 (In English) | N/A
objective.objective2 | Basic objectives2 | N/A
outcome.primary | Primary outcomes (In Japanese) | N/A
outcome.primary_en |  Primary outcomes (In English) | Primary Outcome(s)
outcome.secondary | Key secondary outcomes (In Japanese) | N/A
outcome.secondary_en | Key secondary outcomes (In English) |Key Secondary Outcomes
design.type | Study type | Study type
design.basic | Basic design | Study design
design.randomization | Randomization | Study design
design.randomizationunit | Randomization unit | Study design
design.blinding | Blinding | Study design
design.control | Control | Study design
design.stratification | Stratification (In randomization) | Study design
design.dynamic | Dynamic allocation (In randomization)| Study design
design.institutionblock | Institution Consideration (In block randomization) | Study design
design.blocking | Blocking (In randomization) | Study design
design.concealment | method to conceal assignment | Study design
eligibility.samplesize | Target Sample Size | Target Sample Size
eligibility.inclusion | Key inclusion criteria (In Japanese) | N/A
eligibility.inclusion_en | Key inclusion criteria (In English) | Key Inclusion and Exclusion Criteria
eligibility.exclusion | Key exclusion criteria (In Japanese) | N/A
eligibility.exclusion_en | Key exclusion criteria (In English) | Key Inclusion and Exclusion Criteria
relinfo.other | Other related information (In Japanese), which may contain relationship to other trials.| N/A
relinfo.other_en | Other related information (In English)| N/A
intervention.narms | Number of arms | N/A
intervention.purpose | Purpose of intervention | Intervention(s)
intervention.type | Type of intervention | Intervention(s)
interventions(Array) | Description of interventions (In Japanese) | N/A
interventions_en(Array) | Description of interventions (In English) | Interventions(s)
