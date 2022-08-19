# Create SA Candidate Tech Exercise VMs

Pre-reqs:
  * Install terraform: `brew install terraform` or <a href="https://learn.hashicorp.com/tutorials/terraform/install-cli" target="_blank">follow instructions here</a>.
  * Install Gcloud CLI: `brew install --cask google-cloud-sdk` or <a href="https://cloud.google.com/sdk/docs/quickstart" target="_blank">follow instructions here</a>.

## The Steps
1. Clone this project: ```git clone https://github.com/Redislabs-Solution-Architects/tech_exercise_terraform.git```

2. Get the public key from your candidate.

3. Authorize terraform to with gcloud credentials. 
    You can a) authorize gcloud command line or b) provide the service account credentials to terraform Gcloud provider.

    a) Authorize gcloud command line. Our gcloud web login screen will open in a browser:
    ```
    $ gcloud auth application-default login
    ```
    b) Provide the service account credentials to terraform Gcloud provider via environment variable. If you don't have one you can create one with instructions at the end of this file, or you can ask one of the SAs for one with the `compute.admin` role. 

    ```
    $ export GOOGLE_APPLICATION_CREDENTIALS=/Users/brad/Desktop/code/tech_exercise_terraform/central-beach-194106-4f85e190ed0e.json
    $ ls -al $GOOGLE_APPLICATION_CREDENTIALS
    -rw-r--r--@ 1 brad  staff   2.3K Jul 30 15:58 /Users/brad/Desktop/code/tech_exercise_terraform/central-beach-194106-4f85e190ed0e.json
    ```
1. Modify the variables in `terraform.tfvars`
    ```
    hiring_manager_name = "brad"

    candidate_name = "bobross"

    candidate_public_key = "ssh-rsa AAAAB3Nz...<snip>...BNKs= ubuntu"
    ```

2. Initialize terraform, plan. 
 
    Execute steps all at once. Replace <candidate_name> with candidate name. Run `terraform init; terraform plan`.

<details><summary>Alternatively, run the `init / plan / apply` steps individually</summary>
<p>
    
```
    $ terraform init

    Initializing the backend...

    Initializing provider plugins...
    - Reusing previous version of hashicorp/google from the dependency lock file
    - Using previously-installed hashicorp/google v3.77.0

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
```
```
    $ terraform plan
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # google_compute_address.gcp-ip[0] will be created
      + resource "google_compute_address" "gcp-ip" {
          + address            = (known after apply)
          + address_type       = "EXTERNAL"
          + creation_timestamp = (known after apply)
    <snip>
    Changes to Outputs:
      + gcp_instance_external_ips = [
          + (known after apply),
          + (known after apply),
        ]
      + gcp_instance_vm_names     = [
          + "brad-sa-candidate-bobross-vm1",
          + "brad-sa-candidate-bobross-vm2",
        ]

    ------------------------------------------------------------------------

    Note: You didn't specify an "-out" parameter to save this plan, so Terraform
    can't guarantee that exactly these actions will be performed if
    "terraform apply" is subsequently run.
```
</p>
</details><br />
    
1. Apply it with `terraform apply --auto-approve --state-out=<candidate_name>.tfstate`
    ```
    $ terraform apply --auto-approve --state-out=bobross.tfstate
    ... < 2 mins max>
    Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

    Outputs:

    gcp_instance_external_ips = [
      "35.237.6.209",
      "34.75.9.58",
    ]
    gcp_instance_vm_names = [
      "brad-sa-candidate-bobross-vm1",
      "brad-sa-candidate-bobross-vm2",
    ]
    ```
Provide these IPs to the candidate over email.

## Remove Resources 

Find the `<candidate_name>.tfstate` file, run `terraform destroy --state=<candidate_name>.tfstate`.

```
$ terraform destroy --auto-approve --state=bobross.tfstate
...< 1 minute max>
...
google_compute_network.gcp-network: Still destroying... [id=projects/central-beach-194106/global/networks/brad-sa-candidate-bobross-network, 10s elapsed]
google_compute_network.gcp-network: Still destroying... [id=projects/central-beach-194106/global/networks/brad-sa-candidate-bobross-network, 20s elapsed]
google_compute_network.gcp-network: Destruction complete after 22s

Destroy complete! Resources: 7 destroyed.
```


## Creating a service account

Create a service account for our GCP project with json file output:
```
export SERVICE_ACCOUNT_NAME=blah-sa123
export PROJECT=`gcloud config get-value project 2> /dev/null`
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME --display-name="$SERVICE_ACCOUNT_NAME for tech exercise automation"
gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@$PROJECT.iam.gserviceaccount.com" --role="roles/compute.admin"
# creating the key.json output file
gcloud iam service-accounts keys create $SERVICE_ACCOUNT_NAME.json --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT.iam.gserviceaccount.com
# get the full path to the file to use in your terraform config.
ls -d $PWD/$SERVICE_ACCOUNT_NAME.json
/Users/brad/Desktop/code/tech_exercise_terraform/blah-sa123.json
```
```
# delete it
gcloud iam service-accounts delete $SERVICE_ACCOUNT_NAME@$PROJECT.iam.gserviceaccount.com
rm -rf blah-sa123.json
```

## Command line shortcuts
Plan/apply using environment variables:
```
export TF_VAR_hiring_manager_name=brad
export TF_VAR_candidate_name=simon
export TF_VAR_candidate_public_key=`cat id_rsa_SI.pub`
terraform plan
terraform apply --auto-approve --state-out=$TF_VAR_candidate_name.tfstate
terraform destroy --auto-approve -state=$TF_VAR_candidate_name.tfstate
```

Plan/apply using cli only:
```
terraform plan -var="hiring_manager_name=brad" -var="candidate_name=simon" -var="candidate_public_key=`cat id_rsa_SI.pub`" 
terraform apply --auto-approve --state-out=simon.tfstate -var="hiring_manager_name=brad" -var="candidate_name=simon" -var="candidate_public_key=`cat id_rsa_SI.pub`"  --state-out=simon.tfstate
...
terraform destroy --auto-approve -var="hiring_manager_name=brad" -var="candidate_name=simon" -var="candidate_public_key=`cat id_rsa_SI.pub`" -state=simon.tfstate
``` 
