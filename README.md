zookeeper Cookbook
==================

Requirements
------------
- Relies on the get_data* and normalization functions in hp_common_functions
- hostsfile needed to modify /etc/hosts

Attributes
----------
#### zookeeper::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>[:zookeeper][:cluster]</tt></td>
    <td>String</td>
    <td>Name of the zookeeper cluster, used to pull the right data bag</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>[:zookeeper][:log_dir]</tt></td>
    <td>String</td>
    <td>Logging dir</td>
    <td><tt>/var/log/zookeeper</tt></td>
  </tr>
</table>

Data Bags
-----
For each cluster there is a data bag with the name of the cluster. The get_data bag functions are used so the cluster name
can vary based on environment. The data bag contains a servers hash with this format:
  "servers": [
    "fqdn": { "id": 0, "ip": "10.10.10.10" },
    "fqdn2": { "id": 1, "ip": "10.10.10.11" }
  ]

Usage
-----
Simply include the zookeeper default recipe in your role making sure to setup the data bags and attributes as described above.
