#powershell -ExecutionPolicy ByPass -File ./scripts/deleteFlow.ps1 'AppSuite Wizard' AppSuite_Wizard
$apexScript = (Get-Content -path scripts\deleteFlowInterviewsTemplate.apex -Raw) -replace '__FLOW_NAME__', $args[0]
New-Item scripts\deleteFlowInterviews.apex
Set-Content scripts\deleteFlowInterviews.apex "$apexScript"
sfdx force:apex:execute -f scripts\deleteFlowInterviews.apex
Remove-Item scripts\deleteFlowInterviews.apex
$FlowName = $args[1] + '.flowDefinition-meta.xml'
Rename-Item -Path 'cd\deactivateFlow\Flow_Name.flowDefinition-meta.xml' -NewName "$FlowName"
$FlowPath = 'cd\deactivateFlow\' + $FlowName
sfdx force:source:deploy -p "$FlowPath"
Rename-Item -Path ('cd\deactivateFlow\' + $FlowName) -NewName 'Flow_Name.flowDefinition-meta.xml'