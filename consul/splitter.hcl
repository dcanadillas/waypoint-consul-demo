Kind = "service-splitter"
Name = "front"
Namespace = "apps"
Splits = [
  {
    Weight        = 90
    Service = "front"
    ServiceSubset = "v1"
  },
  {
    Weight        = 10
    Service = "front"
    ServiceSubset = "v2"
  },
]