{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = with pkgs; [
      (writeShellScriptBin "ascii" ''
        RED=$(tput setaf 1)
        GREEN=$(tput setaf 2)
        BLUE=$(tput setaf 4)
        MAGENTA=$(tput setaf 5)
        CYAN=$(tput setaf 6)
        NORMAL=$(tput sgr0)

        echo -e "┌─────────────┬─────────────┬─────────────┬─────────────┐"
        echo -e "│ $${BLUE}Dec$${NORMAL} $${GREEN}Hex$${NORMAL} Chr │ $${BLUE}Dec$${NORMAL} $${GREEN}Hex$${NORMAL} Chr │ $${BLUE}Dec$${NORMAL} $${GREEN}Hex$${NORMAL} Chr │ $${BLUE}Dec$${NORMAL} $${GREEN}Hex$${NORMAL} Chr │"
        echo -e "├─────────────┼─────────────┼─────────────┼─────────────┤"
        echo -e "│ 0   0   \033[2mNUL\033[0m\033[0m │ 32  20      │ 64  40   $${CYAN}@$${NORMAL}  │ 96  60   $${CYAN}\`$${NORMAL}  │"
        echo -e "│ 1   1   \033[2mSOH\033[0m │ 33  21   $${CYAN}!$${NORMAL}  │ 65  41   $${GREEN}A$${NORMAL}  │ 97  61   $${GREEN}a$${NORMAL}  │"
        echo -e "│ 2   2   \033[2mSTX\033[0m │ 34  22   $${CYAN}\"$${NORMAL}  │ 66  42   $${GREEN}B$${NORMAL}  │ 98  62   $${GREEN}b$${NORMAL}  │"
        echo -e "│ 3   3   \033[2mETX\033[0m │ 35  23   $${CYAN}#$${NORMAL}  │ 67  43   $${GREEN}C$${NORMAL}  │ 99  63   $${GREEN}c$${NORMAL}  │"
        echo -e "│ 4   4   \033[2mEOT\033[0m │ 36  24   $${CYAN}\$''${NORMAL}  │ 68  44   $${GREEN}D$${NORMAL}  │ 100 64   $${GREEN}d$${NORMAL}  │"
        echo -e "│ 5   5   \033[2mENQ\033[0m │ 37  25   $${CYAN}%$${NORMAL}  │ 69  45   $${GREEN}E$${NORMAL}  │ 101 65   $${GREEN}e$${NORMAL}  │"
        echo -e "│ 6   6   \033[2mACK\033[0m │ 38  26   $${CYAN}&$${NORMAL}  │ 70  46   $${GREEN}F$${NORMAL}  │ 102 66   $${GREEN}f$${NORMAL}  │"
        echo -e "│ 7   7   \033[2mBEL\033[0m │ 39  27   $${CYAN}'$${NORMAL}  │ 71  47   $${GREEN}G$${NORMAL}  │ 103 67   $${GREEN}g$${NORMAL}  │"
        echo -e "│ 8   8   \033[2mBS\033[0m  │ 40  28   $${CYAN}($${NORMAL}  │ 72  48   $${GREEN}H$${NORMAL}  │ 104 68   $${GREEN}h$${NORMAL}  │"
        echo -e "│ 9   9   \033[2mHT\033[0m  │ 41  29   $${CYAN})$${NORMAL}  │ 73  49   $${GREEN}I$${NORMAL}  │ 105 69   $${GREEN}i$${NORMAL}  │"
        echo -e "│ 10  A   \033[2mLF\033[0m  │ 42  2A   $${CYAN}*$${NORMAL}  │ 74  4A   $${GREEN}J$${NORMAL}  │ 106 6A   $${GREEN}j$${NORMAL}  │"
        echo -e "│ 11  B   \033[2mVT\033[0m  │ 43  2B   $${CYAN}+$${NORMAL}  │ 75  4B   $${GREEN}K$${NORMAL}  │ 107 6B   $${GREEN}k$${NORMAL}  │"
        echo -e "│ 12  C   \033[2mFF\033[0m  │ 44  2C   $${CYAN},$${NORMAL}  │ 76  4C   $${GREEN}L$${NORMAL}  │ 108 6C   $${GREEN}l$${NORMAL}  │"
        echo -e "│ 13  D   \033[2mCR\033[0m  │ 45  2D   $${CYAN}-$${NORMAL}  │ 77  4D   $${GREEN}M$${NORMAL}  │ 109 6D   $${GREEN}m$${NORMAL}  │"
        echo -e "│ 14  E   \033[2mSO\033[0m  │ 46  2E   $${CYAN}.$${NORMAL}  │ 78  4E   $${GREEN}N$${NORMAL}  │ 110 6E   $${GREEN}n$${NORMAL}  │"
        echo -e "│ 15  F   \033[2mSI\033[0m  │ 47  2F   $${CYAN}/$${NORMAL}  │ 79  4F   $${GREEN}O$${NORMAL}  │ 111 6F   $${GREEN}o$${NORMAL}  │"
        echo -e "│ 16  10  \033[2mDLE\033[0m │ 48  30   $${RED}0$${NORMAL}  │ 80  50   $${GREEN}P$${NORMAL}  │ 112 70   $${GREEN}p$${NORMAL}  │"
        echo -e "│ 17  11  \033[2mDC1\033[0m │ 49  31   $${RED}1$${NORMAL}  │ 81  51   $${GREEN}Q$${NORMAL}  │ 113 71   $${GREEN}q$${NORMAL}  │"
        echo -e "│ 18  12  \033[2mDC2\033[0m │ 50  32   $${RED}2$${NORMAL}  │ 82  52   $${GREEN}R$${NORMAL}  │ 114 72   $${GREEN}r$${NORMAL}  │"
        echo -e "│ 19  13  \033[2mDC3\033[0m │ 51  33   $${RED}3$${NORMAL}  │ 83  53   $${GREEN}S$${NORMAL}  │ 115 73   $${GREEN}s$${NORMAL}  │"
        echo -e "│ 20  14  \033[2mDC4\033[0m │ 52  34   $${RED}4$${NORMAL}  │ 84  54   $${GREEN}T$${NORMAL}  │ 116 74   $${GREEN}t$${NORMAL}  │"
        echo -e "│ 21  15  \033[2mNAK\033[0m │ 53  35   $${RED}5$${NORMAL}  │ 85  55   $${GREEN}U$${NORMAL}  │ 117 75   $${GREEN}u$${NORMAL}  │"
        echo -e "│ 22  16  \033[2mSYN\033[0m │ 54  36   $${RED}6$${NORMAL}  │ 86  56   $${GREEN}V$${NORMAL}  │ 118 76   $${GREEN}v$${NORMAL}  │"
        echo -e "│ 23  17  \033[2mETB\033[0m │ 55  37   $${RED}7$${NORMAL}  │ 87  57   $${GREEN}W$${NORMAL}  │ 119 77   $${GREEN}w$${NORMAL}  │"
        echo -e "│ 24  18  \033[2mCAN\033[0m │ 56  38   $${RED}8$${NORMAL}  │ 88  58   $${GREEN}X$${NORMAL}  │ 120 78   $${GREEN}x$${NORMAL}  │"
        echo -e "│ 25  19  \033[2mEM\033[0m  │ 57  39   $${RED}9$${NORMAL}  │ 89  59   $${GREEN}Y$${NORMAL}  │ 121 79   $${GREEN}y$${NORMAL}  │"
        echo -e "│ 26  1A  \033[2mSUB\033[0m │ 58  3A   $${CYAN}:$${NORMAL}  │ 90  5A   $${GREEN}Z$${NORMAL}  │ 122 7A   $${GREEN}z$${NORMAL}  │"
        echo -e "│ 27  1B  \033[2mESC\033[0m │ 59  3B   $${CYAN};$${NORMAL}  │ 91  5B   $${CYAN}[$${NORMAL}  │ 123 7B   $${CYAN}{$${NORMAL}  │"
        echo -e "│ 28  1C  \033[2mFS\033[0m  │ 60  3C   $${CYAN}<$${NORMAL}  │ 92  5C   $${CYAN}\\$${NORMAL}  │ 124 7C   $${CYAN}|$${NORMAL}  │"
        echo -e "│ 29  1D  \033[2mGS\033[0m  │ 61  3D   $${CYAN}=$${NORMAL}  │ 93  5D   $${CYAN}]$${NORMAL}  │ 125 7D   $${CYAN}}$${NORMAL}  │"
        echo -e "│ 30  1E  \033[2mRS\033[0m  │ 62  3E   $${CYAN}>$${NORMAL}  │ 94  5E   $${CYAN}^$${NORMAL}  │ 126 7E   $${CYAN}~$${NORMAL}  │"
        echo -e "│ 31  1F  \033[2mUS\033[0m  │ 63  3F   $${CYAN}?$${NORMAL}  │ 95  5F   $${CYAN}_$${NORMAL}  │ 127 7F  \033[2mDEL\033[0m │"
        echo -e "└─────────────┴─────────────┴─────────────┴─────────────┘"      
      '')
    ];
  };
}
