{ username, ... }: {
  home.file = { 
    "/home/${username}/.local/share/qBittorrent/nova3/engines/jackett.json" = { 
      text = ''
{
  "api_key": "mgikmiiem80zmtyecv8xusz9twqxsmzl",
  "thread_count": 20,
  "tracker_first": false,
  "url": "http://jackett.home"
}
      ''; 
      executable = false; 
    };

    "/home/${username}/.config/qBittorrent/qBittorrent.conf" = { 
      force = true;
      text = ''
[Application]
FileLogger\Age=1
FileLogger\AgeType=1
FileLogger\Backup=true
FileLogger\DeleteOld=true
FileLogger\Enabled=true
FileLogger\MaxSizeBytes=66560
FileLogger\Path=/.local/share/qBittorrent/logs

[BitTorrent]
Session\DefaultSavePath=/media/videos/shows
Session\ExcludedFileNames=
Session\Interface=wg0
Session\InterfaceName=wg0
Session\Port=44008
Session\QueueingSystemEnabled=false
Session\SSL\Port=64215
Session\UseAlternativeGlobalSpeedLimit=false

[Core]
AutoDeleteAddedTorrentFile=Never

[LegalNotice]
Accepted=true

[Meta]
MigrationVersion=8

[Preferences]
General\Locale=en
MailNotification\password=qbittorrent+240803
MailNotification\req_auth=true
MailNotification\username=stroby
Scheduler\end_time=@Variant(\0\0\0\xf\0\x36\xee\x80)
Scheduler\start_time=@Variant(\0\0\0\xf\x4\x13\xb3\x80)
WebUI\AuthSubnetWhitelist=@Invalid()
WebUI\MaxAuthenticationFailCount=0
WebUI\Password_PBKDF2="@ByteArray(hbfqcjsSYVJ4wZ44izyo7g==:vCnpTGzM6mhKoIEEiV8ybaPvFTX++AdR1ANs9dEKIcaoz4E7akMy33r1g24e/i2C3+c1IuV3sR+Pb1L5XspxDQ==)"
WebUI\Port=8083
WebUI\ReverseProxySupportEnabled=true
WebUI\SessionTimeout=0
WebUI\TrustedReverseProxiesList=""
WebUI\Username=stroby

[RSS]
AutoDownloader\DownloadRepacks=true
AutoDownloader\SmartEpisodeFilter=s(\\d+)e(\\d+), (\\d+)x(\\d+), "(\\d{4}[.\\-]\\d{1,2}[.\\-]\\d{1,2})", "(\\d{1,2}[.\\-]\\d{1,2}[.\\-]\\d{4})"

[SearchEngines]
disabledEngines=torrentproject
      ''; 
      executable = false; 
    };

  };
}
