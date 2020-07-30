# Terraform code to deploy a HashiCorp Consul Service aka HCS in Azure
4 seperate TF folders
1. Resource group 
2. DEVELOPMENT HCS environment with ACL bootstrapping
3. HCS Client Azure VM node (with vnet peering and configuration)
4. AKS Cluster with HCS and configuration

3 and 4 can be executed after 2
