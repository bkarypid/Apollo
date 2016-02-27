# Variables

variable "region"                  { default = "LON" }
variable "instance_type"           { default = "general1-4" }
variable "image_id"                { default = "40155f16-21d4-4ac1-ad65-c409d94b8c7c" }
variable "key_pair"                { default = "apollo" }
variable "network_id"              { default = "11111111-1111-1111-1111-111111111111" }
variable "network_name"            { default = "PublicNet" }
variable "etcd_discovery_url_file" {}
variable "masters"                 { default = "3" }
variable "slaves"                  { default = "1" }
variable "etcd_discovery_ready"    { default = "" }

# Resources

resource "template_file" "slave_cloud_init" {
  template               = "${path.module}/slave-cloud-config.yml.tpl"
  vars {
    etcd_discovery_url   = "${file(var.etcd_discovery_url_file)}"
    etcd_discovery_ready = "${var.etcd_discovery_ready}"
    size                 = "${var.masters + var.slaves}"
  }
}

resource "openstack_compute_instance_v2" "mesos-slave" {
  region            = "${var.region}"
  name              = "apollo-mesos-slave-${count.index}"
  flavor_id         = "${var.instance_type}"
  image_id          = "${var.image_id}"
  count             = "${var.slaves}"
  key_pair          = "${var.key_pair}"
  network           =
    {
      uuid          = "${var.network_id}"
      name          = "${var.network_name}"
    }
  config_drive      = "true"
  user_data         = "${template_file.slave_cloud_init.rendered}"
}

# Outputs

output "slave_ips" {
  value = "${join(",", openstack_compute_instance_v2.mesos-slave.*.access_ip_v4)}"
}