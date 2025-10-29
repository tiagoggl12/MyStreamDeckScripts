<#
    Copia para a área de transferência o(s) caminho(s) do(s) item(ns)
    atualmente selecionado(s) na janela ativa do Windows Explorer.
    Se nada estiver selecionado, por padrão copia o caminho da pasta atual.

    Parâmetros:
      -UseCurrentFolderIfNoSelection (switch)
          Quando não houver seleção, usa a pasta atual (padrão: True).
      -Join (newline|space|semicolon)
          Forma de juntar múltiplos caminhos (padrão: newline).
      -NoQuotes (switch)
          Não envolve os caminhos em aspas. Por padrão, os caminhos são
          colocados entre aspas (útil para caminhos com espaços).

    Exemplos:
      powershell -NoProfile -File .\Copy-SelectedPath.ps1
      powershell -NoProfile -File .\Copy-SelectedPath.ps1 -NoQuotes
      powershell -NoProfile -File .\Copy-SelectedPath.ps1 -Join space
      powershell -NoProfile -File .\Copy-SelectedPath.ps1 -UseCurrentFolderIfNoSelection:$false

    Integração com Stream Deck (Ação "Abrir"):
      Programa:
        powershell.exe
      Argumentos:
        -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Copy-SelectedPath.ps1"
#>

param(
    [switch]$UseCurrentFolderIfNoSelection = $true,
    [ValidateSet('newline','space','semicolon')]
    [string]$Join = 'newline',
    [switch]$NoQuotes
)

# Obtém o identificador (handle) da janela em foco no momento
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

$fgHandle = [int]([Win32]::GetForegroundWindow())

# Acessa as janelas do Explorer via COM (Shell.Application)
$shell = New-Object -ComObject Shell.Application
$targetWindow = $null

try {
    # Tenta encontrar a janela cujo HWND coincide com a janela em foco
    foreach ($w in $shell.Windows()) {
        try {
            if ($w -and ($w.HWND -eq $fgHandle)) { $targetWindow = $w; break }
        } catch {}
    }

    # Fallback: se não encontrou a ativa, mas há exatamente um Explorer aberto, usa-o
    if (-not $targetWindow) {
        $explorers = @()
        foreach ($w in $shell.Windows()) {
            try {
                if ($w -and $w.Document) { $explorers += $w }
            } catch {}
        }
        if ($explorers.Count -eq 1) { $targetWindow = $explorers[0] }
    }
} catch {}

if (-not $targetWindow) {
    # Sem janela válida do Explorer, encerra com erro
    Write-Error "Nenhuma janela ativa do Explorador foi encontrada."
    exit 1
}

$doc = $targetWindow.Document
$selected = @()
try { $selected = @($doc.SelectedItems()) } catch {}

$paths = @()
if ($selected.Count -gt 0) {
    # Há itens selecionados: coleta os caminhos
    foreach ($item in $selected) { if ($item -and $item.Path) { $paths += $item.Path } }
} elseif ($UseCurrentFolderIfNoSelection) {
    # Sem seleção e permitido usar a pasta atual: usa o caminho da pasta
    try { if ($doc.Folder -and $doc.Folder.Self -and $doc.Folder.Self.Path) { $paths += $doc.Folder.Self.Path } } catch {}
}

if ($paths.Count -eq 0) {
    # Ainda sem nada para copiar: informa erro e sai
    Write-Error "Nada selecionado no Explorador e nenhuma pasta ativa foi detectada."
    exit 2
}

if (-not $NoQuotes) {
    # Envolve cada caminho em aspas para segurança com espaços/caracteres especiais
    $paths = $paths | ForEach-Object { '"' + ($_.Replace('"','""')) + '"' }
}

switch ($Join) {
    'space'     { $text = ($paths -join ' ') }       # Ex.: "C:\A" "C:\B"
    'semicolon' { $text = ($paths -join ';') }       # Ex.: "C:\A";"C:\B"
    default     { $text = ($paths -join "`r`n") }   # Uma por linha
}

Set-Clipboard -Value $text

# Opcional: imprime no console (útil para testes manuais)
Write-Output $text
