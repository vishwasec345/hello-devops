# Day 1 Terraform demo (trainer only, about 10 minutes)

Shows the Infrastructure as Code workflow without a cloud account.
The "servers" are text files in a folder, so it is free, fast and safe to run live.

## Before class

- Install Terraform 1.5 or newer, then check: `terraform version`
- Run `terraform init` once with internet access so the provider is downloaded and cached.

## Steps

Run everything from this folder: `cd day1/terraform`

| # | Command | What to say |
|---|---|---|
| 1 | `cat main.tf` | "This file describes what we want: 2 web servers in the dev environment. We write the desired state, not the steps." |
| 2 | `terraform init` | "Downloads the provider, the plugin that knows how to talk to the platform (here: local files; in real life: AWS, Azure)." |
| 3 | `terraform plan` | "A dry run. Nothing changes yet. Look for `Plan: 3 to add`." |
| 4 | `terraform apply` then type `yes` | "Now Terraform builds it." Then show the result: `ls infra-dev` and `cat infra-dev/web-1.txt` |
| 5 | `terraform apply` again | "Run it twice, nothing happens: `No changes`. This is idempotency." |
| 6 | `terraform apply -var="servers=4"` | "Scale up by changing one number. Plan shows `3 to add, 1 to destroy`: 2 new servers, and the README is replaced because its text changed. Existing servers are left alone." |
| 7 | `rm infra-dev/web-1.txt` then `terraform plan -var="servers=4"` | "Someone deleted a server by hand. Terraform spots the drift and plans to recreate it." Then `terraform apply -var="servers=4" -auto-approve` |
| 8 | `cat terraform.tfstate \| head -30` | "The state file is Terraform's memory of what it built. In a team it lives in shared remote storage, never on a laptop." |
| 9 | `terraform destroy -var="servers=4"` then `yes` | "Tear down everything with one command. The folder is now empty." |

Tip for step 6 onwards: pass the same `-var` values to every command, or Terraform will plan to go back to the defaults (2 servers).

## Optional extra

`terraform plan -var="environment=prod"` shows every resource marked `must be replaced`, because the file paths change. Good moment to say: "Always read the plan. A one-word change can rebuild everything." (In real projects, each environment gets its own state, for example with workspaces, so dev and prod live side by side.)

## Reset after the demo

```bash
rm -rf .terraform .terraform.lock.hcl terraform.tfstate* infra-*
```
