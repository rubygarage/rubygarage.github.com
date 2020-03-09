---
layout: slide
title: EC2
---

## What is EC2

Amazon Elastic Compute Cloud(Amazon EC2) - it is a web service that provides scalable computing resources in the cloud. The service allows you to simplify the process for developers of computing on the Internet.

--

## What is cloud computing?

This is the provision of computing services (including servers, storage, databases, networks, software, analytics and data mining) via the Internet (“cloud”)

--

## Advantages

`Expenses` - Cloud computing avoids the capital cost of acquiring hardware and software, setting up and operating local data centers

`Global scale` - cloud computing services include scalability

`Performance` - cloud computing services regularly updated to the latest generation of fast and efficient computing equipment

`Security` - cloud service providers increase security by helping protect data, applications, and infrastructure from potential threats

`Speed` - large amounts of computing resources can be prepared in a few minutes, usually in just a few clicks

`Reliability` - Cloud computing makes data backup, disaster recovery, and business continuity easier and less costly

---

# Regions

This is the physical location where our data centers are located

--

## All existing regions

![](/assets/images/aws/regions_aws.png)

--

## Which region to choose?

You need to choose a region based on the needs of your specific application.
It may make sense to store data in a region that...

- located close to your customers, data centers or other AWS resources, to reduce data access latency

- removed from your other nodes and systems for geographic redundancy and disaster recovery

- allows you to meet certain legal and regulatory requirements

- reduces the cost of machine hours and data storage. For economic reasons, you can choose a less expensive region

---

# Instance

`An EC2 instance` - is a virtual server in Amazon's Elastic Compute Cloud, for running applications on the Amazon Web Services infrastructure

--

##Kinds of instances

- **On Demand Instances:** short workload, predictable pricing
- **Reserved Instances:** long workloads (>= 1 year)
- **Convertible Reserved Instances:** long workloads with flexible instances
- **Scheduled Reserved Instances:** launch within time window you reserve
- **Spot Instances:** short workloads, for cheap, can lose instances
- **Dedicated Instances:** no other customers will share your hardware
- **Dedicated Hosts:** book an entire physical server, control instance placement

--

##EC2 launch types:

 **On Demand Instances:** - the most common type of server (when needed for several hours, for example, turned on for 2 hours and then immediately deleted) payment is done hourly. If you turned on the server for 5 minutes and then turned it off, then you will pay for an hour

 **Spot** - when on demand servers are not taken so that they are not idle, they can reduce the price.
  they are needed for works that do not require the importance of storing information on the servers themselves, that is, they do some work and no matter what happens to the data

--

## Reserved:

 **Reserved Instances:** - usually take for long periods from 1 to a maximum of 3 years, this is a very cheap option compared to ondemand (70% cheaper). Can be payed by 3 ways: No Upfront - all sum at the end of contract; Partial Upfront - pay by parts; All Upfront - all sum right away (Most cheepest way)

 **Scheduled Reserved Instances** -  almost the same as a **Reserved Instances** but can be purchaised for a smaller term with recurring launches (daily, weekly or monthly).  They are available in the following Regions: US East (N. Virginia), US West (Oregon), and Europe (Ireland).

 **Convertible Reserved Instances:** - Can change the EC2 instance type. Up to 54% discount

--

## Dedicated

 **Dedicated hosts** - when the whole server (not a piece of processor and memory) belongs to you. needed for leasing

 **Dedicated instances** - physical instances running on hardware that’s dedicated to you. May share hardware with other instances in same account. No control over instance placement (can move hardware after Stop / Start)

---

##Types of instances

Types include how many processors, memory, disks

Instance types naming schema:
**type(+generation).(multiplier+)sizetype**

![](https://imgur.com/LRLKOWT.png)

# Types of EC2 Instances

- General Purpose Instances - **T, M** - (generic type, free)

- Computer Optimized Instances - **C** - (bigger and more powerful processors)

- Memory Optimized Instances - **X, R, High Memory, z1d** - (memory db)

- Accelerated Computing Instances - **P, G, Inf, F** - (powerful graphics cards)

- Storage Optimized Instances - **I, D, H** - (for databases, when needs to connect many hard disks)

### Size types:
**micro, nano, small, medium, large, xlarge(extra large)**

**metal** - special size type with physical CPUs

###From more info see: https://mindmajix.com/aws-ec2-instance-types

---

#Amazon Elastic Block Store (EBS)

is an easy to use, high performance block storage service designed for use with Amazon Elastic Compute Cloud (EC2) for both throughput and transaction intensive workloads at any scale. A broad range of workloads, such as relational and non-relational databases, enterprise applications, containerized applications, big data analytics engines, file systems, and media workflows are widely deployed on Amazon EBS.


*Snapshot* - reserve copy of Volume
--

## Volume types:

**Root-Boot volumes:**
**General purpose SSD (GP2)** - up to 10.000 *iops.<br />
(Boot volumes, low-latency interactive apps, dev & test)

**Provisioned IOPS SSD (IO1)** - up to 20.000 iops. **Most powerful volume type.**<br />
(I/O-intensive NoSQL and relational databases)

**Magnetic** - standart HDD

*iops - input/output operations per second

#### **Additional types. (Not available as root-boot volume):**
**Throughput Optimized HDD (ST1)** - enchanced HDD. For frequently accessed workloads.<br />
(Big data, data warehouses, log processing)

**Cold HDD (SC1)** - lowest cost HDD. For less frequently accessed workloads.<br />(Colder data requiring fewer scans per day)

--

## Changing the Instance Type

To change the type of your instance, you just need to stop(not terminate!) it, change the type and start it again.

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-resize.html

---

# AMI

AMI - the type of virtual device that is used to create the virtual machine.

the virtual machine on which all the software is stored, you can use it to start new instances

https://ru.bmstu.wiki/AMI_(Amazon_Machine_Image)

---

# Tags

Amazon Web Services allows customers to assign metadata to their AWS resources in the form of tags. Each tag is a simple label consisting of a customer-defined key and an optional value that can make it easier to manage, search for, and filter resources. Also it is aws best practices

For more info - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html

https://aws.amazon.com/answers/account-management/aws-tagging-strategies/

---

#Key pairs

Amazon AWS uses keys to encrypt and decrypt login information. At the basic level, a sender uses a public key to encrypt data, which its receiver then decrypts using another private key. These two keys, public and private, are known as a key pair. You need a key pair to be able to connect to your instances

--

##How to create Key pair for EC2

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.

- In the navigation pane, choose *Key Pairs*.

- Choose Create *key pair*.

- For *Name*, enter a descriptive name for the key pair.

- For *File format*, choose the format in which to save the private key. To save the private key in a format that can be used with OpenSSH, choose *pem*. To save the private key in a format that can be used with PuTTY, choose *ppk*.

- Choose *Create key pair*.

for more info(different contents of key pairs and manage it) see -  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html

---

#Security Group

AWS security groups (SGs) are associated with EC2 instances and provide security at the protocol and port access level. Each security group — working much the same way as a firewall — contains a set of rules that filter traffic coming into and out of an EC2 instance

--

#How to create

By default, new security groups start with only an outbound rule that allows all traffic to leave the instances. You must add rules to enable any inbound traffic or to restrict the outbound traffic.


###To create a security group using the console

*Open the Amazon VPC console at https://console.aws.amazon.com/vpc*

*In the navigation pane, choose Security Groups.*

*Choose Create Security Group.*

*Enter a name for the security group (for example, my-security-group) and provide a description. Select the ID of your VPC from the VPC menu and choose Yes, Create.*

--

##Rules

AWS Security Groups have a set of rules that filter traffic in two ways: inbound and outbound. Since AWS security groups are assigned differently, you won’t be needing the same rules for both inbound and outbound traffic. Thus, any provision that permits traffic into the EC2 instance will ultimately filter outbound traffic.


To further break this down each rule is made up of four principal components: Type, Protocol, Port Range, and Source. There is also a space for a description as well.

--

![](/assets/images/aws/security_group_rules.png)

*Rule* allows for selection of the common type of protocols such as HTTP, SSH, etc., and it opens a drop-down menu were all the protocols are listed.

*Protocols* are automatically selected to be the TCP. However, it can be changed to UDP, ICMP as well as assigns a corresponding association to IPv4 or IPv6.

*Port Range* is also pre-filled, but you can decide to choose the port range of your choice depending on the protocol. Nonetheless, there will be times when you will have to use the custom port range number. A selection of ICMP will grey out the port selection option as it is not a layer 4 protocol.

*Source* (custom IP) this can be a particular IP address or a subnet range. However, you can grant access using the anywhere source IP (0.0.0.0/0) value. Allowing access through the anywhere source can turn out to be a mistake every AWS user should avoid. It will be a discussion in the best practices section below.

--

##Add a rule using the console

*Open the Amazon VPC console at https://console.aws.amazon.com/vpc/.*

*In the navigation pane, choose Security Groups.*

*Select the security group to update.*

*Choose Actions, Edit inbound rules or Actions, Edit outbound rules.*

*For Type, select the traffic type, and then fill in the required information. For example, for a public web server, choose HTTP or HTTPS and specify a value for Source as 0.0.0.0/0.*


*You can also allow communication between all instances that are associated with this security group. Create an inbound rule with the following options:*

  **Type: All Traffic**

  **Source: Enter the ID of the security group.**

*Choose Save rules.*

--

##Delete a rule using the console

*Open the Amazon VPC console at https://console.aws.amazon.com/vpc/.*

*In the navigation pane, choose Security Groups.*

*Select the security group to update.*

*Choose Actions, Edit inbound rules or Actions, Edit outbound rules.*

*Choose the delete button (“x”) to the right of the rule that you want to delete.*

*Choose Save rules.*

--

##Update a rule using the console

*Open the Amazon VPC console at https://console.aws.amazon.com/vpc/*

*In the navigation pane, choose Security Groups.*

*Select the security group to update.*

*Choose Actions, Edit inbound rules or Actions, Edit outbound rules.*

*Modify the rule entry as required.*

*Choose Save rules.*

--

You must provide it with a name and a description. The following rules apply:

*Names and descriptions can be up to 255 characters in length*

*Names and descriptions are limited to the following characters: a-z, A-Z, 0-9, spaces, and ._-:/()#,@[]+=&;{}!$**

*A security group name cannot start with sg-*

*A security group name must be unique within the VPC*


--

###Tips on Configuring Security Groups:

Avoid incoming traffic through (0.0.0.0/0)
 It could end up exposing sensitive cloud information to outside threats.

Avoid opening the floodgates to the entire internet
The best thing to do is permit only necessary IP ranges and their respective ports to send incoming traffic, and all other connection attempts will be dropped


Delete unused security groups
  There is no need to keep a security group not assignedto an EC2 instance


Enable Tracking and Alerting
  AWS comes with some unique set of tools that allows its user to keep track of working information. The AWS Cloudtrail is a cloud tool that enforces the compliance of AWS.

---

#Monitoring Instances with CloudWatch

You can enable detailed monitoring on an instance as you launch it or after the instance is running or stopped. Enabling detailed monitoring on an instance does not affect the monitoring of the EBS volumes attached to the instance. For more information, see Amazon CloudWatch Metrics for Amazon EBS

--

##To enable detailed monitoring for an existing instance (console)

*Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.*

*In the navigation pane, choose Instances.*

*Select the instance and choose Actions, CloudWatch Monitoring, Enable Detailed Monitoring.*

*In the Enable Detailed Monitoring dialog box, choose Yes, Enable.*

*Choose Close.*

---

#Instance Lifecycle

![](/assets/images/aws/instance_lifecycle.png)

--

*Pending* - When the instance is first launched is enters into the pending state. The instance is being provisioned in this state


*Running* - When the instance is ready and can be used, it enters the running state. The instance can be used, rebooted, shut down or terminated from this state. The user starts paying for the instance in this state.

*Stop & Start (EBS-backed instances only)* - Note that only EBS-backed instance (where the root volume is EBS volume) can be stopped and started. Instance store-backed instances cannot be stopped and started. When an instance is stopped and started, AWS usually will start the instance in a new host, thus the instance can stopped & started when the instance fails a system status check. When the instance is stopped, the instance changes state from running to stopping to stopped state. When in stopped state, certain attributes of the instance can be modified. When the instance is started, it changes state from pending to running.

--

*Stop* - When the instance is stopped, the instance changes state from running to stopping to stopped state. The user will not pay for the EC2 instances in this state (EBS volumes are charged in usual rate). Therefore, for development purpose EC2 instances, it is better to stop the instances in non-business hours and weekends or as the business see fit. The root volume can be used as any other EBS volumes and can be detached from the stopped instance, and attached to a different running instance and re-attached to another instance.

*Start* - When the instance is started, it changes state from pending to running. When an instance is stopped and started, AWS usually will start the instance in a new host, thus the instance can stopped & started when the instance fails a system status check. Any data that previously persisted on instance store volume would be lost while data on the EBS volume would persist. When started, the public IP of the instance is changed but the elastic and private IP is retained. EC2 instances are charged for full hours and stopping and starting the instance would incur more charges.

--

*Instance Reboot* - Both EBS-backed and Instance store-backed instances can be rebooted. Rebooting is different that stopping and starting an instance in that it retains the public IP (and private and elastic IP), data on the instance store volumes (and EBS volumes). The instance can be rebooted from the AWS console and also from the operating system but AWS recommends rebooting EC2 instance from the console as it performs a hard reboot.

*Instance Retirement* - An instance is scheduled to be retired when AWS detects irreparable failure of the underlying hardware hosting the instance. When an instance reaches its scheduled retirement date, it is stopped or terminated by AWS. If the instance root device is an Amazon EBS volume, the instance is stopped, and can be started again at any time. If the instance root device is an instance store volume, the instance is terminated, and cannot be used again.

--

*Instance Termination* - When an instance is terminated, it enters into the shutting-down and then the terminated state. When an instance is terminated, it cannot be used and will not be charged. EBS-backed instances support InstanceInitiatedShutdownBehavior attribute which determines whether the instance would be stopped or terminated during an instance initiated shutdown command. By default, the instance would be stopped. A shutdown command for an Instance store-backed instance will always terminate the instance.

*Termination Protection* - Termination protection can be enabled by the DisableApiTermination attribute that prevents an instance from being accidently terminated from the AWS console, CLI, and the API. The attribute is available to both instance-store and EBS backed instances. Note that termination protection does not work for spot instances, instances launched through Autoscaling group and when terminating an instance by shutting down the instance from the operating system

*Data Persistence* - EBS volume has DeleteOnTermination attribute that determines whether the volumes would be persisted or deleted when an instance it is associated with is terminated. By default, the root volume is deleted and the additional volumes are preserved but detached from the instance. Data on Instance store volume data does not persist.

---

# Launching an EC2 Instance

Before launching an instance it is better to be aware that you are elegible for AWS `Free Tier`. You can check it in `My Billing Dashboard` section.

So, the order of actions to launch an instance is:

> Go to AWS console -> `Services` -> `EC2` -> `Instances` (*left menu*) -> `Launch Instance` ->
> Choose AMI you need (*Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type, ami-0e2ff28bfb72a4e45* would be fine for the first time, because it has Ruby and PostgreSQL pre-installed) ->
> `Select` -> `t2.micro` -> `Review and Launch` -> `Launch` -> choose `Create a new key pair` -> Enter key-pair name (*for example `key_name`*) -> `Download Key Pair` -> `Launch Instances` -> `View Instances`

Your instance was launching, and now is running.

--

To connect to your instance via `ssh` you have to do:

1. Check `IPv4 Public IP` on an `Instances` page (*scroll right on the running instance*).

2. Enter `chmod 400` command with the path to your key-pair `.pem` file you saved before, for example: `chmod 400 ~your_user/Desktop/key-name.pem`

3. Enter command `ssh -i path_to_your_pem_key_pair ec2-user@ip_you_checked_in_first_step`, for example: `ssh -i ~your_user/Desktop/key-name.pem ec2-user@52.87.155.123` (*`ec2-user` is default name*)

That's all! Now you are connected to your instance and can perform any actions you need. You can install any software, setup configuration you need and later save your own AMI with config you made.

When you are done, don't forget to terminate your instance to prevent charging for EC2 usage:

> `Instances` -> *Choose your instance* -> `Actions` -> `Instance State` -> `Terminate`

for more info see - https://aws.amazon.com/ru/getting-started/tutorials/launch-a-virtual-machine/

---

#Useful links

https://aws.amazon.com/ec2/instance-types/

https://www.ec2instances.info/

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-credits-baseline-concepts.html

https://aws.amazon.com/blogs/aws/new-t2-unlimited-going-beyond-the-burst-with-high-performance/

https://aws.amazon.com/ec2/instance-types/t3/

---

## The end

---
