#!/bin/bash

# Define kubectl alias
alias k=kubectl

# Array of manifest files to apply
manifests=(
    "secrets.yml"
    "config.yml" 
    "postgres-deployment.yaml"
    "deployment.yml"
    "sevice.yaml"
)

# Apply all manifest files
for manifest in "${manifests[@]}"; do
    k apply -f "$manifest"
done

# Get cluster resources
k get all
k get pods 
k get svc

