# Copies the mkcert root CA into each service directory so Docker can install it
# during the image build. Run this once after cloning or regenerating certs.
#
# Prerequisites: mkcert must be installed and `mkcert -install` must have been run.
# https://github.com/FiloSottile/mkcert

$mkcertDir = "$env:LOCALAPPDATA\mkcert"
$rootCa = Join-Path $mkcertDir "rootCA.pem"

if (-not (Test-Path $rootCa)) {
    Write-Error "mkcert root CA not found at '$rootCa'. Run 'mkcert -install' first."
    exit 1
}

$services = @(
    "..\DummyApp.ApiGateway",
    "..\DummyApp.BFF",
    "..\DummyApp.Identity",
    "..\DummyApp.StorageService"
)

foreach ($svc in $services) {
    $dest = Join-Path $PSScriptRoot "$svc\certs"
    if (-not (Test-Path $dest)) {
        New-Item -ItemType Directory -Path $dest | Out-Null
    }
    Copy-Item $rootCa (Join-Path $dest "rootCA.pem") -Force
    Write-Host "Copied rootCA.pem -> $dest"
}

Write-Host "`nDone. Rebuild images with: docker compose up --build"
