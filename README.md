# RG Supervision agent installer

This software made by RG System deploys a supervision agent which includes features for:
- Remote Monitoring and Management
- Remote desktop access (Assist)
- Backup (Files and Data, Microsoft 365)
- Security (BitDefender integration)
- ...and many other (automation, scripting, reports)

## Requirements
All agent features and monitored data will be available within the RG System dashboard (or through authenticated API).

A user account will be required prior deploying, in order to authenticate with your **deployment token**. 
This token can be generated from the user profile page within dashboard (parameters tab).

Don't have any account ? Visit https://www.rgsystem.com for more information.

## Package parameters
The following package parameters must be set:
* `/Token:` (string) User deployment token used for authentication while registering agent (required)
* `/Node:`  (integer) Node ID where agent will be located within dashboard (optional, default to user's root node)
* `/ExpectedHostName:`  (string) Only for advanced users: Custom host name used for registration (optional, bad usage may prevent proper installation)

To pass parameters, use `--params "''"` within install command.  
Example: `choco install rgsupervision [other options] --params "'/Token:mytokenvalue /Node:12345'"`
 
## Package update
This installer deploys the latest RG Supervision release for Windows operating systems. 
Following updates will be automatically handled by agent self update feature. Hence, no Chocolatey update action is required.

## Current version
Binary included in the current package corresponds to version 2.3.5062.0.  
If a newer version has been released since, it will be automatically updated a few moments after installation.  