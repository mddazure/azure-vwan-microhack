
##########################################################
## Install IIS role on spoke-1
##########################################################
resource "azurerm_virtual_machine_extension" "install-iis-spoke-1-vm" {
    
  name                 = "install-iis-spoke-1-vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.spoke-1-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
}

##########################################################
## Install IIS role on spoke-2
##########################################################
resource "azurerm_virtual_machine_extension" "install-iis-spoke-2-vm" {
    
  name                 = "install-iis-spoke-2-vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.spoke-2-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
}
##########################################################
## Install IIS role on spoke-3
##########################################################
resource "azurerm_virtual_machine_extension" "install-iis-spoke-3-vm" {
    
  name                 = "install-iis-spoke-3-vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.spoke-3-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
}
##########################################################
## Install IIS role on spoke-4
##########################################################
resource "azurerm_virtual_machine_extension" "install-iis-spoke-4-vm" {
    
  name                 = "install-iis-spoke-4-vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.spoke-4-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
}
##########################################################
## Install IIS role on onprem
##########################################################
resource "azurerm_virtual_machine_extension" "install-iis-onprem-vm" {
    
  name                 = "install-iis-spoke-onprem-vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.onprem-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
}
##########################################################
## Install ADDC role on spoke-addc-vm
##########################################################
resource "azurerm_virtual_machine_extension" "install-spoke-addc-vm" {
    
  name                 = "install-spoke-addc-vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.spoke-addc-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File addc.ps1",
        "fileUris":["https://gist.githubusercontent.com/mddazure/fc3db37583cbfc80852f68a6b38bdc35/raw/d07b82133582199d2032b4d153bc3c696f88644f/addc.ps1"] 
    }
SETTINGS
}
##########################################################
## Enable routing on nva-iptables-vm
##########################################################
resource "azurerm_virtual_machine_extension" "enable-routing-nva-iptables-vm" {
    
  name                 = "enable-routing-nva-iptables-vm"
  virtual_machine_id   = azurerm_linux_virtual_machine.nva-iptables-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

   settings = <<SETTINGS
    {
        "script": "c3VkbyBjaG1vZCA3NzcgL2V0Yy9zeXNjdGwuY29uZgplY2hvICJuZXQuaXB2NC5pcF9mb3J3YXJkID0gMSIgPiAvZXRjL3N5c2N0bC5jb25mCnN1ZG8gc3lzY3RsIC1wIC9ldGMvc3lzY3RsLmNvbmYKc3VkbyBpcHRhYmxlcyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLWQgMTAuMC4wLjAvOCAtaiBBQ0NFUFQKc3VkbyBpcHRhYmxlcyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLWQgMTcyLjE2LjAuMC8xMiAtaiBBQ0NFUFQKc3VkbyBpcHRhYmxlcyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLWQgMTkyLjE2OC4wLjAvMTYgLWogQUNDRVBUCnN1ZG8gaXB0YWJsZXMgLXQgbmF0IC1BIFBPU1RST1VUSU5HIC1vIGV0aDAgLWogTUFTUVVFUkFERQ=="
    }
SETTINGS
}






/*
##########################################################
## Install ADDC role on spoke-addc-vm
##########################################################
resource "azurerm_virtual_machine_extension" "install-spoke-addc-vm" {
    
  name                 = "install-spoke-addc-vm"
  virtual_machine_id   = azurerm_virtual_machine.spoke-addc-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

   settings = <<SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name AD-Domain-Services; powershell -ExecutionPolicy Unrestricted Install-ADDSForest -DomainName micro-hack.local -SafeModeAdministratorPassword (ConvertTo-SecureString -String \"microhack-12345%\" -AsPlainText -Force) -Force -SkipPreChecks"
    }
SETTINGS
}
*/

