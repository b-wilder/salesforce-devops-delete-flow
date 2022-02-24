#powershell -ExecutionPolicy ByPass -File ./scripts/deleteFlow.ps1 'AppSuite Wizard'
$apexScript = (Get-Content -path scripts\deleteFlowInterviews.apex -Raw) -replace '__FLOW_NAME__', $args[0]