# Build and Deploy to EKS

This repository uses a GitHub Actions workflow to automate building, pushing Docker images to AWS ECR, and deploying services to an Amazon EKS cluster.

## 📌 Quick Links

- **CloudWatch Dashboard**: [View Dashboard](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards/dashboard/Sreekanth_Reddy_EKS_Cluster_dashboard?start=PT1H&end=null)
- **Appointment Service Health Check**: [Check Health](http://a30e5f86326f2434792c962dc1d20aeb-293716483.us-east-1.elb.amazonaws.com/health)
- **Patient Service Health Check**: [Check Health](http://a2487b88e8e914f459e00eab8074262d-1988869648.us-east-1.elb.amazonaws.com/health)

---

## Workflow Trigger

The workflow runs automatically on every push to the `main` branch.

## Workflow Steps

1. **Checkout Code**  
   - Uses `actions/checkout@v2` to pull the latest code.

2. **Configure AWS CLI**  
   - Sets up AWS credentials from GitHub Secrets:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - `AWS_ACCOUNT_ID`
   - Region: `us-east-1`

3. **Login to Amazon ECR**  
   - Authenticates Docker with ECR for pushing images.

4. **Build Docker Images**
   - `appointment-service`: from `npm/appointment-service`
   - `patient-service`: from `npm/patient-service`

5. **Push Docker Images to ECR**
   - Tags images and pushes them to the ECR repository:
     - Repository: `sreekanth-ecr-repo`
     - Tags:
       - `appointment-service-latest`
       - `patient-service-latest`

6. **Install and Configure kubectl**
   - Installs the latest version of `kubectl`.
   - Updates kubeconfig to access the `sreekanth-eks-cluster` EKS cluster.

7. **Deploy to EKS**
   - Applies Kubernetes manifests:
     - `k8s/appointment-service-deployment.yaml`
     - `k8s/patient-service-deployment.yaml`
   - Verifies pods and services using `kubectl get pods` and `kubectl get svc`.

## Kubernetes Deployment Details

### patient-service

- **Deployment**
  - Replicas: 2
  - Image:  
    `539935451710.dkr.ecr.us-east-1.amazonaws.com/sreekanth-ecr-repo:patient-service-latest`
  - Container Port: 3001

- **Service**
  - Type: `LoadBalancer`
  - Exposes port 80 → Targets container port 3001
    
###Appointment Service

- **Deployment**
  - Replicas: 2
  - Image:  
    `539935451710.dkr.ecr.us-east-1.amazonaws.com/sreekanth-ecr-repo:appointment-service-latest`
  - Container Port: 3000

- **Service**
  - Type: `LoadBalancer`
  - Exposes port 80 → Targets container port 3000

## Folder Structure

```plaintext
npm/
 ├── appointment-service/
 │    └── Dockerfile
 └── patient-service/
      └── Dockerfile

k8s/
 ├── appointment-service-deployment.yaml
 └── patient-service-deployment.yaml
.github/
 └── workflows/
     └── terraform-eks-pipeline.yml
     └── service-deploy-pipeline.yml
terraform-eks-code
 └── main.tf
 └── output.tf
 └── provider.tf

