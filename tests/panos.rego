package panos

default allow = false

# Apps that aren't sanctioned
unsanctioned_apps = [
    "ms-ds-smb"
]

# Disallowed from-to zone combinations
disallowed_zones = {
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

# Rules that has unsanctioned applications
deny[msg]{
    some i, j
    rule := input.security_policies[_]
    unsanctioned_apps[j]
    msg := sprintf("Rule '%v' has a unsanctioned application ID '%v'", [rule.name, rule.applications[i]])
}

# Rules that are not zone compliant
deny[msg]{
    rule := input.security_policies[_]
    some i, j, k
    disallowed_zones[i].from
    disallowed_zones[i].to
    msg := sprintf("Rule '%v' from '%v' zone to '%v' zone is not allowed", [rule.name, rule.source_zones[j], rule.destination_zones[k]])
}

# Returns true only if there are no violations
allow {
    count(deny) == 0
}