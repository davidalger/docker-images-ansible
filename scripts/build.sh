#!/usr/bin/env bash
set -e
trap '>&2 printf "\n\e[01;31mError: Command \`%s\` on line $LINENO failed with exit code $?\033[0m\n" "$BASH_COMMAND"' ERR

## find directory above where this script is located following symlinks if neccessary
readonly BASE_DIR="$(
  cd "$(
    dirname "$(
      (readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}") \
        | sed -e "s#^../#$(dirname "$(dirname "${BASH_SOURCE[0]}")")/#"
    )"
  )/.." >/dev/null \
  && pwd
)"
pushd ${BASE_DIR} >/dev/null

## if --push is passed as first argument to script, this will login to docker hub and push images
PUSH_FLAG=
if [[ "${1:-}" = "--push" ]]; then
  PUSH_FLAG=1
fi

## login to docker hub as needed
if [[ $PUSH_FLAG ]]; then
  [ -t 1 ] && docker login \
    || echo "${DOCKER_PASSWORD:-}" | docker login -u "${DOCKER_USERNAME:-}" --password-stdin
fi

## iterate over and build each version; by default building latest version;
## build matrix will override to build each supported version
VERSION_LIST="${VERSION_LIST:-"2.9"}"

for ANSIBLE_VERSION in ${VERSION_LIST}; do
  IMAGE_TAG="davidalger/ansible:${ANSIBLE_VERSION}"
  export ANSIBLE_VERSION

  printf "\e[01;31m==> building ${IMAGE_TAG}\033[0m\n"
  docker build -t "${IMAGE_TAG}" --build-arg ANSIBLE_VERSION ${BASE_DIR}

  [[ $PUSH_FLAG ]] && docker push "${IMAGE_TAG}"
done
