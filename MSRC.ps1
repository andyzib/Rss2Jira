# This started out as testing reading feeds but turned into a parser for the MSRC feed. 
# May end up neededing a full parser for every feed. 

$ConfigFile = "C:\Users\azbikowski\Code\GitHub\Rss2Jira\Conf\Feeds\MSRC.json"
$Conf = Get-Content $ConfigFile | ConvertFrom-Json
#$rss = "https://blogs.technet.microsoft.com/msrc/feed/"
$result = [xml](Invoke-WebRequest $Conf.RSS)
#$result.rss.channel.item | Select-Object @{Name="Id";Expression={$_."post-id".InnerText}}, title, link, pubDate
$MatchedRSSItems = @()

$result.rss.channel.item | ForEach-Object {
    # title, link, comments, pubDate, creator, category, guid, descript, encoded, commentRss
    Write-Host $_.title
    $result = $_ | select-object title,link,pubDate,@{Name="Categories";Expression={[string]::join(";",($_.category.OuterXml))}}
    $RssCategories = $result.Categories
    #Write-Host "Categories: $RssCategories"
    $match = $false
    ForEach ($Trigger in $Conf.Triggers) {
        if ($RssCategories -like "*$Trigger*" ) {
            # Tags matched, we should use this one. 
            #Write-Host "$RssCategories contains $Trigger" -ForegroundColor Green
            $match = $true
        } 
    }

    if ($match) {
        $MatchedRSSItems += $_
        $match = $false
        #Write-Host "Added item to array."
    }
}

Write-Host "Matched Items"
$MatchedRSSItems | Format-List
# Now deal with matched items. 

if ( !(Test-Path -Path $Conf.TrackingFile -PathType Leaf) ) {
    New-Item -ItemType "file" -Path $Conf.TrackingFile
}

ForEach ($RSSItem in $MatchedRSSItems) {
    Write-Host 

    if( Select-String -Path $Conf.TrackingFile -Pattern $RSSItem.guid.OuterXml -SimpleMatch -Quiet )
    {
        Write-Host "Tracking File Contains String $($RSSItem.title)" -ForegroundColor Green
    }
    else
    {
        Write-Host "Tracking File DOES NOT Contain String $($RSSItem.title)" -ForegroundColor Red
        Add-Content -Path $Conf.TrackingFile -Value $RSSItem.guid.OuterXml 
    }
    # Write GUID to a file. 
    #$MatchedRSSItems[0].guid.OuterXml
    #$RSSItem | fl
    # title, link, pubDate, encoded
}