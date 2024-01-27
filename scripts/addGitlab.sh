#/bin/bash

# This script will add a .gitlab-ci.yml file to all microservices
# in the spring-petclinic-* directory

CI_TEMPLATE=".gitlab-ci.yml.template"
MAIN_GITLAB_CI="../.gitlab-ci.yml"

for microservice_dir in ../spring-petclinic-*; do
    echo $microservice_dir
    if [ -d "$microservice_dir" ]; then
        echo "Adding .gitlab-ci.yml to $microservice_dir"
        cp $CI_TEMPLATE $microservice_dir/.gitlab-ci.yml
        MICROSERVICE_NAME=$(basename $microservice_dir)
        echo "Replacing {{MICROSERVICE_NAME}} with $MICROSERVICE_NAME"
        sed -i "s/{{MICROSERVICE_NAME}}/$MICROSERVICE_NAME/g" $microservice_dir/.gitlab-ci.yml
        if ! grep -q "^\s*- local: $MICROSERVICE_NAME/.gitlab-ci.yml" $MAIN_GITLAB_CI; then
            sed -i '/^include:/a \ \ - local: '"$MICROSERVICE_NAME/.gitlab-ci.yml" $MAIN_GITLAB_CI
        else
            echo "Already added $MICROSERVICE_NAME to $MAIN_GITLAB_CI"
        fi
    fi
done
