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
        aws-east1-spoke1 = {
            cloud = "AWS"
            account         = "aws-main"
            region         = "us-east-1"
            cidr   = "10.111.0.0/16"
            transit = "aws-east2-transit"
            attach_host = false
        },
        az-east-spoke1 = {
            cloud = "Azure"
            account         = "azure-main"
            region         = "Central US"
            cidr   = "10.211.0.0/16"
            transit = "az-east-transit"
        }
    }
}