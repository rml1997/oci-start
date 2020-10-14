# Get important login values
USERLIST=$(oci iam user list --all)
export USER_OCID=$(echo $USERLIST | jq -r '.data |sort_by(."time-created")| .[0]."id"')
export TENANCY_OCID=$(echo $USERLIST | jq -r '.data[0]."compartment-id"')
export REGION=$(oci iam region-subscription list | jq -r '.data[0]."region-name"')
if [ ! -f ~/oci-keys/oci_api_key.pem ]; then
# Generate private key
mkdir ~/oci-keys
openssl genrsa -out ~/oci-keys/oci_api_key.pem 2048
# generate public key
openssl rsa -pubout -in ~/oci-keys/oci_api_key.pem -out ~/oci-keys/oci_api_key_public.pem
# upload public key
oci iam user api-key upload --user-id $USER_OCID --key-file ~/oci-keys/oci_api_key_public.pem
fi
export KEY_FINGERPRINT=$(oci iam user api-key list --user-id $USER_OCID | jq -r '.data |sort_by(."time-created")| .[-1]."fingerprint"')
reset && echo -e "# Copy and paste the following into the Katacoda terminal:\n# Echo the login details into the correct file path in Katacoda\nmkdir ~/.oci\n
echo \"[DEFAULT]\nuser=$USER_OCID\nfingerprint=$KEY_FINGERPRINT\ntenancy=$TENANCY_OCID\nregion=$REGION\nkey_file=~/.oci/oci_api_key.pem\" >  ~/.oci/config\n
# Echo the private key into the correct file path in Katacoda. Keep this secret!\n
echo \"$(cat ~/oci-keys/oci_api_key.pem)\" > ~/.oci/oci_api_key.pem\n# copy from the top of this terminal to the line above"
