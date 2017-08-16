#!/usr/bin/env sh

### begin login
loginCmd='az login -u "$loginId" -p "$loginSecret"'

# handle opts
if [ "$loginTenantId" != " " ]; then
    loginCmd=$(printf "%s --tenant %s" "$loginCmd" "$loginTenantId")
fi

case "$loginType" in
    "user")
        echo "logging in as user"
        ;;
    "sp")
        echo "logging in as service principal"
        loginCmd=$(printf "%s --service-principal" "$loginCmd")
        ;;
esac
eval "$loginCmd" >/dev/null

echo "setting default subscription"
az account set --subscription "$subscriptionId"
### end login

createCmd='az webapp deployment slot create'
createCmd=$(printf "%s --name %s" "$createCmd" "$name")
createCmd=$(printf "%s --resource-group %s" "$createCmd" "$resourceGroup")
createCmd=$(printf "%s --slot %s" "$createCmd" "$slot" )

# handle opts
if [ "$configurationSource" != " " ]; then
createCmd=$(printf "%s --configuration-source %s" "$createCmd" "$configurationSource")
fi

echo "creating webapp deployment slot"
eval "$createCmd"