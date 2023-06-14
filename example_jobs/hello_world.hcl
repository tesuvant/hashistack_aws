# https://developer.hashicorp.com/nomad/tutorials/manage-jobs/jobs-submit
# Execute with:
#   export NOMAD_ADDR=http://<YOUR_NOMAD_CLIENT_IP>:4646
#   nomad job plan hello_world.hcl && nomad job run hello_world.hcl
# Try to curl the service locally (or allow inbound 5678):
#   ubuntu@ip-10-0-3-79:~$ curl 10.0.3.79:5678
#   hello world

job "website" {
  datacenters = ["dc1"]

  update {
    # The "max_parallel" parameter specifies the maximum number of updates to
    # perform in parallel.
    max_parallel = 1

    # The "min_healthy_time" parameter specifies the minimum time the allocation
    # must be in the healthy state before it is marked as healthy and unblocks
    # further allocations from being updated.
    min_healthy_time = "10s"

    # The "healthy_deadline" parameter specifies the deadline in which the
    # allocation must be marked as healthy after which the allocation is
    # automatically transitioned to unhealthy. Transitioning to unhealthy will
    # fail the deployment and potentially roll back the job if "auto_revert" is
    # set to true.
    healthy_deadline = "3m"

    # The "progress_deadline" parameter specifies the deadline in which an
    # allocation must be marked as healthy.
    progress_deadline = "5m"
    auto_revert = false

    # The "canary" parameter specifies that changes to the job that would result
    # in destructive updates should create the specified number of canaries
    # without stopping any previous allocations. Once the operator determines the
    # canaries are healthy, they can be promoted which unblocks a rolling update
    # of the remaining allocations at a rate of "max_parallel".
    #
    # Further, setting "canary" equal to the count of the task group allows
    # blue/green deployments. When the job is updated, a full set of the new
    # version is deployed and upon promotion the old version is stopped.
    canary = 0
  }

  group "website" {
    count = 3
    network {
      port "website" {
        static = "5678"
      }
    }

    task "http-echo" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"
        ports = ["website"]
        args = [
          "-listen",
          ":5678",
          "-text",
          "hello world",
        ]
      }

      service {
        name = "helloworld"
        tags = ["global", "website","helloworld","urlprefix-/"]
        port = "website"
        check {
          name     = "HelloWorld HTTP Check"
          type     = "http"
          interval = "10s"
          path   = "/"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 100 # MHz
        memory = 32 # MB
        network {
          mbits = 10
        }
      }
    }
  }
}
