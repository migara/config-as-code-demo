package panos

default allow = false

# Apps that aren't sanctioned
sanctioned_apps = {
    "ssl"
}

# Apps that aren't sanctioned
blacklisted_apps = {
    "ms-ds-smb"
}

blacklisted_zones = {
  {"from":"db", "to": "untrust"},
  {"from":"frontend", "to": "db"}
}

# Records rules that has application "any"
violations_appID_any[rule.name] {
    rule := input.security_policies[_]
    rule.applications[_] == "any"
}

# Records rules that has blacklisted applications
violations_blacklisted_apps[{"name": rule.name, "apps": rule.applications}]{
    rule := input.security_policies[_]
    rule.applications[_] == blacklisted_apps[_]
}

# Records rules that are not zone compliant
violations_blacklisted_zones[{"name": rule.name, "from": rule.source_zones}]{
    rule := input.security_policies[_]
    some i
    rule.source_zones[_] == blacklisted_zones[i].from
    rule.destination_zones[_] == blacklisted_zones[i].to
}

# Returns true only if there are no violations
allow {
    count(violations_appID_any) == 0
}