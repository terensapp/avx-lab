gateways = {
    transit = {
        aws-east2-transit1 = {
            account         = "aws-main"
            region         = "us-east-2"
            cidr   = "10.110.0.0/16"
        },
        "aws-west2-transit2" = {
            account         = "aws-main"
            region         = "us-west-2"
            cidr   = "10.210.0.0/16"
        }
    },
    spoke = {
        aws-east2-spoke1 = {
            account         = "aws-main"
            region         = "us-east-2"
            cidr   = "10.111.0.0/16"
            transit = "aws-east2-transit1-transit"
        },
        "aws-east2-spoke2" = {
            account         = "aws-main"
            region         = "us-east-2"
            cidr   = "10.112.0.0/16"
            transit = "aws-east2-transit1-transit"
        },
        aws-west2-spoke1 = {
            account         = "aws-main"
            region         = "us-west-2"
            cidr   = "10.211.0.0/16"
            transit = "aws-west2-transit2-transit"
        },
        "aws-west2-spoke2" = {
            account         = "aws-main"
            region         = "us-west-2"
            cidr   = "10.212.0.0/16"
            transit = "aws-west2-transit2-transit"
        }
    }
}