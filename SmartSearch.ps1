param([string]$Query)

# Configurazione
$File = "$PSScriptRoot\Guida_Bash.txt"
$StopWords = @("il", "lo", "la", "i", "gli", "le", "un", "uno", "una", "di", "a", "da", "in", "su", "per", "con", "tra", "fra", "che", "ed", "od", "ho", "ha", "scrivere", "script", "bash", "esercizio")

# Controllo file
if (-not (Test-Path $File)) {
    Write-Error "File $File non trovato!"
    exit 1
}

# 1. Pulisci la query
$CleanQuery = $Query -replace '[^\w\s]', '' 
$Keywords = $CleanQuery.Split(" ", [StringSplitOptions]::RemoveEmptyEntries) | 
            Where-Object { $_.Length -gt 2 -and $StopWords -notcontains $_.ToLower() } | 
            Select-Object -Unique

Write-Host "Cerco keywords: $($Keywords -join ', ')" -ForegroundColor Cyan

# 2. Leggi il contenuto e dividilo in Blocchi (separati da Headers '[ ... ]' o linee vuote importanti)
# Usiamo una regex per catturare i blocchi che iniziano con '[' (Esempi) o headers di sezione
$Content = Get-Content $File -Raw
$Blocks = $Content -split "(?=\r?\n\[)"

$Results = @()

foreach ($Block in $Blocks) {
    if ([string]::IsNullOrWhiteSpace($Block)) { continue }
    
    $Score = 0
    $FoundWords = @()
    
    foreach ($Word in $Keywords) {
        # Match case-insensitive
        if ($Block -match $Word) { 
            $Score++ 
            $FoundWords += $Word
        }
    }
    
    if ($Score -gt 0) {
        # Calcola un punteggio pesato (più keyword diverse = meglio)
        $Results += [PSCustomObject]@{
            Score = $Score
            Found = ($FoundWords -join ", ")
            Preview = $Block.Trim().Split("`n")[0]
            Body = $Block
        }
    }
}

# 3. Mostra i Top 3 Risultati
$TopResults = $Results | Sort-Object Score -Descending | Select-Object -First 3

if ($TopResults) {
    foreach ($Res in $TopResults) {
        Write-Host "`n=======================================================" -ForegroundColor Cyan
        Write-Host "MATCH SCORE: $($Res.Score) (Trovati: $($Res.Found))" -ForegroundColor Yellow
        Write-Host "SEZIONE: $($Res.Preview)" -ForegroundColor Green
        Write-Host "-------------------------------------------------------"
        Write-Host $Res.Body.Trim()
    }
} else {
    Write-Host "Nessun risultato trovato." -ForegroundColor Red
}
