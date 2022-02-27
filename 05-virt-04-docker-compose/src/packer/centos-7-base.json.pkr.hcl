# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "yandex" "centos7"{
  disk_type           = "network-nvme"
  folder_id           = "b1g1acekav76h07m2gko"
  image_description   = "by packer"
  image_family        = "centos"
  image_name          = "centos-7-base"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  subnet_id           = "e9b7d0b400scqa1m0l5l"
  token               = ""
  use_ipv4_nat        = true
  zone                = "ru-central1-a"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.yandex.centos7"]

  provisioner "shell" {
    inline = ["sudo yum -y update", "sudo yum -y install bridge-utils bind-utils iptables curl net-tools tcpdump rsync telnet openssh-server vim-enhanced mc"]
  }

}
