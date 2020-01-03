# bloom-release-action

GitHub Action to bloom release the ROS package.

**This action requires higher privilege than typical action to push to the release repository and open pull-requests to the index. Use it with special care!**

## Inputs
<dl>
<dt>ros_distro</dt> <dd>ROS distributions to create a release. (required)</dd>
<dt>github_token_bloom</dt> <dd>GitHub personal access token to push to your release repository and rosdistro fork. Use <a href="https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets">encrypted secrets</a>. (required)</dd>
<dt>github_user</dt> <dd>GitHub login name to push to your rosdistro fork. (required)</dd>
<dt>git_user</dt> <dd>User name of commit author. Defaults to github_user.</dd>
<dt>git_email</dt> <dd>E-mail address of commit author. (required)</dd>
<dt>repository</dt> <dd>Override package repository name.</dd>
<dt>release_repository_push_url</dt> <dd>Override release repository push URL. Must be https.</dd>
<dt>tag_and_release</dt> <dd>Set true to add a tag automatically before releasing. It requires that the source code is checked out.</dd>
<dt>open_pr</dt> <dd>Set true to open PR on ros/rosdistro automatically. (use with care)</dd>
</dl>

## Outputs
<dl>
  <dt>version</dt> <dd>Version of the created release on tag_and_release=true.</dd>
</dl>

## Example

### Manually tag and release

```yaml
name: bloom-release
on:
  push:
    tags:
      - '[0-9]+.[0-9]+.[0-9]+'

jobs:
  bloom-release:
    runs-on: ubuntu-latest
    steps:
      - name: bloom release
        uses: at-wat/bloom-release-action@v0
        with:
          ros_distro: kinetic melodic
          github_token_bloom: ${{ secrets.GITHUB_TOKEN_BLOOM }}
          github_user: @@MAINTAINER_LOGIN@@
          git_user: @@MAINTAINER_NAME@@
          git_email: @@MAINTAINER_EMAIL_ADDRESS@@
          release_repository_push_url: https://github.com/${{ github.repository }}-release.git
          # open_pr: true
```
Test carefully before enabling `open_pr`.

### Automatically tag and release

Use with [at-wat/catkin-release-action](https://github.com/at-wat/catkin-release-action).

```yaml
name: bloom-release
on:
  push:
    paths:
      - package.xml
    branches:
      - master

jobs:
  bloom-release:
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v2
      - name: bloom release
        uses: at-wat/bloom-release-action@v0
        with:
          ros_distro: kinetic melodic
          github_token_bloom: ${{ secrets.GITHUB_TOKEN_BLOOM }}
          github_user: @@MAINTAINER_LOGIN@@
          git_user: @@MAINTAINER_NAME@@
          git_email: @@MAINTAINER_EMAIL_ADDRESS@@
          release_repository_push_url: https://github.com/${{ github.repository }}-release.git
          tag_and_release: true
          # open_pr: true
```
Test carefully before enabling `open_pr`.

If you want to create a GitHub Release on the created tag, append following step:
```yaml
      - name: create release
        uses: actions/create-release@v1
        with:
          tag_name: ${{ steps.bloom_release.outputs.version }}
          release_name: ${{ steps.bloom_release.outputs.version }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
