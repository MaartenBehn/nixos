{ pkgs, lib, ... }: 
let
  backup_folder = "~/backups"; 

  repo_folder_to_name = repo_folder: builtins.replaceStrings ["/"] ["_"] repo_folder;
  make_repo = repo_folder: server_name: (if server_name == "fritz_behns" then 
    "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/${repo_folder}" 
  else 
    "ssh://root@138.199.203.38/backup/${repo_folder}");

  make_script_inner = repo_folder: server_name: folder: pkgs.writeShellScriptBin 
    "borg_mount_${server_name}_${repo_folder_to_name repo_folder}" 
    ''
      mkdir -p ${folder}
      borgfs -p ${make_repo repo_folder server_name} ${folder}
    '';

  make_script = repo_folder: server_name: (make_script_inner repo_folder server_name 
      ("${backup_folder}/${server_name}/${repo_folder_to_name repo_folder}")); 

  actual_folders = builtins.map (name: "actual-server/${name}") [
    "user-files"
    "server-files"
    "user-files-test"
    "server-files-test"
  ];

  both_folders = [
    "notes"
  ] ++ actual_folders;

  only_fritz_folders = [
    "study"
    "immich"
  ];

  servers = [
    "fritz_behns"
    "proxy"
  ];

  scripts = lib.lists.flatten (
    builtins.map (repo_folder: 
      builtins.map (server_name: 
        make_script repo_folder server_name
      ) servers
    ) both_folders
  ) ++ builtins.map (repo_folder: 
    make_script repo_folder "fritz_behns"
  ) only_fritz_folders;
in {
  home.packages = (with pkgs; [
    borgbackup
  ] ++ scripts);

}
