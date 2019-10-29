---
layout: slide
title: Continuous integration
---

# Introduction to Continuous strategies

---

# Why do we use that?

-  You have a team working on this project. Your team deliver some amount of features/per day/per week/ per sprint.
-  All participants of your team want to be sure that your repository contains stable and covered with specs code.

--

## Under control
All of these cases could be handled with continuous strategies

- Continuous integration
- Continuous delivery
- Continuous deployment 

---
# Continuous integration
It's is a development practice that requires developers to integrate code into a shared repository several times a day.

Each check-in is then verified by an automated build, allowing teams to detect problems early.

--

## Benefits

- Say goodbye to long and tense integrations
- Increase visibility enabling greater communication
- Catch issues early and nip them in the bud
- Spend less time debugging and more time adding features
- Build a solid foundation
- Stop waiting to find out if your code’s going to work
- Reduce integration problems allowing you to deliver software more rapidly

---

![](/assets/images/ci.jpg)

---

# Continuous delivery
Continuous delivery is an extension of continuous integration to make sure that you can release new changes to your customers quickly in a sustainable way. This means that on top of having automated your testing, you also have automated your release process and you can deploy your application at any point of time by clicking on a button.

### CD(delivery) = CI + Autodeploy to staging


---

# Continuous deployment
Continuous deployment goes one step further than continuous delivery. With this practice, every change that passes all stages of your production pipeline is released to your customers. There's no human intervention, and only a failed test will prevent a new change to be deployed to production.

### CD(deployment) = CI + Autodeploy to production

---

### Continuous delivery VS Continuous deployment

![](/assets/images/ci_vs_cd.png)

---

# Control questions

- What is continuous integration and how does it work?

- What benefits do we get from continuous integration?

- What is Continuous delivery?

- What is Continuous deployment?

- What criterias for continuous strategy choosing for your project?
