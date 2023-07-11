# PSKPlatformWANRole
#
# Used by: psk-aws-platform-wan pipeline
# manages platform networking dependencies

module "PSKPlatformWANRole" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version     = "~> 5.27.0"
  create_role = true

  role_name                         = "PSKPlatformWANRole"
  role_path                         = "/PSKRoles/"
  role_requires_mfa                 = false
  custom_role_policy_arns           = [aws_iam_policy.PSKPlatformWANRolePolicy.arn]
  number_of_custom_role_policy_arns = 1

  trusted_role_arns = ["arn:aws:iam::${var.state_account_id}:root"]
}

# role permissions
#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "PSKPlatformWANRolePolicy" {
  name = "PSKPlatformWANRolePolicy"
  path = "/PSKPolicies/"

  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : [
          "ec2:Accept*",
          "ec2:AdvertiseByoipCidr",
          "ec2:AllocateAddress",
          "ec2:AllocateIpamPoolCidr",
          "ec2:ApplySecurityGroupsToClientVpnTargetNetwork",
          "ec2:Assign*",
          "ec2:Associate*",
          "ec2:Attach*",
          "ec2:Authorize*",
          "ec2:CreateClientVpnEndpoint",
          "ec2:CreateClientVpnRoute",
          "ec2:CreateCoipPoolPermission",
          "ec2:CreateCustomerGateway",
          "ec2:CreateDhcpOptions",
          "ec2:CreateEgressOnlyInternetGateway",
          "ec2:CreateFlowLogs",
          "ec2:CreateInternetGateway",
          "ec2:CreateIpam*",
          "ec2:CreateLocalGateway*",
          "ec2:CreateNatGateway",
          "ec2:CreateNetwork*",
          "ec2:CreatePublicIpv4Pool",
          "ec2:CreateRoute*",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet*",
          "ec2:CreateTags",
          "ec2:CreateTraffic*",
          "ec2:CreateTransitGateway*",
          "ec2:CreateVpc*",
          "ec2:CreateVpn*",
          "ec2:DeleteCarrierGateway",
          "ec2:DeleteClientVpnEndpoint",
          "ec2:DeleteClientVpnRoute",
          "ec2:DeleteCoipPoolPermission",
          "ec2:DeleteCustomerGateway",
          "ec2:DeleteDhcpOptions",
          "ec2:DeleteEgressOnlyInternetGateway",
          "ec2:DeleteFlowLogs",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteIpam*",
          "ec2:DeleteLocalGateway*",
          "ec2:DeleteNatGateway",
          "ec2:DeleteNetwork*",
          "ec2:DeletePublicIpv4Pool",
          "ec2:DeleteRoute*",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet*",
          "ec2:DeleteTags",
          "ec2:DeleteTraffic*",
          "ec2:DeleteTransitGateway*",
          "ec2:DeleteVpc*",
          "ec2:DeleteVpn*",
          "ec2:Deprovision*",
          "ec2:Deregister*",
          "ec2:Describe*",
          "ec2:Detach*",
          "ec2:DisableEbsEncryptionByDefault",
          "ec2:DisableTransitGatewayRouteTablePropagation",
          "ec2:DisableVgwRoutePropagation",
          "ec2:DisableVpcClassicLink",
          "ec2:DisableVpcClassicLinkDnsSupport",
          "ec2:Disassociate*",
          "ec2:Enable*",
          "ec2:Export*",
          "ec2:GetAssociatedEnclaveCertificateIamRoles",
          "ec2:GetAssociatedIpv6PoolCidrs",
          "ec2:GetCoipPoolUsage",
          "ec2:GetConsoleOutput",
          "ec2:GetConsoleScreenshot",
          "ec2:GetEbsDefaultKmsKeyId",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:GetFlowLogsIntegrationTemplate",
          "ec2:GetIpam*",
          "ec2:GetNetwork*",
          "ec2:GetPasswordData",
          "ec2:GetResourcePolicy",
          "ec2:GetSerialConsoleAccessStatus",
          "ec2:GetSubnetCidrReservations",
          "ec2:GetTransitGateway*",
          "ec2:GetVpn*",
          "ec2:ImportClientVpnClientCertificateRevocationList",
          "ec2:ModifyAddressAttribute",
          "ec2:ModifyAvailabilityZoneGroup",
          "ec2:ModifyClientVpnEndpoint",
          "ec2:ModifyEbsDefaultKmsKeyId",
          "ec2:ModifyId*",
          "ec2:ModifyIpam*",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifyPrivateDnsNameOptions",
          "ec2:ModifyReservedInstances",
          "ec2:ModifySecurityGroupRules",
          "ec2:ModifySubnetAttribute",
          "ec2:ModifyTraffic*",
          "ec2:ModifyTransitGateway*",
          "ec2:ModifyVpc*",
          "ec2:ModifyVpn*",
          "ec2:MonitorInstances",
          "ec2:MoveAddressToVpc",
          "ec2:MoveByoipCidrToIpam",
          "ec2:Provision*",
          "ec2:PutResourcePolicy",
          "ec2:RegisterTransitGateway*",
          "ec2:Reject*",
          "ec2:Release*",
          "ec2:ReplaceIamInstanceProfileAssociation",
          "ec2:ReplaceNetworkAclAssociation",
          "ec2:ReplaceNetworkAclEntry",
          "ec2:ReplaceRoute",
          "ec2:ReplaceRouteTableAssociation",
          "ec2:ReplaceTransitGatewayRoute",
          "ec2:ReportInstanceStatus",
          "ec2:RequestSpotFleet",
          "ec2:RequestSpotInstances",
          "ec2:ResetAddressAttribute",
          "ec2:ResetEbsDefaultKmsKeyId",
          "ec2:ResetNetworkInterfaceAttribute",
          "ec2:RestoreAddressToClassic",
          "ec2:RevokeClientVpnIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:SearchLocalGatewayRoutes",
          "ec2:SearchTransitGatewayMulticastGroups",
          "ec2:SearchTransitGatewayRoutes",
          "ec2:SendDiagnosticInterrupt",
          "ec2:StartNetworkInsightsAccessScopeAnalysis",
          "ec2:StartNetworkInsightsAnalysis",
          "ec2:StartVpcEndpointServicePrivateDnsVerification",
          "ec2:TerminateClientVpnConnections",
          "ec2:UnassignIpv6Addresses",
          "ec2:UnassignPrivateIpAddresses",
          "ec2:UnmonitorInstances",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
          "ec2:WithdrawByoipCidr",
          "rds:CreateDBSubnetGroup",
          "rds:ModifyDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:DescribeDBSubnetGroups",
          "rds:AddTagsToResource",
          "rds:ListTagsForResource",
          "rds:RemoveTagsFromResource",
          "networkmanager:*",
          "ram:*ResourceShare*",
          "ram:TagResource"
        ]
        "Effect" : "Allow"
        "Resource" : "*"
      },
    ]
  })
}
