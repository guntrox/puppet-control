node default {
  if $facts[role] {
    include "role::${facts[role]}"
  } else {
    notify {"Node ${facts[fqdn]} does not have a role set specified":}
    include profile::base
  }
}
