variable "management_subscription_id" {
  type        = string
  default     = "d560f02f-91d4-4a3a-afd3-0a220fc6762c"
  description = "The ID of the management subscription."
}

variable "subscription_id" {
  type        = string
  default     = ""
  description = "Existing subscription ID. If blank, a new subscription will be created."
}

variable "subscription_alias_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable the subscription alias feature."
}


variable "subscription_management_group_association_enabled" {
  type        = bool
  default     = true
  description = "Whether to associate the subscription with a management group."
}

variable "subscription_management_group_id" {
  type        = string
  default     = "lza-th-au-bis-prod" # Update to short ID

  description = "The ID of the management group to associate the subscription with."
}

variable "subscription_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to assign to the subscription. Example: { environment = 'prod', team = 'devops' }"
}

variable "subscription_use_azapi" {
  type        = bool
  default     = false
  description = "Whether to use the azapi provider for the subscription alias."
}

variable "subscription_update_existing" {
  type        = bool
  default     = false
  description = "Whether to update an existing subscription."
}

variable "subscription_workload" {
  type        = string
  default     = "Production"
  description = "The workload type for the subscription. Allowed values: 'Production', 'DevTest'."
}

variable "wait_for_subscription_before_subscription_operations" {
  type = object({
    create  = optional(string, "30s")
    destroy = optional(string, "0s")
  })
  default     = {}
  description = "The duration to wait after vending a subscription before performing subscription operations."
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "The location for resources created by this module."
}

variable "disable_telemetry" {
  type        = bool
  default     = false
  description = "Whether to disable telemetry."
}





#variables for resource group 
variable "resource_group_creation_enabled" {
  type        = bool
  default     = true
  description = "Whether to create additional resource groups in the target subscription. Requires `var.resource_groups`."
}

variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
  default = {
    rg1 = {
      name     = "DefaultResourceGroup"
      location = "australiaeast"
      tags     = {
        environment = "default"
      }
    }
  }
  description = "A map of resource groups to create."
}

variable "network_watcher_resource_group_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable the network watcher resource group creation."
}


### variable group for Budget 

variable "budget_enabled" {
  type        = bool
  description = "Whether to create budgets."
  default     = true
}



variable "budgets" {
  type = map(object({
    name            = string
    amount          = number
    time_grain      = string
    time_period_start = string
    time_period_end   = string
    notifications   = optional(map(object({
      enabled        = bool
      operator       = string
      threshold      = number
      threshold_type = optional(string, "Actual")
      contact_emails = optional(list(string), [])
      contact_roles  = optional(list(string), [])
      contact_groups = optional(list(string), [])
      locale         = optional(string, "en-us")
    })), {})
  }))
  default = {
    budget1 = {
      name            = "MonthlyBudget"
      amount          = 150
      time_grain      = "Monthly"
      time_period_start = "2024-12-01T00:00:00Z"  # Adjusted to the first day of the current month
      time_period_end   = "2024-12-31T23:59:59Z"
      notifications = {
        eightypercent = {
          enabled        = true
          operator       = "GreaterThan"
          threshold      = 80
          threshold_type = "Actual"
          contact_emails = ["user@example.com"]
        }
      }
    }
  }
}
