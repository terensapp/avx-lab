gateways = {
    transit = {
        aws-east1-transit = {
            account         = "aws-main"
            region         = "us-east-1"
            cidr   = "10.110.0.0/16"
        },
        az-east-transit = {
            account         = "azure-main"
            region         = "us-east"
            cidr   = "10.210.0.0/16"
        }
    },
    spoke = {
        aws-east1-spoke1 = {
            account         = "aws-main"
            region         = "us-east-1"
            cidr   = "10.111.0.0/16"
            transit = "aws-east2-transit"
            attach_host = true
        },
        az-east-spoke1 = {
            account         = "azure-main"
            region         = "us-central"
            cidr   = "10.211.0.0/16"
            transit = "az-east-transit"
        }
    }
}