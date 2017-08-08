# Guidelines

These Packer templates are used to generate AWS AMIs required by the Terraform templates under the [Terraform Repository](https://github.com/CloudPartners/terraform).

> With AMIs being scoped to an AWS region, the AMIs will need to be created in the same region targeted by the Terraform templates.

Core packer templates:

- TeamCity Server Node image : teamcity-server
- ...

## AWS Credentials

Standard approach is to provide your AWS ACCESS_KEY / SECRET_KEY pair, either via the *.vars.json file (don't commit with your credentials...), via direct variable declaration, or via standard AWS environment variables.

## Variables

Each of the templates requires valid region / vpc-id / subnet-id values.  Update each *.vars.json file to reflect current resources, or provide explicit variables when running the packer command.

## Execution

> The following snippets assume you have `packer` installed on your PATH.

```powershell
cd teamcity-server

# if using the vars.json file
packer build -var-file=teamcity-server.vars.json teamcity-server.json

# if not using the vars.json file, provide all vars explicitly
packer build -var "access_key=***" -var "secret_key=***" -var "region=***" -var "vpc_id=***" -var "subnet_id=***" teamcity-server.json
```
