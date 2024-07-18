{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  networking.hostName = "PouyaCode";
  networking.domain = "pouyacode.net";

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCaYMKbgs1cGsB/njtYk9tP+BBtCDRRdYrAGtJ7UQdPMV07sSfU3eBEWe6X1E1ydlvdMT/YCN3KQ8mk/nerdhnOCUyscKLYEA+5i8MG+7wAEWhUOIfr2lN04wieTlo1m5OXgyJS45NHi+Yow87x/x+eSFbO/SLW31CPkhciMmjEwnLioCstjOolzz068tl3/JIBVxRlas3JkMitEDxtiyz29ya2zbdyKgN0EUCy2RoGKaf0ygluqw8IxSRFKguV38uT9DgoaLatuLJqLGWLcTo7gI7k6bPSMTW0oidc7bZETMrLw8iDogXedOkuM40UEt9PLMkgYvhuqesa5belNvq6GUWuk9TTFTtVirgvuIG+lBQuN6vjgMMD9B40CAd2DhOSKGuo4rtpr/ixTVpd+FfdRhiRJTiKHDL59dcSxynfOx2CwSYG54HFZdMYdafElG7yeVLjzNTiKfrkRR8iMcqFoa46Zn/Chd+EOJY/0EMYJhp8A7EjW5AEsM1srWE+suHrxV65D93daGHTiQk9dduaXRfm4PzeCFW//jSiZoYzT0/DSkh3RsvRE4Fq5ucy3vYhwkhTMNeokW/dGsbMuPqHGP8dif+uN3SU1Ha/ODMDun+Q2ZB1IDB6ogy3aGXXd7/hfn7DPDhQNwqHW/hu+QHdtZ+l80JiMNUjM20LhxlqVQ== pouya@b9440''];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  system.stateVersion = "23.11";
}

