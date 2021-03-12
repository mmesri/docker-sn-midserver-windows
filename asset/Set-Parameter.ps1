# Mandatory Parameters
# ConfigFile: Location of config.xml
# Name: Name of XML Parameter to Update
# Value: Value to Update Selected Parameter

param ([Parameter(Mandatory)]$ConfigFile, [Parameter(Mandatory)]$Name, [Parameter(Mandatory)]$Value)
$xmlDoc = [System.Xml.XmlDocument](Get-Content $ConfigFile)
$nodes = $xmlDoc.SelectNodes("/parameters/parameter")

# Search For Uncommented Parameter And Update Value
foreach($node in $nodes) {
	if ($node.GetAttribute("name") -eq $Name) {
		$node.SetAttribute("value", $Value)
		$xmlDoc.Save($ConfigFile)
		return
	}
}

# If Uncommented Parameter Does Not Exist, Create New Parameter With Name/Value
$newXmlParameter = $xmlDoc.parameters.AppendChild($xmlDoc.CreateElement("parameter"))
$newXmlParameter.SetAttribute("name", $Name)
$newXmlParameter.SetAttribute("value", $Value)
$xmlDoc.Save($ConfigFile)
