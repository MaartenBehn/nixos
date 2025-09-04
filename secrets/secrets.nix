let
  stroby_laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUXkATqaafhR+432ME91TwkAEbiYG4+D8Fhw9C+7ujK";
  users = [ stroby_laptop ];
in
{
  "mullvad.conf".publicKeys = users;
}
