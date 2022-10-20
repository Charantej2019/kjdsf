#!/bin/bash
# Usage:  bash invalidate_cache.sh dev
#         bash invalidate_cache.sh dev e62fd744-9d9f-47a0-afe9-fec6bdb51928

COLOR_OUT=$'\e[1;94m'
COLOR_SUC=$'\e[1;92m'
COLOR_ERR=$'\e[1;91m'
COLOR_ENV=$'\e[1;96m'
COLOR_RST=$'\e[0m'

# Fail script on any error
set -e

# Check if argument was passed in
if [[ -z "$1" ]]; then echo "${COLOR_ERR}ERROR: No Environment argument included${COLOR_RST}" && exit 1; fi
if [[ -z "$ARM_SUBSCRIPTION_ID" ]] && [[ -z "$2" ]]; then echo "${COLOR_ERR}ERROR: ARM_SUBSCRIPTION_ID or subscription as an argument needs to be provided${COLOR_RST}" && exit 1; fi

# Default to BitBucket repository variable for subscription if not provided as argument
export AZURE_SUB_ID=${2:-$ARM_SUBSCRIPTION_ID}

# Print Date
echo -e "\n${COLOR_OUT}> date${COLOR_SUC}"
date
echo "${COLOR_RST}"

# Print Environment
echo "${COLOR_OUT}Environment: ${COLOR_SUC}${1^^}${COLOR_RST}"

# Print Azure-Cli version
echo -e "\n${COLOR_OUT}> az version${COLOR_SUC}"
az version
echo "${COLOR_RST}"

# Install extensions automatically
echo -e "${COLOR_OUT}> az config set extension.use_dynamic_install=yes_without_prompt${COLOR_SUC}"
az config set extension.use_dynamic_install=yes_without_prompt
echo "${COLOR_RST}"

# Login to Azure
echo -e "${COLOR_OUT}> az login --service-principal --username ${ARM_CLIENT_ID}${COLOR_SUC}"
az login --service-principal --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
echo "${COLOR_RST}"

# Submit Purge job
STARTTIME=$(date -Iseconds)
echo -e "${COLOR_OUT}INFO: ${COLOR_SUC}Starting Purge job at ${STARTTIME}${COLOR_RST}"
echo -e "${COLOR_OUT}> az network front-door purge-endpoint --content-paths /* --name rtweb-${1} --resource-group realtytrac-${1} --subscription ${AZURE_SUB_ID}${COLOR_RST}"
az network front-door purge-endpoint --content-paths /* --name rtweb-"${1}" --resource-group realtytrac-"${1}" --subscription "${AZURE_SUB_ID}"
EXITCODE=$?
echo -e "${COLOR_OUT}INFO: ${COLOR_SUC}Purge job was submitted with exit code of ${EXITCODE}\n${COLOR_RST}"

# Print Date
echo -e "\n${COLOR_OUT}> date${COLOR_SUC}"
date
echo "${COLOR_RST}"

# Exit with exitcode from Front Door purge command
exit $EXITCODE
