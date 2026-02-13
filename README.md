# AWS Cost Tracker Dashboard

A serverless AWS cost monitoring tool that converts raw AWS billing data into a clear, categorized, and easy-to-read dashboard.

## 🌐 Live Site

https://cost.khalidhashim.com

## Overview

This project uses AWS Lambda and the AWS Cost Explorer API to automatically retrieve, process, and categorize AWS cost data. The processed data is then published as structured JSON to an S3 bucket configured for static hosting and served via a custom subdomain.

The goal of this project is to simplify complex AWS billing data into meaningful business categories such as Compute, Database, Storage, Network, and Support.

## Architecture

- AWS Lambda – Fetches and processes cost data
- AWS Cost Explorer API – Provides daily unblended cost metrics
- EventBridge (CloudWatch Events) – Schedules Lambda to run automatically every day
- Amazon S3 (Static Hosting) – Stores and serves dashboard data
- Custom Domain/Subdomain – Public dashboard endpoint

## How It Works

1. Lambda retrieves the last 14 days of cost data.
2. Costs are grouped by AWS service.
3. Services are mapped into simplified categories.
4. Daily totals and category breakdowns are calculated.
5. A structured JSON file is generated.
6. The JSON file is uploaded to S3 for dashboard visualization.
7. EventBridge triggers the Lambda function automatically on a weekly schedule.

## Key Features

- Fully serverless architecture
- Automated weekly cost aggregation via EventBridge
- Custom service-to-category mapping
- Near real-time dashboard updates
- Public access via custom domain
- No servers to manage

## Technologies Used

- Python (boto3)
- AWS Lambda
- AWS Cost Explorer API
- EventBridge (CloudWatch Events)
- Amazon S3
- IAM Roles & Policies

---

This project demonstrates practical experience with AWS serverless architecture, cost visibility optimization, IAM configuration, EventBridge scheduling, and cloud-native data processing.
