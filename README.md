# AWS GitHub Actions Workflow

This repository contains a GitHub Actions workflow to automate the deployment of a Docker container to Amazon ECS (Elastic Container Service). The workflow builds, tags, and pushes a Docker image to Amazon ECR (Elastic Container Registry) and updates the ECS service to use the new image.

---

## Table of Contents

1. [Overview](#overview)
2. [Workflow Tasks](#workflow-tasks)
3. [Environment Variables](#environment-variables)
4. [Prerequisites](#prerequisites)
5. [Triggering the Workflow](#triggering-the-workflow)
6. [Example Workflow File](#example-workflow-file)

---

## Overview

The workflow is defined in `.github/workflows/aws.yml` and is triggered on a `push` event to the `main` or `dev` branches. It automates the following tasks:
- Building and tagging a Docker image.
- Pushing the Docker image to Amazon ECR.
- Updating the ECS service to use the new image.

---

## Workflow Tasks

### 1. Checkout Code
- Uses the `actions/checkout@v4` action to clone the repository into the GitHub Actions runner.

### 2. Configure AWS Credentials
- Uses the `aws-actions/configure-aws-credentials@v1` action to authenticate with AWS using credentials stored in GitHub Secrets.
- Required secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

### 3. Login to Amazon ECR
- Uses the `aws-actions/amazon-ecr-login@v1` action to authenticate with Amazon ECR.

### 4. Build, Tag, and Push Docker Image
- Builds a Docker image using the repository's `Dockerfile`.
- Tags the image with a unique identifier (e.g., `glatest` and a timestamp).
- Pushes the image to Amazon ECR.

### 5. Update ECS Service
- Uses the AWS CLI to update the ECS service with the new image, forcing a new deployment.

---

## Environment Variables

The following environment variables are defined in the workflow:

| Variable             | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `AWS_REGION`         | The AWS region where your ECS cluster and ECR repository are located (e.g., `us-west-2`). |
| `ECR_REPOSITORY`     | The name of your Amazon ECR repository.                                    |
| `ECS_SERVICE`        | The name of your Amazon ECS service.                                       |
| `ECS_CLUSTER`        | The name of your Amazon ECS cluster.                                       |
| `ECS_TASK_DEFINITION`| The name of your ECS task definition.                                      |
| `CONTAINER_NAME`     | The name of the container in your ECS task definition.                    |

---

## Prerequisites

### 1. AWS Setup
- Ensure you have an Amazon ECS cluster, service, and task definition configured.
- Create an Amazon ECR repository to store your Docker images.

### 2. GitHub Secrets
- Add the following secrets to your GitHub repository:
  - `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
  - `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.

### 3. Dockerfile
- Ensure your repository contains a valid `Dockerfile` for building the Docker image.

---

## Triggering the Workflow

The workflow is triggered automatically on a `push` event to the `main` or `dev` branches. You can also trigger it manually if needed.

---

## Example Workflow File

Here’s a snippet of the workflow file:

```yaml
name: Deploy to Amazon ECS

on:
  push:
    branches:
      - "main"
      - "dev"

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build, tag, and push image to Amazon ECR
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:latest .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest

      - name: Update ECS Service
        run: |
          aws ecs update-service --cluster ${{ env.ECS_CLUSTER }} --service ${{ env.ECS_SERVICE }} --force-new-deployment
```

---

## Notes

- Ensure your IAM user or role has the necessary permissions for ECS and ECR operations.
- Modify the workflow file to suit your specific deployment requirements.
