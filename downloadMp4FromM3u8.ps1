param (
    [Parameter(Mandatory=$true)][string]$url,
    [Parameter(Mandatory=$true)][string]$name,
    [Parameter(Mandatory=$false)][string]$dir="D:\downloadMp4FromM3u8"
)

[string]$OUTPUT_DIR = "$dir"
[string]$OUTPUT_PATH = "$OUTPUT_DIR\$name.mp4"

If(!(Test-Path -PathType container $OUTPUT_DIR))
{
      New-Item -Force -ItemType Directory -Path $OUTPUT_DIR
}

ffmpeg -i "$url" -c copy -bsf:a aac_adtstoasc $OUTPUT_PATH

Write-Host 
Write-Host Output file is in $OUTPUT_PATH
