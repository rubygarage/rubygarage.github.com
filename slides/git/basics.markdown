---
layout: slide
title: Git
---

![](/assets/images/git/basics/logo.svg)

# Git

---

# What is Git?

> It is a version control system for tracking changes in computer files and coordinating work on those files among multiple people.

---

# Why Git?

### Distributed
<!-- .element: class="fragment" -->

### Exceptionally fast performance
<!-- .element: class="fragment" -->

### Branching and merging
<!-- .element: class="fragment" -->

---

# What is Git Repository?

> The purpose of Git is to manage a project, or a set of files, as they change over time. Git stores this information in a data structure called a repository.

---

# What is Remote Repo?

> To communicate with the outside world, git uses what are called remotes. These are repositories other than the one on your local disk which you can push your changes into (so that other people can see them) or pull from (so that you can get others changes).

---

# What is Git Branch?

> A branch in Git is simply a lightweight movable pointer to commits. The default branch name in Git is `master`. As you initially make commits, you’re given a master branch that points to the last commit you made. Every time you commit, it moves forward automatically.

---

# What is Git staging area?

![](/assets/images/git/basics/staging-area.png)

---

# What is commit?

> A "commit" is a snapshot of your files. Stores the current contents of the index in a new commit along with a log message from the user describing the changes.

---

# What is commit hash?

> Unique ID for particular commit. Big cryptographic string that is directly generated based on the information it represents. Because it is generated based on the information contained in the commit, the hash cannot be changed.

---

# What is `HEAD`?

> A head is simply a reference to a commit object. Each head has a name (branch name or tag name, etc). By default, there is a head in every repository called master. A repository can contain any number of heads. At any given time, one head is selected as the “current head.” This head is aliased to HEAD, always in capitals".

---

# Basic configuration

> Git comes with a tool called `git config` that lets you get and set configuration variables that control all aspects of how Git looks and operates.

> You can make Git read and write to `~/.gitconfig` file specifically by passing the --global option.

--

## Your Identity

> The first thing you should do when you install Git is to set your user name and email address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you start creating:

```shell
$ git config --global user.name 'John Doe'
$ git config --global user.email 'johndoe@example.com'
```

---

# Useful basics commands

| Command      | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| `git clone`  | clone repository into a local directory                      |
| `git init`   | repository setup                                             |
| `git fetch`  | download objects and refs from another repository            |
| `git merge`  | join two or more development histories together              |
| `git pull`   | shorthand for `git fetch` followed by `git merge FETCH_HEAD` |
| `git add`    | add files to queue for next commit                           |
| `git commit` | commit queued files                                          |
| `git log`    | view a log of commits                                        |
| `git diff`   | generate a differences between multiple commits              |
| `git push`   | push commit(s) to remote repository                          |
| `git status` | show uncommited changes                                      |
| `git reset`  | download objects and refs from another repository            |
| `git rebase` | download objects and refs from another repository            |

---

# Commands in Details

---

# Initialization

Lets create our first repository

```shell
$ mkdir ./repo-example && cd ./repo-example

$ git init
Initialized empty Git repository in /home/root/repo-example/.git/
```

---

# Commit

```shell
$ echo "TEST" > README.md

$ git add README.md

$ git commit -m 'Add README.md'
[master (root-commit) 2b726fa] Add README.md
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

--

When you `commit`, git creates a new commit object using the files from the stage and sets the parent to the current commit. It then points the current branch to this new commit.

![](/assets/images/git/basics/commit-master.svg)

---

# Branches

```shell
$ git checkout -b feature/my-new-branch
Switched to a new branch 'feature/my-new-branch'

$ echo 'Useful tip' >> README.md

$ git diff
diff --git a/README.md b/README.md
index 2a02d41..5674f35 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,2 @@
 TEST
+Useful tip

$ git add README.md

$ git diff # empty output

$ git diff --staged
diff --git a/README.md b/README.md
index 2a02d41..5674f35 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,2 @@
 TEST
+Useful tip
```

---

# Status

```shell
$ git status
On branch feature/my-new-branch
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   README.md
```

---

# Log

```shell
$ git commit -m 'Update Some File'
[feature/my-new-branch 1308517] Update some file
 1 file changed, 1 insertion(+)

$ git log
commit 130851795b42775f070b19fdc125ee48649696a5 (HEAD -> feature/my-new-branch)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 21:49:21 2017 +0200

    Update some file

commit 2b726fa8a1d23c001ba3523f03521b7d5d39d76d (master)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 20:55:09 2017 +0200

    Add README.md
```

---

# Checkout

```shell
$ git checkout master
Switched to branch 'master'

$ git checkout -
Switched to branch 'feature/my-new-branch'
```

---

# Amend

```shell
$ git commit --amend -m 'Update README.md'
[feature/my-new-branch 0f005b6] Update Readme.md
 Date: Sun Dec 3 21:49:21 2017 +0200
 1 file changed, 1 insertion(+)
```

--

Sometimes a mistake is made in a commit, but this is easy to correct with `git commit --amend`. When you use this command, git creates a new commit with the same parent as the current commit. (The old commit will be discarded if nothing else references it).

![](/assets/images/git/basics/commit-amend.svg)

---

# Merge

```shell
$ git checkout master
Switched to branch 'master'

$ git log
commit 2b726fa8a1d23c001ba3523f03521b7d5d39d76d (HEAD -> master)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 20:55:09 2017 +0200

    Add README.md

$ git branch
feature/my-new-branch
* master

$ git merge feature/my-new-branch master
Updating 2b726fa..0f005b6
Fast-forward
README.md | 1 +
 1 file changed, 1 insertion(+)

$ git log
commit 0f005b6f2ace47f2e267f91fa1d372651f3eef4a (HEAD -> master, feature/my-new-branch)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 21:49:21 2017 +0200

    Update Readme.md

commit 2b726fa8a1d23c001ba3523f03521b7d5d39d76d
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 20:55:09 2017 +0200

    Add README.md
```

--

A merge creates a new commit that incorporates changes from other commits. Before merging, the stage must match the current commit. The trivial case is if the other commit is an ancestor of the current commit, in which case nothing is done. The next most simple is if the current commit is an ancestor of the other commit. This results in a fast-forward merge. The reference is simply moved, and then the new commit is checked out.

![](/assets/images/git/basics/merge-ff.svg)

---

# Deleting a Branch

```shell
$ git branch -d feature/my-new-branch
Deleted branch feature/my-new-branch (was 0f005b6).

$ git branch
* master
```

The `-d` option is an alias for `--delete`, which only deletes the branch if it has already been fully merged in its upstream branch. You could also use `-D`, which is an alias for `--delete --force`, which deletes the branch "irrespective of its merged status."

---

# Reset

```shell
$ echo '<?= "I love PHP" ?>' > index.php

$ git add .

$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   index.php

$ git reset

$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	index.php

nothing added to commit but untracked files present (use "git add" to track)
```

--

```shell
$ git add .

$ git commit -m 'Make terrible mistake'
[master c2dc263] Make terrible mistake
 1 file changed, 1 insertion(+)
 create mode 100644 index.php

$ git log
commit c2dc2634e05f42177bef04f5a86f09a901d45fbd (HEAD -> master)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 22:39:10 2017 +0200

    Make terrible mistake

commit 0f005b6f2ace47f2e267f91fa1d372651f3eef4a
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 21:49:21 2017 +0200

    Update Readme.md

commit 2b726fa8a1d23c001ba3523f03521b7d5d39d76d
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 20:55:09 2017 +0200

    Add README.md
```

--

```shell
$ git reset --hard HEAD~1
HEAD is now at 0f005b6 Update Readme.md
```

![](/assets/images/git/basics/reset.svg)

---

# Cherry pick

```shell
$ git checkout -b feature/add-license
Switched to a new branch 'feature/add-license'

$ echo 'Copyright (c) 2017' > license.md

$ git add .

$ git commit -m 'Add license'
[feature/add-license 41dbc16] Add license
 1 file changed, 1 insertion(+)
 create mode 100644 license.md

$ git checkout master
Switched to branch 'master'

$ git cherry-pick feature/add-license

$ git log
commit cc391429bc307f2b8a6440058117a8c0645f0860 (HEAD -> master)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 22:50:41 2017 +0200

    Add license

commit 0f005b6f2ace47f2e267f91fa1d372651f3eef4a (feature/product-filters, feature/cherry)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 21:49:21 2017 +0200

    Update Readme.md

commit 2b726fa8a1d23c001ba3523f03521b7d5d39d76d
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 20:55:09 2017 +0200

    Add README.md
```

--

![](/assets/images/git/basics/cherry-pick.svg)

---

# Rebase

```shell
$ echo 'v0.1.0 Some Improvements' > CHANGELOG.md

$ git add .

$ git commit -m 'Make release v0.1.0'
[master 7a8bee0] Make release v0.1.0
 1 file changed, 1 insertion(+)
 create mode 100644 CHANGELOG.md

$ echo 'v0.2.0 Some new feature' >> CHANGELOG.md

$ git add .

$ git commit -m 'Make release v0.2.0'
[master c5d7b62] Make release v0.2.0
 1 file changed, 1 insertion(+)

$ git log
commit c5d7b624fd1ad3934fc00332dc910aa051e180e4 (HEAD -> master, feature/cherry, feature/add-license)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 23:01:11 2017 +0200

    Make release v0.2.0

commit 7a8bee0df2a339213cfb788270a45f6ddf41df48
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 22:59:07 2017 +0200

    Make release v0.1.0
```

--

```shell
$ git checkout feature/add-license
Switched to branch 'feature/add-license'

$ git rebase master
First, rewinding head to replay your work on top of it...
Fast-forwarded feature/add-license to master.

$ git log
commit cc391429bc307f2b8a6440058117a8c0645f0860 (HEAD -> feature/add-license, master)
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 22:50:41 2017 +0200

    add license

commit c5d7b624fd1ad3934fc00332dc910aa051e180e4
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 23:01:11 2017 +0200

    Make release v0.2.0

commit 7a8bee0df2a339213cfb788270a45f6ddf41df48
Author: Rubygarage <info@rubygarage.org>
Date:   Sun Dec 3 22:59:07 2017 +0200

    Make release v0.1.0

```

---

# Diff

```shell
$ echo 'New Info' > README.md

$ git diff
diff --git a/README.md b/README.md
index 5674f35..893bd01 100644
--- a/README.md
+++ b/README.md
@@ -1,2 +1 @@
-TEST
-Useful tip
+New Info
(END)

$ git checkout -- README.md
(END)
```

--

![](/assets/images/git/basics/diff.svg)

---

# Push

`origin` is an alias on your system for a particular remote repository

```shell
$ git remote add origin git@github.com:rubygarage/repo-example.git

$ git push
Counting objects: 22, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (14/14), done.
Writing objects: 100% (22/22), 1.89 KiB | 0 bytes/s, done.
Total 22 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), done.
To github.com:rubygarage/repo-example.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.
```

---

# Pull

```shell
$ git pull
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 1), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From github.com:rubygarage/repo-example
   1182d69..3048a8d  master     -> origin/master
Updating 1182d69..3048a8d
Fast-forward
 CHANGELOG.md | 1 +
 1 file changed, 1 insertion(+)
```

---

# Remotes

```shell
$ git remote -v
origin	git@github.com:rubygarage/repo-example.git (fetch)
origin	git@github.com:rubygarage/repo-example.git (push)
```

---

# Conflicts

> Merge conflicts may occur if competing changes are made to the same line of a file or when a file is deleted that another person is attempting to edit.

--

### Explanation

- the top half is the branch you a merging into
- the bottom half is from the commit that you are trying to merge in

```
<<<<<<< HEAD
foo
=======
bar
>>>>>>> cb1abc6bd98cfc84317f8aa95a7662815417802d
```

> What this means in practice if you are doing something like `git pull` (which is equivalent to a `git fetch` followed by a `git merge`) is:

- the top half shows your local changes
- the bottom half shows the remote changes, which you are trying to merge in

---

# Additinal Commands

| Command                   | Description                                                     |
| ------------------------- | --------------------------------------------------------------- |
| `git blame`               | show what revision and author last modified each line of a file |
| `git stash (pop / apply)` | stash the changes in a dirty working directory away             |
| `git show`                | show various types of objects                                   |
| `git tag`                 | create, list, delete or verify a tag object signed with GPG     |
| `git bisect`              | use binary search to find the commit that introduced a bug      |
| `git reflog`              | manage reflog information                                       |
| `git prune`               | prune all unreachable objects from the object database          |

---

# `.gitignore` file

> If you create a file in your repository named `.gitignore`, Git uses it to determine which files and directories to ignore, before you make a commit.

--

## Example of `.gitignore` file

```
# Ignore bundler config.
/.bundle

# Ignore secrets
/config/application.yml
/config/database.yml
/config/cable.yml

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

# Ignore spec files
/spec/examples.txt

.byebug_history

# Ignore encrypted secrets key file.
config/secrets.yml.key

# Ignore test coverage info
/coverage/*
```

---

# Useful configs

```shell
git config --global push.default current
git config --global pull.rebase true

git config --global core.quotepath false
git config --global core.filemode false
git config --global core.editor vim

git config --global core.autocrlf input
git config --global core.safecrlf true

git config --global color.interactive true
git config --global color.branch true
git config --global color.status true
git config --global color.diff true
git config --global color.ui true

git config --global color.branch.current 'yellow'
git config --global color.branch.local 'yellow'
git config --global color.branch.remote 'green'

git config --global color.status.changed 'yellow'
git config --global color.status.untracked 'red'
git config --global color.status.added 'green'
```

You can find more config options on [Git Config](https://git-scm.com/docs/git-config) page.

---

# Useful git-aliases

```shell
git config --global alias.a 'add -A'
git config --global alias.b 'branch'
git config --global alias.ca 'commit --ammend --no-edit'
git config --global alias.ci 'commit'
git config --global alias.co 'checkout'
git config --global alias.cp 'cherry-pick'
git config --global alias.d 'diff'
git config --global alias.dc '!git --no-pager diff --name-only --diff-filter=U'
git config --global alias.ds '!git diff --staged'
git config --global alias.dst '!git --no-pager diff --stat'
git config --global alias.it '!git init && git commit -m "init" --allow-empty'
git config --global alias.l 'log --graph --decorate --abbrev-commit --date="format:%d.%m.%Y" --pretty="format:%C(yellow)%h %C(blue)%ad%C(auto)%d %C(reset)%s %C(green)%aN%C(reset) %C(blue)(%ar)%C(reset)"'
git config --global alias.s 'status --short --branch'
git config --global alias.sup '!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`'
```

---

# The End
