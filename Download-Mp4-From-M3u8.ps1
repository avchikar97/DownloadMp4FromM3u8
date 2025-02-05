param (
    [Parameter(Mandatory=$true, HelpMessage=".m3u8 URL of the stream to download")][string]$Url,
    [Parameter(Mandatory=$true, HelpMessage="Output filename (not including .mp4 extension)")][string]$Name,
    [Parameter(Mandatory=$false, HelpMessage="Codec of the output video")][string]$Codec="H.264",
    [Parameter(Mandatory=$false, HelpMessage="Output directory of the downloaded .mp4")][string]$Dir=(Join-Path "$PSScriptRoot" "downloadMp4FromM3u8")
)

[string]$OUTPUT_PATH = (Join-Path $Dir "$($Name).mp4")

if (Get-Command "ffmpeg.exe" -ErrorAction SilentlyContinue){
    If(!(Test-Path -PathType container $Dir))
    {
        New-Item -Force -ItemType Directory -Path $Dir
    }

    if($Codec -eq "AV1"){
        ffmpeg -i $Url -c:v libsvtav1 -crf 30 -preset 5 -c:a copy -c:s copy $OUTPUT_PATH
    }
    elseif($Codec -eq "H.265"){
        ffmpeg -i $Url -c:v libx265 -crf 24 -preset slow -c:a copy -c:s copy $OUTPUT_PATH
    }
    else{ # fall back to same as source (usually H.264 but whatever)
        ffmpeg -i $Url -c copy $OUTPUT_PATH
    }

    Write-Host "`nOutput file is $OUTPUT_PATH"

    if($IsLinux){
        xdg-open $Dir
    }
    elseif($IsWindows){
        explorer $Dir
    }
}
else{
    Write-Host "ERROR: ffmpeg is not installed. Please see https://www.ffmpeg.org/download.html to install ffmpeg before proceeding."
}
