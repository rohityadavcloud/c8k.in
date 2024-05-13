# [c8k.in](https://github.com/cloudstack/c8k.in)

> [!NOTE]
> Only supports CloudStack on Ubuntu with x86_64 KVM and tested with Ubuntu 22.04 LTS (x86_64)

One-liner installer for [Apache CloudStack](https://cloudstack.apache.org), just copy and run the following as `root` user:

```bash
curl -sL https://c8k.in/stall.sh | bash
```

> [!IMPORTANT]
> This deploys an all-in-a-box CloudStack installation that has the CloudStack management & usage server, CloudStack agent, MySQL DB, NFS and KVM on a single Linux host and is only useful for anyone who just wants to try CloudStack on a host or a VM, but does not want to [read the official docs](https://docs.cloudstack.apache.org). It makes several assumptions about the IaaS deployment, and tries to figure out host's network setup so the deployment could work out of the box. This is not advised for production deployment.

Screenshot after running the command:

![](snap1.png)

Screenshot when the command finishes:

![](snap2.png)

Created by [@rohityadavcloud](https://github.com/rohityadavcloud) as part of a hackathon.

[Discuss further here](https://github.com/apache/cloudstack/discussions)

Source: [https://github.com/cloudstack/c8k.in](https://github.com/cloudstack/c8k.in)
