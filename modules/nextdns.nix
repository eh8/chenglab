.services.nextdns.wantedBy = [ "network.target" ];
  systemd.services.nextdns.after = [ "network-pre.target" ];
  systemd.services.nextdns.bindsTo = [ "network.target" ];

  # Define any additional settings or dependencies specific to NextDNS here
}
