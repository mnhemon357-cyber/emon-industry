my $log = "2026-11-24 Failed password for root from 45.33.22.11 port 22";
if $log ~~ / 'from ' $<ip>=[ [\d+] ** 4 % '.' ] / {
    say "[ESECURITY RAKU] Blocked Intruder IP: $<ip>";
}
