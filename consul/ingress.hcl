Kind = "ingress-gateway"
Name = "ingress-gateway"

Listeners = [
 {
   Port = 8080
   Protocol = "http"
   Services = [
     {
        Name = "front"
        Namespace = "apps"
        Hosts = "*"
     }
   ]
 }
]
