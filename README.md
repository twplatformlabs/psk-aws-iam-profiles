<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-iam-profiles</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-aws-iam-profiles"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

This pipeline manages:  

**Product cloud infrastructure provider service accounts**  
Two service accounts (machine users) are defined for use in the Engineering Platform teams AWS infratructure pipelines. The service accounts do not have any permission assigned directly but are instead added to either the non-production or the production Group as appropriate. The groups have policies attached that enable assumption of any PSKRoles in the related product accounts.  

main.tf  

<div align="center">
	<img alt="architecture1.png" src="https://github.com/ThoughtWorks-DPS/psk-aws-iam-profiles/raw/main/doc/architecture1.png" width=800 />
</div>

The diagram represents the typical configuration for an initial engineering platform on AWS. The PSK code will be limited to a two-account configuration for budgetary reasons.  

**Pipeline Roles (permissions)**  

Each pipeline role has a matching, named role file.  

<div align="center">
	<img alt="architecture2.png" src="https://github.com/ThoughtWorks-DPS/psk-aws-iam-profiles/raw/main/doc/architecture2.png" width=800 />
</div>

### about access permissions  

In general, it is only the Engineering Platform product development team(s) that will have direct access to the cloud (AWS) accounts (as in directly assuming IAM roles). Customers of the platform will not have AWS IAM identities but rather will have access defined and maintained as part of the overall product capabilities through an external idp.  

Even though EP product team members have direct access, apart from the Development account you should not expect to see actual human write-access taking place. All change is brought about through the software-defined process and via a service account persona.  

As you can see from the above diagram, account level roles are ubiquitous. Each account used by the product has the same set of roles defined. A service account's group membership then determines which accounts the svc identity may assume any role.  

### scanning examples

This pipeline workflow includes three code scans that demonstrate two kinds of static-code inspections. TFlint performs the 'lint' style checks on terraform files for code syntax, style, and convention oriented checks. Trivy and Checkov are both used to perform security and other best-practice style scans of the code. Trivy and Checkov are not identical in their functionality, but as you might expect there is considerable overlap. Generally, teams decide on a single tool that covers the scope of things they determine of needed. Not all of the PSK exmaples will have muiltiple examples of the same type of scan using different tools but some may.  

See [maintainer notes](doc/maintainer_notes.md) for detailed information.  
