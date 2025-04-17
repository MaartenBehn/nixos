{ pkgs, lib, ... }:

let 
  gmail_configs = [
    {
      mail = "maarten.behn@gmail.com";
      name = "Maarten Behn";
      primary = true; # Can be undefined 
    }
    {
      mail = "stroby241@gmail.com";
      name = "Stroby";
    }
    {
      mail = "socialropelab@gmail.com";
      name = "Social Rope Lab";
    }
    {
      mail = "strobyburn@gmail.com";
      name = "Stroby";
    }
    {
      mail = "socialropelab@gmail.com";
      name = "Social Rope Lab";
    }
  ];
  imap_configs = [
    {
      mail = "behn@uni-bremen.de";
      name = "Maarten Behn";
      host = "smtp.uni-bremen.de";
    }
    {
      mail = "stroby@smjg.org";
      name = "Stroby";
      username = "stroby"; # Optional if username is not mail
      host = "web.smjg.org";
    }
  ];
  rope_lab_configs = [
    {
      username = "social";
      name = "Social Rope Lab";
    }
    {
      username = "status";
      name = "Social Rope Lab Status";
    }
    {
      username = "stroby";
      name = "Stroby";
    }
  ];
in
{
  # https://nix-community.github.io/home-manager/options.xhtml
  home.packages = [
    pkgs.thunderbird
  ];

  programs.thunderbird = {
    enable = true;
    profiles."Default" = {
      isDefault = true;
    };
  };
  
  accounts.email.accounts = builtins.listToAttrs ( 
    (builtins.map (config: 
      { 
        name = config.mail; 
        value = {
          thunderbird = {
            enable = true;
            
            # Enable OAuth2
            settings = id: {
              "mail.smtpserver.smtp_${id}.authMethod" = 10;
              "mail.server.server_${id}.authMethod" = 10;
            };
          };

          realName = config.name;
          address = config.mail;
          userName = config.mail;
          flavor = "gmail.com";

          primary = lib.mkIf (builtins.hasAttr "primary" config) config.primary;
        };
      }) gmail_configs)
    ++ (builtins.map (config: 
      { 
        name = config.mail; 
        value = {
          thunderbird = {
            enable = true;
          };

          realName = config.name;
          address = config.mail;
          userName = if (builtins.hasAttr "username" config) then config.username else config.mail;
          
          imap = {
            host = config.host;
            port = 993;
          };         
          smtp = {
            host = config.host;
            port = 465; 
          };

          primary = lib.mkIf (builtins.hasAttr "primary" config) config.primary;
        };
      }) imap_configs)
    ++ (builtins.map (config: 
      { 
        name = "${config.username}@ropelab.de"; 
        value = {
          thunderbird = {
            enable = true;
          };

          realName = config.name;
          address = "${config.username}@ropelab.de";
          userName = "${config.username}@ropelab.de";
          
          imap = {
            host = "betelgeuse.uberspace.de";
            port = 993;
          };         
          smtp = {
            host = "betelgeuse.uberspace.de";
            port = 465; 
          };

          primary = lib.mkIf (builtins.hasAttr "primary" config) config.primary;
        };
      }) rope_lab_configs)
  );
}


