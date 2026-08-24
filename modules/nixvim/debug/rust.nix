{
  nixvimConfig = { pkgs, ... }: {
    plugins = {
      dap = {
        enable = true;
        configurations = {
          rust = [
            {
              name = "cargo build";
              type = "lldb";
              request = "launch";
              program = {
                __raw = '' 
                function()  
                  return preShellTask("cargo build", function() 
                    return "./target/debug/".. getRustPackageName() 
                  end)  
                end
                '';
              };
            }
            {
              name = "cargo build --features $RUST_FEATURES";
              type = "lldb";
              request = "launch";
              program = {
                __raw = '' 
                function()  
                  return preShellTask("cargo build --features $RUST_FEATURES", function() 
                    return "./target/x86_64-unknown-linux-gnu/debug/".. getRustPackageName() 
                  end)  
                end
                '';
              };
            }
            {
              name = "cargo build --features $RUST_FEATURES --release";
              type = "lldb";
              request = "launch";
              program = {
                __raw = '' 
                function()  
                  return preShellTask("cargo build --features $RUST_FEATURES --release", function() 
                    return "./target/x86_64-unknown-linux-gnu/release/".. getRustPackageName() 
                  end)  
                end
                '';
              };
            }
          ];
        };

        adapters = {
          executables = {
            lldb = {
              command = "${pkgs.lldb_19}/bin/lldb-dap";
            };
          };
        };
      };
    };

    extraConfigLuaPre = ''
    function preShellTask(command, getNameFunc)
      return coroutine.create(function(dap_run_co)
        local progress = require("fidget.progress") 
        local handle = progress.handle.create({
          title = command,
          message = "starting ...",
          lsp_client = { name = "pre debug task" },
        })

        function log (id, data, name)
          for k, v in pairs(data) do
            if v ~= "" then
              handle.message = v
            end
          end
        end

        function done (id, code, type)
          handle:finish()
          local name = getNameFunc()
          coroutine.resume(dap_run_co, name)
        end

        local job = vim.fn.jobstart(
          command, 
          {
            on_stdout = log,
            on_stderr = log,
            on_exit = done 
          }
        )
      end)
    end

    function getRustPackageName() 
      local handle = io.popen("cargo metadata --no-deps --format-version 1 | jq -r '.packages[].targets[] | select( .kind | map(. == \"bin\") | any ) | .name'")
      local result = handle:read("*a")
      handle:close()
      -- remove new line char at the end
      result = result:sub(1, -2)
      return result
    end
    '';
  };
}
