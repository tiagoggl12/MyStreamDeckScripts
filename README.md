# Scripts para Stream Deck (Windows)

Coleção de scripts PowerShell para automatizar ações no Windows com o Elgato Stream Deck.

- Copiar caminho(s) selecionado(s) no Explorer para a área de transferência.
- Abrir o ChatGPT no navegador e iniciar a digitação por voz (Win+H).

## Requisitos

- Windows 10/11
- PowerShell 5+ (ou PowerShell 7)
- Permissão para executar scripts: use `-ExecutionPolicy Bypass` na ação do Stream Deck se necessário

---

## 1) Copy-SelectedPath.ps1

Copia para o clipboard o(s) caminho(s) dos itens atualmente selecionados no Windows Explorer. Se nada estiver selecionado, por padrão copia o caminho da pasta atual.

Caminho: `Copy-SelectedPath.ps1`

Parâmetros:
- `-UseCurrentFolderIfNoSelection` (switch): usa a pasta atual se não houver seleção (padrão: True)
- `-Join` (`newline` | `space` | `semicolon`): como juntar múltiplos caminhos (padrão: `newline`)
- `-NoQuotes` (switch): não envolve os caminhos em aspas

Exemplos (PowerShell):
```
# Básico (quebra de linha + aspas)
powershell -NoProfile -File .\Copy-SelectedPath.ps1

# Sem aspas
powershell -NoProfile -File .\Copy-SelectedPath.ps1 -NoQuotes

# Em uma única linha separados por espaço
powershell -NoProfile -File .\Copy-SelectedPath.ps1 -Join space

# Exigir seleção (não usar pasta atual)
powershell -NoProfile -File .\Copy-SelectedPath.ps1 -UseCurrentFolderIfNoSelection:$false
```

Configuração no Stream Deck:
- Ação: “Abrir” (Open)
- Programa: `powershell.exe`
- Argumentos (exemplo):
```
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Copy-SelectedPath.ps1"
```

---

## 2) Start-ChatGPT-Voice.ps1

Abre o ChatGPT no navegador (Edge, Chrome ou padrão) e ativa a digitação por voz do Windows (`Win+H`) para ditar a mensagem no campo de texto do ChatGPT.

Caminho: `Start-ChatGPT-Voice.ps1`

Parâmetros:
- `-Browser` (`default` | `edge` | `chrome`): navegador a utilizar (padrão: `default`)
- `-Url` (string): URL a abrir (padrão: `https://chatgpt.com/`)
- `-DelaySec` (int): atraso antes de enviar `Win+H` (padrão: 3)

Exemplos (PowerShell):
```
# Básico
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1

# Forçar Edge em modo app
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Browser edge -DelaySec 3

# Chrome
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Browser chrome

# Alterar URL
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Url "https://chat.openai.com/"
```

Configuração no Stream Deck:
- Ação: “Abrir” (Open)
- Programa: `powershell.exe`
- Argumentos (exemplo):
```
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Start-ChatGPT-Voice.ps1"
```

Notas:
- A primeira execução pode solicitar a ativação/instalação da digitação por voz do Windows.
- Se o campo de texto não estiver focado, clique nele e tente novamente.
- `Win+H` abre/fecha o painel de ditado. Ajuste `-DelaySec` conforme a velocidade de abertura do navegador.

---

## Dicas e Solução de Problemas

- Execução de scripts bloqueada: use `-ExecutionPolicy Bypass` nos argumentos do Stream Deck.
- Permissões do navegador: se o navegador não abrir, verifique se `msedge.exe` ou `chrome.exe` está no `PATH`.
- Múltiplos caminhos com espaços: mantenha as aspas no `Copy-SelectedPath.ps1` (não use `-NoQuotes`) para evitar erros ao colar em terminais.
- Teste manual: rode os scripts pelo PowerShell antes de configurar no Stream Deck para validar comportamentos.

---

## Estrutura do Repositório

- `Copy-SelectedPath.ps1` — Copia caminho(s) selecionado(s) no Explorer para o clipboard.
- `Start-ChatGPT-Voice.ps1` — Abre ChatGPT e ativa ditado de voz (Win+H).

