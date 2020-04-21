---
layout: slide
title: VPC
---

# Amazon VPC

--

## What is VPC?

Amazon Virtual Private Cloud (Amazon VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. You have complete control over your virtual networking environment, including selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways. You can use both IPv4 and IPv6 in your VPC for secure and easy access to resources and applications.

Create VPC:

> Services => VPC => *left menu* Your VPCs => Create VPC

- Within a Region, you’re able to create VPCs (Virtual Private Cloud)
- Each VPC contains subnets (networks)
- Each subnet must be mapped to an AZ (Availability Zone)
- It can have a public subnets (public IP)
- It can have a private subnets (private IP)


---

## Internet Gateway

An Internet Gateway is a VPC component that allows communication between instances in your VPC and the internet.

- To provide a target in your VPC route tables for internet-routable traffic
- Perform network address translation (NAT) for instances that have been assigned public IPv4 addresses

![](/assets/images/aws/architecture-of-vpc.png)

---

## Route Table

Route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.

--

#### Route Table Concepts

Your VPC has an implicit router, and you use route tables to control where network traffic is directed. Each subnet in your VPC must be associated with a route table, which controls the routing for the subnet. You can explicitly associate a subnet with a particular route table. Otherwise, the subnet is implicitly associated with the main route table. A subnet can only be associated with one route table at a time, but you can associate multiple subnets with the same subnet route table.

--

**Main route table** — the route table that automatically comes with your VPC. It controls the routing for all subnets that are not explicitly associated with any other route table.
**Custom route table** — a route table that you create for your VPC.
**Edge association** - a route table that you use to route inbound VPC traffic to an appliance. You associate a route table with the internet gateway or virtual private gateway, and specify the network interface of your appliance as the target for VPC traffic.
**Route table association** — the association between a route table and a subnet, internet gateway, or virtual private gateway.
**Subnet route table** — a route table that's associated with a subnet.
**Gateway route table** — a route table that's associated with an internet gateway or virtual private gateway.
**Local gateway route table** — a route table that's associated with an Outposts local gateway. For information about local gateways, see Local Gateways in the AWS Outposts User Guide.
**Destination** — the destination CIDR where you want traffic to go. For example, an external corporate network with a 172.16.0.0/12 CIDR.
**Target** — the target through which to send the destination traffic; for example, an internet gateway.
**Local route** — a default route for communication within the VPC.

---

## VPC Security

--

## Access Control List (ACL)

A network access control list (ACL) is a layer of security for your VPC that acts as a virtual firewall for controlling traffic in and out of one or more subnets. You might set up network ACLs with rules similar to your security groups in order to add an additional layer of security to your VPC.

- rule is either INBOUND or OUTBOUND
- rule can specify ALLOW or DENY
- inbound rule has SOURCE CIDR (Classless Inter-Domain Routing)
- outbound rule has DESTINATION CIDR

Default Network ACL allows all inbound and outbound traffic.

--

### The following are the parts of a network ACL rule:

- **Rule number.** Rules are evaluated starting with the lowest numbered rule. As soon as a rule matches traffic, it's applied regardless of any higher-numbered rule that might contradict it.
- **Type.** The type of traffic; for example, SSH. You can also specify all traffic or a custom range.
- **Protocol.** You can specify any protocol that has a standard protocol number. For more information, see Protocol Numbers. If you specify ICMP as the protocol, you can specify any or all of the ICMP types and codes.
- **Port range.** The listening port or port range for the traffic. For example, 80 for HTTP traffic.
- **Source.** [Inbound rules only] The source of the traffic (CIDR range).
- **Destination.** [Outbound rules only] The destination for the traffic (CIDR range).
- **Allow/Deny.** Whether to allow or deny the specified traffic.

--

## Security Groups

For security group you can add rules that control inbound and outbound traffic to instance. When you launch an instance in a VPC, you can assign up to five security groups to the instance. Security groups act at the instance level, not the subnet level. Therefore, each instance in a subnet in your VPC can be assigned to a different set of security groups.

--

#### The following are the basic characteristics of security groups for your VPC:

- You can specify allow rules, but not deny rules.
- You can specify separate rules for inbound and outbound traffic.
- When you create a security group, it has no inbound rules. Therefore, no inbound traffic originating from another host to your instance is allowed until you add inbound rules to the security group.
- By default, a security group includes an outbound rule that allows all outbound traffic. You can remove the rule and add outbound rules that allow specific outbound traffic only. If your security group has no outbound rules, no outbound traffic originating from your instance is allowed.
- **Security groups are stateful** — if you send a request from your instance, the response traffic for that request is allowed to flow in regardless of inbound security group rules. Responses to allowed inbound traffic are allowed to flow out, regardless of outbound rules.
- Instances associated with a security group can't talk to each other unless you add rules allowing the traffic (exception: the default security group has these rules by default).

---

## Bastion HOST

### What is Bastion?
This is a jump host or jump box which used to access and manage instances in a separate security zone. It used for access to all private subnets in VPC using only one instance with SSH access.

--

Let's imagine that we have VPC with one public and one private subnets in two AZs. We want to have access to private subnets via one secure jump box, so we need to launch Bastion Host in public subnet.

To achive that we must do several steps:
- Create Security Group (SG) for our VPC with inbound rule for SSH connection

- Create Auto Scaling Group (ASG) with new launch configuration. This will give us confidence that we won't lose access to our Bastion in case of failure of one of the data centers where our subnets are located. If data center in which our Bastion are located will down then ASG automaticaly launch new Bastion instance in second AZ.

---

## NAT

NAT (Network Address Translation) - technology that allows your instances with private IP communicate with Global Internet (for example, for software updates) by remmaping private address to public using NAT table. AWS offers two kinds of NAT devices — a NAT gateway or a NAT instance.

![](https://qph.fs.quoracdn.net/main-qimg-56413cede35ff6c11ff66cfbf2d5c780)
