# ⚙️ Stream Deck Scripts (Windows)

Coleção de scripts PowerShell para automatizar tarefas no Windows com o Elgato Stream Deck.

- 📁 Copiar caminho(s) selecionado(s) no Explorer para a área de transferência
- 🗣️ Abrir ChatGPT no navegador e iniciar a Digitação por Voz (Win+H)

---

## 🧰 Requisitos
- Windows 10/11
- PowerShell 5+ (ou PowerShell 7)
- Elgato Stream Deck + aplicativo do Stream Deck
- Execução de scripts: use `-ExecutionPolicy Bypass` nos argumentos, se necessário

---

## 🚀 Início Rápido
### 1) Copiar Caminhos no Explorer
- Ação: “Abrir (Open)”
- Programa: `powershell.exe`
- Argumentos:
```powershell
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Copy-SelectedPath.ps1"
```

### 2) ChatGPT com Ditado de Voz (Win+H)
- Ação: “Abrir (Open)”
- Programa: `powershell.exe`
- Argumentos:
```powershell
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Start-ChatGPT-Voice.ps1"
```

---

## 📦 Scripts

### 📁 Copy-SelectedPath.ps1
Copia para o clipboard o(s) caminho(s) dos itens selecionados no Windows Explorer. Se nada estiver selecionado, copia a pasta atual (padrão).

- Arquivo: `Copy-SelectedPath.ps1`
- Parâmetros:
  - `-UseCurrentFolderIfNoSelection` (switch): usa a pasta atual se não houver seleção. Padrão: `True`.
  - `-Join` (`newline` | `space` | `semicolon`): como combinar múltiplos caminhos. Padrão: `newline`.
  - `-NoQuotes` (switch): não envolver caminhos em aspas (por padrão, envolve).

Exemplos:
```powershell
# Básico (uma linha por caminho + entre aspas)
powershell -NoProfile -File .\Copy-SelectedPath.ps1

# Sem aspas
powershell -NoProfile -File .\Copy-SelectedPath.ps1 -NoQuotes

# Em uma única linha (espaço)
powershell -NoProfile -File .\Copy-SelectedPath.ps1 -Join space

# Exigir seleção (não usar pasta atual)
powershell -NoProfile -File .\Copy-SelectedPath.ps1 -UseCurrentFolderIfNoSelection:$false
```

---

### 🗣️ Start-ChatGPT-Voice.ps1
Abre o ChatGPT no navegador e ativa a Digitação por Voz do Windows (`Win+H`) para ditar a mensagem.

- Arquivo: `Start-ChatGPT-Voice.ps1`
- Parâmetros:
  - `-Browser` (`default` | `edge` | `chrome`): navegador. Padrão: `default`.
  - `-Url` (string): URL. Padrão: `https://chatgpt.com/`.
  - `-DelaySec` (int): atraso antes de enviar `Win+H`. Padrão: `3`.

Exemplos:
```powershell
# Básico
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1

# Edge (modo app)
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Browser edge -DelaySec 3

# Chrome
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Browser chrome

# URL alternativa
powershell -NoProfile -File .\Start-ChatGPT-Voice.ps1 -Url "https://chat.openai.com/"
```

---

## 🧩 Dicas & Solução de Problemas
- 🔐 Execução bloqueada: adicione `-ExecutionPolicy Bypass` nos argumentos do Stream Deck.
- 🌐 Navegador não abre: confirme `msedge.exe`/`chrome.exe` no `PATH` ou use o padrão.
- 📝 Caminhos com espaços: mantenha aspas (evite `-NoQuotes`) para colar com segurança em terminais.
- 🧪 Teste antes: execute os scripts no PowerShell para validar o comportamento.
- 🎙️ Primeira vez no ditado: o Windows pode solicitar ativação/instalação da Digitação por Voz.

---

## 📁 Estrutura do Repositório
```
Scripts StreamDeck/
├── Copy-SelectedPath.ps1        # Copia caminho(s) do Explorer para o clipboard
├── Start-ChatGPT-Voice.ps1      # Abre ChatGPT e ativa Win+H (ditado)
└── README.md                    # Este arquivo
```

---

## 💡 Sugestões de Botões Extras
- ✅ Copiar e colar automaticamente (enviar `Ctrl+V` após copiar)
- 🔔 Toast de confirmação (notificação “Caminho copiado”)
- 🎚️ Variantes do ChatGPT (Edge/Chrome, URL específica, delays diferentes)


---

## 🆕 Novos Scripts de Produtividade

### 🕒 Insert-DateTime.ps1
Copia a data/hora para o clipboard no formato escolhido e, se desejar, cola automaticamente (Ctrl+V) no app em foco.

- Arquivo: `Insert-DateTime.ps1`
- Parâmetros:
  - `-Format` (string): formato .NET (padrão: `yyyy-MM-dd HH:mm`).
  - `-Utc` (switch): usa UTC em vez do horário local.
  - `-Paste` (switch): envia `Ctrl+V` após copiar.

Exemplos:
```powershell
powershell -NoProfile -File .\Insert-DateTime.ps1
powershell -NoProfile -File .\Insert-DateTime.ps1 -Format "dd/MM/yyyy"
powershell -NoProfile -File .\Insert-DateTime.ps1 -Utc -Format "yyyy-MM-ddTHH:mm:ssZ" -Paste
```

Configuração no Stream Deck (Ação "Abrir"):
```powershell
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Insert-DateTime.ps1" -Paste
```

---

### 🪟 Copy-ActiveWindowTitle.ps1
Copia para o clipboard o título da janela atualmente em foco.

- Arquivo: `Copy-ActiveWindowTitle.ps1`

Exemplo:
```powershell
powershell -NoProfile -File .\Copy-ActiveWindowTitle.ps1
```

Configuração no Stream Deck (Ação "Abrir"):
```powershell
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Copy-ActiveWindowTitle.ps1"
```

---

### 🚀 Open-WorkApps.ps1
Abre rapidamente um conjunto de apps e URLs de trabalho, com pequeno atraso entre cada abertura.

- Arquivo: `Open-WorkApps.ps1`
- Parâmetros:
  - `-Apps` (string[]): `edge`, `chrome`, `teams`, `outlook`, `explorer`.
  - `-Urls` (string[]): URLs adicionais para abrir.
  - `-DelayMs` (int): atraso entre aberturas (padrão: `200`).

Exemplo:
```powershell
powershell -NoProfile -File .\Open-WorkApps.ps1 -Apps edge,teams -Urls "https://chatgpt.com/","https://outlook.office.com/mail/"
```

Configuração no Stream Deck (Ação "Abrir"):
```powershell
-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\tiago\Downloads\Scripts StreamDeck\Open-WorkApps.ps1" -Apps edge,teams -Urls "https://chatgpt.com/"
```

