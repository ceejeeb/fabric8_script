
$NetworkSwitch = "TestSwitch1"
echo "Set Network Switch to $NetworkSwitch"

$Memory = 16384
echo "Set Memory to $Memory"

$Cpus = 4
echo "Set Cpus to $Cpus"

try {$HOME = $USERPROFILE } catch {}
echo "Setting HOME to $HOME"

echo "Creating directory for install at $HOME\fabric8"
New-Item -ItemType directory -Path $HOME\fabric8 -Force | out-null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if(![System.IO.File]::Exists("$HOME\fabric8\kubectl.exe")){
	echo "Downloading Kubectl v1.9.3"
	Invoke-WebRequest -OutFile $HOME\fabric8\kubectl.exe http://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/windows/amd64/kubectl.exe
} 
else {
	echo "Kubectl found at $HOME\fabric8\kubectl.exe"
}

if(![System.IO.File]::Exists("$HOME\fabric8\minikube.exe")){
	echo "Downloading Minikube v.0.25.0"
	Invoke-WebRequest -OutFile $HOME\fabric8\minikube.exe http://github.com/kubernetes/minikube/releases/download/v0.25.0/minikube-windows-amd64
} 
else {
	echo "Minikube found at $HOME\fabric8\minikube.exe"
}

if(![System.IO.File]::Exists("$HOME\fabric8\gofabric8.exe")){
	echo "Downloading GoFabric8 v0.4.176"
	Invoke-WebRequest -OutFile $HOME\fabric8\gofabric8.exe http://github.com/fabric8io/gofabric8/releases/download/v0.4.176/gofabric8-windows-amd64.exe
} 
else {
	echo "GoFabric8 found at $HOME\fabric8\gofabric8.exe"
}

$env:Path = "$HOME\fabric8;" + $env:Path
echo "Adding  $HOME\fabric8 to your Path variable"


echo "Starting Minikube VM"
minikube start --vm-driver=hyperv --hyperv-virtual-switch=$NetworkSwitch --memory=$Memory --cpus=$Cpus

echo "Enabling ingress in Minikube"
minikube addons enable ingress

minikube status

echo "Deploying Fabric8"
gofabric8 start -n fabric8 -y
