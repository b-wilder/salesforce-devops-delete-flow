#powershell -ExecutionPolicy ByPass -File ./scripts/deleteFlow.ps1 'AppSuite Wizard' AppSuite_Wizard
$flowLabel = $args[0]
$flowApiName = $args[1]
$apexScript = (Get-Content -path scripts\deleteFlowInterviewsTemplate.apex -Raw) -replace '__FLOW_NAME__', $flowLabel
New-Item scripts\deleteFlowInterviews.apex
Set-Content scripts\deleteFlowInterviews.apex "$apexScript"
sfdx force:apex:execute -f scripts\deleteFlowInterviews.apex
Remove-Item scripts\deleteFlowInterviews.apex
$FlowName = $flowApiName + '.flowDefinition-meta.xml'
Rename-Item -Path 'cd\deactivateFlow\Flow_Name.flowDefinition-meta.xml' -NewName "$FlowName"
$FlowPath = 'cd\deactivateFlow\' + $FlowName
sfdx force:source:deploy -p "$FlowPath"
Rename-Item -Path ('cd\deactivateFlow\' + $FlowName) -NewName 'Flow_Name.flowDefinition-meta.xml'
$flowVersions = (sfdx force:data:soql:query -q ('Select VersionNumber, FullName, MasterLabel FROM Flow WHERE MasterLabel = ''' + $flowLabel +'''') -t --json) | ConvertFrom-Json
foreach ($version in $flowVersions.result.records) {
    if($version.FullName.StartsWith($flowApiName) ) {
        sfdx force:source:delete -m ('Flow:' + $flowApiName + '-' + $version.VersionNumber) --noprompt
    }
}