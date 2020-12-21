Kind  = "service-resolver"
Name = "front"
Namespace = "apps"
DefaultSubset = "v1"
Subsets = {
  "v1" = {
    Filter = "Service.Tags contains v1"
  }
  "v2" = {
    Filter = "Service.Tags contains v2"
  }
}
// Failover = {
//   "*" = {
//     Datacenters = ["dc2"]
//   }
// }