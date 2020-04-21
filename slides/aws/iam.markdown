---
layout: slide
title:  IAM
---

## Identity and Access Management

**Identity and Access Management (IAM)** - is where you manage your AWS users, groups, and roles, as well as their access to AWS accounts and services.

- **provides access and access permissions to AWS resources (such as 	EC2, S3 and DynamoDB) **

- **is global to all AWS regions — creating a user account will apply to all regions**

---

## IAM Features

- *Shared access to your AWS account*

- *Granular permissions*

- *Secure access to AWS resources for applications that run on Amazon EC2*

- *Multi-factor authentication (MFA) *

- *Identity federation*

- *Identity information for assurance*

---

# Policies

`Policy` - is an authorization file that describes which type of access to services the `AWS identity` has.
By default all actions for all types of identities are denied. Only root user can perform any actions for its account. To give different kinds of access you have to assign policy to identity. There is an ability to chose policy from `AWS managed list` or create custom policy you need.

--

## How to create

> `Services -> IAM -> Policies (Left menu) -> Create policy`

Then you can specify policy content through `visual editor` or using `JSON`.

--

## JSON Policy Document Structure

- `Version` - Specify the version of the policy language that you want to use (as a best practice, use the latest 2012-10-17 version) 

- `Statement` — container which includes information about a single permissions 	(consists from next elements) 

- `Sid (optional)` — id 

- `Effect` — Use Allow or Deny to indicate whether the policy allows or denies access

- `Principal (optional)` 	- Account, user, role, or federated user to which you would like to allow or deny access

- `Action` - Include a list of actions that the policy allows or denies

- `Resource (optional)` - A list of resources to which the actions apply

- `Condition (optional)` - Specify the circumstances under which the policy grants permission

--

## Templates

- **Administrator access** — Full access to all AWS resources 

- **Power user access** — Like «Administrator access», but it does not allow user/group managment

- **Read-only access** — Only view AWS resources (user can view what is in an S3 bucket)

You can also create custom IAM permission policies using the policy generator or written from scratch.

--

### Identity-based policies are permissions policies that you attach to an IAM identity (such as an IAM user, group, or role).

*`Managed policies` - policies that you can attach to multiple users, groups, and roles in your AWS account*

*`AWS managed policies` – Managed policies that are created and managed by AWS*

*`Customer managed policies` – Managed policies that you create and manage in your AWS account.*

*`Inline policies` – Policies that you create and manage and that are embedded directly into a single user, group, or role.*

--

## Useful links

Policies and Permissions:
https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html

Examples:
https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html

Overview of Access Management:
https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_access-management.html

---

# Users

`IAM user` - is the one who have some access to your AWS account. You can attach policy to user during creation or later.

--

## To add policy to user:

> `Services -> IAM -> Users (Left menu) -> Choose user -> Add permissions`

One more feature in this part is `permissions boundary`. The permission boundary dominates over common permissions, it restricts access even if common permission allowing some actions with some resources.

--

## Users and credentials

You can access AWS in different ways depending on the user credentials:

- **Console password **

- **Access keys**

- **SSH keys for use with CodeCommit**

- **Server certificates**

- **Manage passwords, access for your IAM users**

- **Enable multi-factor authentication (MFA)**

--

## Useful links

https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_identity-management.html

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html

---

# Groups

`Group` - is a collection of users. You can set policy to a group and it will be applied to each user in the group.

**allow	you to assign IAM permission policies to more than one user at a time**

**allows for easier access management to AWS resources**

**can contain many users, and a user can belong to multiple	groups.**

**can't be nested; they can contain only users, not other groups**

**there's a limit to the number of groups you can have, and a limit to how many groups a user can be in**

--

## How to create group:

> `Services -> IAM -> Groups (Left menu) -> Create new group`

## To attach users:
> `Click on group name -> Add users to Group`

--

## Useful links

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html

---

# Roles

`Roles` are needed to get temporary permissions for performing some actions. It can be assumed by `AWS Account`, `AWS service` or `Web Identity`. It is an important topic, because roles are widely used in many AWS services.

You can use roles to delegate access to users, applications, or services that don't normally have access to your AWS resources

--

## How to create role

> `Services -> IAM -> Roles (Left menu) -> Create role`

You have to specify which actions can be performed by adding `policy`, and also specify trust relationships, i.e. who can perform actions that is defined in policy.

--

## Useful links

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html

---

# Access Keys

`Access keys` are needed to perform actions via `CLI`. It can be generated for IAM user. It consists from the public part - `ID`, and the secret part - `secret key`.

## How to create keys

> `Services -> IAM -> Users (Left menu) -> Choose user -> Security credentials tab -> Create access key`

The secret key will be shown only `once`, so you have to save it in some way.

---

# IAM Best practices

it is strongly recommended not to use the root user and create another user with administrative permissions for yourself 

when 	a new AWS root account is created, complete the tasks listed in IAM	under Security Status:

1. `Delete your root access keys`
2. `Activate MFA on your root account`
3. `Create individual IAM users`
4. `User IAM groups to assign permissions`
5. `Apply an IAM password policy `

--

## Root user

With the root user you can perform any actions you need. However, the best way to manage your AWS sevices in terms of security is to use other I AM users to perform any actions. For example, you can create an Administrator user with necessary access rights and then use it for common operations you need.


## Groups

You do not need to assign custom policy for each I AM user, the best solution is to set `AWS managed policy` for group and then customize any user individually with inline policy.

--

## Billing Alert

There are may be some cases, when you do not know if the AWS service can charge you or not. Also you can forget to deactivate some service that was activated during studying AWS services. Anyway, it is recommended to set up `billing alarm` for your account for notifying when some money limit will be reached. You can choose any amount you want.

> `Services -> CloudWatch -> Alarms(Billing) (*left menu*) -> Create alarm ->
> *Scroll down* -> *Define the limit* -> Next ->`
> `Create new topic -> *Enter topic name* -> *Enter email for notification* -> Create topic ->
> *Confirm subscription at your email box* -> *Set alarm name* -> Next -> Create alarm`

--

## MFA

To secure your AWS account there is an opportunity to use multi-factor authentication. It can be activated this way:

> `Services -> I AM -> MFA -> Activate MFA`

![](/assets/images/aws/iam/mfa_1.png)

--

> *Choose* `Virtual MFA device`

![](/assets/images/aws/iam/mfa_2.png)

*NOTE: You need MFA app to be already installed to your device (phone, laptop, browser) to move to the next step.*

--

Then you will be prompted to scan QR-code or enter authentication codes. If codes option chosen you should enter two consecutive codes from your app.

![](/assets/images/aws/iam/mfa_3.png)

--

Then you will see something like this:

![](/assets/images/aws/iam/mfa_4.png)

--

## Authy vs Google Authenticator

As a personal preference, I recommend to use `Authy` app over `Google Authenticator` for `MFA`. It has some solid advantages compared to other apps, like multi-device support and encrypted recovery backups. You can install `authy` to your mobile and laptop, for example, and easily manage devices that you are using for MFA when needed (in case you lost your phone/laptop or decide to buy the new one).

---

# The End

---
