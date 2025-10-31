<#
    Copia para a área de transferência a data/hora no formato desejado
    e (opcionalmente) cola no app em foco enviando Ctrl+V.

    Parâmetros:
      -Format (string)
          Formato .NET de data/hora (padrão: yyyy-MM-dd HH:mm)
      -Utc (switch)
          Usa horário UTC em vez de local
      -Paste (switch)
          Após copiar, envia Ctrl+V para colar no app atual

    Exemplos:
      powershell -NoProfile -File .\Insert-DateTime.ps1
      powershell -NoProfile -File .\Insert-DateTime.ps1 -Format "dd/MM/yyyy"
      powershell -NoProfile -File .\Insert-DateTime.ps1 -Paste
      powershell -NoProfile -File .\Insert-DateTime.ps1 -Utc -Format "yyyy-MM-ddTHH:mm:ssZ" -Paste

    Stream Deck (Ação "Abrir"):
      Programa:
        powershell.exe
      Argumentos:
        -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Insert-DateTime.ps1" -Paste
#>

param(
    [string]$Format = 'yyyy-MM-dd HH:mm',
    [switch]$Utc,
    [switch]$Paste
)

if ($Utc) {
    $now = [DateTime]::UtcNow
} else {
    $now = [DateTime]::Now
}

$text = $now.ToString($Format, [System.Globalization.CultureInfo]::InvariantCulture)

Set-Clipboard -Value $text

if ($Paste) {
    # Envia Ctrl+V via Win32 SendInput (não depende de foco no console)
    Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class SendKeysCtrlV {
    [StructLayout(LayoutKind.Sequential)] struct INPUT { public uint type; public InputUnion U; }
    [StructLayout(LayoutKind.Explicit)] struct InputUnion { [FieldOffset(0)] public KEYBDINPUT ki; }
    [StructLayout(LayoutKind.Sequential)] struct KEYBDINPUT { public ushort wVk; public ushort wScan; public uint dwFlags; public uint time; public IntPtr dwExtraInfo; }
    [DllImport("user32.dll", SetLastError=true)] static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);
    const uint INPUT_KEYBOARD = 1; const uint KEYEVENTF_KEYUP = 0x0002;
    static void Key(ushort vk, bool up){ INPUT i=new INPUT(); i.type=INPUT_KEYBOARD; i.U.ki.wVk=vk; i.U.ki.dwFlags=up?KEYEVENTF_KEYUP:0; SendInput(1,new INPUT[]{i},System.Runtime.InteropServices.Marshal.SizeOf(typeof(INPUT))); }
    public static void CtrlV(){ const ushort CTRL=0x11, V=0x56; Key(CTRL,false); Key(V,false); Key(V,true); Key(CTRL,true); }
}
"@

    Start-Sleep -Milliseconds 100
    [SendKeysCtrlV]::CtrlV()
}

Write-Output $text


