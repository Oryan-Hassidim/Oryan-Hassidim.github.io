param(
    [Parameter(Mandatory = $true)]
    [string]$DocPath,
    
    # נתיב ברירת המחדל לתיקיית המאמרים ב-11ty
    [string]$ArticlesDir = "src\articles"
)

# 1. חילוץ שמות והכנת נתיבים
$DocFile = Get-Item $DocPath
$Title = $DocFile.BaseName
# החלפת רווחים במקפים לשם התיקייה
$FolderName = $Title -replace '\s+', '-'
$DestDir = Join-Path -Path $ArticlesDir -ChildPath $FolderName

# יצירת התיקייה במידה ואינה קיימת
if (-not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
}

[string]$NewDocPath = Join-Path -Path $DestDir -ChildPath $DocFile.Name
[string]$PdfRelativePath = Join-Path -Path $DestDir -ChildPath "$Title.pdf"
[string]$PdfAbsolutePath = Join-Path -Path (Get-Location) -ChildPath $PdfRelativePath
[string]$PdfPath = $PdfAbsolutePath
[string]$HtmlPath = Join-Path -Path $DestDir -ChildPath "index.html"

# 2. העתקת קובץ הוורד המקורי
Copy-Item -Path $DocFile.FullName -Destination $NewDocPath -Force
Write-Host "Copied Word document to $DestDir" -ForegroundColor Green

# 3. יצירת PDF באמצעות Word COM
Write-Host "Generating PDF..." -ForegroundColor Cyan
$Word = New-Object -ComObject Word.Application
$Word.Visible = $true
try {
    # פתיחת המסמך ושמירתו כ-PDF (17 הוא הקוד של wdExportFormatPDF)
    $Doc = $Word.Documents.Open([string]$DocFile.FullName)
    $Doc.ExportAsFixedFormat([ref]$PdfPath, [ref]17)
    $Doc.Close([ref]$false)
    Write-Host "PDF generated successfully." -ForegroundColor Green
}
catch {
    Write-Host "Error generating PDF: $_" -ForegroundColor Red
}
finally {
    $Word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Word) | Out-Null
}

# 4. המרה ל-HTML באמצעות Pandoc
Write-Host "Converting to HTML using Pandoc..." -ForegroundColor Cyan
# שינוי תיקיית העבודה ליעד כדי ש-Pandoc ישמור את התמונות במיקום הנכון
Set-Location -Path $DestDir
# משתמשים ב-extract-media כדי לחלץ תמונות (אם יש)
pandoc "$DocFile" -o "index.html" --toc --lua-filter="../../../remove-spans.lua" --template="../../../pandoc_template.html" -extract-media

# 5. עיבוד ה-HTML (מחיקת spans, סידור תמונות והוספת Front Matter)
Write-Host "Processing HTML..." -ForegroundColor Cyan
$HtmlContent = Get-Content -Path "index.html" -Raw -Encoding UTF8

# Pandoc שומר תמונות בתיקיית 'media' כברירת מחדל. 
# נשנה את שמה ל-'images' כדי להתאים למבנה שלך, ונעדכן את הנתיבים ב-HTML.
# $MediaDir = Join-Path -Path $DestDir -ChildPath "media"
# if (Test-Path $MediaDir) {
#     Rename-Item -Path $MediaDir -NewName "images"
#     $HtmlContent = $HtmlContent -replace 'src="media/', 'src="images/'
# }

# בניית ה-Front Matter
$FrontMatter = @"
---
title: "$Title"
---


"@

# שרשור ושמירה חזרה לקובץ
$FinalContent = $FrontMatter + $HtmlContent
Set-Content -Path "index.html" -Value $FinalContent -Encoding UTF8

Write-Host "Done! Article '$Title' successfully deployed." -ForegroundColor Green
Set-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Path) # חזרה לתיקיית הסקריפט