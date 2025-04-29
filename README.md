Azure Network Terraform Module

What's This? This Terraform setup helps you spin up Azure virtual networks (VNets) and subnets in a neat and scalable way. Instead of repeating the same code over and over, you define your networks in one place using a simple local spec, and Terraform takes care of the rest.

What Gets Created For each network in your spec, Terraform will:

Create a Resource Group: named like rg-yourNetworkName Spin up a Virtual Network (VNet): named like vnet-yourNetworkName Drop in Subnets: each named as you specify in your config

How to Use It You don’t have to pass in any variables. Just update the network_spec block inside network.tf with your networks. Example:

module "network" { source = "./path_to_module" }
