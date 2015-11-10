apache101 cookbook [![Build Status](https://travis-ci.org/nirmaljss/apache101.svg)](https://travis-ci.org/nirmaljss/apache101/)
====================
Configures and installs a simple and basic Apache server.

Requirements
------------
* Chef 11+, 12

Platform
--------
* RHEL, CentOS (Tested)

Recipes
----------
### Default
* Configures and installs a basic Apache server with custom home page.

### Custom_Log
* Defined a custom log format for apache web access logs.

Usage
-----
#### apache101::default

Just include `apache101` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[apache101]"
  ]
}
```
