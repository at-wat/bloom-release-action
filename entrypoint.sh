#!/bin/bash

cd "${GITHUB_WORKSPACE}" \
  || (echo "Workspace is unavailable" >&2; exit 1)

set -eu

# Setup
mkdir -p ~/.config
echo "{\"github_user\": \"${INPUT_GITHUB_USER}\", \"oauth_token\": \"${INPUT_GITHUB_TOKEN_BLOOM}\"}" > ~/.config/bloom
echo -e "machine github.com\nlogin ${INPUT_GITHUB_TOKEN_BLOOM}" > ~/.netrc
git config --global user.name ${INPUT_GIT_USER:-${INPUT_GITHUB_USER}}
git config --global user.email ${INPUT_GIT_EMAIL}

if [ "${INPUT_TAG_AND_RELEASE}" == "true" ]
then
  manifest=$(find . -name package.xml | head -n1)
  version=$(sed -e ':l;N;$!b l;s/\n/ /g;s|^.*<version>\(.*\)</version>.*|\1|' ${manifest})
  if ! git ls-remote --exit-code origin ${version}
  then
    echo "Tag ${version} not found. Adding..."
    git tag ${version}
    git push origin ${version}
    echo "::set-output name=version::${version}"
  else
    echo "Tag ${version} found. Nothing to do."
    exit 0
  fi
fi

# Initialize
rosdep update

# Prepare bloom-release
options=

if [ ! -z "${INPUT_RELEASE_REPOSITORY_PUSH_URL:-}" ]
then
  options="${options} --override-release-repository-push-url ${INPUT_RELEASE_REPOSITORY_PUSH_URL}"
fi

if [ "${INPUT_OPEN_PR:-false}" != "true" ]
then
  options="${options} --no-pull-request"
fi

export TERM=dumb

for ros_distro in ${INPUT_ROS_DISTRO}
do
  bloom-release \
    -y \
    --no-web \
    --ros-distro ${ros_distro} \
    ${options} \
    ${INPUT_REPOSITORY:-$(basename ${GITHUB_REPOSITORY})}
done
