#!/bin/bash -e

# the registry should have been created already
# you could just paste a given url from AWS but I'm
# parameterising it to make it more obvious how its constructed
REGISTRY_URL=${AWS_ACCOUNT_ID}.dkr.ecr.${EB_REGION}.amazonaws.com
# this is most likely namespaced repo name like myorg/veryimportantimage
SOURCE_IMAGE="${DOCKER_REPO}"
# using it as there will be 2 versions published
TARGET_IMAGE="${REGISTRY_URL}/${DOCKER_REPO}"
# lets make sure we always have access to latest image
TARGET_IMAGE_LATEST="${TARGET_IMAGE}:latest"
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
# using datetime as part of a version for versioned image
VERSION="${TIMESTAMP}-${TRAVIS_COMMIT}"
# using specific version as well
# it is useful if you want to reference this particular version
# in additional commands like deployment of new Elasticbeanstalk version
TARGET_IMAGE_VERSIONED="${TARGET_IMAGE}:${VERSION}"
# making sure correct region is set
aws configure set default.region ${EB_REGION} --profile "administrator"
# Push image to ECR
###################

# I'm speculating it obtains temporary access token
# it expects aws access key and secret set
# in environmental vars
$(aws --profile administrator ecr get-login --region eu-central-1 --no-include-email)

# update latest version
docker tag continuous-report-delivery-rocker:latest 125849576382.dkr.ecr.eu-central-1.amazonaws.com/continuous-report-delivery-rocker:latest

docker push 125849576382.dkr.ecr.eu-central-1.amazonaws.com/continuous-report-delivery-rocker:latest
