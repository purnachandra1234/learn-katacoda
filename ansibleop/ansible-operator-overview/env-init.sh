ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'

#grant the user: developer permissions to push images to the internal registry
ssh root@host01 'oc policy add-role-to-user registry-editor developer --as system:admin'
ssh root@host01 'mkdir -p /opt/ansible/roles'

#Save the existing system:admin .kube/config for up local
ssh root@host01 'mkdir -p ~/backup/.kube'
ssh root@host01 'cp -r ~/.kube/config ~/backup/.kube/'

#Remove the existing ~/.kube/config -> this addresses a untrusted cert issue
ssh root@host01 'rm -rf ~/.kube/config  >> /dev/null'

#This is Temporary until we get the env issues addressed:
#install ansible runner -> this will be used for operator-sdk local installs
ssh root@host01 'yum install python-devel -y'
ssh root@host01 'yum remove python-requests -y'
ssh root@host01 'pip uninstall requests -y'
ssh root@host01 'pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org requests ansible-runner ansible-runner-http idna==2.7'
