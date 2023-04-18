import boto3
import sys
import json

if len(sys.argv) < 2 or len(sys.argv) > 3:
  print("Usage: rotate PATH [filename]")
  exit(1)

user_path = f"/{sys.argv[1]}/"
credential_file = "credentials" if len(sys.argv) == 2 else sys.argv[2]
print(f"Rotate all IAM User access credentials on path :user{user_path}\n")

iam = boto3.client('iam')

svc_accounts = iam.list_users(
    PathPrefix=user_path,
    MaxItems=100
)

if len(svc_accounts['Users']):
    new_credentials = {}

    for user in svc_accounts['Users']:
        print(f"Rotate: {user['UserName']}")
        access_keys = iam.list_access_keys(UserName=user['UserName'])["AccessKeyMetadata"]

        # delete the oldest key (if there is more than one; currently IAM Users are permitted only 2 keys)
        if len(access_keys) > 1:
            # sort by creation date to find oldest key (by convention, service accounts always use the newest key)
            access_keys.sort(key=lambda x: x["CreateDate"])

            print(f"Delete out of date key: **********{access_keys[0]['AccessKeyId'][-5:]}")
            response = iam.delete_access_key(
                UserName=user['UserName'],
                AccessKeyId=access_keys[0]['AccessKeyId']
            )

        else:
          print(f"Skipping: {user['UserName']} has only one key")

        # generate new key, add details to list of new keys
        new_access_key = iam.create_access_key(UserName=user['UserName'])
        print(f"New access key created: **********{new_access_key['AccessKey']['AccessKeyId'][-5:]}\n")
        new_credentials[user['UserName']] = {}
        new_credentials[user['UserName']]['AccessKeyId'] = new_access_key['AccessKey']['AccessKeyId']
        new_credentials[user['UserName']]['SecretAccessKey'] = new_access_key['AccessKey']['SecretAccessKey']

    # write new_credentials to local file, to be processed into your secrets store
    print(json.dumps(new_credentials, indent = 2))
    with open(credential_file, "w") as outfile:
      json.dump(new_credentials, outfile)

else:
    print("No PSK service accounts found!")
