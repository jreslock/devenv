# Development Environment Setup

## Provisioner

### Provisions a VM in Openstack, hands off configuration to ansible

Requirements:

- terraform
- ansible
- Ubuntu 16.04 image
- ssh key pair


        cd devenv/provisioner/openstack
    
        terraform apply -var-file=your.tfvars

The provisioner will run ansible as a last-step which should run the ansible code in the configurator directory.

## Configurator

### Configures an Ubuntu 16.04 system as a development environment
    
### Notes

This development environment is primarily used for infrastructure automation and devops work.  I work with packer, ansible, python, docker, etc.  These tools are all pre-installed.  I also use zsh with antigen for shell customization.  

### SSH

You will want to forward your ssh key to the remote machine.  To do this I suggest setting up an ~/.ssh/config
file with the following:

    Host <your devenv>
        ForwardAgent yes
        
This will allow you to access things like github, other remote servers, etc without actually copying your keys.  It works very well with gpg-agent and a yubikey as a smart card.