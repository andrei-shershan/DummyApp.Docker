# 1. Install mkcert (one time)
choco install mkcert        # or: winget install FiloSottile.mkcert

# 2. Install the local CA into the system store
mkcert -install

# 3. Create a certificate for all services
cd DummyApp.Docker
mkdir certs
mkcert -cert-file certs/dummy.crt -key-file certs/dummy.key "*.dummy.localhost" dummy.localhost

#
cd \DummyApp\DummyApp.Docker
.\install-dev-certs.ps1