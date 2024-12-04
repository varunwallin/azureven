# The subscription submodule creates a new subscription alias
# If we don't use this module, supply the `subscription_id` variable
# to be able to deploy resources to an existing subscription.
module "subscription" {
  source = "./submodules/subscription"
  count  = (var.subscription_id != "" && var.subscription_update_existing) || var.subscription_alias_enabled || var.subscription_management_group_association_enabled ? 1 : 0

  subscription_alias_enabled                           = true
  subscription_alias_name                              = "az-vendingsub-alias"
  subscription_billing_scope                           = "/providers/Microsoft.Billing/billingAccounts/8613795/enrollmentAccounts/375206"
  subscription_display_name                            = "azvendingsub"
  subscription_id                                      = var.subscription_id
  subscription_management_group_association_enabled    = true
  subscription_management_group_id                     = var.subscription_management_group_id
  subscription_tags                                    = var.subscription_tags
  subscription_use_azapi                               = var.subscription_use_azapi
  subscription_update_existing                         = var.subscription_update_existing
  subscription_workload                                = var.subscription_workload
  wait_for_subscription_before_subscription_operations = var.wait_for_subscription_before_subscription_operations
}

module "resource_groups" {
  source = "./submodules/resourcegroup"
  # Pass the values required by the submodule
  resource_group_name = var.resource_groups["rg1"].name
  location            = var.resource_groups["rg1"].location
  tags                = var.resource_groups["rg1"].tags
  subscription_id     = var.subscription_id
}




# The budget module creates budgets from the data
# supplied in the var.budgets variable


module "budgets" {
  source       = "./submodules/budget"
  for_each     = var.budget_enabled ? var.budgets : {}
  budget_name  = each.value.name
  budget_scope       = "/subscriptions/${module.subscription[0].subscription_id}"  # Reference the newly created subscription
  budget_amount = each.value.amount
  budget_time_grain = each.value.time_grain
  budget_time_period = {
    start_date = each.value.time_period_start
    end_date   = each.value.time_period_end
  }
  budget_notifications = each.value.notifications
}
