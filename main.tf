#Kubernetes Create Cluster
resource "mgc_kubernetes_cluster" "cluster" {
  provider             = mgc.cloud
  name                 = "cluster-teste-11-02-tf"
  description          = "Cluster criado terraform para análises"
  version              = "v1.30.2"
  enabled_server_group = false
  #allowed_cidrs        = null

}

#Kubernetes Create Node Pool
resource "mgc_kubernetes_nodepool" "nodepool_prod" {
  provider     = mgc.cloud
  depends_on   = [mgc_kubernetes_cluster.cluster]
  cluster_id   = mgc_kubernetes_cluster.cluster.id
  name         = "nodepool-prod-cluster"
  flavor_name  = "cloud-k8s.gp1.medium"
  replicas     = 3
  min_replicas = 3
  max_replicas = 5
  #recuperar o tfstate do cluster
  #terraform import mgc_kubernetes_cluster.cluster dd43ad60-bd48-4f58-bd2b-b8fa1141867b

}

#Buscar dados do cluster para gerar o kubeconfig
data "mgc_kubernetes_cluster_kubeconfig" "cluster" {
  depends_on = [mgc_kubernetes_cluster.cluster]
  provider   = mgc.cloud
  cluster_id = mgc_kubernetes_cluster.cluster.id
}

#Criar um local file do kubeconfig
resource "local_file" "kubeconfig" {
  depends_on = [data.mgc_kubernetes_cluster_kubeconfig.cluster]
  content    = data.mgc_kubernetes_cluster_kubeconfig.cluster.kubeconfig
  filename   = "${path.module}/configs/kubeconfig_tf.yaml"
}

#Create VM Ubuntu Instance
resource "mgc_virtual_machine_instances" "vm_ubuntu" {
  provider          = mgc.cloud
  name              = "vm-ticket-22944-tf"
  machine_type      = "BV1-1-10"
  image             = "cloud-ubuntu-24.04 LTS"
  ssh_key_name      = "key-diego-2025"
  availability_zone = "br-se1-a"
}

resource "mgc_virtual_machine_instances" "vm_ubuntu2" {
  provider          = mgc.cloud
  name              = "vm-ticket-22944-tf-b"
  machine_type      = "BV1-1-10"
  image             = "cloud-ubuntu-24.04 LTS"
  ssh_key_name      = "key-diego-2025"
  availability_zone = "br-se1-b"
}

#resource "mgc_object_storage_buckets" "bucket_escravo" {
resource "mgc_object_storage_buckets" "my-bucket" {
  provider          = mgc.cloud
  bucket            = "bucket-name"
  enable_versioning = true
  bucket_is_prefix  = true
}

resource "mgc_block_storage_volumes" "volume_vm_ubuntu" {
  provider = mgc.cloud
  name     = "volume_vm_ubuntu"
  size     = 50
  type     = "nvme"
}

resource "mgc_block_storage_volume_attachment" "attach_vm_ubuntu" {
  block_storage_id   = mgc_block_storage_volumes.volume_vm_ubuntu.id
  virtual_machine_id = mgc_virtual_machine_instances.vm_ubuntu.id
}

#Create VM Windows Instance
resource "mgc_virtual_machine_instances" "vm_windows" {
  provider     = mgc.cloud
  name         = "vm-diego-win-server-2022-bv816100-3"
  machine_type = "BV8-16-100"
  image        = "windows-server-2022"
}

#Create DBaaS-Instace
resource "mgc_dbaas_instances" "my_dbaas" {
  name                  = "test-instance"
  user                  = "dbadmin"
  password              = "examplepassword"
  engine_name           = "mysql"
  engine_version        = "8.0"
  instance_type         = "cloud-dbaas-gp1.small"
  volume_size           = 50
  backup_retention_days = 10
  backup_start_at       = "16:00:00"
}
# Create a snapshot for a DBaaS instance
resource "mgc_dbaas_instances_snapshots" "example" {
  instance_id = mgc_dbaas_instances.my_dbaas.id
  name        = "example-snapshot"
  description = "Snapshot created via Terraform"
}



resource "mgc_network_vpcs_interfaces" "interface_example" {
  provider = mgc.cloud
  name     = "interface-teste"
  vpc_id   = "e757ae03-582a-436e-9bf1-0453d593f7dd"
}

resource "mgc_network_security_groups" "sg-principal" {
  name                  = "SG-default"
  description           = "security group criado pelo terraform"
  disable_default_rules = false

}


resource "mgc_network_security_groups_attach" "attach_example" {
  provider          = mgc.cloud
  security_group_id = "b23fcbfb-3a41-41ce-b80d-e7cc7fd752b0"
  interface_id      = mgc_virtual_machine_instances.vm_ubuntu.network_interfaces[0].id
}

resource "mgc_network_security_groups_rules" "allow_ssh" {
  provider          = mgc.cloud
  description       = "SSH Teste"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_max    = 22
  port_range_min    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "186.205.17.56/32"
  security_group_id = mgc_network_security_groups.sg-principal.id
} 