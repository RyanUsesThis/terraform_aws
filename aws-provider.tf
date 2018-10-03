provider "aws" {
  #security $ access pulled from ~/.aws/credentials see readme
  #access_key = "${var.access_key}"
  #secret_key = "${var.secret_key}"
  region = "${var.vm_region}"
}
