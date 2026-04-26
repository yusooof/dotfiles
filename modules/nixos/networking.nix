_:

{
  networking = {
    hostName = "computer";
    networkmanager.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [ 7000 7001 7100 ];
      allowedUDPPorts = [ 5353 6000 6001 7011 ];
      allowedTCPPortRanges = [{ from = 7000; to = 7005; }];
      allowedUDPPortRanges = [{ from = 6000; to = 6005; }];
    };
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
