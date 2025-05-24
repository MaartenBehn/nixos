{ username, ... }: {
  home.file = {
    "/home/${username}/.ssh/id_ed25519" = {
      text = ''
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDM2tbXBQYnllp9r6XMLOZzt6RI0w9TAO3VGf9lymUUBgAAAJhecnUBXnJ1
AQAAAAtzc2gtZWQyNTUxOQAAACDM2tbXBQYnllp9r6XMLOZzt6RI0w9TAO3VGf9lymUUBg
AAAEAbxnYcEIsit/c2JAzW/EjH4Pp4St1zxI+/zgygch3wVsza1tcFBieWWn2vpcws5nO3
pEjTD1MA7dUZ/2XKZRQGAAAAFHN0cm9ieUBzdHJvYnktbGFwdG9wAQ==
      '';
    };

    "/home/${username}/.ssh/id_ed25519.pub" = {
      text = ''
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMza1tcFBieWWn2vpcws5nO3pEjTD1MA7dUZ/2XKZRQG stroby@iso
      '';
    };
  };
}
