$modules_to_install = @(
    "scoop-completion"
    "PSReadLine"
    "PSFzf"
    "PSProfiler"
    "PSColors"
    "posh-git"
    "posh-docker"
    "PSWriteColor"
    "Foil"
    "Microsoft.PowerShell.ConsoleGuiTools"
)

foreach ($module in $modules_to_install) {
    Install-Module -Name $module -AllowClobber -AcceptLicense -Force -ErrorAction SilentlyContinue
}