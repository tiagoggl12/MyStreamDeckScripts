<#
    Copia o título da janela ativa (em foco) para a área de transferência.

    Exemplos:
      powershell -NoProfile -File .\Copy-ActiveWindowTitle.ps1

    Stream Deck (Ação "Abrir"):
      Programa:
        powershell.exe
      Argumentos:
        -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Copy-ActiveWindowTitle.ps1"
#>

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public static class Win32Title {
    [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern int GetWindowTextW(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    [DllImport("user32.dll")] static extern int GetWindowTextLengthW(IntPtr hWnd);
    public static string GetActiveTitle(){
        var h = GetForegroundWindow();
        if(h==IntPtr.Zero) return null;
        int len = GetWindowTextLengthW(h);
        if(len<=0) return null;
        var sb = new StringBuilder(len+1);
        GetWindowTextW(h, sb, sb.Capacity);
        return sb.ToString();
    }
}
"@

$title = [Win32Title]::GetActiveTitle()

if ([string]::IsNullOrWhiteSpace($title)) {
    Write-Error "Não foi possível obter o título da janela ativa."
    exit 1
}

Set-Clipboard -Value $title
Write-Output $title


