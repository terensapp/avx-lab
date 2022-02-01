gateways = {
    transit = {
        aws-east1-transit = {
            cloud = "AWS"
            account         = "aws-main"
            region         = "us-east-1"
            cidr   = "10.110.0.0/16"
        },
        az-east-transit = {
            cloud = "Azure"
            account         = "azure-main"
            region         = "Central US"
            cidr   = "10.210.0.0/16"
        }
    },
    spoke = {
        aws-east1-prod = {
            cloud = "AWS"
            account         = "aws-main"
            region         = "us-east-1"
            cidr   = "10.111.0.0/16"
            transit = "aws-east2-transit"
            attach_host = false
        },
        aws-east1-dev = {
            cloud = "AWS"
            account         = "aws-main"
            region         = "us-east-1"
            cidr   = "10.121.0.0/16"
            transit = "aws-east2-transit"
            attach_host = false
        },
        aws-east2-prod = {
            cloud = "AWS"
            account         = "aws-main"
            region         = "us-east-2"
            cidr   = "10.112.0.0/16"
            transit = "aws-east2-transit"
            attach_host = false
        },
        aws-east2-dev = {
            cloud = "AWS"
            account         = "aws-main"
            region         = "us-east-2"
            cidr   = "10.122.0.0/16"
            transit = "aws-east2-transit"
            attach_host = false
        },
        az-central-prod = {
            cloud = "Azure"
            account         = "azure-main"
            region         = "Central US"
            cidr   = "10.113.0.0/16"
            transit = "az-east-transit"
        },
        az-central-dev = {
            cloud = "Azure"
            account         = "azure-main"
            region         = "Central US"
            cidr   = "10.123.0.0/16"
            transit = "az-east-transit"
        },
        az-east-prod = {
            cloud = "Azure"
            account         = "azure-main"
            region         = "East US"
            cidr   = "10.114.0.0/16"
            transit = "az-east-transit"
        },
        az-east-dev = {
            cloud = "Azure"
            account         = "azure-main"
            region         = "East US"
            cidr   = "10.124.0.0/16"
            transit = "az-east-transit"
        }
    }
}