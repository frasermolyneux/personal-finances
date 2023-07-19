resource "random_uuid" "oauth2_finances_access" {
}

resource "azuread_application" "finances_api" {
  display_name = local.app_registration_name

  identifier_uris = [format("api://%s", local.app_registration_name)]

  owners = [
    data.azuread_client_config.current.object_id
  ]

  sign_in_audience = "AzureADMyOrg"
  tags             = []

  api {
    known_client_applications      = []
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allows the app to access the web API on behalf of the signed-in user"
      admin_consent_display_name = "Access the API on behalf of a user"
      enabled                    = true
      id                         = random_uuid.oauth2_finances_access.result
      type                       = "User"
      user_consent_description   = "Allows this app to access the web API on your behalf"
      user_consent_display_name  = "Access the API on your behalf"
      value                      = "access_as_user"
    }
  }

  web {
    redirect_uris = [
      "http://localhost:30593/signin-oidc",
      "http://localhost:5126/signin-oidc",
      "http://localhost:51443/signin-oidc",
      "http://localhost:5145/signin-oidc",
      "http://localhost:5246/signin-oidc",
      "http://localhost:6445/signin-oidc",
      "https://localhost:44337/signin-oidc",
      "https://localhost:44346/signin-oidc",
      "https://localhost:44368/signin-oidc",
      "https://localhost:7012/signin-oidc",
      "https://localhost:7121/signin-oidc",
      "https://localhost:7255/signin-oidc",
    ]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
}

resource "azuread_service_principal" "finances_api_service_principal" {
  application_id               = azuread_application.finances_api.application_id
  app_role_assignment_required = false

  owners = [
    data.azuread_client_config.current.object_id
  ]
}

resource "azuread_application_password" "app_password_primary" {
  application_object_id = azuread_application.finances_api.object_id

  rotate_when_changed = {
    rotation = time_rotating.thirty_days.id
  }
}

locals {
  local_redirect_uris = [
    "http://localhost:5126/authentication/login-callback",
    "http://localhost:6445/authentication/login-callback",
    "https://localhost:44346/authentication/login-callback",
    "https://localhost:7255/authentication/login-callback"
  ]

  remote_redirect_uris = [for web_app in azurerm_linux_web_app.app : format("https://%s/authentication/login-callback", web_app.default_hostname)]

  redirect_uris = concat(local.local_redirect_uris, local.remote_redirect_uris)
}

resource "azuread_application" "finances_api_client" {
  display_name = local.app_registration_name_client

  owners = [
    data.azuread_client_config.current.object_id
  ]

  sign_in_audience = "AzureADMyOrg"

  tags = []

  api {
    known_client_applications      = []
    mapped_claims_enabled          = false
    requested_access_token_version = 2
  }

  single_page_application {
    redirect_uris = local.redirect_uris
  }
}

resource "azuread_service_principal" "finances_api_client_service_principal" {
  application_id               = azuread_application.finances_api_client.application_id
  app_role_assignment_required = false

  owners = [
    data.azuread_client_config.current.object_id
  ]
}

resource "azuread_application_pre_authorized" "finances_api_client" {
  application_object_id = azuread_application.finances_api.object_id
  authorized_app_id     = azuread_application.finances_api_client.application_id
  permission_ids        = [random_uuid.oauth2_finances_access.result]
}
