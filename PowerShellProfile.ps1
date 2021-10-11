
Import-Module Terminal-Icons
# Set this alias every time PowerShell launches so I stop mistyping code-insiders
Set-Alias code code-insiders

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

# Get-AzContext -ListAvailable | ? account -like '*knox*'| Set-AzContext

function Update-Nvim {
    if (((nvim -v) -split "`n")[0] -ne ((Invoke-RestMethod 'https://api.github.com/repos/neovim/neovim/releases/tags/nightly').body -split "`n")[2]) {
        Invoke-WebRequest https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip -OutFile $env:TEMP\nvim.zip
        Expand-Archive $env:TEMP\nvim.zip C:\tools\neovim -Force
    }
    else {
        Write-Host -ForegroundColor Green "nvim currently up to date."
    }
}

Set-Alias -Name e -Value nvim-qt
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# function vagrant {
#     & vagrant.exe $args | ForEach-Object {
#         write-host -ForegroundColor blue -NoNewline "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] "
#         write-host $_
#     }
# }

Invoke-Expression (&starship init powershell)

function cleangit {
    $hasOcgv = Get-Command Out-ConsoleGridView
    if($null -ne $hasOcgv){
        Write-Error "Out-ConsoleGridView not found on your system. This won't work."
    }
    $files = git clean -xdn | % { $_ -replace "Would remove ", "" } |  Out-ConsoleGridView
    Invoke-Expression "& git clean -xdf -e $($files -join " -e ")"

}

function config{
     git --git-dir ${env:USERPROFILE}\configurations --work-tree ${env:USERPROFILE} $args
}
