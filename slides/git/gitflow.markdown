---
layout: slide
title: GitFlow
---

![](/assets/images/git/gitflow/gitflow.png)

---

# Introduction

<br />

- What is Gitflow?
- Installing Gitflow
- Initializing Gitflow
- Git branching models

---

# Git Branching Models

<br />

- Centralized
- Feature branch
- Gitflow

--

## Centralized

<br />

- Uses a centralized repository
- End users clone the repository
- Pull changes from the central repository to local
- Push local changes to central repository
- Very like SVN

![](/assets/images/git/gitflow/centralized-workflow.png)

--

## Feature Branch

<br />

- End users keep changes isolated from collaborators
- Independent “tracks” of developing a project
- Pull requests and push permissions

![](/assets/images/git/gitflow/feature-branch-workflow.png)

--

## Gitflow

<br />

- More complicated than feature branch workflow
- Two branches record history of the project (`master` and `develop`)
- Features reside in their own branches (as do hotfixes)
- Release branches branch off develop

--

![](/assets/images/git/gitflow/gitflow-workflow.svg)

---

# Install Gitflow

<br />

> - Gitflow is a set of scripts that extend git (Can use standard git commands but scripts make it easier)
> - Has to be installed separately to git ([Installation](https://github.com/petervanderdoes/gitflow-avh/wiki/Installation))

---

# The main branches

The central repo holds two main branches with an infinite lifetime:

### `master` and `develop`

--

![](/assets/images/git/gitflow/branches.svg)

The `master` branch at `origin` should be familiar to every Git user. Parallel to the `master` branch, another branch exists called `develop`.

When the source code in the `develop` branch reaches a stable point and is ready to be released, all of the changes should be merged back into `master` somehow and then tagged with a release number.

---

# Supporting branches

> Next to the main branches `master` and `develop`, our development model uses a variety of supporting branches to aid parallel development between team members, ease tracking of features, prepare for production releases and to assist in quickly fixing live production problems.

> Unlike the main branches, these branches always have a limited life time, since they will be removed eventually.

--

## The main types of support branches

<br />

- `Feature` branches
- `Release` branches
- `Hotfix` branches

---

# Feature branches

<br />

- May branch off from `develop`
- Must merge back into `develop`

<br />

## Branch naming convention

<br />

- Must begin with `feature/` (e.g. `feature/my-awesome-feature`)

---

# Release branches

<br />

- May branch off from `develop`
- Must merge back into `master` and `develop`

<br />

## Branch naming convention

<br />

- Must begin with `release/*` (e.g. `release/0.1.0`)

---

# Hotfix branches

<br />

- May branch off from `master`
- Must merge back into `master` and `develop`

<br />

## Branch naming convention

<br />

- Must begin with `hotfix/*` (e.g. `hotfix/v0.1.1`)

---

# How to use Gitflow?

--

## Git repository initialization

<br />

Regular git repository

```shell
$ mkdir gitflow-sandbox && cd gitflow-sandbox

$ git init .
Initialized empty Git repository in /home/john/gitflow-sandbox/.git/

$ git branch # empty
```

--

## Git flow initialization

<br />

```shell
$ git flow init -d
No branches exist yet. Base branches must be created now.
Branch name for production releases: [master]
Branch name for "next release" development: [develop]

How to name your supporting branch prefixes?
Feature branches? [feature/]
Bugfix branches? [bugfix/]
Release branches? [release/]
Hotfix branches? [hotfix/]
Support branches? [support/]
Version tag prefix? []
Hooks and filters directory? [/home/john/gitflow-sandbox/.git/hooks]

$ git branch
* develop
  master
```

`-d` - use default branch naming conventions

--

## Comparison with raw `git` commands

```shell
$ git flow init
```
<!-- .element: class="left width-50" -->

```shell
$ git init
$ git commit --allow-empty -m "Initial commit"
$ git checkout -b develop master
```
<!-- .element: class="right width-50" -->

---

# Features

> Each new feature should reside in its own branch, which can be pushed to the central repository for backup/collaboration. But, instead of branching off of `master`, `feature` branches use `develop` as their parent branch.

> When a feature is complete, it gets merged back into `develop`. Features should never interact directly with `master`.

--

![](/assets/images/git/gitflow/feature-start.svg)

--

## Creating features

```shell
$ git flow feature start my-feature
Switched to a new branch 'feature/my-feature'

Summary of actions:
- A new branch 'feature/my-feature' was created, based on 'develop'
- You are now on branch 'feature/my-feature'

Now, start committing on your feature. When done, use:

     git flow feature finish my-feature
```

--

## Comparison with raw `git` command

```shell
$ git flow feature start my-feature
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout -b feature/my-feature develop
```
<!-- .element: class="right width-50" -->

--

## Commit

```shell
$ echo 'Add new feature' > README.md

$ git add .

$ git commit -m 'Create README.md'
[feature/my-feature c40e454] Create README.md
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

--

## Push

```shell
$ git flow feature publish my-feature
Counting objects: 5, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (5/5), 394 bytes | 0 bytes/s, done.
Total 5 (delta 0), reused 0 (delta 0)
To github.com:rubygarage/gitflow-sandbox.git
 * [new branch]      feature/my-feature -> feature/my-feature
Branch feature/my-feature set up to track remote branch feature/my-feature from origin.
Already on 'feature/my-feature'
Your branch is up-to-date with 'origin/feature/my-feature'.

Summary of actions:
- The remote branch 'feature/my-feature' was created or updated
- The local branch 'feature/my-feature' was configured to track the remote branch
- You are now on branch 'feature/my-feature'
```

--

## Comparison with raw `git` commands

```shell
$ git flow feature publish my-feature
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout feature/my-feature
$ git push origin feature/my-feature
```
<!-- .element: class="right width-50" -->

---

# Pull requests

> Create a pull request to propose and collaborate on changes to a repository. These changes are proposed in a branch, which ensures that the `develop` branch only contains finished and approved work.

![](/assets/images/git/gitflow/pull-request-review-edit-branch.png)

--

## About pull request reviews

> Reviews allow collaborators to comment on the changes proposed in pull requests, approve the changes, or request further changes before the pull request is merged. Repository administrators can require that all pull requests are approved before being merged.

![](/assets/images/git/gitflow/review-header-with-line-comment.png)

--

## Merge to develop

> Merge a pull request into the `develop` branch when work is completed. Anyone with push access to the repository can complete the merge.

![](/assets/images/git/gitflow/pullrequest-mergebutton.png)

--

## Sync `develop` branch

```shell
$ git checkout develop
Switched to branch 'develop'

$ git pull origin develop
remote: Counting objects: 1, done.
remote: Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (1/1), done.
From github.com:rubygarage/gitflow-sandbox
 * branch            develop    -> FETCH_HEAD
   1c5d705..140dcbc  develop    -> origin/develop
Updating 1c5d705..140dcbc
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

--

## Remove merged `feature` branch locally

```shell
$ git flow feature delete my-feature
Deleted branch feature/my-feature (was c40e454).

Summary of actions:
- Feature branch 'feature/my-feature' has been deleted.
- You are now on branch 'develop'
```

--

## Comparison with raw `git` commands

```shell
$ git flow feature delete my-feature
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout develop
$ git branch -d feature/my-feature
```
<!-- .element: class="right width-50" -->

---

# Release

> Once `develop` has acquired enough features for a release (or a predetermined release date is approaching), you create a release branch off of `develop`. Creating this branch starts the next release cycle, so no new features can be added after this point—only bug fixes, documentation generation, and other release-oriented tasks should go in this branch.

--

![](/assets/images/git/gitflow/release-branch.svg)

--

## Creating release

```shell
$ git flow release start 0.1.0
Switched to a new branch 'release/0.1.0'

Summary of actions:
- A new branch 'release/0.1.0' was created, based on 'develop'
- You are now on branch 'release/0.1.0'

Follow-up actions:
- Bump the version number now!
- Start committing last-minute fixes in preparing your release
- When done, run:

     git flow release finish '0.1.0'
```

--

## Comparison with raw `git` command

```shell
$ git flow release start 0.1.0
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout -b release/0.1.0 develop
```
<!-- .element: class="right width-50" -->

--

## Commit

```shell
$ echo 'Release 0.1.0' > CHANGELOG.md

$ git add .

$ git commit -m 'Bump to 0.1.0'
[release/0.1.0 07fc48d] Bump to 0.1.0
 1 file changed, 1 insertion(+)
 create mode 100644 CHANGELOG.md
```

--

## Finish

> Once the release is ready to ship, it will get merged it into `master` and `develop`, then the `release` branch will be deleted. It’s important to merge back into `develop` because critical updates may have been added to the `release` branch and they need to be accessible to new features

```shell
$ git flow release finish 0.1.0
Switched to branch 'master'
Merge made by the 'recursive' strategy.
 CHANGELOG.md | 1 +
 README.md    | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 CHANGELOG.md
 create mode 100644 README.md
Switched to branch 'develop'
Merge made by the 'recursive' strategy.
 CHANGELOG.md | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 CHANGELOG.md
Deleted branch release/0.1.0 (was 07fc48d).

Summary of actions:
- Release branch 'release/0.1.0' has been merged into 'master'
- The release was tagged '0.1.0'
- Release tag '0.1.0' has been back-merged into 'develop'
- Release branch 'release/0.1.0' has been locally deleted
- You are now on branch 'develop'
```

--

## Comparison with raw `git` commands

```shell
$ git flow release finish 0.1.0
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout master
$ git merge --no-ff release/0.1.0
$ git tag -a 0.1.0
$ git checkout develop
$ git merge --no-ff release/0.1.0
$ git branch -d release/0.1.0
```
<!-- .element: class="right width-50" -->

--

## Push

```shell
$ git push --all
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 411 bytes | 0 bytes/s, done.
Total 4 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), done.
To github.com:leksster/empty.git
   ea8af76..55edea2  develop -> develop
   e80daca..662a7ca  master -> master

$ git push --tags
```

---

# Hotfix

> Maintenance or "hotfix" branches are used to quickly patch production releases. `Hotfix` branches are a lot like `release` branches and `feature` branches except they're based on `master` instead of `develop`. This is the only branch that should fork directly off of `master`.

--

![](/assets/images/git/gitflow/hotfix-branches.svg)

--

## Creating hotfix

```shell
$ git flow hotfix start 0.1.1
Switched to a new branch 'hotfix/0.1.1'

Summary of actions:
- A new branch 'hotfix/0.1.1' was created, based on 'master'
- You are now on branch 'hotfix/0.1.1'

Follow-up actions:
- Start committing your hot fixes
- Bump the version number now!
- When done, run:

     git flow hotfix finish '0.1.1'
```

--

## Comparison with raw `git` command

```shell
$ git flow hotfix start 1.2.1
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout -b hotfix/1.2.1 master
```
<!-- .element: class="right width-50" -->

--

## Commit

```shell
$ echo 'Update instructions' > README.md

$ git add .

$ git commit -m 'Change readme instructions'
[hotfix/0.1.1 88daaf7] Change readme instructions
 1 file changed, 1 insertion(+), 1 deletion(-)
```

--

## Finish

> As soon as the fix is complete, it should be merged into both `master` and `develop` (or the current `release` branch), and `master` should be tagged with an updated version number.

```shell
$ git flow hotfix finish 0.1.1
Switched to branch 'master'
Merge made by the 'recursive' strategy.
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
Switched to branch 'develop'
Merge made by the 'recursive' strategy.
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
Deleted branch hotfix/0.1.1 (was 88daaf7).

Summary of actions:
- Hotfix branch 'hotfix/0.1.1' has been merged into 'master'
- The hotfix was tagged '0.1.1'
- Hotfix tag '0.1.1' has been back-merged into 'develop'
- Hotfix branch 'hotfix/0.1.1' has been locally deleted
- You are now on branch 'develop'
```

--

## Comparison with raw `git` commands

```shell
$ git flow hotfix finish 0.1.1
```
<!-- .element: class="left width-50" -->

```shell
$ git checkout master
$ git merge --no-ff hotfix/0.1.1
$ git tag -a 0.1.1
$ git checkout develop
$ git merge --no-ff hotfix/0.1.1
$ git branch -d hotfix/0.1.1
```
<!-- .element: class="right width-50" -->

--

## Push

```shell
$ git push --all
Counting objects: 5, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (5/5), 596 bytes | 0 bytes/s, done.
Total 5 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), done.
To github.com:leksster/empty.git
   55edea2..d1f1ce8  develop -> develop
   662a7ca..85e4e09  master -> master

$ git push --tags
```

---

# Main rules

<br />

- Do not commit to the `master` branch
- One task — one branch
- Every pull-request to the `develop` branch have to be working
- The `release` branch doesn't have to contain any new functionality

---

# Useful Links

<br />

- [Gitflow by Vincent Driessen](http://nvie.com/posts/a-successful-git-branching-model/)
- [Gitflow Cheatsheet](https://danielkummer.github.io/git-flow-cheatsheet/)
- [Gitflow Workflow by atlassian](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [Gitflow step-by-step](http://mkuthan.github.io/blog/2013/07/21/gitflow-step-by-step/)

---

# The End
