# **Routing in Azure Virtual WAN MicroHack**

# Contents
[Introduction](#introduction)

[Objectives](#objectives)

[Scenario](#scenario)

[Lab](#lab)

[Prerequisites](#prerequisites)

[Scenario 1: Single region Virtual WAN with Default Routing](#scenario-1-single-region-virtual-wan-with-default-routing)

[Scenario 2: Add a branch connection](#scenario-2-add-a-branch-connection)

[Scenario 3: Multi-region VWAN with Isolated Spokes and Shared Services Spoke](#scenario-3-multi-region-vwan-with-isolated-spokes-and-shared-services-spoke)

[Scenario 4: Filter traffic through a Network Virtual Appliance](#scenario-4-filter-traffic-through-a-network-virtual-appliance)

[Scenario 5: Secured Hubs](#scenario-5-secured-hubs)

[Close out](#close-out)

# Introduction
This MicroHack explores some of the advanced routing capabilities recently introduced into Azure Virtual WAN. 

The lab starts with a single Hub with Spoke VNETs and default routing. We then connect a simulated on-premise location via S2S VPN. Then we add another regional Hub with Spokes and observe how routing extends across multiple Hubs. Next we implement custom routing patterns for Shared Services- and Isolated Spokes, and secure traffic through a Network Virtual Appliance.
Finally, we use Azure Firewall Manager to convert our Hubs into Secured Hubs adding Azure Firewall.

Prior to starting this MicroHack, please familiarize yourself with routing in Virtual WAN by reviewing the documentation at https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about and https://docs.microsoft.com/en-us/azure/virtual-wan/about-virtual-hub-routing.

# Objectives
After completing this MicroHack you will:
-	Know how to build a hub-and-spoke topology with Virtual WAN
-	Understand default routing in Virtual WAN and how this differs from the classic virtual data center hub-and-spoke spoke architecture 
-	Understand how custom routing works and know how to build some custom routing scenarios
-	Know how to implement network security in Virtual WAN with a Network Virtual Appliance, and with Secure Hubs

# Lab

The lab consists of a Virtual WAN with Hubs in West Europe and US East, 4 Spoke VNETs (2 in West Europe, 1 in US East and 1 US West), a Shared Services VNET and an NVA VNET in West-Europe and a simulated On-premise location in North Europe. 

Each of the Spoke and On-prem VNETs contains a Virtual Machine running a basic web site. The Shared Services VNET contains an Active Directory Domain Controller, the NVA VNET contains a Linux VM with Iptables.

During the course of the MicroHack you will connect the Spoke and Shared Services VNETs and the On-premise site to Virtual WAN, deploy an additional Virtual WAN Hub, and manipulate and observe routing. 

At the end of the lab your deployment looks like this:

![image](images/microhack-vwan.png)


Although a Branch (site-to-site VPN) connection is part of this MicroHack, it does not cover the integration with products from  SDWAN partners.
# Prerequisites
To make the most of your time on this MircoHack, the green elements in the diagram above are deployed and configured for you through Terraform. You will focus on deploying and configuring the blue items using the Azure portal and Cloud Shell.
## Task 1: Deploy
Steps:
- Log in to Azure Cloud Shell at https://shell.azure.com/ and select Bash
- If necessary select your target subscription:
  
`az account set --subscription <Name or ID of subscription>`
- Clone the  GitHub repository:
  
`git clone https://github.com/mddazure/azure-vwan-microhack`
  
  - Change directory:
  
`cd ./azure-vwan-microhack`
  - Initialize terraform and download the azurerm resource provider:

`terraform init`

- Now start the deployment (when prompted, confirm with **yes** to start the deployment):
 
`terraform apply`

Deployment takes approximately 30 minutes. 
## Task 2: Explore and verify

After the Terraform deployment concludes successfully, the following has been deployed into your subscription:
- A resource group named **vwan-microhack-spoke-rg** containing
  - Four Spoke VNETs, each containing a Virtual Machine running a simple web site, and a Bastion Host.
  - An Onprem VNET containing a Virtual Machine running a simple web site, a VNET Gateway and a Bastion Host.
  - A Services VNET containing and a Virtual Machine configured as an Active Directory Domain Controller, and a Bastion Host.
  - An NVA VNET containing a Virtual Machine with Linux (Ubuntu 18.4) and Iptables installed, and a Bastion Host.
- A resource group named **vwan-microhack-hub-rg** containing a Virtual WAN resource with one Hub and one VPN Gateway. You will deploy another Hub into this resource group manually later on.

Verify these resources are present in the portal.

Credentials are identical for all VMs, as follows:
- User name: AzureAdmin
- Password: Microhack2020
- Domain: micro-hack.local (this is on the ADDC VM only, the other VMs are not joined to this domain yet)

You may log on to each VM through Bastion. Disable IE Enhanced Security Configuration in Server Manager, open Internet Explorer and access http://localhost. You will see  a blank page with the VM name in the upper left corner. When logging on to the ADDC VM before it is ready, you will see "Waiting for the Group Policy Client". That is OK, just let it run while you proceed with the lab.
# Scenario 1: Single Region Virtual WAN with Default Routing

In this scenario you connect in-region VNETs to the pre-deployed Hub, and establish VNET-to-VNET communication. You will then inspect effective routes on the spoke VMs and take a look at the VWAN Default routing table.
## Task 1: Baseline
Connect to spoke-1-vm via Bastion, turn off IE Enhanced Security Configuration in Server Manager, open Internet Explorer and attempt to connect to spoke-2-vm at 172.16.2.4.

:question: Does it connect?

Check the routing on spoke-1-vm, as follows:

In the portal, in the Properties view of the VM Overview blade, click on Networking. Then click on the name of the Network Interface. The NIC overview shows, under Support + troubleshooting click Effectice routes.

Alternatively, in Cloud Shell, issue this command:

`az network nic show-effective-route-table -g vwan-microhack-spoke-rg -n spoke-1-nic --output table`

:question: Is there a specific route for spoke-2-vnet (172.16.2.0/24)?

## Task 2: Connect VNETs
In the portal, navigate to the Virtual WAN named **microhack-vwan** in resource group **vwan-microhack-hub-rg**. 

Click "Virtual network connections" under "Connectivity" and click "+ Add connection" at the top of the page.
Name your connection **spoke-1-we**, select the hub and in the Resource group drop down select **vwan-microhack-spoke-rg**. In the Virtual network drop down, select **spoke-1-vnet** and click Create. Wait for the connection to complete and do the same for **spoke-2-vnet**.
![image](images/vwan-with-connections.png)

Your Virtual WAN now looks like this:


![image](images/scenario1.png)

:question: Can you now browse from spoke-1-vm to spoke-2-vm and vice versa?

### :point_right: Spoke routes
Again observe Effective Routes for spoke-1-vm.

:exclamation: Notice it now has a route for spoke-2-vnet (172.16.2.0/24), pointing to a public address. This is the address of the Route Service, deployed into the Hub to enable routing between peered VNETs, branch connections and other Hubs. The fact that this is a public IP address does not present a security risk, it is not reachable from the internet.

:exclamation: Notice that the routes that enable spoke-to-spoke communication were plumbed into the spoke VNETs automatically. Contrast this with a "classic" hub-and-spoke architecture, where you would need to set up a routing device in the hub VNET and then put UDRs in each of the spokes manually.

### :point_right: Hub routes
Navigate to the blade for the microhack-we-hub in your Virtual WAN and select Routing under Connectivity. Notice there are two Route tables present now: Default and None.

Click on Effective Routes at the top of the page. In the drop downs on the next page, select Route Table and Default respectively. This brings up the Default route table. 

:exclamation: Note that routes for the prefixes of both connected VNETs are present, pointing to the respective VNET connections.

A Virtual WAN can contain multiple Route tables, and we'll add some in the course of this MicroHack. Each Connection (Hub-to-Spoke VNET, ExpressRoute, S2S (Branch) VPN or P2S (User) VPN) can be *Associated* with a single table and be *Propagating* to multiple tables.

The Default table has Associated Connections and Propagating Connections. Click on ... at the end of the row to see that both Spoke VNETs are Associated with and Propagating to the Default table.

*Associated* means that traffic from the Connections listed is governed by this table, in this case the Default route table. This table decides where traffic sent from the connection to the VWAN Route Service (remember the route entry pointing to the public IP address in the Spoke VM's Effective Routes) goes.

*Propagating* means that the Connection's destinations are entered into this Routing table: the table learns the Connection's routes. 

The None Route table is also present for each Hub; traffic from Connections Associated with this Route table is dropped. 

# Scenario 2: Add a branch connection

Now connect a branch site via a BGP-enabled VPN connection and explore the routing between spokes and the branch. The branch site is simulated through a VNET with a VNET Gateway which was deployed through Terraform as part of the Prerequisites.

## Task 1: Connect a simulated branch site

In Cloud Shell, in the azure-vwan-microhack directory
- Run the connect-branch shell script:

`./connect-branch.sh`

The script contains Azure CLI commands that create following resources:
- A VPN Site named "onprem" in the Virtual WAN
- A BGP-enabled VPN connection from the "onprem" site to the West Europe Hub
- A Local Network Gateway named "lng" to represent the West Europe Hub
- A BGP-enabled VPN connection from the Gateway in "onprem-vnet" to the Local Network Gateway

After the script completes, it may take a few minutes for the connection to show "Connected" in the portal.

Your Virtual WAN now looks like this:

![image](images/scenario2.png)

## Task 2: Verify connectivity
Connect to onprem-vm via Bastion and turn off IE Enhanced Security Configuration in Server Manager.

Open Internet Explorer and browse to spoke-1-vm at 172.16.1.4 and spoke-2-vm at 172.16.2.4.

:question: Does it connect?
## Task 3: Inspect routing
### :point_right: BGP routing exchange over VPN
In Cloud Shell, in the azure-vwan-microhack directory
- Run the branch-routes script:

`./branch-routes.sh`

This scripts pulls information on the BGP session from the VNET Gateway vnet-onprem-gw. 

:exclamation: Note that the "routes learned" output contains all routes the Gateway knows: those that are in the same VNET, with "origin" indicating "Network", as well as routes learned from the Virtual WAN Hub via BGP with "origin" indicating "EBgp". 

### :point_right: Branch routes
Now observe Effective Routes for onprem-vm.

:exclamation: Note that routes are present for the Spoke VNETs, pointing to the local VNET VPN Gateway. 

The routes for the Spoke VNETs were learned via BGP and programmed into the vm route table automatically, without the need to install UDRs.

### :point_right: Spoke routes
Again observe Effective Routes for spoke-1-vm, as follows:

In the portal, in the Properties view of the VM Overview blade, click on Networking. Then click on the name of the Network Interface. The NIC overview shows, under Support + troubleshooting click Effective routes.

Alternatively, in Cloud Shell, issue this command:

`az network nic show-effective-route-table -g vwan-microhack-spoke-rg -n spoke-1-nic --output table`

:exclamation: Notice that spoke-vm-1 now has routes for the IP ranges of the onprem site, 10.0.1.0/24 and 10.0.2.0/24. This site is connected via VPN, and although "Source" and "Next Hop Type" are the same as for peered VNET spoke-2-vnet, the next hop address is different.
 
Whereas the next hop for spoke-vnet-2 is the Hub routing engine, the next hop for VPN connection is the VPN Gateway, which has a private IP address from the range assigned to Hub.

The routes for the VPN connection where plumbed into the spoke automatically and there is no need to place User Defined Routes in the spoke VNETs.

### :point_right: Hub routes
Observe the Effective routes of the Default route table. 

:exclamation: Note that routes for the on-prem site's prefixes are now present, pointing to S2S VPN Gateway. 

Realize that the Route Service itself is not in the data path for branch traffic. The Route Service acts as a route reflector, traffic flows directly between the VM in the spoke and VPN Gateway.

# Scenario 3: Multi-regional Virtual WAN
We will now expand the Virtual WAN across regions by adding a Hub with Spokes in the US East region. 

An key take away from this scenario is that each hub runs its own routing instance and contains its own routing tables.

Although tables may be called the same across Hubs, Default for example, it is important to realize that these are independent and there is no "global" routing table spanning the entire VWAN.

At the end of this scenario, your lab looks like this:

![image](images/scenario3.png)

## Task 1: Add a Hub

In the portal, Select your **microhack-vwan**. Under Connectivity, select Hubs, then +New Hub at the top of the page and complete the Basics dialog as follows:
- Region: East US
- Name: microhack-useast-hub
- Hub private address space: 192.16.1.0/24

As this Hub will not contain any gateways, skip the other tabs, click Review + create and then Create.

Alternatively, in Cloud Shell, issue this command:

`az network vhub create --address-prefix 192.168.1.0/24 --name microhack-useast-hub --resource-group vwan-microhack-hub-rg --location useast --sku Standard`

## Task 2: Connect VNETs
Connect spoke-3-vnet and spoke-4-vnet to the new Hub. We connected VNETs through the portal in Scenario 1, so to save time we'll do this through a prepared shell script.

In Cloud Shell, enter

`./connect-us-east-spokes.sh`

This will take a few minutes to complete. While the script runs, you can see the connections being added in the portal, in your microhack-vwan under Connectivity, Virtual network connections. Wait for both Connections to show status Succeeded.

## Task 3: Verifiy connectivity and inspect routing
Connect to spoke-1-vm via Bastion. Open Internet Explorer, browse to spoke-3-vm at 172.16.3.4 and to spoke-4-vm at 172.16.4.4.

Do the same from on-prem-vm.

:question: Do you see the web pages from spoke-3-vm and spoke--4vm?

:point_right: Spoke routes

Observe Effective Routes for spoke-1-vm, either in the portal or in Cloud Shell through 

`az network nic show-effective-route-table -g vwan-microhack-spoke-rg -n spoke-1-nic --output table`

:question: Which routes have been added to spoke-1-vm's route table? 

:question: What is the next hop for the new routes?

Again, realize that Virtual WAN installed these routes in the VNET automatically!

:point_right: Hub routes

Observe Effective Routes of the Default route table of the microhack-we-hub, as you did in Scenario 1.

:question: Which routes have been added and where do they point? 

:question: What is the meaning of the AS path?

:point_right: Association and Propagation

In the portal, in the microhack-vwan blade under Connectivity click Virtual network connections and expand Virtual networks for both Hubs. 

:exclamation: Note that for all 4 connections across both Hubs, under Associated to Route Table it says "defaultRouteTable". This means that each connection takes its routing information from the default route table of its *local* hub. This is always the case: the route service in a Hub only programs routing information to its directly connected Spokes.

Under Propagation to Route Tables, it also says "defaultRouteTable". This means that this connection sends its reachability information (i.e. the prefixes behind it) to its *local* default route table only, but *not* to the other Hub.

However, we observed that the defaultRouteTable of the US East Hub does have routes for the Spokes in West Europe and vice versa. 

This happens because under Propagating to labels, there is the entry "default". Labels are a method of grouping Route Tables across Hubs, so that they do not have to be specified individually. The defaultRouteTables in all Hubs in a VWAN are automatically included in the "default" label, and Propagation to this label is automatically enabled. It is possible to change this after deployment to implement custom routing patterns.

# Scenario 4: Isolated Spokes and Shared Services Spoke
Imagine an IT department that must facilitate DevOps teams. IT operates a number of central services, such as the networks in and between Azure and on-premise, and the Active Directory domain.

DevOps teams are given their own VNETs in Azure, connected to a central hub that provides connectivity and the domain. The DevOps teams operate independently and their environments must remain isolated from each other.

This scenario adds a Shared Services Spoke with a Domain Controller, and changes the routing so that the Spokes can only reach the Branch and the Shared Services Spoke, but remain isolated from each other.

See https://docs.microsoft.com/en-us/azure/virtual-wan/scenario-shared-services-vnet for background.

At the end of this Scenario, your VWAN, with enabled and disabled traffic flows, looks like this:

![image](images/scenario4.png)

## Task 1: Connect Services Spoke

Run the following in Cloud Shell to connect services-vnet to microhack-we-hub:

`./connect-services-spoke.sh`

## Task 2: Create custom Route Tables
In the microhack-we-hub, under Connectivity select Routing and then +Create route table. Complete the configuration as follows:
- Tab Basics
  - Name: RT-Shared-we
- Tab Labels
  - Label Name: Shared
- Tab Associations
  - In the drop down under Virtual Networks, select both Spokes but do *not* select services-vnet
- Tab Propagations
  - Under Branches, at Propagate routes from connections to this route table?, select Yes
  - Under Virtual Networks, select services-vnet but do *not* select the Spokes
- Click Create

The Routing view of the West Europe Hub hub shows 2 connections associated to the Default table (Shared Service Spoke and Branch), and 4 connections propagating to the Default table (both Spokes, Shared Services and Branch). The RT-Shared-we table has 2 connections associated (both Spokes), and 2 connections propagating (Shared Services and Branch):

![image](images/scenario-4-we-routetables.png) 

For microhack-useast-hub, under Connectivity select Routing and then +Create route table and complete as follows:
Tab Basics
  - Name: RT-Shared-useast
- Tab Labels
  - Label Name: Shared
- Tab Associations
  - In the drop down under Virtual Networks, select both Spokes.
- Tab Propagations
  - Enter *nothing* because:
    -  We do not want the local Spokes to propagate to this table, as they should not learn each other's routes
    -  The RT-Shared-useast table must only contain a routes to the Shared Services Spoke- and the Branch connections, and it will learn these from we hub via the inter-hub link
  - Click Create

Routing for the US East Hub shows both Spoke VNET connections propagating to the Default route table, and both are associated with the RT-Shared-useast table.

![image](images/scenario-4-useast-routetables.png) 

We must also ensure that the Shared Services VNET connection, which is connected to the West Europe Hub, *also* propagates to the Shared-RT-use-east table. This is configured on the connection itself, and we will use the Shared label which groups the Shared-RT tables in both hubs. 

In the microhack-vwan view, select Virtual network connections. Expand the connections on microhack-we-hub, click the elipsis at the end of the services-vnet row and select Edit. In the Propagate to labels drop-down, select both default and Shared labels, and click Confirm.

![image](images/scenario-4-edit-shared.png) 

## Task 3: Verify connectivity

From spoke-1-vm, try to browse to any of the other Spokes (172.16.2/3/4.4), and the Branch (10.0.1.4)

:Question: Do the web pages of the Spokes and the Branch display?

Try to ping spoke-addc-vm.

:Question: Does ping succeed?

## Task 4 (Optional): Join Spoke vm to Domain
The Shared Service VNET contains an AD domain controller.

To demonstrate connectivity from the Spokes to the Shared Services VNET, you can optionally join one or more spoke vm's to the domain.
- Point the DNS in spoke-vnet-1 to spoke-addc-vm, in Cloud Shell:

`az network vnet update --name spoke-1-vnet --resource-group vwan-microhack-spoke-rg --dns-servers 172.16.10.4`

- On spoke-1-vm, open a command prompt and enter:
  
`ipconfig /renew`
  
- On spoke-1-vm, open Server Manager and click Local Server. 
- Then click WORKGROUP, click the Change ... button, select the Domain radio button under Member of and enter micro-hack.local, click OK.
- Enter credentials
  - User name: AzureAdmin
  - Password: Microhack2020

The machine will now join the domain and will need to be restarted for this change to take effect.

## Task 5: Inspect routing

:point_right: Spoke routes

:point_right: Hub routes



# Scenario 5: Filter traffic through a Network Virtual Appliance

# Scenario 6: Secured Hubs

# Extra: Monitoring


# Close out









  










