CHART_NAME=${1}
CLUSTER_NAME=${2}
SERVICE_ACCOUNT_NAME=${3}
NAMESPACE=${4}

helm upgrade -i "${CHART_NAME}" eks/aws-load-balancer-controller \
  --set clusterName="${CLUSTER_NAME}" \
  --set serviceAccount.create=false \
  --set serviceAccount.name="${SERVICE_ACCOUNT_NAME}" \
  -n "${NAMESPACE}"