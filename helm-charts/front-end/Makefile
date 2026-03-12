# Makefile
.PHONY: plan apply destroy

plan:
	terraform init -upgrade
	terraform fmt -recursive
	terraform validate
	terraform plan -out=tfplan

apply: plan
	terraform apply tfplan

destroy:
	terraform destroy -auto-approve

#make plan    # runs init → fmt → validate → plan
#make apply   # runs plan first, then apply