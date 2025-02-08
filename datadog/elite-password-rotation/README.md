# Elite Password Rotation #

The high level steps to create the Terraform code are these three steps:

Step 1: get the JSON representation of a Synthetic Test using API call
Step 2: manually, or using an online tool further convert the JSON to a valid string which I then set it in the element parameter
Step 3: use that JSON string in Terraform

Get the JSON representation of an existing Synthetic Test following these instructions [https://docs.datadoghq.com/api/latest/synthetics/#get-a-browser-test](https://docs.datadoghq.com/api/latest/synthetics/#get-a-browser-test)

I used these CLI commands:

```
# Environment Variables
export public_id="btb-kb3-qmr"
export DD_API_KEY=
export DD_APP_KEY=

# Curl command
curl -X GET "https://api.datadoghq.com/api/v1/synthetics/tests/browser/${public_id}" \
-H "Accept: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" | jq
```

Then I converted the `element` JSON into a string JSON using this website: [JSON to String Conversion Tool](https://dadroit.com/json-to-string/)

The JSON string is then copied into the relevant `browser_step` section.  For example:

```
browser_step {
    name = "Click on link \"Users\""
    type = "click"
    params {
      element = <COPY JSON STRING HERE>
    }
```