CLUSTER_NAME=${1}
NAMESPACE=${2}
NAME=${3}
POLICY_ARN=${4}
AWS_REGION=${5}

eksctl create iamserviceaccount \
  --cluster="${CLUSTER_NAME}" \
  --namespace="${NAMESPACE}" \
  --name="${NAME}" \
  --attach-policy-arn="${POLICY_ARN}" \
  --region "${AWS_REGION}" \
  --override-existing-serviceaccounts \
  --approve