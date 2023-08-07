#! /usr/bin/env bash

# this script is called by GithHub worflow of https://github.com/Digital-Garage-ICL/create-wf-app
# it will replace the applicaiton and component name placeholders with the values suppolied by the user
# who triggered the workflow

# check that 2 arguments have been supplied
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 app_name component_name"
    echo "where app_name is the name of the application to be created (e.g. my-app)"
    echo "      component_name is the name of the component to be created (e.g. my-component)"
    exit 1
fi

APP_NAME=$1
WORKSPACE= $2

function rename_resources_in_file() {
    local file=$1
    local app_name=$2
    local workspace=$3
    local repo_name=$(basename "$PWD")

    echo "Renaming resources in ${file}..."
    sed -i "s/app-name-placeholder/${app_name}/g" "${file}"
    sed -i "s/component-name-placeholder/${component_name}/g" "${file}"
    sed -i "s/repo-name-placeholder/${repo_name}/g" "${file}"
    sed -i "s/workspace-placeholder /${workspace}/g" "${file}"
}

rename_resources_in_file "infra/application.yaml" "${APP_NAME}" "${WORKSPACE}"
rename_resources_in_file "infra/azure-app.yml" "${APP_NAME}" "${WORKSPACE}"
rename_resources_in_file "infra/storage-account.yml" "${APP_NAME}" "${WORKSPACE}"
rename_resources_in_file "infra/appenv.yaml" "${APP_NAME}"  "${WORKSPACE}"
rename_resources_in_file ".github/workflows/ci.yaml" "${APP_NAME}" "${WORKSPACE}"
rename_resources_in_file "setup.sh" "${APP_NAME}" "${WORKSPACE}"
rename_resources_in_file "README.md" "${APP_NAME}" "${WORKSPACE}"
