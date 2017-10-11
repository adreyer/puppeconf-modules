#!/usr/bin/env powershell

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true, Position=1)] [String] $TaskPath
)

$BannedParams = @("informationvariable",
    "errorvariable",
    "outvariable",
    "pipelinevariable",
    "warningvariable",
    "outbuffer")


$Metadata = @{ }
$parameters = @{ }
$Metadata.add("parameters", $parameters)

function ParamType($Param) {
  $Req = $Param.attributes.Mandatory
  $PSType = $Param.ParameterType.Name
  $PType = switch ($Param.ParameterType.Name)
    {
      "String" { "String"}
      "String[]" { "Array[String]"}
      "bool" { "Boolean"}
      "bool[]" { "Array[Boolean]"}
      "Int32" { "Integer" }
      "Int32[]" { "Array[Integer]" }
      "Float" { "Float" }
      "Float[]" { "Array[Float]" }
      "Hashtable" { "Hash" }
      "Hashtable[]" { "Array[Hash]" }
      default { "Any" }
    }

    if(!$Param.attributes.Mandatory) {
      $PType = "Optional[$PType]"
    }

   $PType
}

$ParameterList = (Get-Command -Name $TaskPath).Parameters
$Help = Get-Help $TaskPath

$Metadata = @{ }
$parameters = @{ }
$Metadata.add("parameters", $parameters)

if($Help.description) {
  $Metadata.add("description", $Help.description.text)
}


foreach ($Parameter in $ParameterList.values) {
  $ParamName = $Parameter.Name.ToLower()
  if (!($BannedParams -contains $ParamName)){
    $ParamSpec = ParamType($Parameter)
    $parameters.add([String]$ParamName, @{ "type" = $ParamSpec})
  }
}

foreach ($Parameter in $Help.parameters.parameter) {
  if($Parameter.description.text) {
    $ParamName = $Parameter.name.ToLower()
    $spec = $parameters.Get_Item($ParamName)
    $spec.add("description", $Parameter.description.text)
  }
}

$MDPath = ($TaskPath -split "\.")[-2] + ".json"
Set-Content -Path $MDPath -Value (ConvertTo-Json -InputObject $Metadata)
