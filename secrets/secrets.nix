let
  pouya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyvUJK9jI07Vp1jBNUvlOYjX2/QQy+gFtotGtNko4vt pouya@strix";
  users = [ pouya ];

in
{
  "noti.age".publicKeys = [ pouya ];
  "nextdns.age".publicKeys = [ pouya ];
}