# Terraform Items
This is to build the basic infrastructure for the Tilt Platform.

## Overview
There are no folders in this repository. Everything is marked as production or staging as appropriate and other items are generally available. Ultimately this helps to ease the need to import various modules into the different Terraform main files. 

## Steps to run
Currently the TF State file is committed. This should be commited regularly after an update so that someone else can grab it.

_NOTE: This should be migrated somewhere like Terraform Cloud. This was avoided since it was not possible to link the repos as needed due to permissions_

Currently the way that you can run this is with a simple `terraform apply`, read the items that it wants to change to make sure it is correct. Then just type yes

Ultimately if things are moved to Terraform Cloud this can allow the ability to have more detailed logs as things happen. This also provides more information on PRs.

## Continued Improvements
- There should be the ability to have Staging and production use the same build process. This was causing a lot of 403s initially, but should be able to be resolved with some more work on the IAM Roles.
    - Ultimately this could help save some money
- With Notifications. I am normally not the biggest fan of mixing Terraform and CloudFormation. I see why it was done, but it could be helpful to convert to TF and keep things consistent.
- Variables used throughout make it a little more difficult at times. Would be good to generalize variables and create more specifics throughout as items are generated.