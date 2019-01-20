# dotnet
Source for https://mikeder.net

Static site to be built with Hugo, service on AWS S3 via CloudFront.
Links to images/music via separate cache origin behaviors.

Builder TODO:

  * Docker builder image (hugo + plugins?)

Content TODO:

  * Hugo Theme
  * Archive oldindex.md
  * Image pages
  * Music pages
  * Code/Projects pages
  * Resume rejiggerin' (certs section?)

CloudFormation TODO:

  * CloudFront Distro
  * S3 Bucket
  * Route53 records
  * API Gateway for webhook trigger
  * CodeBuild
