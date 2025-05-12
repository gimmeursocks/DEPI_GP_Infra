#!/usr/bin/env python3
import json
import subprocess

def get_terraform_output():
    result = subprocess.run(['terraform', 'output', '-json'], stdout=subprocess.PIPE, check=True)
    return json.loads(result.stdout)

def main():
    tf_output = get_terraform_output()
    inventory = {
        "jenkins_master": {
            "hosts": [tf_output["jenkins_master_public_dns"]["value"]],
            "vars": {
                "ansible_user": "ec2-user",
                "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
            }
        },
        "jenkins_agents": {
            "hosts":  [tf_output["jenkins_agent_public_dns"]["value"]],
            "vars": {
                "ansible_user": "ec2-user",
                "ansible_ssh_common_args": "-o StrictHostKeyChecking=no",
                "jenkins_master_private_ip": tf_output["jenkins_master_private_ip"]["value"],
                "jenkins_secret": "0ddf4d399f6ee20742f8078047163964488df1fc7bbddbd736f1c1031c44747c",
                "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
            }
        },
        "_meta": {
            "hostvars": {
                f"ec2-user@{tf_output["jenkins_master_public_dns"]["value"]}": {
                    "ansible_python_interpreter": "/usr/local/bin/python3.8"
                },
                f"ec2-user@{tf_output["jenkins_agent_public_dns"]["value"]}": {
                    "ansible_python_interpreter": "/usr/local/bin/python3.8"
                }
            }
        }
    }
    print(json.dumps(inventory))

if __name__ == "__main__":
    main()
