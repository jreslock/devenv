[all:vars]

user="{{ lookup('env', 'USER') }}"
gpg_sign_key=${gpg_key}
email=${email}
full_name=${fullname}
ansible_user=${ansible_user}
ansible_ssh_private_key_file=${private_key}
ansible_ssh_extra_args = '-o StrictHostKeyChecking=no'

[all]
${name} ansible_host=${public_ip}