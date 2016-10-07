#!/usr/bin/env bash

set -e

# Instructions: https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/blob/master/docs/get-started/create-service-principal.md

function ver {
  # Used to compare semvers
  # shellcheck disable=2046
  printf "%03d%03d%03d%03d" $(echo "$1" | tr '.' ' ')
}

function check_prerequisites() {
  if which "azure" > /dev/null; then
		:
	else
		echo "Could not find azure. Please \`brew install azure-cli\`."
		exit 1
	fi

  local minimum_supported_azure_cli="0.10.3"
  # shellcheck disable=2046
  if [[ $(ver $(azure --version)) -lt $(ver "$minimum_supported_azure_cli") ]]; then
    echo "Error: Please update your Azure CLI to at least $minimum_supported_azure_cli"
    exit 1
  fi

  if which "uuidgen" > /dev/null; then
		:
	else
		echo "Could not find uuidgen. Please install."
		exit 1
	fi

  if which "jq" > /dev/null; then
		:
	else
		echo "Could not find jq. Please \`brew install jq\`."
		exit 1
	fi
}

function prep_azure() {
	azure config mode arm

	local app_display_name="Service Principal for PCF"

  local account_count
  account_count=$(azure account list --json | jq ". | length")
  if [[ $account_count -eq 0 ]]; then
    echo "Please log in to the Azure CLI"
    exit 1
  fi

  local subscription_id
  subscription_id=$(azure account show -s "$account" --json | jq ".[0].id" --raw-output)

  local tenant_id
  tenant_id=$(azure account show -s "$account" --json | jq ".[0].tenantId" --raw-output)

  app_list=$(azure ad app show -c "$app_display_name" --json)
  if [[ "$app_list" != "data: No matching application was found" ]]; then
    app_object_id=$(azure ad app show -c "$app_display_name" --json | jq ".[0].objectId")
    if [[ -n "$app_object_id" ]]; then
      echo "The \"$app_display_name\" application already exists (objectId: $app_object_id)."
      echo "Cannot determine password. Quitting."
      echo "You may need to create a service principal for the application."
      exit 1
    fi
  fi

  local client_secret
	client_secret=$(uuidgen)

  local client_id
	client_id=$(azure ad app create --name "$app_display_name" --password "$client_secret" --home-page "http://example.com" --identifier-uris "http://example.com" --json | jq ".appId" --raw-output)

	azure ad sp create --applicationId "$client_id"
	azure ad sp show --spn "$client_id"
  sleep 30
  azure role assignment create --spn "$client_id" --roleName "Contributor" --subscription "$subscription_id"

  cat > "$credential_output_file" <<-EOF
subscription_id = "$subscription_id"
tenant_id = "$tenant_id"
client_id = "$client_id"
client_secret = "$client_secret"
EOF

  echo "Wrote credentials to $credential_output_file"
	echo "Done."
}

function cmdline() {
    # got this idea from here:
    # http://kirk.webfinish.com/2009/10/bash-shell-script-to-use-getopts-with-gnu-style-long-positional-parameters/
    arg=
    for arg in "${ARGS[@]}"
    do
        delim=""
        case "$arg" in
            #translate --gnu-long-options to -g (short options)
            --account)  args="${args}-a ";;
            --credential-output-file)  args="${args}-o ";;
            #pass through anything else
            *) [[ "${arg:0:1}" == "-" ]] || delim="\""
                args="${args}${delim}${arg}${delim} ";;
        esac
    done

    #Reset the positional parameters to the short options
    eval set -- "$args"

    export credential_output_file
    export account

    while getopts ":o:a:" OPTION
    do
         case $OPTION in
         o)
             credential_output_file=$OPTARG
             ;;
         a)
             account=$OPTARG
             ;;
         :)
             echo "Missing option argument for -$OPTARG" >&2
             exit 1
             ;;
        esac
    done

    if [ -z "${credential_output_file+x}" ]; then
      echo "--credential-output-file must be specified"
      exit 1
    fi

    if [ -z "${account+x}" ]; then
      echo "--account must be specified (either id or name). Use \`azure account list\` to see your accounts"
      exit 1
    fi
}

function main() {
  cmdline
  check_prerequisites
  prep_azure
}

export ARGS=( "$@" )

main
