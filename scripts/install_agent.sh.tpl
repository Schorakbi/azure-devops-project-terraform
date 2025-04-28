#!/usr/bin/env bash
set -eu


echo "Installing prerequisites…"
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  ca-certificates curl jq git wget tar

echo "Preparing agent directory…"
sudo mkdir -p "/home/azureuser/agent"
sudo chown azureuser:azureuser "/home/azureuser/agent"

echo "Downloading & extracting agent v${AGENT_VERSION}…"
cd "/home/azureuser/agent"
curl -sSL -o agent.tar.gz \
     "https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"
tar -xzf agent.tar.gz --strip-components=1
sudo chown -R azureuser:azureuser "/home/azureuser/agent"

echo "Configuring agent (as azureuser)…"
sudo -u azureuser bash -lc "\
  cd '/home/azureuser/agent'; \
  ./config.sh --unattended \
    --url '${AZDO_ORG_URL}' \
    --auth pat \
    --token '${AZDO_PAT}' \
    --pool '${AGENT_POOL}' \
    --agent '${AGENT_NAME}' \
    --acceptTeeEula
"

echo "Installing service (as azureuser)…"
sudo -u azureuser bash -lc "cd '/home/azureuser/agent'; ./svc.sh install"

echo "Starting agent service…"
cd "/home/azureuser/agent" && sudo ./svc.sh start

echo "🎉 Agent is up and running!"