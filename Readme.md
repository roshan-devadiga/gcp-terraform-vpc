Built secure VPC in GCP Mumbai (asia-south1) using Terraform.

VPC: roshan-vpc (Global)
Public Subnet: 10.0.1.0/24
Private Subnet: 10.0.2.0/24
Cloud NAT:For private VM internet access
Firewall:Allow 22, 80, 443
VM:e2-micro in private subnet, No Public IP
Storage: Cloud Storage Bucket

terraform init
terraform plan
terraform apply
terraform destroy
