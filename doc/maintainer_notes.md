<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/twplatformlabs/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-iam-profiles</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/lab-iam-profiles"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

## maintainers notes

**conventions**  

_User, Role, and Policy paths_  

All users, roles, and policies are placed on a matching /PSK*/ path. This is a good practice as there will typically also be org-level roles and policies maintained and the separation adds clarity.  

In addition, the iam-credential-rotation tool expects to rotate credentials for all IAM Users on a path so that you do not need to direcetly manage which Users to rotate. In this case, all Users on the `/PSKServiceAccounts/`  path will be rotated with each deployment and during the weekly recurring integration test run.  

_Roles_  

The roles are each defined in a separate terraform file, named to an abbreviation of the github repository of the pipeline that uses the role, follow a camel case naming convention, prefixed with `PSK` and ending in `Role`.  

Ex: the role for the psk-aws-iam-profiles pipeline is named `PSKIamProfilesRole`.

In a typical, greenfield product release roadmap you should expect to see the number of defined roles increase as each successive dependent domain pipeline is created.  

**bootstrap**  

In the PSK example platform, this is the first cloud resource pipeline defined. So we a chicken-or-the-egg, bootstrapping problem. E.g., the pipeline expects to run with a service account identity and matching pipeline role that can be assumed that will provide the IAM permissions necessary to configure and maintain the standard pipeline roles across all of the platforms cloud accounts. But the PSKNonprodServiceAccount and PSKIamProfilesRole don't exist yet. The pipeline is itself attempting to create those things.  

In it's current state, the repository contains all the roles for all the cloud infrastructure pipelines in the PSK example platform. But in a real world build situation, you would be starting out defining just the iam-profiles role (with each successive role being added for the subsequent, successive pipeline as you commence creating it).  

So we first need to _bootstrap_ the iam-profiles role before the actual iam-profiles pipeline can work. This means that you must apply the terraform configuration to each account using your personal account identity. This results in the needed service account creation and the creation of the necessary role across all the product accounts, as well as the access/audit logs correctly indicating who and when this initial configuration took place.  

This is a one-time behavior. Once the initial service accounts and role are created, the iam-profiles pipeline can now be configured to use that information so that it maintains itself (so to speak) as well as all future service accounts or roles.  

We did have to _bootstrap_, but we did so in a manner that does leave any desired state information out of the software-defined automation.  

### architecture  

_main.tf_  

This configuration is only applied in the `state` account and creates the service accounts (machine users) and service account groups.  

_Roles_.tf  

A unique role is created for each cloud infrastructure pipeline, providing the specific permissions necessary for whatever the pipeline is building.  

When a service account is given assume-role permissions for an account, this means the service account will be able to assume all roles placed within the `/PSKRoles/` IAM Role path.  

When creating a new role, first create the related integration test and confirm it is successfully "failing", then create the actual role. E.g., test-driven development.

_terraform modules_  

Uses the following AWS official terraform modules: (check for updates)  

terraform-aws-modules/iam/aws//modules/iam-user  
terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy  
terraform-aws-modules/iam/aws//modules/iam-assumable-role  

_integration tests_  

The post-run integration tests are limited to testing for the existence of the named role, and that the role has the correct named policy attached. We do not check the details of the individual policy statements. This is because such a test would involve duplicating a long list of permission settings and then comparing that against the exact same list in the actual declarative policy file. It is the terraform api that is actually making the configuration change so if is succeeds at all that means it has successfully applied what is defined in the policy file. Therefore checking a list of permissions we write ourselves in one file against another list of the same permission we separately type into another file is actually more likely to result in multiple false-postives (double the opportuntity for typos) then simply using the role in the dependent pipeline and adjusting for failures from there. And on a practical level, to be useful such detailed testing would need to reflect exactly the requirements of the pipeline that uses the role. As this is a one-to-one relationship, it is actually just adding time and complexity to duplicate the requirements of each pipeline into such local tests.  

_credential rotation_  

Presently, a scheduled pipeline is configured to run once per week. This pipeline will perform a two-key rotation pattern and then run the integration tests. The effect of which is that PSK infrastructure service account credentials are fully rotated every two weeks.  

### local engineering practice additions or notes (See lab-documentation for standard practices and ADRs)  

1. As this is the initial pipeline in the PSK example platform, note the particular DRY pattern used with the terraform code. There is no duplication of code. Each environmental deployment has its' own variable settings file, but that is all. This practice is by far the most sustainable across both evolution and scale, as well as having the correct constraining effect on complexity.

2. Note. Terraform is not used to create the service account progammatic credentials. A separate cli uses a two-key pattern to generate new keys. The pipeline maintains the current key in the secrets store (1password). If terraform is used, be sure to encrypt using gpg keys.

3. specific .gitignore entries

* Ignore all extensions of .auto.tfvars.json. The version of the tfvars file used by the pipeline is generated by the pipeline from the environments/*.tpl files. The runtime file names are ignored so that any local testing doesn't accidently cause problems to the pipeline.  
* Local python and ruby environment config is ignored.
* credential information generated at runtime but not maintained is ignored to prevent local development from accidently pushing secrets into the repo.

4. requirements-dev.txt used only for pre-commit local commit hook management

5. Pre-commit checks. In addition to typical linting and style checks, several terraform code checks are run. This aligns with static checks performed in the pipeline.

* terraform fmt
* terraform validate
* [tflint](https://github.com/terraform-linters/tflint)
* [checkov](https://github.com/bridgecrewio/checkov)

6. Note. There are both nonprod and prod environment credential files (op.nonprod.env, op.prod.env). In this case, it is actually only the pipeline AWS service account credentials that change in production. As there are relatively few secrets needed by the pipeline, there is simply duplicate info in the files. Where you have extensive values, refactor the pipeline to load both default and environment specific files to reduce the duplication and potential for typos.

### Tools used in this repo or by the pipeline

* [pre-commit](https://pre-commit.com)
* Common [pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks)
* [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)
* [awslabs/git-secrets](https://github.com/awslabs/git-secrets)
* Circleci Executor: [twdps/circleci-infra-aws](https://github.com/twplatformlabs/circleci-infra-aws)
* [Terraform Cloud](https://app.terraform.io/) for backend state
* [1password](https://1password.com) for secrets
* [awspec(https://github.com/k1LoW/awspec)]
* [iam-credential-rotation](https://github.com/twplatformlabs/iam-credential-rotation)
* [orbs](https://circleci.com/developer/orbs): twdps/terraform, twdps/onepassword, twdps/pipeline-events
* [tflint](https://github.com/terraform-linters/tflint)
* [trivy](https://github.com/aquasecurity/trivy)
* [checkov](https://github.com/bridgecrewio/checkov)
