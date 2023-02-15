<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-iam-profiles</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/lab-iam-profiles"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>


Repo Documentation

diagram of the service account configuration and relationship to roles

main.tf - this is where we create the nonprod and prod service account, the groups which the svc accounts will be added, and the
role assumption permissions. in general, a production service account can assume roles in any account, whereas the nonproduction
service account is limited to only accounts without customer workloads.


things we do and why

1. .gitignore - stop all .terraform* files from being tracked

backend using terrafrom cloud. if not you must bootstrap in your cloud vendor space, "concerns"

2. pre-commit
check the common file-types in the repo for syntax
check for aws creentials
terraform
- all the things

3. permission boundary

4. SBOM


**considerations for terraform backend state**
1. Bootstrap issues if you aren't using SaaS




-replace="module.PSKNonprodServiceAccount.aws_iam_access_key.this[0]" -replace="module.PSKProdServiceAccount.aws_iam_access_key.this[0]"
