#!/bin/sh
cat << EOF > /app/vault-agent.hcl
exit_after_auth = true
pid_file = "./pidfile"
auto_auth {
   method "kubernetes" {
       mount_path = "auth/kubernetes"
       config = {
           role = "universal"
       }
   }
}
template {
    destination = "/app/config/application.properties"
    source = "/app/config/application.properties.ctmpl"
}
EOF

/app/vault agent -config /app/vault-agent.hcl
cat /app/config/application.properties
exec "$@"