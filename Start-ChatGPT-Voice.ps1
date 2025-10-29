<#
  Abre o ChatGPT no navegador e inicia a digitação por voz do Windows (Win+H),
  permitindo ditar sua mensagem no campo de texto do ChatGPT.

  Observações:
  - Usa a digitação por voz nativa do Windows (Win+H), que funciona em qualquer caixa de texto.
  - O campo de mensagem do ChatGPT geralmente recebe foco automaticamente; caso não, clique nele.
  - Na primeira vez, o Windows pode solicitar download/ativação do recurso de voz.

  Exemplos:
    powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1
    powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Browser edge -DelaySec 3
    powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Browser chrome

  Integração com Stream Deck (Ação "Abrir"):
    Programa:
      powershell.exe
    Argumentos:
      -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Start-ChatGPT-Voice.ps1"
#>

param(
    [ValidateSet('default','edge','chrome')]
    [string]$Browser = 'default',
    [string]$Url = 'https://chatgpt.com/',
    [int]$DelaySec = 3
)

function Start-ChatGPTBrowser {
    param([string]$Browser, [string]$Url)
    switch ($Browser) {
        'edge'   { Start-Process 'msedge.exe' -ArgumentList @("--app=$Url") | Out-Null }
        'chrome' { Start-Process 'chrome.exe' -ArgumentList @("--app=$Url") | Out-Null }
        default  { Start-Process $Url | Out-Null }
    }
}

# Envia combinação de teclas usando Win32 SendInput (permite usar tecla Win)
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class SendKeysWin {
    [StructLayout(LayoutKind.Sequential)] struct INPUT { public uint type; public InputUnion U; }
    [StructLayout(LayoutKind.Explicit)] struct InputUnion { [FieldOffset(0)] public KEYBDINPUT ki; }
    [StructLayout(LayoutKind.Sequential)] struct KEYBDINPUT { public ushort wVk; public ushort wScan; public uint dwFlags; public uint time; public IntPtr dwExtraInfo; }
    [DllImport("user32.dll", SetLastError=true)] static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);
    const uint INPUT_KEYBOARD = 1; const uint KEYEVENTF_KEYUP = 0x0002;
    static void Key(ushort vk, bool up){ INPUT i=new INPUT(); i.type=INPUT_KEYBOARD; i.U.ki.wVk=vk; i.U.ki.dwFlags=up?KEYEVENTF_KEYUP:0; SendInput(1,new INPUT[]{i},System.Runtime.InteropServices.Marshal.SizeOf(typeof(INPUT))); }
    public static void Chord(params ushort[] vks){ foreach(var v in vks) Key(v,false); for(int i=vks.Length-1;i>=0;i--) Key(vks[i],true); }
}
"@

try {
    Start-ChatGPTBrowser -Browser $Browser -Url $Url
} catch {
    Write-Error "Falha ao abrir navegador ($Browser) em $Url: $($_.Exception.Message)"
}

Start-Sleep -Seconds $DelaySec

# Envia Win+H para abrir a Digitação por Voz do Windows
$VK_LWIN = 0x5B
$VK_H    = 0x48
[SendKeysWin]::Chord($VK_LWIN, $VK_H)

Write-Output "ChatGPT aberto em $Url e digitação por voz (Win+H) acionada."

