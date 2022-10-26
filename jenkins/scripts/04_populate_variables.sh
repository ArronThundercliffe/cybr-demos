#!/bin/bash
#==========
SAFE_PATH=jenkins/projects/safe/project
VARIABLE_NAME=secret
JENKINS_URL=http://ec2-35-178-244-130.eu-west-2.compute.amazonaws.com:8080

#==========

# Checking if a user is logged-in to Conjur-CLI
conjur whoami

# Populate safe secrets with values
for i in {1..3}
do
    for k in {1..3}
    do
        if command -p md5sum  >/dev/null 2>&1
        then
            conjur variable set -i "$SAFE_PATH$i/$VARIABLE_NAME$k" -v "$(echo $RANDOM | md5sum | head -c 20; echo;)"
        else
            conjur variable set -i "$SAFE_PATH$i/$VARIABLE_NAME$k" -v "$(echo $RANDOM | md5 | head -c 20; echo;)"
        fi
    done
done

# Populate authenticator values
conjur variable set -i conjur/authn-jwt/jenkins1/identity-path -v "/jenkins/projects"
conjur variable set -i conjur/authn-jwt/jenkins1/issuer -v "$JENKINS_URL"
conjur variable set -i conjur/authn-jwt/jenkins1/token-app-property -v "conjur_host"
conjur variable set -i conjur/authn-jwt/jenkins1/jwks-uri -v "$JENKINS_URL/jwtauth/conjur-jwk-set"
conjur variable set -i conjur/authn-jwt/jenkins1/audience -v "conjur-jenkins-demo1"