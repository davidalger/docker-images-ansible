# Ansible Docker Images

![Docker Image CI](https://github.com/davidalger/docker-images-ansible/workflows/Docker%20Image%20CI/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/davidalger/ansible.svg?label=Docker%20Pulls)

## Supported Tags

* `2.4`
* `2.5`
* `2.6`
* `2.7`
* `2.8`
* `2.9`

## Example Usage

```
ANSIBLE_VERSION=2.9

## when on macOS environments use the special ssh auth socket
if [[ $OSTYPE =~ ^darwin ]]; then
  SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
fi

docker run --rm -it -v $(pwd):/opt/ansible -w /opt/ansible \
  --env SSH_AUTH_SOCK=/tmp/ssh-auth.sock -v "${SSH_AUTH_SOCK:-/dev/null}":/tmp/ssh-auth.sock \
  --env ANSIBLE_REMOTE_USER="$(whoami)" docker.io/davidalger/ansible:${ANSIBLE_VERSION} \
  ansible-playbook -i inventory playbook.yml --tags users --diff
```

## License

This work is licensed under the MIT license. See [LICENSE](https://github.com/davidalger/warden/blob/develop/LICENSE) file for details.

## Author Information

This project was started in 2020 by [David Alger](https://davidalger.com/).
