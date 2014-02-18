default[:zookeeper][:firewall][:rules] = [
  "zookeeper-2181" => {
    "port" => "2181",
    "protocol" => "tcp"
  },
  "zookeeper-2888" => {
    "port" => "2888",
    "protocol" => "tcp"
  },
  "zookeeper-3888" => {
    "port" => "3888",
    "protocol" => "tcp"
  }
]
