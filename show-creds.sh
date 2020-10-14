export USER_OCID=$(oci iam user list --all | jq -r '.data |sort_by(."time-created")| .[0]."id"')
# Generate private key
mkdir ~/oci-keys
openssl genrsa -out ~/oci-keys/oci_api_key.pem 2048
# generate public key
openssl rsa -pubout -in ~/oci-keys/oci_api_key.pem -out ~/oci-keys/oci_api_key_public.pem
# upload public key
oci iam user api-key upload --user-id $USER_OCID --key-file ~/oci-keys/oci_api_key_public.pem

# Get important login values
export KEY_FINGERPRINT=$(oci iam user api-key list --user-id $USER_OCID | jq -r '.data |sort_by(."time-created")| .[-1]."fingerprint"')
export TENANCY_OCID=$(oci iam user list --all | jq -r '.data[0]."compartment-id"')
export REGION=$(oci iam region-subscription list | jq -r '.data[0]."region-name"')
export REGION_KEY=$(oci iam region-subscription list | jq -r '.data[0]."region-key"')
reset && echo -e "# Copy and paste the following into the Katacoda terminal:\n# Echo the login details into the correct file path in Katacoda
echo \"[DEFAULT]\nuser=$USER_OCID\nfingerprint=$KEY_FINGERPRINT\ntenancy=$TENANCY_OCID\nregion=$REGION\nkey_file=~/.oci/oci_api_key.pem\" >  ~/.oci/config\n
# Echo the private key into the correct file path in Katacoda. Keep this secret!\n
echo \"$(cat ~/oci-keys/oci_api_key.pem)\" > ~/.oci/oci_api_key.pem\n# copy from the top of this terminal to the line above"
