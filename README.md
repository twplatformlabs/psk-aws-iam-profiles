<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/psk_banner.png" width=800 />
	</p>
	<h2>psk-aws-iam-profiles</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/psk-aws-iam-profiles"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
</div>

This pipeline manages:  

**Product cloud infrastructure pipeline service accounts**  
Two service accounts are defined for use in the Engineering Platform product infrastructure pipelines. The service accounts do not have any permission assigned directly but are instead added to either the non-production or the production Group, respectively. The groups have policies attached that enable assumption of any role in the PSKRoles path, in the appropriate account types. The nonprod SA can assume roles in Non-production accounts. The prod SA can assume roles in both nonprod and production accounts.

The service accounts are defined in `main.tf`  

```mermaid
---
title: State Account isolation for SA pattern
---
flowchart LR
    NPSA --> ARSB --- ARDEV --- ARNP
    PSA --> ARSB --- ARDEV --- ARNP --- ARP

    subgraph State Account
        ARSB@{ shape: braces, label: "Assume PSKRoles/*" }
        subgraph Resource: IAM Service Account
            NPSA[Nonprod Service Account]
            PSA[Prod Service Account]
        end
    end

    subgraph Platform Dev Account
        ARDEV@{ shape: braces, label: "Assume PSKRoles/*" }
    end
    subgraph Nonproduction
        ARNP@{ shape: braces, label: "Assume PSKRoles/*" }
    end
    subgraph Production
        ARP@{ shape: braces, label: "Assume PSKRoles/*" }
    end

    linkStyle 0 stroke:#30BF00,stroke-width:3px
    linkStyle 1 stroke:#30BF00,stroke-width:3px
    linkStyle 2 stroke:#30BF00,stroke-width:3px


    linkStyle 3 stroke:#30BFFF,stroke-width:3px
    linkStyle 4 stroke:#30BFFF,stroke-width:3px
    linkStyle 5 stroke:#30BFFF,stroke-width:3px
    linkStyle 6 stroke:#30BFFF,stroke-width:3px
```  

**Pipeline Roles (permissions)**  

Each Platform product infrastructure pipeline uses a specific role with the permissions required for the responsibilities of the pipeline. Pipelines orchestrate CI and CD, which can include all accounts used by the platform. Hence, the PSKRoles are an identical set of roles in each account. The SA group configuration is used to define in which accounts a particular SA can assume roles.  

As a convention, a role is named the same, or very similar, to the pipeline that uses it.  
```mermaid
---
title: Typical product pipeline roles
---
flowchart LR

    A@{ shape: processes, label: "PSKIamProfilesRole
                                  PSKPlatformHostedZonesRole
                                  PSKPlatformVPCRole
                                  PSKControlPlaneBaseRole
                                  ..." }
```

**Release**  
```mermaid
---
title: Release pipeline
---
flowchart LR

    GITPUSH --> RS & SA
    GITTAG --> RDEV --> RNP --> RP

    GITPUSH@{ shape: brace-r, label: "$ git push" }
    GITTAG@{ shape: brace-r, label: "$ git tag _1.3.3_" }

    subgraph Acct: Platform Development
        RDEV@{ shape: processes, label: "PSKRoles/*" }
    end
    subgraph Acct: Nonproduction
        RNP@{ shape: processes, label: "PSKRoles/*" }
    end
    subgraph Acct: Production
        RP@{ shape: processes, label: "PSKRoles/*" }
    end
    subgraph Acct: State
        RS@{ shape: processes, label: "PSKRoles/*" }
        SA[Service Accounts]
    end
```

### about access permissions  

In general, it is only the Engineering Platform product development team(s) that will have direct access to the cloud (AWS) accounts (as in directly assuming IAM roles). Customers of the platform will not have AWS IAM identities but rather will have access defined and maintained as part of the overall product capabilities through an external idp.  

Even though EP product team members have direct access, apart from the Development account you should not expect to see actual human write-access taking place. All change is brought about through the software-defined process and via a service account persona.  

As you can see from the above diagram, account level roles are ubiquitous. Each account used by the product has the same set of roles defined. A service account's group membership then determines which accounts the svc identity may assume any role.  

### scanning examples

This pipeline workflow includes three code scans that demonstrate two kinds of static-code inspections. TFlint performs the 'lint' style checks on terraform files for code syntax, style, and convention oriented checks. Trivy and Checkov are both used to perform security and other best-practice style scans of the code. Trivy and Checkov are not identical in their functionality, but as you might expect there is considerable overlap. Generally, teams decide on a single tool that covers the scope of things they determine of needed. Not all of the PSK exmaples will have muiltiple examples of the same type of scan using different tools but some may.  

See [maintainer notes](doc/maintainer_notes.md) for detailed information.  
