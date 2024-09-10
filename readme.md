# Step functions labs


!!!!! WIP !!!!!!!


This is a working in progress project for explore aws step functions features.


 - inside `terraform` folder there are IAC code to generate resources in your aws account.

 - inside `projects` folders there are projects examples that generates containers images, useful for ecs tasks.
    - `simple-python-worker` is a python project that consumes messages from a SQS queue.


## Notes for developers


This example use a ECR repository to store `projects` images.
First of all you need to build the images and store them in ECR.
You can use the `build.sh` script to this.
Pay attention to option `docker buildx build --platform=linux/amd64`, this asserts that even you are running the build in a not amd64 (eg macbook with M1/M2) platform the result image is linux/amd64 compatible.


Before running terraform commands you need to create a `terrform.tfvars` inside terraform folder to configure variables:

```
subnet_ids = [
  "your_subnet_id_1",
  "your_subnet_id_2"
]
security_group_ids = ["your_security_group_id"]
```

When selection subnet please pay attention to connection rules between ECR and ECS , if you are using public subnets make sure that you enable the option auto-assign public IP in ecs service.
More info: 
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/verify-connectivity.html
- https://stackoverflow.com/questions/61265108/aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry


