# rss2jira Database

## Table: Feeds
FeedID PK
FeedURL String
Channel
Title
Description
Link
Enabled

## Table: FeedItems
FeedID FK
pubDate PK
guid PK
title
description
link
JiraIssueKey

## Table: JiraCredentials
JiraCredentialID PK
JiraURL PK
JiraUser PK
CreatedBy String ($env:USERDOMAIN\$env:USERNAME)
JiraSecureString
https://blog.kloud.com.au/2016/04/21/using-saved-credentials-securely-in-powershell-scripts/

## Table: SchemaVersion
Major INT
Minor INT
Point INT

# rss2jira Functions
* Add-rss2jriafeed
* Enable-rss2jriafeed
* Disable-rss2jriafeed
* Remove-rss2jriafeed
* Update-rss2jirafeeds
* Show-rss2jirafeeds
* Set-rss2jiracredentials
* Set-rss2jiracredentials
* Create-rss2jiradatabase

# Requirments
* PowerShell 5
* PSSQLite Module
* PSJira Module
* Configuring the PSJira Module

# Starting Code
$feedurl='https://www.citrix.com/content/citrix/en_us/downloads/xenapp-and-xendesktop.rss'
$chfeed = [xml](Invoke-WebRequest $feedurl)
$chfeed.rss.channel.item | Select-Object @{Name="Id";Expression={$_."post-id".InnerText}}, title, link, pubDate

