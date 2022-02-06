data "aws_iam_policy_document" "this" {
    dynamic "statement" {
        for_each = var.enabled_sts_services
        iterator = enabled_sts_services
        content {
            sid = "GrantSTS${upper(enabled_sts_services.value)}"
            actions = ["sts:AssumeRole"]
            principals {
                type        = "Service"
                identifiers = ["${enabled_sts_services.value}.amazonaws.com"]
            }
            effect = "Allow"
        }
    }
    statement {
        sid = "GrantK8sSAAccessToAWS"
        actions = ["sts:AssumeRoleWithWebIdentity"]
        principals {
            type        = "Federated"
            identifiers = [var.openid_connect_provider_arn]
        }
        effect = "Allow"    
        condition {
            test = "StringEquals"
            variable = "${replace(var.openid_connect_provider_url, "https://", "")}:sub"
            values = [
                "system:serviceaccount:${var.kubernetes_namespace}:${var.service_account_name}"
            ]
        }
        condition {
            test = "StringEquals"
            variable = "${replace(var.openid_connect_provider_url, "https://", "")}:aud"
            values = [
                "sts.amazonaws.com"
            ]
        }
    }
}
