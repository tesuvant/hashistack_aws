# https://developer.hashicorp.com/nomad/tutorials/manage-jobs/jobs-submit
# Execute with:
#   export NOMAD_ADDR=http://<YOUR_NOMAD_CLIENT_IP>:4646
#   nomad job plan hello_world.hcl && nomad job run hello_world.hcl
# Try to curl the service locally (or allow inbound 5678):
#   ubuntu@ip-10-0-3-79:~$ curl 10.0.3.79:5678
#   hello world

job "docs" {
  datacenters = ["dc1"]

  group "example" {
    count = 3
    network {
      port "http" {
        static = "5678"
      }
    }
    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"
        ports = ["http"]
        args = [
          "-listen",
          ":5678",
          "-text",
          "hello world",
        ]
      }
    }
  }
}
