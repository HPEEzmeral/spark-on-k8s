#!/usr/bin/env bash

delete_tenantvalidator_secret() {
  kubectl delete secret tenant-validator-certs -n hpe-system --ignore-not-found
}

run_uninstall() {

  echo "Deleting created Tenant Validator Service certs secret..."
  delete_tenantvalidator_secret

  echo "Deleting mutating webhook"
  kubectl delete MutatingWebhookConfiguration tenant-validator-mutating-webhook-cfg

  echo "Deleting validating webhook"
  kubectl delete  ValidatingWebhookConfiguration tenant-validator-validating-webhook-cfg

  echo "Deleting tenant CRD"
  kubectl delete crd tenants.hcp.hpe.com

}

run_uninstall