# terraform-for-ansible
Shows a simple setup with Terraform for creating and provisioning servers for Ansible.

For running these terraform files, make sure you use a SSH key that does not have a passphrase, otherwise the local provisioner, which executes the Ansible playbook, fails. 

For the second SSH key, which is meant for Ansible, also make sure it doesn't have a passphrase either.

For the backend, Azure Blob Storage is used. This can be changed to whatever backend you want. The configuration for the backend is omitted and can be provided by creating a local .tfbackend file like 'config.tfbackend' where arguments of the backend block can be appended with key/value pairs. For Azure Blob Storage with access key as authentication it could look like this:

```
storage_account_name = "testdevopsstorage"
container_name = "tfstate"
key    = "terraform.tfstate"
access_key  = "<access key>"
```

After having created this file, you can start with ```terraform init```.
