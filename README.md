# Udacity k8s infrastructure

This project provides guide and setup scripts for udacity eks cluster 

# Table Of Contents

- [pre requisites](#pre-requisites)
- [cluster setup](#cluster-setup)
  - [create cluster](#create-cluster)
  - [aws load balancer controller setup](#aws-load-balancer-controller-setup)
- [create namespace](#create-a-namespace)
- [configure circle ci aws user or role access to cluster](#configure-circle-ci-aws-user-or-role-access-to-cluster)

## Pre-requisites
- aws clii v2 ([Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- eksctl ([Installation Guide](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html))
- kubectl ([Installation Guide](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html))
- AWS User or Role having sufficient permissions to create eks cluster. More info on setting it up can be found 
  [here](https://docs.aws.amazon.com/eks/latest/userguide/security-iam.html)
- helm ([Installation Guide](https://helm.sh/docs/intro/install/))

## Cluster Setup

### Create Cluster
You can create a cluster by using the [create-eks-cluster.sh](./create-eks-cluster.sh) script.

Pass the cluster name, region, ssh public key and zones to the script as arguments shown below to create the cluster

```shell
# Arguments: cluster name, region, ssh public key and zones
./create-eks-cluster.sh udacity-1 us-east-1 XXXXX us-east-1a,us-east-1b
```

### AWS Load Balancer Controller Setup
AWS Load Balancer Controller listens to ingress and service objects to create ALB and NLB respectively. More info can be found [here].(https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/)  
Please set up the ALB loadbalancer requirements as specified [here](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)

or you can use the below steps to set it up

```shell
# create ALB Controller with policy name AWSLoadBalancerControllerIAMPolicy. 
# Pleas note the arn of the policy
#Arguments: policy name
./create-iam-policy-for-aws-load-balancer-controller.sh AWSLoadBalancerControllerIAMPolicy

# create k8s serviceaccount for aws-load-balancer-controller
# Arguments: cluster name, namespace to install, name of service account, policy arn and region 
./create-serviceaccount-for-aws-load-balancer-controller.sh udacity-1 kube-system aws-load-balancer-controller \
arn:aws:iam::XXXXXXXXXX:policy/AWSLoadBalancerControllerIAMPolicy us-east-1

# Install a TargetGroupBinding custom resource definitions(CRD)
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

# Add eks charts repo to helm
helm repo add eks https://aws.github.io/eks-charts

# install eks/aws-load-balancer-controller chart to setup aws-load-balancer-controller in cluster
# Arguments: chart name, cluster name, name of service account, namespace to install 
./helm-setup-aws-load-balancer-controller.sh aws-load-balancer-controller udacity-1 aws-load-balancer-controller kube-system
```

## Create a namespace
Using the kubectl command, please create your desired namespace

```shell
kubectl create namespace udacity-services
```

## Configure circle CI aws user or role access to cluster

Please refer to the guide [here](https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/) on how to set it up. 

Example k8s config map yaml can be found below
```yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::XXXXXXXXXXX:role/ZZZZZZZZZZ
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::XXXXXXXXXXX:user/YYYYYYYYY
      username: YYYYYYYYY
      groups:
        - system:masters
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
```
