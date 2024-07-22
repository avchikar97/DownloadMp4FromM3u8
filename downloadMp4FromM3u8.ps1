param (
    [Parameter(Mandatory=$true, HelpMessage=".m3u8 URL of the stream to download")][string]$url,
    [Parameter(Mandatory=$true, HelpMessage="Output filename (not including .mp4 extension)")][string]$name,
    [Parameter(Mandatory=$false, HelpMessage="Output directory of the downloaded .mp4")][string]$dir=(Join-Path "$PSScriptRoot" "downloadMp4FromM3u8")
)

[string]$OUTPUT_DIR = "$dir"
[string]$OUTPUT_PATH = (Join-Path "$OUTPUT_DIR" "$name.mp4")

if (Get-Command "ffmpeg.exe" -ErrorAction SilentlyContinue){
    If(!(Test-Path -PathType container $OUTPUT_DIR))
    {
        New-Item -Force -ItemType Directory -Path $OUTPUT_DIR
    }

    ffmpeg -i "$url" -c copy -bsf:a aac_adtstoasc $OUTPUT_PATH

    Write-Host 
    Write-Host "Output file is in $OUTPUT_PATH"

    if($IsLinux){
        xdg-open $dir
    }
    elseif($IsWindows){
        explorer $dir
    }
}
else{
    Write-Host "ERROR: ffmpeg is not installed. Please see https://www.ffmpeg.org/download.html to install ffmpeg before proceeding."
}
