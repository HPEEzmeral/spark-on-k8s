#!/usr/bin/env bash

NAMESPACE=${1:-default}

delete_autoticket_generator_secret() {
  kubectl delete secret autoticket-generator-certs -n $NAMESPACE --ignore-not-found
}

run_uninstall() {

  echo "Deleting created autoticket generator Service certs secret..."
  delete_autoticket_generator_secret

  echo "Deleting mutating webhook"
  kubectl delete MutatingWebhookConfiguration autoticket-generator-mutating-webhook-cfg

  echo "Deleting validating webhook"
  kubectl delete  ValidatingWebhookConfiguration autoticket-generator-validating-webhook-cfg

}

run_uninstall