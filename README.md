
# wayfinder-app

This repository is a template for creating a new application repository for Wayfinder. It contains a workflow that will build and deploy a simple example application to a Kubernetes cluster managed by Wayfinder.

The contents of this repo needs to be tailored to suit your needs, e.g. the source folder needs to be replaced with your application code.

## Prerequisites

If you created this repo using a [create-wf-app workflow](https://github.com/Digital-Garage-ICL/create-wf-app/actions) for students, all pre-requesites should already be set up for you.

Here's a list of pre-requisites for this repository to work:

1. A Wayfinder instance. You will find the URL for the Wayfinder portal in the `Resources info` step of the [create-wf-app workflow](https://github.com/Digital-Garage-ICL/create-wf-app/actions) that you've run.

2. A Workspace created. You can also find the name of the Wayfinder workspace in the `Resources info` step of the create-wf-app workflow.

3. A Kubernetes cluster created and available to use in your workspace. A shared student cluster is available for you to use. The [AppEnv](./infra/appenv.yaml) resource points to it.

4. Permission on this repository to add secrets and trigger Github workflows. You should be owner of this repository if you created it using the create-wf-app workflow.

5. Wayfinder CLI. Read more [here](https://docs.appvia.io/wayfinder/getting-started/cli)

6. gh and jq installed. See more in comments section at the beginning of the [setup.sh](./setup.sh) script.

## Setup Repository

***IMPORTANT*** You need to log in the Wayfinder portal and GitHub CLI for the setup to work. You can find the URL for the Wayfinder portal in the `Resources info` step of the create-wf-app workflow.

To check that you have logged in to Wayfinder, run `wf whoami` in the terminal. You should see your username (e-mail address).

Also make sure you log into the github cli using `gh auth login` and follow the instructions.
  
Before you start, you will need run the setup.sh script to setup the repo. This will create the required secrets and Variables for the workflow to work and set up access to the Wayfinder workspace for the CI pipeline.

 1. Clone the repository you've created using the create-wf-app workflow. You can find the URL in the `Resources info` step of the create-wf-app workflow.

 2. Open the terminal and navigate to the root of this repository then
    run the following command:

	```bash
	./setup.sh  ${WORKSPACE_NAME} ${GITHUB_PERSONAL_ACCESS_TOKEN}
	```
	
	Where:
	- `${WORKSPACE_NAME}` is the name of the Wayfinder workspace you've created using the create-wf-app workflow.
	- `${GITHUB_PERSONAL_ACCESS_TOKEN}` is a Github personal access token with `read:packages` scope. Make sure you create a `Classic` token. You can find more information about how to create a token [Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

Once this is complete the script will generate the relevant secrets, and variables for the workflow to work. Now you can start configuring the repository for your application.

You should now re-run the `deployment` GitHub workflow that got triggered when you created this repository. This will deploy the application to the Kubernetes cluster. In your repo's UI on GitHub, go to Actions. You should see a workflow run with a name of "Initial commit" that has failed. Re-run it by clicking on the "Re-run all jobs" button.

The workflow initially failed because the CI token was not authorised to do the things it needs to do (creating an application, an environment and deploying an application to that environment). You created and authorised the token in the previous step (running `./setup.sh`). The workflow should now succeed.

TODO: sort out imagePullSecrets attribute of the deployment resource so that the application can pull images from the GitHub container registry.

## Creating your image
  
There is a CI workflow, which can take your Dockerfile and build an image for you. This is the recommended way to build your image.

 - You will need to adjust your Docker file for your pacific application.  
 - Then CI workflow will be triggered on a push to main branch.
 -  The image will be created in GitHub registry which can be located here

>   https://github.com/ImperialCollegeLondon/{REPO NAME}/pkgs/container/{REPO NAME}

## Deployment strategy

There are Two ways to the point using Wayfinder  

 1. Configure resources using the UI
 2. Configure resources using yaml

## Deployment using the UI

### Creating Application

In Wayfinder, **Applications** are a way to model the elements of your applications (containers, cloud resources, environments, etc) to simplify deployment and provisioning. Applications should consist of things that follow the same software lifecycle and would typically be deployed together, although individual components can be deployed separately.

 - Navigate to [wayfinder](https://portal-20-0-245-170.go.wayfinder.run/login?returnURL=/).
 - Then find your workspace and create a new application.
 - Once you created your application, you can add components.

	>   Components are individually deployable parts of your application and component can either be of type [**container**](https://docs.appvia.io/wayfinder/using/devex/application-components#container-components) or of type  [**cloud resource**](https://docs.appvia.io/wayfinder/using/devex/application-components#cloud-resource-components).

### **Container components**[​](https://docs.appvia.io/wayfinder/using/devex/application-components#container-components "Direct link to heading")

A container component requires an image and registry path to be specified when defined.

Container components are defined in Wayfinder's web interface by selecting  **Workspaces**, and then by clicking on the  **Step2: Define Components** button.

If you do not have an existing Kubernetes manifest then you can define one by specifying the following:

-   Container image
-   [Dependencies](https://docs.appvia.io/wayfinder/using/devex/application-components#dependencies)
-   [Environment variables](https://docs.appvia.io/wayfinder/using/devex/application-components#environment-variables)
-   [Endpoints](https://docs.appvia.io/wayfinder/using/devex/application-components#endpoints)


![enter image description here](https://docs.appvia.io/img/wayfinder/wf-self-service-container-component.png)

### **Cloud resource components**

≈### Cloud Resource Overview[​](https://docs.appvia.io/wayfinder/using/devex/application-components#overview-1 "Direct link to Overview")
A cloud resource component represents a dependency of your application which is served by a cloud service, such as a database, storage bucket or message queue. It requires a cloud resource plan to be specified when defined, and that represents a Terraform module that administrators have made available to your workspace.

#### Create a Cloud Resource Plan using Wayfinder's web interface[​](https://docs.appvia.io/wayfinder/settings/self-service/cloud-resource-plans#create-a-cloud-resource-plan-using-wayfinders-web-interface "Direct link to Create a Cloud Resource Plan using Wayfinder's web interface")

-   Select  **Settings**, and then navigate to  **Developer Self-service > Cloud resources**.
-   Click on the  **Add cloud resource plan**  button. (The  **Add cloud resource plan**  screen appears).
-   Enter the details as required (See table below for options).
-   Click the  **Scan**  button. Wayfinder will scan the URL/Repo for available terraform modules. After the scan, select the terraform module that you want to create a cloud resource plan for.
  
You can read more about cloud resource [here](https://docs.appvia.io/wayfinder/settings/self-service/cloud-resource-plans#create-a-cloud-resource-plan-using-wayfinders-web-interface) 

   
Now that you created the application, we need to set what environments this application will be deployed in.

### Environments

Environments map to namespaces in Kubernetes. Kubernetes namespaces provide a mechanism for isolating groups of resources within a single cluster. You can deploy your application into an environment which uses existing infrastucture.


Here are the steps to get set up.

 - Navigate to your application
 - Find the create button on the top right hand corner and select environment
 - A wizard with a pair, and you need to specify **Environment name** and then you will need to select an existing **Environment host** called aks-stdnt1
 - Then select create environment.

Now you have your application and environments ready, we're ready to deploy.


### Deploy 

We have a workflow set up called you ci.yaml which will be the workflow that you need to use.  This workflow is triggered on merge to the main branch.

***IMPORTANT***  You will need to amend ci.yaml to allow deployment through UI. This can be done by commenting out the job which you are not using for example, if you're  configuring your application, using the UI insure job `apply-configured-with-ui` is not commented and `apply-configured-with-yaml` is commented.


 ## Configure resources using yaml 
 
### Creating Application

In Wayfinder, **Applications** are a way to model the elements of your applications (containers, cloud resources, environments, etc) to simplify deployment and provisioning. Applications should consist of things that follow the same software lifecycle and would typically be deployed together, although individual components can be deployed separately.

 - Create application.yaml and located in the infra/ folder. 

	```yaml
    apiVersion: app.appvia.io/v2beta1
    kind: Application
    metadata:
    	name: rbc-tst2
    spec:
	    cloud: azure
		name: rbc-tst2
	```
Once you created your application, you can add components.

### **Container components**[​](https://docs.appvia.io/wayfinder/using/devex/application-components#container-components "Direct link to heading")


  > Components are individually deployable parts of your application and component can either be of type [**container**](https://docs.appvia.io/wayfinder/using/devex/application-components#container-components) or of type  [**cloud resource**](https://docs.appvia.io/wayfinder/using/devex/application-components#cloud-resource-components).

A container component can take the following inputs

-   Container image
-   [Dependencies](https://docs.appvia.io/wayfinder/using/devex/application-components#dependencies)
-   [Environment variables](https://docs.appvia.io/wayfinder/using/devex/application-components#environment-variables)
-   [Endpoints](https://docs.appvia.io/wayfinder/using/devex/application-components#endpoints)

Within infra/azure-app.yml you should be able to find the below code. When modifying application you can replace values for your application.

```yaml
apiVersion: app.appvia.io/v2beta1
kind: AppComponent
metadata:
  name: rbc-tst2-storage-account-app
spec:
  application: rbc-tst2
  container:
    containers:
    - env:
      - fromCloudResourceOutput:
          componentName: rbc-tst2-storage-account
          output: SECONDARY_ACCESS_KEY
        name: PRIMARY_ACCESS_KEY
      - fromCloudResourceOutput:
          componentName: rbc-tst2-storage-account
          output: NAME
        name: AZURE_STORAGE_ACCOUNT_NAME
      - fromCloudResourceOutput:
          componentName: rbc-tst2-storage-account
          output: CONTAINER_NAME
        name: AZURE_CONTAINER_NAME
      image: ghcr.io/digital-garage-icl/student-rbc-tst2:latest
      name: ui
      ports:
      - containerPort: 3002
        name: ui
        protocol: TCP
      securityContext:
        runAsGroup: 999
        runAsUser: 999
    expose:
      container: ui
      port: 3002
    tls: true
  dependsOn:
  -  rbc-tst2-storage-account
  name: rbc-tst2-storage-account-app
  type: Container
```


### **Cloud resource components**


#### Overview[​](https://docs.appvia.io/wayfinder/using/devex/application-components#overview-1 "Direct link to Overview")

A cloud resource component represents a dependency of your application which is served by a cloud service, such as a database, storage bucket or message queue. It requires a cloud resource plan to be specified when defined, and that represents a Terraform module that administrators have made available to your workspace.

Within infra/storage-account.yml you should be able to find the below code. When modifying your application you can replace values for your application. 

To use the example set in this repo, replace `NAME` in the below code. This is because a storage account will be created and requires a unique string which is up to 24 alphanumeric lowercase characters.

You can read more about cloud resource [here](https://docs.appvia.io/wayfinder/settings/self-service/cloud-resource-plans#create-a-cloud-resource-plan-using-wayfinders-web-interface)
  

```yaml
apiVersion: app.appvia.io/v2beta1
kind: AppComponent
metadata:
  name: rbc-tst2-storage-account
spec:
  application: rbc-tst2
  cloudResource:
    plan: azurerm-demo-storage-account
    variables:
      container_name: demostorageaccountcontainer
      name: {{ NAME }}
      resource_group_name: terranetes
  key: storage
  name: rbc-tst2-storage-account
  type: CloudResource
```

Now that you created the application, we need to set what environments this application will be deployed in.

### Environments

Environments map to namespaces in Kubernetes. Kubernetes namespaces provide a mechanism for isolating groups of resources within a single cluster. You can deploy your application into an environment which uses existing infrastucture.

Create appenv.yaml and located in the infra/ folder. 

```yaml
apiVersion: app.appvia.io/v2beta1
kind: AppEnv
metadata:
  name: rbc-tst2-dev
spec:
  name: dev
  stage: nonprod
  application: rbc-tst2
  cloud: azure
  clusterRef:
    group: compute.appvia.io
    kind: Cluster
    name: aks-stdnt1
    # the namespace should be "ws-<cluster_workspace>" where <cluster_workspace> is the name of the workspace the cluster is in
    namespace: ws-to1
    version: v2beta1
```

Now you have your application and environments ready, we're ready to deploy.


### Deploy 

We have a workflow set up called you ci.yaml which will be the workflow that you need to use.  This workflow is triggered on merge to the main branch.

***IMPORTANT***  You will need to amend ci.yaml to allow deployment through UI. This can be done by commenting out the job which you are not using for example, if you're  configuring your application, using the yaml insure job `apply-configured-with-yaml` is not commented and `apply-configured-with-ui` is commented.




  ## Validating terranetes

Your configuration for your cloud resources can fail or pass for reasons, not controlled by yourself. For example, when you're making a Storage account you need to specify the name. You may provide a reasonable name, however, it is not unique and has already been registered within Azure. So your terraform plan will succeed, but in your apply, it will fail. 

Terranetes creates jobs for your terraform plan and apply. The pods that are created are short lived so they will be removed after a certain period of time so it's important that you check your logs within those pods.

For more information about terranetes [here is the documentation](https://terranetes.appvia.io/terranetes-controller/category/developer-docs/) 

  ### Here's how to check your Terraform plan and apply.

 - Login to wayfinder 

>   wf login -a https://api-20-0-245-170.go.wayfinder.run

 - Login to the cluster 

	>  wf use workspace 
	wf access env rbc-tst2 dev

 - List all the pods

>  kubectl get pods

 - Take a look at the plan pod logs 

>  kubectl logs {pod name}

 - If this is successful, you can then take a look at the apply pod logs in the same way

>  kubectl logs {pod name}

