
CLUSTER_NAME=${1}
AWS_REGION=${2}
EKS_SSH_PUBLIC_KEY=${3}
ZONES=${4}

eksctl create cluster \
  --name "${CLUSTER_NAME}" \
  --region "${AWS_REGION}" \
  --with-oidc \
  --ssh-access \
  --ssh-public-key "${EKS_SSH_PUBLIC_KEY}" \
  --managed \
  --zones="${ZONES}"