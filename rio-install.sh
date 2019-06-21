# get rio binary
wget https://github.com/rancher/rio/releases/download/v0.1.1-rc3/rio-linux-amd64
chmod a+x rio-linux-amd64
mv rio-linux-amd64 /usr/local/bin/rio

# install rio components
rio install --ipaddress $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# install rio sample app
rio run -p 80/http --name svc --scale=3 ibuildthecloud/demo:v1

# install rio sample app that builds from source
rio run https://github.com/rancher/rio-demo
