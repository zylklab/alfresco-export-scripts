# Alfresco Export Scripts

Alfresco shell scripts for extracting user, groups, sites, data and metadata information from Alfresco repository. For the extraction of metadata information it is needed to deploy a webscript in Alfresco Repository.

## Table of Contents
- [Installation](#installation)
- [Environment vars](#environment-vars)
- [Bulk Export Scripts](#bulk-export-scripts)
- [Other helper Scripts](#other-helper-scripts)
- [Tested on](#tested-on)
- [Author](#author)
- [Links](#links)

## Installation

For running the shell scripts we need curl, wget, sed and jq shell utilities on the command line. For using metadata extraction, we need to deploy a webscript in /Data Dictionary/Webscripts/net/zylk

 * export-bulk-metadata.get.desc.xml
 * export-bulk-metadata.get.js
 * export-bulk-metadata.get.text.ftl

and then, to refresh Webscripts in /alfresco/service/index page.

## Environment vars

Originally each shell script was provided with parameters in the command line (-h <alfrescourl> -u <user> -p <password>). For making easy the script execution we provide exportENVARS.sh that may be used according to your environment, every script invokes it.
```
$ cat exportENVARS.sh

#! /bin/bash
export ALFURL=http://localhost:8080/alfresco
export MYUSER=admin
export MYPASS=secret
```

## Bulk Export Scripts

The following two scripts (downloadSite.sh and getMetadata.sh) are needed to extract Alfresco documents and their corresponding metadata from repository. For running getMetadata.sh properly we need to deploy export-bulk-metadata webscript in Alfresco Server.

Note: A better approach is probably done with [Alfresco Bulk Export Module](https://github.com/vprince1/alfresco-bulk-export) but it only works from Alfresco 4.2 (JDK7 needed).

### downloadSite.sh

It downloads a site (-s) or a given repository folder (-f) via wget using webdav,

```
$ ./downloadSite.sh
Usage: ./downloadAlfrescoSite.sh [-s <site-shortname>] | [-f <folder>]
```
  
For downloading the example site in Alfresco (Web Site Design Project):

```  
$ ./downloadSite.sh -s swsdp
```

```
├── webdav
│   └── Sitios
│       └── swsdp
│           └── documentLibrary
│               ├── Agency Files
│               │   ├── Contracts
│               │   │   └── Project Contract.pdf
│               │   ├── Images
│               │   │   ├── coins.JPG
│               │   │   ├── graph.JPG
│               │   │   ├── grass.jpg
│               │   │   ├── header.png
│               │   │   ├── low consumption bulb.png
│               │   │   ├── money.JPG
│               │   │   ├── plugs.jpg
│               │   │   ├── turbine.JPG
│               │   │   ├── windmill.png
│               │   │   ├── wind turbine.JPG
│               │   │   └── wires.JPG
│               │   ├── Logo Files
│               │   │   ├── GE Logo.png
│               │   │   └── logo.png
│               │   ├── Mock-Ups
│               │   │   ├── sample 1.png
│               │   │   ├── sample 2.png
│               │   │   └── sample 3.png
│               │   └── Video Files
│               │       └── WebSiteReview.mp4
│               ├── Budget Files
│               │   ├── budget.xls
│               │   └── Invoices
│               │       ├── inv I200-109.png
│               │       └── inv I200-189.png
│               ├── Meeting Notes
│               │   ├── Meeting Notes 2011-01-27.doc
│               │   ├── Meeting Notes 2011-02-03.doc
│               │   └── Meeting Notes 2011-02-10.doc
│               └── Presentations
│                   ├── Project Objectives.ppt
│                   └── Project Overview.ppt
```

### getMetadata.sh

It gets metadata files (needed for a bulk import) of a previously downloaded site or folder.

```
$ ./getAlfrescoMetadata.sh
Usage: ./getAlfrescoMetadata.sh [-f <local-webdav-folder>]

$ ./getAlfrescoMetadata.sh -f webdav
```

generating the corresponding metadata.properties.xml foreach document and folder.

```
├── webdav
│   ├── Sitios
│   │   ├── swsdp
│   │   │   ├── documentLibrary
│   │   │   │   ├── Agency Files
│   │   │   │   │   ├── Contracts
│   │   │   │   │   │   ├── Project Contract.pdf
│   │   │   │   │   │   └── Project Contract.pdf.metadata.properties.xml
│   │   │   │   │   ├── Contracts.metadata.properties.xml
│   │   │   │   │   ├── Images
│   │   │   │   │   │   ├── coins.JPG
│   │   │   │   │   │   ├── coins.JPG.metadata.properties.xml
│   │   │   │   │   │   ├── graph.JPG
│   │   │   │   │   │   ├── graph.JPG.metadata.properties.xml
│   │   │   │   │   │   ├── grass.jpg
│   │   │   │   │   │   ├── grass.jpg.metadata.properties.xml
│   │   │   │   │   │   ├── header.png
│   │   │   │   │   │   ├── header.png.metadata.properties.xml
│   │   │   │   │   │   ├── low consumption bulb.png
│   │   │   │   │   │   ├── low consumption bulb.png.metadata.properties.xml
│   │   │   │   │   │   ├── money.JPG
│   │   │   │   │   │   ├── money.JPG.metadata.properties.xml
│   │   │   │   │   │   ├── plugs.jpg
│   │   │   │   │   │   ├── plugs.jpg.metadata.properties.xml
│   │   │   │   │   │   ├── turbine.JPG
│   │   │   │   │   │   ├── turbine.JPG.metadata.properties.xml
│   │   │   │   │   │   ├── windmill.png
│   │   │   │   │   │   ├── windmill.png.metadata.properties.xml
│   │   │   │   │   │   ├── wind turbine.JPG
│   │   │   │   │   │   ├── wind turbine.JPG.metadata.properties.xml
│   │   │   │   │   │   ├── wires.JPG
│   │   │   │   │   │   └── wires.JPG.metadata.properties.xml
│   │   │   │   │   ├── Images.metadata.properties.xml
│   │   │   │   │   ├── Logo Files
│   │   │   │   │   │   ├── GE Logo.png
│   │   │   │   │   │   ├── GE Logo.png.metadata.properties.xml
│   │   │   │   │   │   ├── logo.png
│   │   │   │   │   │   └── logo.png.metadata.properties.xml
│   │   │   │   │   ├── Logo Files.metadata.properties.xml
│   │   │   │   │   ├── Mock-Ups
│   │   │   │   │   │   ├── sample 1.png
│   │   │   │   │   │   ├── sample 1.png.metadata.properties.xml
│   │   │   │   │   │   ├── sample 2.png
│   │   │   │   │   │   ├── sample 2.png.metadata.properties.xml
│   │   │   │   │   │   ├── sample 3.png
│   │   │   │   │   │   └── sample 3.png.metadata.properties.xml
│   │   │   │   │   ├── Mock-Ups.metadata.properties.xml
│   │   │   │   │   ├── Video Files
│   │   │   │   │   │   ├── WebSiteReview.mp4
│   │   │   │   │   │   └── WebSiteReview.mp4.metadata.properties.xml
│   │   │   │   │   └── Video Files.metadata.properties.xml
│   │   │   │   ├── Agency Files.metadata.properties.xml
│   │   │   │   ├── Budget Files
│   │   │   │   │   ├── budget.xls
│   │   │   │   │   ├── budget.xls.metadata.properties.xml
│   │   │   │   │   ├── Invoices
│   │   │   │   │   │   ├── inv I200-109.png
│   │   │   │   │   │   ├── inv I200-109.png.metadata.properties.xml
│   │   │   │   │   │   ├── inv I200-189.png
│   │   │   │   │   │   └── inv I200-189.png.metadata.properties.xml
│   │   │   │   │   └── Invoices.metadata.properties.xml
│   │   │   │   ├── Budget Files.metadata.properties.xml
│   │   │   │   ├── Meeting Notes
│   │   │   │   │   ├── Meeting Notes 2011-01-27.doc
│   │   │   │   │   ├── Meeting Notes 2011-01-27.doc.metadata.properties.xml
│   │   │   │   │   ├── Meeting Notes 2011-02-03.doc
│   │   │   │   │   ├── Meeting Notes 2011-02-03.doc.metadata.properties.xml
│   │   │   │   │   ├── Meeting Notes 2011-02-10.doc
│   │   │   │   │   └── Meeting Notes 2011-02-10.doc.metadata.properties.xml
│   │   │   │   ├── Meeting Notes.metadata.properties.xml
│   │   │   │   ├── Presentations
│   │   │   │   │   ├── Project Objectives.ppt
│   │   │   │   │   ├── Project Objectives.ppt.metadata.properties.xml
│   │   │   │   │   ├── Project Overview.ppt
│   │   │   │   │   └── Project Overview.ppt.metadata.properties.xml
│   │   │   │   └── Presentations.metadata.properties.xml
│   │   │   └── documentLibrary.metadata.properties.xml
│   │   └── swsdp.metadata.properties.xml
│   └── Sitios.metadata.properties.xml
```

## Other helper scripts

This helper scripts are examples based on the blog post [Alfresco REST API examples using curl and jq](https://www.zylk.net/es/web-2-0/blog/-/blogs/using-jq-for-parsing-json-documents)
 
Note: A similar approach is done with [Alfresco Shell Tools](https://github.com/ecm4u/alfresco-shell-tools).

### getPeople.sh

It provides a complete list of users of Alfresco repository. With -f option it adds first name, surname and user email.

```
$ ./getPeople.sh
guest
admin
abeecher
mjackson

$ ./getPeople.sh -f
guest,Guest,,
admin,Administrator,,admin@alfresco.com
abeecher,Alice,Beecher,abeecher@example.com
mjackson,Mike,Jackson,mjackson@example.com
```

### getGroups.sh

It gives the list of repository groups. With -f option you may obtain additionally info.

```
$ ./getGroups.sh
ALFRESCO_ADMINISTRATORS
ALFRESCO_MODEL_ADMINISTRATORS
ALFRESCO_SEARCH_ADMINISTRATORS
EMAIL_CONTRIBUTORS
SITE_ADMINISTRATORS
site_swsdp
site_swsdp_SiteCollaborator
site_swsdp_SiteConsumer
site_swsdp_SiteContributor
site_swsdp_SiteManager
```

### getSites.sh

It gives a list with the shortnames of the sites. With -f option you additionally get the visibility and the title of the site.

```
$ ./getSites.sh
swsdp

$ ./getSites.sh -f
swsdp,PUBLIC,Sample: Web Site Design Project
```

### getSiteMemberships.sh

It provides the list of users and roles of a given site (-s <shortname>).

```
$ ./getSiteMemberships.sh
Usage: ./getAlfrescoSiteMemberships.sh [-f | -s <site>]

$ ./getSiteMemberships.sh -s swsdp
swsdp,mjackson,SiteManager
swsdp,admin,SiteManager
swsdp,abeecher,SiteCollaborator
```

With -f option you obtain the full list of users and roles for every site in Alfresco repository.
 
### getUserGroups.sh

```
./getUserGroups.sh
Usage: ./getUserGroups.sh [-f] [-a user]
```

It provides the groups of a given user (-a <user>).

```
$ ./getUserGroups.sh -a admin
GROUP_ALFRESCO_ADMINISTRATORS
GROUP_ALFRESCO_MODEL_ADMINISTRATORS
GROUP_ALFRESCO_SEARCH_ADMINISTRATORS
GROUP_EMAIL_CONTRIBUTORS
GROUP_SITE_ADMINISTRATORS
```

### getAuthority.sh

It provides the users and groups of a given group (-g <group>). With -f option you obtain further details.
```
$ ./getAuthority.sh
Usage: ./getAuthority.sh [-f] [-g <group>]

$ ./getAuthority.sh -g ALFRESCO_ADMINISTRATORS
admin

$ ./getAuthority.sh -g ALFRESCO_ADMINISTRATORS -f
admin,Administrator,Administrator,USER
```

## Tested on

* Alfresco Enterprise 4.1.1
* Alfresco Community 201707GA

## Author

- [Cesar Capillas](http://github.com/CesarCapillas)

## Links

- [Alfresco REST API examples using curl and jq](https://www.zylk.net/es/web-2-0/blog/-/blogs/using-jq-for-parsing-json-documents)
- [Alfresco Bulk Export Module](https://github.com/vprince1/alfresco-bulk-export)
- [Alfresco Shell Tools](https://github.com/ecm4u/alfresco-shell-tools)
