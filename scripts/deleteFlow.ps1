#powershell -ExecutionPolicy ByPass -File ./scripts/deleteFlow.ps1 'AppSuite Wizard'
$apexScript = (Get-Content -path scripts\deleteFlowInterviewsTemplate.apex -Raw) -replace '__FLOW_NAME__', $args[0]
New-Item scripts\deleteFlowInterviews.apex
Set-Content scripts\deleteFlowInterviews.apex "$apexScript"
sfdx force:apex:execute -f scripts\deleteFlowInterviews.apex