# resource "datadog_synthetics_global_variable" "keycloak_admin_passwords" {
#   for_each    = data.aws_ssm_parameter.passwords
#   name        = "${upper(join("_", slice(split("/", each.key), 1, 3)))}_KEYCLOAK_ADMIN_PASSWORD"
#   description = "Datadog Global Variable for ${each.key}"
#   value       = each.value.value
# }

resource "datadog_synthetics_global_variable" "keycloak_admin_passwords" {
  for_each    = var.customers
  name        = "${upper(each.key)}_KEYCLOAK_ADMIN_PASSWORD"
  description = "Keycloak admin password for ${upper(replace(each.key, "_", " "))}"
  value       = each.value.password
}

# Generate random characters for each required type
resource "random_string" "lowercase" {
  length  = 1
  special = false
  upper   = false
  numeric = false
}

resource "random_string" "uppercase" {
  length  = 1
  special = false
  upper   = true
  numeric = false
}

resource "random_string" "digit" {
  length  = 1
  special = false
  upper   = false
  numeric = true
}

# Generate the remaining random characters
resource "random_password" "remaining" {
  length           = 9  # Adjust based on total length required (12 - 3 fixed characters)
  special          = false
  override_special = ""
}

# Combine all parts together
resource "random_shuffle" "final_password" {
  input = [
    random_string.lowercase.result,
    random_string.uppercase.result,
    random_string.digit.result,
    random_password.remaining.result
  ]
  result_count = 1
}

resource "datadog_synthetics_global_variable" "new_password_variable" {
  for_each    = var.customers
  name        = "NEW_${upper(each.key)}_ELITE_PASSWD"
  description = "${title(replace(each.key, "_", " "))} Elite Password"
  # tags        = ["foo:bar", "env:test"]
  value       = join("", random_shuffle.final_password.result)
}

resource "datadog_synthetics_test" "elite_password_change" {
  for_each   = var.customers
  name       = "${title(replace(each.key, "_", " "))} Password Rotation Synthetic Test"
  type       = "browser"
  status     = "paused"
  message    = "${title(replace(each.key, "_", " "))} Password Rotation Synthetic Test"
  device_ids = ["laptop_large", "chrome.laptop_large"]
  locations  = ["pl:elite-private-location-f5fce069cf409769e55d47be8871ec5d"]
  tags       = []

  request_definition {
    method = "GET"
    url    = each.value.url
  }

  config_variable {
    name = "${upper(each.key)}_KEYCLOAK_ADMIN_PASSWORD"
    type = "global"
    id = datadog_synthetics_global_variable.keycloak_admin_passwords[each.key].id
  }

  config_variable {
    name = "NEW_${upper(each.key)}_ELITE_PASSWD"
    type = "global"
    id = datadog_synthetics_global_variable.new_password_variable[each.key].id
  }

  # Step 1
  browser_step {
    name = "Click on link \"Administration Console\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"h3\\\"][1]/*[local-name()=\\\"a\\\"][1]\",\n            \"at\": \"\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" welcome-primary-link \\\")]/*[local-name()=\\\"h3\\\"][1]/*[local-name()=\\\"a\\\"][1]\",\n            \"co\": \"[{\\\"text\\\":\\\"administration console\\\",\\\"textType\\\":\\\"directText\\\"}]\",\n            \"ro\": \"//*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"administration console\\\"]]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" welcome-primary-link \\\")]/descendant::*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"administration console\\\"]]\"\n          },\n          \"targetOuterHTML\": \"<a href=\\\"${each.value.url}/admin/\\\"><img src=\\\"welcome-content/user.png\\\">Administration Console <i class=\\\"fa fa-angle-right link\\\" aria-hidden=\\\"true\\\"></i></a>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 2
  browser_step {
    name = "Type text on input #username"
    type = "typeText"
    params {
      value = "admin"
      element = "{\n          \"url\": \"${each.value.url}/realms/master/protocol/openid-connect/auth?client_id=security-admin-console&redirect_uri=${each.value.url}%2Fadmin%2Fmaster%2Fconsole%2F&state=733de225-c2b1-405f-b23e-26e8519d2b3d&response_mode=fragment&response_type=code&scope=openid&nonce=6c520a92-4ce1-4845-9f26-8a1fbc016870&code_challenge=0ydWE-DrrxKhsLFMoRwcTLFUvF1RlaZlXhHXoOdsDgw&code_challenge_method=S256\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"input\\\"][1]\",\n            \"at\": \"/descendant::*[@name=\\\"username\\\" and @value=\\\"\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" card-pf \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" pf-c-form-control \\\")][1]\",\n            \"co\": \"[{\\\"text\\\":\\\"username or email\\\",\\\"textType\\\":\\\"innerText\\\"}]\",\n            \"ro\": \"//*[@id=\\\"username\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" card-pf \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" pf-c-form-control \\\")][1]\"\n          },\n          \"targetOuterHTML\": \"<input tabindex=\\\"1\\\" id=\\\"username\\\" class=\\\"pf-c-form-control\\\" name=\\\"username\\\" value=\\\"\\\" type=\\\"text\\\" autofocus=\\\"\\\" autocomplete=\\\"off\\\" aria-invalid=\\\"\\\">\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 3
  browser_step {
    name = "Type text on input #password"
    type = "typeText"
    params {
      value = "{{ ${upper(each.key)}_KEYCLOAK_ADMIN_PASSWORD }}"
      element = "{\n          \"url\": \"${each.value.url}/realms/master/protocol/openid-connect/auth?client_id=security-admin-console&redirect_uri=${each.value.url}%2Fadmin%2Fmaster%2Fconsole%2F&state=733de225-c2b1-405f-b23e-26e8519d2b3d&response_mode=fragment&response_type=code&scope=openid&nonce=6c520a92-4ce1-4845-9f26-8a1fbc016870&code_challenge=0ydWE-DrrxKhsLFMoRwcTLFUvF1RlaZlXhHXoOdsDgw&code_challenge_method=S256\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"input\\\"][1]\",\n            \"at\": \"/descendant::*[@name=\\\"password\\\" and @type=\\\"password\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" card-pf \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" pf-c-form-control \\\")][2]\",\n            \"co\": \"[{\\\"text\\\":\\\"password\\\",\\\"textType\\\":\\\"innerText\\\"}]\",\n            \"ro\": \"//*[@id=\\\"password\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" card-pf \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" pf-c-form-control \\\")][2]\"\n          },\n          \"targetOuterHTML\": \"<input tabindex=\\\"2\\\" id=\\\"password\\\" class=\\\"pf-c-form-control\\\" name=\\\"password\\\" type=\\\"password\\\" autocomplete=\\\"off\\\" aria-invalid=\\\"\\\">\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 4
  # browser_step {
  #   name = "Click on input #kc-login"
  #   type = "click"
  #   params {
  #     element = "{\n          \"url\": \"${each.value.url}/realms/master/protocol/openid-connect/auth?client_id=security-admin-console&redirect_uri=${each.value.url}%2Fadmin%2Fmaster%2Fconsole%2F&state=733de225-c2b1-405f-b23e-26e8519d2b3d&response_mode=fragment&response_type=code&scope=openid&nonce=6c520a92-4ce1-4845-9f26-8a1fbc016870&code_challenge=0ydWE-DrrxKhsLFMoRwcTLFUvF1RlaZlXhHXoOdsDgw&code_challenge_method=S256\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"div\\\"][4]/*[local-name()=\\\"input\\\"][2]\",\n            \"at\": \"/descendant::*[@name=\\\"login\\\" and @value=\\\"Sign In\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn-lg \\\")]\",\n            \"co\": \"\",\n            \"ro\": \"//*[@id=\\\"kc-login\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn-lg \\\")]\"\n          },\n          \"targetOuterHTML\": \"<input tabindex=\\\"4\\\" class=\\\"pf-c-button pf-m-primary pf-m-block btn-lg\\\" name=\\\"login\\\" id=\\\"kc-login\\\" type=\\\"submit\\\" value=\\\"Sign In\\\">\"\n        }"
  #   }
  #   allow_failure = false
  #   is_critical = true
  #   no_screenshot = false
  #   exit_if_succeed = false
  #   always_execute = false
  # }
  browser_step {
    allow_failure        = false
    always_execute       = false
    exit_if_succeed      = false
    force_element_update = false
    is_critical          = true
    local_key            = null
    name                 = "Click on input #kc-login"
    no_screenshot        = false
    timeout              = 0
    type                 = "click"
    params {
      attribute  = null
      check      = null
      click_type = null
      code       = null
      delay      = 0
      element = jsonencode({
        multiLocator = {
          ab  = "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"form\"][1]/*[local-name()=\"div\"][4]/*[local-name()=\"input\"][2]"
          at  = "/descendant::*[@name=\"login\" and @value=\"Sign In\"]"
          cl  = "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" btn-lg \")]"
          clt = "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" btn-lg \")]"
          co  = ""
          ro  = "//*[@id=\"kc-login\"]"
        }
        targetOuterHTML = "<input tabindex=\"4\" class=\"pf-c-button pf-m-primary pf-m-block btn-lg\" name=\"login\" id=\"kc-login\" type=\"submit\" value=\"Sign In\">"
        url             = "https://${each.value.url}/realms/master/protocol/openid-connect/auth?client_id=security-admin-console&redirect_uri=${each.value.url}%2Fadmin%2Fmaster%2Fconsole%2F&state=b74d09ae-65cb-4004-932f-afc568f806c3&response_mode=fragment&response_type=code&scope=openid&nonce=b9bdfbdd-20a8-4d17-82e7-669c812e6419&code_challenge=wKKMaZB9hcOagvd6nI_wCLL4-SSK22Lg6RLS99_sO5o&code_challenge_method=S256"
      })
      email             = null
      file              = null
      files             = null
      modifiers         = []
      playing_tab_id    = null
      request           = null
      subtest_public_id = null
      value             = null
      with_click        = false
      x                 = 0
      y                 = 0
    }
  }
  browser_step {
    name = "Click on input #kc-login"
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/realms/master/protocol/openid-connect/auth?client_id=security-admin-console&redirect_uri=${each.value.url}%2Fadmin%2Fmaster%2Fconsole%2F&state=733de225-c2b1-405f-b23e-26e8519d2b3d&response_mode=fragment&response_type=code&scope=openid&nonce=6c520a92-4ce1-4845-9f26-8a1fbc016870&code_challenge=0ydWE-DrrxKhsLFMoRwcTLFUvF1RlaZlXhHXoOdsDgw&code_challenge_method=S256\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"div\\\"][4]/*[local-name()=\\\"input\\\"][2]\",\n            \"at\": \"/descendant::*[@name=\\\"login\\\" and @value=\\\"Sign In\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn-lg \\\")]\",\n            \"co\": \"\",\n            \"ro\": \"//*[@id=\\\"kc-login\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn-lg \\\")]\"\n          },\n          \"userLocator\": {\n            \"failTestOnCannotLocate\": true,\n            \"values\": [\n              {\n                \"type\": \"xpath\",\n                \"value\": \"//*[@id='kc-login']\"\n              }\n            ]\n          },\n          \"targetOuterHTML\": \"<input tabindex=\\\"4\\\" class=\\\"pf-c-button pf-m-primary pf-m-block btn-lg\\\" name=\\\"login\\\" id=\\\"kc-login\\\" type=\\\"submit\\\" value=\\\"Sign In\\\">\"\n        }"
    }
    allow_failure    = false
    is_critical      = true
    no_screenshot    = false
    exit_if_succeed  = false
    always_execute   = false
  }

  # Step 5
  # browser_step {
  #   name = "Click on link \"Users\""
  #   type = "click"
  #   params {
  #     element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users\\\" class=\\\"ng-binding\\\"><span class=\\\"pficon pficon-user\\\"></span> Users</a>\"\n        }"
  #   }
  #   allow_failure = false
  #   is_critical = true
  #   no_screenshot = false
  #   exit_if_succeed = false
  #   always_execute = false
  # }
  browser_step {
    allow_failure        = false
    always_execute       = false
    exit_if_succeed      = false
    force_element_update = false
    is_critical          = true
    local_key            = null
    name                 = "Click on svg"
    no_screenshot        = false
    timeout              = 0
    type                 = "click"
    params {
      attribute  = null
      check      = null
      click_type = null
      code       = null
      delay      = 0
      element = jsonencode({
        multiLocator = {
          ab  = "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"header\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"button\"][1]/*[local-name()=\"svg\"][1]"
          at  = "/descendant::*[@fill=\"currentColor\" and @viewBox=\"0 0 448 512\"]"
          cl  = "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" pf-c-button \")]/*[local-name()=\"svg\"][1]"
          clt = "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" pf-c-button \")]/*[local-name()=\"svg\"][1]"
          co  = ""
          ro  = "//*[@viewBox=\"0 0 448 512\"]"
        }
        targetOuterHTML = "<svg fill=\"currentColor\" height=\"1em\" width=\"1em\" viewBox=\"0 0 448 512\" aria-hidden=\"true\" role=\"img\" style=\"vertical-align: -0.125em;\"><path d=\"M16 132h416c8.837 0 16-7.163 16-16V76c0-8.837-7.163-16- ..."
        url             = "https://${each.value.url}/admin/master/console/"
      })
      email             = null
      file              = null
      files             = null
      modifiers         = []
      playing_tab_id    = null
      request           = null
      subtest_public_id = null
      value             = null
      with_click        = false
      x                 = 0
      y                 = 0
    }
  }

  # Step 6
  browser_step {
    name = "Type text on input \"Search...\""
    type = "typeText"
    params {
      value = "monitoring"
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"table\\\"][1]/*[local-name()=\\\"thead\\\"][1]/*[local-name()=\\\"tr\\\"][1]/*[local-name()=\\\"th\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"input\\\"][1]\",\n            \"at\": \"/descendant::*[@placeholder=\\\"Search...\\\" and @type=\\\"text\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-control \\\")]\",\n            \"co\": \"[{\\\"text\\\":\\\"search...\\\",\\\"textType\\\":\\\"placeholder\\\"}]\",\n            \"ro\": \"//*[local-name()=\\\"input\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-control \\\")]\"\n          },\n          \"targetOuterHTML\": \"<input type=\\\"text\\\" placeholder=\\\"Search...\\\" data-ng-model=\\\"query.search\\\" class=\\\"form-control search ng-pristine ng-untouched ng-valid ng-empty\\\" onkeydown=\\\"if (event.keyCode == 13) document.getElementBy\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 7
  browser_step {
    name = "Press key 'Enter'"
    type = "pressKey"
    params {
      value = "Enter"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 8
  browser_step {
    name = "Click on link ${each.value.url}"
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"table\\\"][1]/*[local-name()=\\\"tbody\\\"][1]/*[local-name()=\\\"tr\\\"][1]/*[local-name()=\\\"td\\\"][1]/*[local-name()=\\\"a\\\"][1]\",\n            \"at\": \"/descendant::*[@*[local-name()=\\\"ng-repeat\\\"]=\\\"user in users\\\"]/descendant::*[@href=\\\"#/realms/${each.value.realm}/users/${each.value.userid}\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" table \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" clip \\\")][1]/*[local-name()=\\\"a\\\"][1]\",\n            \"co\": \"[{\\\"text\\\":\\\"${each.value.userid}\\\",\\\"textType\\\":\\\"directText\\\"}]\",\n            \"ro\": \"//*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"${each.value.userid}\\\"]]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" table \\\")]/descendant::*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"${each.value.userid}\\\"]]\"\n          },\n          \"targetOuterHTML\": \"<a href=\\\"#/realms/${each.value.realm}/users/${each.value.userid}\\\" class=\\\"ng-binding\\\">${each.value.userid}</a>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 9
  browser_step {
    name = "Click on link \"Credentials\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"ul\\\"][1]/*[local-name()=\\\"li\\\"][3]/*[local-name()=\\\"a\\\"][1]\",\n            \"at\": \"/descendant::*[@*[local-name()=\\\"ng-class\\\"]=\\\"{active: path[4] == 'user-credentials'}\\\"]/descendant::*[@href=\\\"#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" nav-tabs \\\")]/*[local-name()=\\\"li\\\"][3]/*[local-name()=\\\"a\\\"][1]\",\n            \"co\": \"[{\\\"text\\\":\\\"credentials\\\",\\\"textType\\\":\\\"directText\\\"}]\",\n            \"ro\": \"//*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"credentials\\\"]]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" nav-tabs \\\")]/descendant::*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"credentials\\\"]]\"\n          },\n          \"targetOuterHTML\": \"<a href=\\\"#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\\\" class=\\\"ng-binding\\\">Credentials</a>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 10
  browser_step {
    name = "Type text on input #newPas"
    type = "typeText"
    params {
      value = "{{ NEW_${upper(each.key)}_ELITE_PASSWD }}"
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"fieldset\\\"][3]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"input\\\"][1]\",\n            \"at\": \"/descendant::*[@*[local-name()=\\\"kc-password\\\"]=\\\"\\\" and @name=\\\"newPas\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-horizontal \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" password-conceal \\\")][1]\",\n            \"co\": \"[{\\\"text\\\":\\\"password *\\\",\\\"textType\\\":\\\"innerText\\\"}]\",\n            \"ro\": \"//*[@id=\\\"newPas\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-horizontal \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" password-conceal \\\")][1]\"\n          },\n          \"targetOuterHTML\": \"<input class=\\\"form-control ng-pristine ng-untouched password-conceal ng-empty ng-invalid ng-invalid-required\\\" kc-password=\\\"\\\" type=\\\"text\\\" id=\\\"newPas\\\" name=\\\"newPas\\\" data-ng-model=\\\"password\\\" required=\\\"\\\" \"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 11
  browser_step {
    name = "Type text on input #confirmPas"
    type = "typeText"
    params {
      value = "{{ NEW_${upper(each.key)}_ELITE_PASSWD }}"
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"fieldset\\\"][3]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"input\\\"][1]\",\n            \"at\": \"/descendant::*[@*[local-name()=\\\"kc-password\\\"]=\\\"\\\" and @name=\\\"confirmPas\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-horizontal \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" password-conceal \\\")][2]\",\n            \"co\": \"[{\\\"text\\\":\\\"password confirmation *\\\",\\\"textType\\\":\\\"innerText\\\"}]\",\n            \"ro\": \"//*[@id=\\\"confirmPas\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-horizontal \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" password-conceal \\\")][2]\"\n          },\n          \"targetOuterHTML\": \"<input class=\\\"form-control ng-pristine ng-untouched password-conceal ng-empty ng-invalid ng-invalid-required\\\" kc-password=\\\"\\\" id=\\\"confirmPas\\\" name=\\\"confirmPas\\\" data-ng-model=\\\"confirmPassword\\\" required=\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 12
  browser_step {
    name = "Click on span \"onoffswitch-switch\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"fieldset\\\"][3]/*[local-name()=\\\"div\\\"][3]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"span\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"label\\\"][1]/*[local-name()=\\\"span\\\"][2]\",\n            \"at\": \"\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" onoffswitch-switch \\\")]\",\n            \"co\": \"[{\\\"relation\\\":\\\"AFTER\\\",\\\"tagName\\\":\\\"SPAN\\\",\\\"text\\\":\\\"onoff\\\",\\\"textType\\\":\\\"innerText\\\"}]\",\n            \"ro\": \"//*[contains(concat(' ', normalize-space(@class), ' '), \\\" onoffswitch-switch \\\")]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" onoffswitch-switch \\\")]\"\n          },\n          \"targetOuterHTML\": \"<span class=\\\"onoffswitch-switch\\\"></span>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 13
  browser_step {
    name = "Click on button \"Reset Password\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"form\\\"][1]/*[local-name()=\\\"fieldset\\\"][3]/*[local-name()=\\\"div\\\"][4]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"button\\\"][1]\",\n            \"at\": \"/descendant::*[@name=\\\"userForm\\\"]/descendant::*[@type=\\\"submit\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-horizontal \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" border-top \\\")][3]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn \\\")][3]\",\n            \"co\": \"[{\\\"text\\\":\\\"reset password\\\",\\\"textType\\\":\\\"directText\\\"},{\\\"relation\\\":\\\"PARENT OF\\\",\\\"tagName\\\":\\\"DIV\\\",\\\"text\\\":\\\" reset password \\\",\\\"textType\\\":\\\"innerText\\\"}]\",\n            \"ro\": \"//*[@type=\\\"submit\\\"]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" form-horizontal \\\")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" border-top \\\")][3]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn \\\") and text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"reset password\\\"]]\"\n          },\n          \"targetOuterHTML\": \"<button data-ng-disabled=\\\"!passwordAndConfirmPasswordEntered()\\\" class=\\\"btn btn-default ng-binding\\\" type=\\\"submit\\\" data-ng-click=\\\"resetPassword(true)\\\">Reset Password</button>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 14
  browser_step {
    name = "Click on button \"Reset password\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"div\\\"][5]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][1]/*[local-name()=\\\"div\\\"][3]/*[local-name()=\\\"button\\\"][2]\",\n            \"at\": \"/descendant::*[@*[local-name()=\\\"ng-click\\\"]=\\\"ok()\\\" and @type=\\\"button\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn-danger \\\")]\",\n            \"co\": \"[{\\\"text\\\":\\\"reset password\\\",\\\"textType\\\":\\\"directText\\\"},{\\\"text\\\":\\\"cancel\\\",\\\"textType\\\":\\\"directText\\\"}]\",\n            \"ro\": \"//*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn \\\") and contains(concat(' ', normalize-space(@class), ' '), \\\" btn-danger \\\")]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" btn-danger \\\")]\"\n          },\n          \"targetOuterHTML\": \"<button type=\\\"button\\\" data-ng-class=\\\"btns.ok.cssClass\\\" ng-click=\\\"ok()\\\" class=\\\"ng-binding btn btn-danger\\\">Reset password</button>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 15
  browser_step {
    name = "Click on bold \"caret\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"nav\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"ul\\\"][1]/*[local-name()=\\\"li\\\"][1]/*[local-name()=\\\"a\\\"][1]/*[local-name()=\\\"b\\\"][1]\",\n            \"at\": \"\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" caret \\\")]\",\n            \"co\": \"\",\n            \"ro\": \"//*[contains(concat(' ', normalize-space(@class), ' '), \\\" caret \\\")]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" caret \\\")]\"\n          },\n          \"targetOuterHTML\": \"<b class=\\\"caret\\\"></b>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  # Step 16
  browser_step {
    name = "Click on link \"Sign Out\""
    type = "click"
    params {
      element = "{\n          \"url\": \"${each.value.url}/admin/master/console/#/realms/${each.value.realm}/users/${each.value.userid}/user-credentials\",\n          \"multiLocator\": {\n            \"ab\": \"/*[local-name()=\\\"html\\\"][1]/*[local-name()=\\\"body\\\"][1]/*[local-name()=\\\"nav\\\"][1]/*[local-name()=\\\"div\\\"][2]/*[local-name()=\\\"ul\\\"][1]/*[local-name()=\\\"li\\\"][1]/*[local-name()=\\\"ul\\\"][1]/*[local-name()=\\\"li\\\"][4]/*[local-name()=\\\"a\\\"][1]\",\n            \"at\": \"/descendant::*[@href=\\\"\\\" and @*[local-name()=\\\"ng-click\\\"]=\\\"auth.authz.logout()\\\"]\",\n            \"cl\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" dropdown-menu \\\")]/*[local-name()=\\\"li\\\"][4]/*[local-name()=\\\"a\\\"][1]\",\n            \"co\": \"[{\\\"text\\\":\\\"sign out\\\",\\\"textType\\\":\\\"directText\\\"}]\",\n            \"ro\": \"//*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"sign out\\\"]]\",\n            \"clt\": \"/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \\\" dropdown-menu \\\")]/descendant::*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \\\"sign out\\\"]]\"\n          },\n          \"targetOuterHTML\": \"<a href=\\\"\\\" ng-click=\\\"auth.authz.logout()\\\" class=\\\"ng-binding\\\">Sign Out</a>\"\n        }"
    }
    allow_failure = false
    is_critical = true
    no_screenshot = false
    exit_if_succeed = false
    always_execute = false
  }

  options_list {
    #device_ids = ["chrome.laptop_large"]
    ignore_server_certificate_error = false
    disable_cors = false
    disable_csp = false
    no_screenshot = false
    tick_every = 300
    min_failure_duration = 0
    min_location_failed = 1
    retry {
      count = 0
      interval = 300
    }
    # monitor_options {
    #   notification_preset_name = "show_all"
    #   on_missing_data = "show_no_data"
    #   notify_audit = false
    #   new_host_delay = 300
    #   include_tags = true
    # }
    rum_settings {
      is_enabled = true
      application_id = "5e4e6492-d890-4372-8d10-4090474d3cfc"
      client_token_id = 82614
    }
  }
}

# output "scheduler_schedule_arn" {
#   value = module.eb_lambda.aws_scheduler_schedule_arn
# }