# Task 1 — Multi-Instance EC2 Provisioning

## Design

- The code uses the Terraform local modules to provision the infra for ec2 instances, IAM roles, and security groups. Modules are maintained under `00-modules` folder.
- All the resources which are getting created as part all the local modules are getting tagged with `Name` by default.
- All 5 instances are driven by a single map variable, `var.ec2_instances`, and created with one
  `module "ec2_instance"` block using `for_each` (no per-instance hardcoded blocks).
- DB instance `db-01` is using `io2` root volume. Databases perform thousands of concurrent random read/write disk transactions (OLTP). Standard gp3 storage can suffer from latency spikes when hitting IOPS/throughput ceilings. `io1` and `io2` provide guaranteed, provisioned storage performance up to thousands of IOPS per GB with sub-millisecond latencies.
- Every instance is tagged with `Name`, `Environment`, and `Owner`. `Name` is part of module itself and the other two are added as common tags in locals block.
- Outputs: `name_id_map` (name → ID) and `name_private_ip_map` (name → private IP).
- Key pairs are getting generted per ec2 as part of the Terraform Module itself.

## Protected instance: `db-01`

The `db-01` instance has `lifecycle { prevent_destroy = true }`.

**Why `db`:** It is the only stateful host in the set. It sits on the highest-durability,
expensive volume (io2, 99.999% durability, provisioned IOPS), and its data cannot be rebuilt from
code. The `web`, and `app` instances are stateless or rebuildable, so recreating
them is safe.

**How it is implemented:** Terraform requires `prevent_destroy` to be a literal and does not allow
it to depend on a variable. Because of that, the shared `ec2-instance` module exposes a
`prevent_destroy` input that switches between two otherwise identical resources:
`aws_instance.instance` (unprotected) and `aws_instance.protected` (with `prevent_destroy = true`).
The `db` instance also gets `disable_api_termination` (EC2 termination protection), which guards
against deletion from outside Terraform (console/CLI) as well.

To intentionally remove `db`, set `prevent_destroy = false` on its entry and either add a `moved` block here from `module.ec2_instance["db_01"].aws_instance.protected[0]` to
`module.ec2_instance["db_01"].aws_instance.instance[0]` or use `terraform state mv` command to move an item from old name to new name. Otherwise Terraform plans a replace.
