#!/usr/bin/env bash

. $DEPLOYMENT_CONF_DIR/settings.sh
test -x $DEPLOYMENT_CONF_DIR/awsCredentials.sh && . $DEPLOYMENT_CONF_DIR/awsCredentials.sh

if [ `echo $ENVIRONMENTS | grep $ENV | wc -l` -eq 0 ]; then
  echo "Wrong env value: $ENV. Allowed values: $ENVIRONMENTS"
  exit 1
fi

. $DEPLOYMENT_CONF_DIR/env_settings_$ENV.sh

# evalHook <stage> <hook_settings>
function evalHook {
    if [ -z "$2" -o "$2" = "custom" ]; then
        echo $DEPLOYMENT_CONF_DIR/hooks/$1.sh
    else
        echo $DEPLOYMENT_SCRIPTS_DIR/standardHooks/$1-$2.sh
    fi
}

evalVersionHook=$(evalHook "evalVersion" $HOOK_EVAL_VERSION)
. $evalVersionHook

