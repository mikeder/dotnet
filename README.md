# dotnet  ![Build Status](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiWGN6WTY0OStTUUtMcnZHWncyTkVDNWgxdEtqaWhFeWl5bEF6Sml0cmV4L0wrUFM3RXJCWTVhSDYzTHdqcStYSVNPZzlWTU80ZnZDbGRHaHBibUxNWWcwPSIsIml2UGFyYW1ldGVyU3BlYyI6IlNZRHRmcHpXcmlGZ1NyWVciLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master) 

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
