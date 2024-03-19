Purpose
---
The purpose of this project it to provision a backup VPN between AWS and Compucom on premises.  In AWS, this will be achieved by deploying a Site-to-Site VPN between the existing Transit Gateway and a new Customer Gateway.  This new Customer Gateway will in turn be connected to the on premises backup Cisco Meraki.

![Alt text](images/VPN-CGW-TG-Diagram.png?raw=true "AWS Transit Gateway VPN Connectivity To On Premises Cisco VPN Devices")