---
layout: slide
title:  Code Review
---

# Code Review

---

## What is Code Review?

Code review is a process for detecting the issues in a project code

---

## Main points
Code review ...

- should be initiated by team members - not business staff of managers
- should be clean and well-structured
- should have all precondition phases completed(details in next slides)
- is suitable for all level of developers as a reviewer
- is suitable for all level of developers as a reviewee
- is suitable for all languages and specific cases

---

## What to review

- markdown issues
- code standards issues
- syntax issues
- performance issues
- general structure of code
- potential miss logics and bugs

---

# NO!

---

## Correct way

- potential miss logics and bugs  ->   Specs and CI!(partially)
- general structure of code
- performance issues              ->   Linters and CI!(partially)
- syntax issues                   ->   Linters and CI!
- code standards issues           ->   Linters and CI!
- markdown issues                 ->   Linters and CI!

---

## Potential cons of code review

- Another one doesn't understand my code as i do
- Too much time spent for reviewing
- It's not the best knowledge sharing tool
- I write the best specs and have CI!
- It's so stressful

---

# Part 1 - Code Owner

---

## Initiating

- `Developer A` right after finishing his task pushes his code to VCS provider(Github, Github, e.t.c)
- `Developer A` knows all the GitFlow standards of his project/company and know how to name the branch and commits well
- `Developer A` prepare the PR (correct title, description, milestones, labels, e.t.c, assignee)
- `Developer A` check all the source code before setting reviewers
- `Developer A` checks that all tests and specs are "green"
- `Developer A` sets a reviewers
- `Developer A` notifies all the reviewers about pending Pull Request

---

## Processing

- `Developer A` checks all the comments and change the PR staff(labels, attachments, e.t.c)
- `Developer A` fix the comments
- If `Developer A` are strongly disagree with his reviewer we propose not to make a panic in comments but discuss it in another communication channel
- It's required to leave a reply comment with a result of communication in such cases

---

## Common oopsies

- Huge complexity PR's
- Several tasks in one PR
- Lovely refactoring in files which are not related to task
- Notify all the reviewers before check the PR and specs completing
- Propose to review not final version of code
- Miss logic with current/parent branches and current/target branches
- Holy war in comments
- Forgetting about the branch after requiring the review
- Mark as a resolved without any issue or ignore the comment
- Agression! Too much agression!
- Ask a question to reviewer before searching the info
- Forget to notify the reviewers after finishing the fix

---

# Part 2 - Code Reviewer

---

## Processing
- `Developer B` receives a notification about review and opens the PR
- `Developer B` checks the common sense of PR, read the details in description and tech details
- `Developer B` checks that all specs are green
- `Developer B` checks all the code in general - hierarchy, classes, modules, gems, e.t.c and leaves a comments
- `Developer B` understands all the logic of code wrote and leaves a comments
- `Developer B` lives a comment with :+1 or something like that in comments of other reviewers if he agrees with it
- `Developer B` change a label of Pull Request is needs some changes or it's a last review

---

## Common mistakes

- Leaves comments like `redo`, or `change` without any sense.
- Doesn't leave comments after communication in another channel (Slack, telegram, email, etc)
- Provide a review for not `one-way resolution` things, when some code are pretty similar to your alternative
- Forget to change the status of PR
- Don't set the resolution to PR - `Approve` or `Request Changes`
- Provide the comments in imperative mood, e.g `Fix it ...`, `Change it ...`
- Provide review for lines of code but not for all PR

---

## Best practices

- Check the complexity of PR - not the code styling
- The best value is finding the miss logic in code - not finding the code smells
- Leave comments with a text like `Good catch :+1` or `Looks good` if some place of code sounds well. Code review isn't only critics
- If you're going to criticize it, then suggest something else. The best way is to provide a link or example of pseudocode
- Don't play in a `good/bad cop` with other reviewers
- Help someone with code if you understands that you have a great complex idea
- Remember that there is no ideal code
- Use `Nit`s in your code. When you have small issue and that's doesn't affect the code quality of all code you can make comments like `Nit: please lets use each_with_index instead each.with_index next time`

---

## Usefull things

- Linters and linter preprocessors(lefthook, overcommit)
- Continuos Integration(We use CircleCi)
- Use Github Notifiers in order not to forget about reviews
- Use Github Template for each PR

---

# The End
