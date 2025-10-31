<#
    Abre rapidamente um conjunto de apps/sites de trabalho.

    Parâmetros:
      -Apps (string[])
          Lista de apps/atalhos predefinidos: edge, chrome, teams, outlook, explorer
      -Urls (string[])
          URLs adicionais para abrir no navegador padrão
      -DelayMs (int)
          Atraso em ms entre aberturas (padrão: 200)

    Exemplos:
      powershell -NoProfile -File .\Open-WorkApps.ps1 -Apps edge,teams -Urls "https://chatgpt.com/","https://outlook.office.com/mail/"

    Stream Deck (Ação "Abrir"):
      Programa:
        powershell.exe
      Argumentos:
        -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Open-WorkApps.ps1" -Apps edge,teams -Urls "https://chatgpt.com/"
#>

param(
    [string[]]$Apps = @(),
    [string[]]$Urls = @(),
    [int]$DelayMs = 200
)

function Open-App {
    param([string]$name)
    switch ($name.ToLower()) {
        'edge'     { Start-Process 'msedge.exe' | Out-Null }
        'chrome'   { Start-Process 'chrome.exe' | Out-Null }
        'teams'    { Start-Process 'ms-teams:' | Out-Null }
        'outlook'  { Start-Process 'outlook:' | Out-Null }
        'explorer' { Start-Process 'explorer.exe' | Out-Null }
        default    { Write-Output "App desconhecido: $name" }
    }
}

foreach ($a in $Apps) {
    try { Open-App -name $a } catch { Write-Error "Falha ao abrir app '$a': $($_.Exception.Message)" }
    if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
}

foreach ($u in $Urls) {
    try { Start-Process $u | Out-Null } catch { Write-Error "Falha ao abrir URL '$u': $($_.Exception.Message)" }
    if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
}

Write-Output "Apps: $([string]::Join(',', $Apps)) | URLs: $([string]::Join(',', $Urls))"


