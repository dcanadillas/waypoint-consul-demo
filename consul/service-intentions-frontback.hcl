Kind = "service-intentions"
Name = "back"
Namespace = "apps"
Sources = [
  {
    Name = "front"
    Namespace = "apps"
    Action = "allow"
  }
]