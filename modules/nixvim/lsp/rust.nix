{
  nixvimConfig = { pkgs, ... }: {
    plugins = {
      #conform-nvim = {
      #  enable = true;
      #  settings = {
      #    #  formatters_by_ft.rust = [ "rustfmt" ];
      #  };
      #};
      rustaceanvim = {
        enable = true;
        settings = {
          dap.adapter = {
            command = "${pkgs.lldb_19}/bin/lldb-dap";
            type = "executable";
          };
          tools.enable_clippy = false;
          server = {
            default_settings = {
              inlayHints = {
                lifetimeElisionHints = {
                  enable = "always";
                };
              };
              rust-analyzer = {
                diagnostics.enable = false;
              };
            };
          };
        };
      };
    };

    extraConfigLua = ''
        -- Load Features from env var RUST_FEATURES
        local project_features_env = os.getenv("RUST_FEATURES")
        local project_features = {}

        if project_features_env ~= nil and project_features_env ~= "" then
          local function split(str, sep)
            local result = {}
            local regex = ("([^%s]+)"):format(sep)
            for each in str:gmatch(regex) do
              table.insert(result, each)
            end
            return result
          end
          project_features = split(project_features_env, ",")
        end

        vim.g.rustaceanvim = {
          -- LSP configuration
          server = {
            default_settings = {
              -- rust-analyzer language server configuration
              ['rust-analyzer'] = {
                cargo = {
                  features = project_features,
                },
                check = {
                  features = project_features,
                },
              },
            },
          },
        }
        '';
  };
}
