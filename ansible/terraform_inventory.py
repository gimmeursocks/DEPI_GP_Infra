#!/usr/bin/env python3
import json
import subprocess
import sys

def get_terraform_output():
    result = subprocess.run(
        ["terraform", "output", "-json"],
        capture_output=True,
        check=True,
        text=True
    )
    return json.loads(result.stdout)

def main():
    if len(sys.argv) == 2 and sys.argv[1] == "--list":
        tf_output = get_terraform_output()

        master_public = tf_output["jenkins_master_public_dns"]["value"]
        agent_public = tf_output["jenkins_agent_public_dns"]["value"]
        master_private = tf_output["jenkins_master_private_ip"]["value"]
        secret = "test"

        inventory = {
            "jenkins_master": {
                "hosts": [f"ec2-user@{master_public}"],
                "vars": {
                    "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
                }
            },
            "jenkins_agents": {
                "hosts": [f"ec2-user@{agent_public}"],
                "vars": {
                    "jenkins_master_private_ip": master_private,
                    "jenkins_secret": secret,
                    "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
                }
            },
            "_meta": {
                "hostvars": {
                    f"ec2-user@{master_public}": {
                        "ansible_python_interpreter": "/usr/local/bin/python3.8"
                    },
                    f"ec2-user@{agent_public}": {
                        "ansible_python_interpreter": "/usr/local/bin/python3.8"
                    }
                }
            }
        }

        print(json.dumps(inventory, indent=2))

    elif len(sys.argv) == 3 and sys.argv[1] == "--host":
        # Not needed because we're using _meta to pre-load hostvars
        print(json.dumps({}))
    else:
        print("Usage: terraform_inventory.py --list", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
