param (
    [Parameter(Mandatory=$true, HelpMessage=".m3u8 URL of the stream to download")][string]$url,
    [Parameter(Mandatory=$true, HelpMessage="Output filename (not including .mp4 extension)")][string]$name,
    [Parameter(Mandatory=$false, HelpMessage="If specified, video will be the same codec. Otherwise ffmpeg will encode the video with x265 to save space. This will likely speed up download.")][switch]$SameAsSource,
    [Parameter(Mandatory=$false, HelpMessage="Output directory of the downloaded .mp4")][string]$dir=(Join-Path "$PSScriptRoot" "downloadMp4FromM3u8")
)

[string]$OUTPUT_DIR = "$dir"
[string]$OUTPUT_PATH = (Join-Path "$OUTPUT_DIR" "$name.mp4")

if (Get-Command "ffmpeg.exe" -ErrorAction SilentlyContinue){
    If(!(Test-Path -PathType container $OUTPUT_DIR))
    {
        New-Item -Force -ItemType Directory -Path $OUTPUT_DIR
    }

    if($SameAsSource){
        ffmpeg -i "$url" -c copy $OUTPUT_PATH
    }
    else{
        ffmpeg -i "$url" -c:v libx265 -c:a copy -c:s copy $OUTPUT_PATH
    }

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
