package panos

default allow = false

# Apps that aren't sanctioned
blacklisted_apps = [
    "ms-ds-smb"
]

# Disallowed from-to zone combinations
blacklisted_zones = {
  {"from":"db", "to": "untrust"},
  {"from":"frontend", "to": "db"},
  {"from":"any", "to": "any"}
}

# Rules that has application ID "any"
deny[msg] {
    rule := input.security_policies[_]
    rule.applications[_] == "any"
    msg := sprintf("Rule '%v' has application ID set to '%v'", [rule.name, "any"])
}

# Rules that has blacklisted applications
deny[msg]{
    some i, j
    rule := input.security_policies[_]
    rule.applications[i] == blacklisted_apps[j]
    msg := sprintf("Rule '%v' has a blacklisted application ID '%v'", [rule.name, rule.applications[i]])
}

# Rules that are not zone compliant
deny[msg]{
    rule := input.security_policies[_]
    some i, j, k
    rule.source_zones[j] == blacklisted_zones[i].from
    rule.destination_zones[k] == blacklisted_zones[i].to
    msg := sprintf("Rule '%v' from '%v' zone to '%v' zone is not allowed", [rule.name, rule.source_zones[j], rule.destination_zones[k]])
}

# Returns true only if there are no violations
allow {
    count(deny) == 0
}