let
  stroby_laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKi3MRFbaHZSYC0C94Lf92v5rHqhgAka46X09x/MIHBE";
  stroby_asus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUXkATqaafhR+432ME91TwkAEbiYG4+D8Fhw9C+7ujK";
  root_asus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQM573R/DN6g7czYxAa2YBjmaYZAkgrfQq3Xwc3orP6";
  users = [ stroby_laptop stroby_asus root_asus ];
in
{
  "mullvad.conf".publicKeys = users;
}
