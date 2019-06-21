# K3s Terraform

A very simple two node cluster built using terraform. If you want to do this on ARM, check out [k3s-arm](https://github.com/wjimenez5271/k3s-arm)

### Instructions

1. Set variables using `terraform.tfvars` or other compatible source, run `terraform init`

2. Run `terraform apply`

3. `kubectl get nodes` on the `server` instance should show two nodes registered

### Bonus: Install Rio on top of k3s

1. get rio binary

```
wget https://github.com/rancher/rio/releases/download/v0.1.1-rc3/rio-linux-amd64
chmod a+x rio-linux-amd64
mv rio-linux-amd64 /usr/local/bin/rio
```

2. Install rio components

```
rio install --ipaddress $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
```

3. install rio sample app

```
rio run -p 80/http --name svc --scale=3 ibuildthecloud/demo:v1
```

4. install rio sample app that builds from source

```
rio run https://github.com/rancher/rio-demo
```
