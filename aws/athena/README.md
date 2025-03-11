### How to get a list of Datadog agent versions

```
curl -s https://api.github.com/repos/DataDog/datadog-agent/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sort -rV
curl -s "https://api.github.com/repos/DataDog/datadog-agent/releases" | jq -r '.[].tag_name' | sort -rV
```

### How to install a specific version of the Datadog agent

```
export DD_API_KEY=<MY_DATADOG_API_KEY>
export DD_AGENT_MAJOR_VERSION=7
export DD_AGENT_MINOR_VERSION=63.2
export DD_SITE="datadoghq.com"
bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
```

or

```
export DD_API_KEY=<MY_DATADOG_API_KEY>
export DD_AGENT_MAJOR_VERSION=7
export DD_AGENT_MINOR_VERSION=63.2
export DD_SITE="datadoghq.com"
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
```
