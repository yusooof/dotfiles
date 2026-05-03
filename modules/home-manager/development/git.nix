{ pkgs, ... }: {
  home.packages = [ pkgs.git-credential-manager ];

  programs.ssh = {
    enable = true;
    matchBlocks."*".addKeysToAgent = "yes";
    matchBlocks."github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/id_ed25519";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "idkysf";
        email = "823480+uproot@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "secretservice";
      };
    };
  };
}
