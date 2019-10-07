# install build tools (gcc needed for nvidia driver install)
sudo yum groupinstall -y 'Development Tools'

# download and nvidia drivers
curl -s -L http://us.download.nvidia.com/tesla/384.183/NVIDIA-Linux-x86_64-384.183.run -z NVIDIA-Linux-x86_64-384.183.run -o NVIDIA-Linux-x86_64-384.183.run -f
chmod +x NVIDIA-Linux-x86_64-384.183.run 

# install kernel headers
sudo yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)

# run driver install (not headless as shown here)
sudo ./NVIDIA-Linux-x86_64-384.183.run 

# install nvidia-container-runtime
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.repo |   sudo tee /etc/yum.repos.d/nvidia-container-runtime.repo
sudo yum install -y nvidia-container-runtime

# install nvidia-docker2
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo |   sudo tee /etc/yum.repos.d/nvidia-docker.repo
sudo yum install -y nvidia-docker2

# make nvidia-container-runtime default
sudo sed -i "s/^[ \t]*\"runtimes\"/  \"default-runtime\": \"nvidia\",\n  \"runtimes\"/" /etc/docker/daemon.json

# clean up
rm NVIDIA-Linux-x86_64-384.183.run 
sudo yum clean all
sudo rm -rf /var/cache/yum
