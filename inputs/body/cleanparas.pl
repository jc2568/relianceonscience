#!/usr/local/bin/perl

use HTML::Entities;

#open(INFILE, "temp1");
#while(<INFILE>) {
while(<>) {
    $line=$_;
#    print "LINE: $line\n";
    &decode_entities($line);
    $line=~s/\&[a-zA-Z]*\;//g;
    $line=~s/\&\#[0-9]*\;//g;  # Added by Aaron to get rid of number denoted entities not covered by decode_entities
#    print "DECODED: $line\n";
    $line=~s/é/e/g;
    $line=~s/ä/a/g;
    $line=~s/ü/u/g;
    $line=~s/Ü/U/g;
    $line=~s/Ö/O/g;
    $line=~s/ö/o/g;
    $line=~s/Ţ/T/g;
    $line=~s/Ñ/N/g;
    $line=~s/Ż/Z/g;
    $line=~s/Ó/O/g;
    $line=~s/Ï/I/g;
    $line=~s/Ø/O/g;
    $line=~s/Ç/C/g;
    $line=~s/Ã/A/g;
    $line=~s/É/E/g;
    $line=~s/Ô/O/g;
    $line=~s/Ä/A/g;
    $line=~s/Ł/L/g;
    $line=~s/Ń/N/g;
    $line=~s/ń/n/g;
    $line=~s/ł/l/g;
    $line=~s/ř/r/g;
    $line=~s/Ź/Z/g;
    $line=~s/Ć/C/g;
    $line=~s/Â/A/g;
    $line=~s/Ą/A/g;
    $line=~s/ś/$line=~s/;
    $line=~s/Ì/I/g;
    $line=~s/Â/A/g;
    $line=~s/Ů/U/g;
    $line=~s/ë/e/g;
    $line=~s/Ą/A/g;
    $line=~s/Á/A/g;
    $line=~s/ě/e/g;
    $line=~s/Đ/D/g;
    $line=~s/Ī/I/g;
    $line=~s/Ć/C/g;
    $line=~s/ã/a/g;
    $line=~s/Ę/E/g;
    $line=~s/Ř/R/g;
    $line=~s/C/C/g;
    $line=~s/š/$line=~s/;
    $line=~s/È/E/g;
    $line=~s/ú/u/g;
    $line=~s/Ś/$LINE=~S/g;
    $line=~s/ś/$line=~s/;
    $line=~s/Ķ/K/g;
    $line=~s/ª/a/g;
    $line=~s/Ë/E/g;
    $line=~s/Ă/A/g;
    $line=~s/Å/A/g;
    $line=~s/č/c/g;
    $line=~s/Ă/A/g;
    $line=~s/Ă/A/g;
    $line=~s/Æ/AE/g;
    $line=~s/ą/a/g;
    $line=~s/Ğ/G/g;
    $line=~s/À/A/g;
    $line=~s/í/i/g;
    $line=~s/ę/e/g;
    $line=~s/Ú/U/g;
    $line=~s/Č/E/g;
    $line=~s/ź/z/g;
    $line=~s/Š/$LINE=~S/g;
    $line=~s/İ/I/g;
    $line=~s/Í/I/g;
    $line=~s/Î/I/g;
    $line=~s/Ě/E/g;
    $line=~s/Š/$LINE=~S/g;
    $line=~s/Ş/$LINE=~S/g;
    $line=~s/á/a/g;
    $line=~s/ó/o/g;
    $line=~s/“/"/g;
    $line=~s/”/"/g;
    $line=~s/—/-/g;
    $line=~s/ъ/-/g;
#from gc
     $line=~s/Ь/-/g;
     $line=~s/Ъ/-/g;
     $line=~s/ь/-/g;
     $line=~s/Ă/A/g;
     $line=~s/Ą/A/g;
     $line=~s/À/A/g;
     $line=~s/Ã/A/g;
     $line=~s/Á/A/g;
     $line=~s/Æ/A/g;
     $line=~s/Â/A/g;
     $line=~s/Å/A/g;
     $line=~s/Ä/Ae/g;
     $line=~s/Þ/B/g;
     $line=~s/Ć/C/g;
     $line=~s/ץ/C/g;
     $line=~s/Ç/C/g;
     $line=~s/È/E/g;
     $line=~s/Ę/E/g;
     $line=~s/É/E/g;
     $line=~s/Ë/E/g;
     $line=~s/Ê/E/g;
     $line=~s/Ğ/G/g;
     $line=~s/İ/I/g;
     $line=~s/Ï/I/g;
     $line=~s/Î/I/g;
     $line=~s/Í/I/g;
     $line=~s/Ì/I/g;
     $line=~s/Ł/L/g;
     $line=~s/Ñ/N/g;
     $line=~s/Ń/N/g;
     $line=~s/Ø/O/g;
     $line=~s/Ó/O/g;
     $line=~s/Ò/O/g;
     $line=~s/Ô/O/g;
     $line=~s/Õ/O/g;
     $line=~s/Ö/Oe/g;
     $line=~s/Ş/S/g;
     $line=~s/Ś/S/g;
     $line=~s/Ș/S/g;
     $line=~s/Š/S/g;
     $line=~s/Ț/T/g;
     $line=~s/Ù/U/g;
     $line=~s/Û/U/g;
     $line=~s/Ú/U/g;
     $line=~s/Ü/Ue/g;
     $line=~s/Ý/Y/g;
     $line=~s/Ź/Z/g;
     $line=~s/Ž/Z/g;
     $line=~s/Ż/Z/g;
     $line=~s/â/a/g;
     $line=~s/ǎ/a/g;
     $line=~s/ą/a/g;
     $line=~s/á/a/g;
     $line=~s/ă/a/g;
     $line=~s/ã/a/g;
     $line=~s/Ǎ/a/g;
     $line=~s/а/a/g;
     $line=~s/А/a/g;
     $line=~s/å/a/g;
     $line=~s/à/a/g;
     $line=~s/א/a/g;
     $line=~s/Ǻ/a/g;
     $line=~s/Ā/a/g;
     $line=~s/ǻ/a/g;
     $line=~s/ā/a/g;
     $line=~s/ä/ae/g;
     $line=~s/æ/ae/g;
     $line=~s/Ǽ/ae/g;
     $line=~s/ǽ/ae/g;
     $line=~s/б/b/g;
     $line=~s/ב/b/g;
     $line=~s/Б/b/g;
     $line=~s/þ/b/g;
     $line=~s/ĉ/c/g;
     $line=~s/Ĉ/c/g;
     $line=~s/Ċ/c/g;
     $line=~s/ć/c/g;
     $line=~s/ç/c/g;
     $line=~s/ц/c/g;
     $line=~s/ċ/c/g;
     $line=~s/Ц/c/g;
     $line=~s/Č/c/g;
     $line=~s/č/c/g;
     $line=~s/Ч/ch/g;
     $line=~s/ч/ch/g;
     $line=~s/ד/d/g;
     $line=~s/ď/d/g;
     $line=~s/Đ/d/g;
     $line=~s/Ď/d/g;
     $line=~s/đ/d/g;
     $line=~s/д/d/g;
     $line=~s/Д/D/g;
     $line=~s/ð/d/g;
     $line=~s/є/e/g;
     $line=~s/ע/e/g;
     $line=~s/е/e/g;
     $line=~s/Е/e/g;
     $line=~s/Ə/e/g;
     $line=~s/ę/e/g;
     $line=~s/ĕ/e/g;
     $line=~s/ē/e/g;
     $line=~s/Ē/e/g;
     $line=~s/Ė/e/g;
     $line=~s/ė/e/g;
     $line=~s/ě/e/g;
     $line=~s/Ě/e/g;
     $line=~s/Є/e/g;
     $line=~s/Ĕ/e/g;
     $line=~s/ê/e/g;
     $line=~s/ə/e/g;
     $line=~s/è/e/g;
     $line=~s/ë/e/g;
     $line=~s/é/e/g;
     $line=~s/ф/f/g;
     $line=~s/ƒ/f/g;
     $line=~s/Ф/f/g;
     $line=~s/ġ/g/g;
     $line=~s/Ģ/g/g;
     $line=~s/Ġ/g/g;
     $line=~s/Ĝ/g/g;
     $line=~s/Г/g/g;
     $line=~s/г/g/g;
     $line=~s/ĝ/g/g;
     $line=~s/ğ/g/g;
     $line=~s/ג/g/g;
     $line=~s/Ґ/g/g;
     $line=~s/ґ/g/g;
     $line=~s/ģ/g/g;
     $line=~s/ח/h/g;
     $line=~s/ħ/h/g;
     $line=~s/Х/h/g;
     $line=~s/Ħ/h/g;
     $line=~s/Ĥ/h/g;
     $line=~s/ĥ/h/g;
     $line=~s/х/h/g;
     $line=~s/ה/h/g;
     $line=~s/î/i/g;
     $line=~s/ï/i/g;
     $line=~s/í/i/g;
     $line=~s/ì/i/g;
     $line=~s/į/i/g;
     $line=~s/ĭ/i/g;
     $line=~s/ı/i/g;
     $line=~s/Ĭ/i/g;
     $line=~s/И/i/g;
     $line=~s/ĩ/i/g;
     $line=~s/ǐ/i/g;
     $line=~s/Ĩ/i/g;
     $line=~s/Ǐ/i/g;
     $line=~s/и/i/g;
     $line=~s/Į/i/g;
     $line=~s/י/i/g;
     $line=~s/Ї/i/g;
     $line=~s/Ī/i/g;
     $line=~s/І/i/g;
     $line=~s/ї/i/g;
     $line=~s/і/i/g;
     $line=~s/ī/i/g;
     $line=~s/ĳ/ij/g;
     $line=~s/Ĳ/ij/g;
     $line=~s/й/j/g;
     $line=~s/Й/j/g;
     $line=~s/Ĵ/j/g;
     $line=~s/ĵ/j/g;
     $line=~s/я/ja/g;
     $line=~s/Я/ja/g;
     $line=~s/Э/je/g;
     $line=~s/э/je/g;
     $line=~s/ё/jo/g;
     $line=~s/Ё/jo/g;
     $line=~s/ю/ju/g;
     $line=~s/Ю/ju/g;
     $line=~s/ĸ/k/g;
     $line=~s/כ/k/g;
     $line=~s/Ķ/k/g;
     $line=~s/К/k/g;
     $line=~s/к/k/g;
     $line=~s/ķ/k/g;
     $line=~s/ך/k/g;
     $line=~s/Ŀ/l/g;
     $line=~s/ŀ/l/g;
     $line=~s/Л/l/g;
     $line=~s/ł/l/g;
     $line=~s/ļ/l/g;
     $line=~s/ĺ/l/g;
     $line=~s/Ĺ/l/g;
     $line=~s/Ļ/l/g;
     $line=~s/л/l/g;
     $line=~s/Ľ/l/g;
     $line=~s/ľ/l/g;
     $line=~s/ל/l/g;
     $line=~s/מ/m/g;
     $line=~s/М/m/g;
     $line=~s/ם/m/g;
     $line=~s/м/m/g;
     $line=~s/ñ/n/g;
     $line=~s/н/n/g;
     $line=~s/Ņ/n/g;
     $line=~s/ן/n/g;
     $line=~s/ŋ/n/g;
     $line=~s/נ/n/g;
     $line=~s/Н/n/g;
     $line=~s/ń/n/g;
     $line=~s/Ŋ/n/g;
     $line=~s/ņ/n/g;
     $line=~s/ŉ/n/g;
     $line=~s/Ň/n/g;
     $line=~s/ň/n/g;
     $line=~s/о/o/g;
     $line=~s/О/o/g;
     $line=~s/ő/o/g;
     $line=~s/õ/o/g;
     $line=~s/ô/o/g;
     $line=~s/Ő/o/g;
     $line=~s/ŏ/o/g;
     $line=~s/Ŏ/o/g;
     $line=~s/Ō/o/g;
     $line=~s/ō/o/g;
     $line=~s/ø/o/g;
     $line=~s/ǿ/o/g;
     $line=~s/ǒ/o/g;
     $line=~s/ò/o/g;
     $line=~s/Ǿ/o/g;
     $line=~s/Ǒ/o/g;
     $line=~s/ơ/o/g;
     $line=~s/ó/o/g;
     $line=~s/Ơ/o/g;
     $line=~s/œ/oe/g;
     $line=~s/Œ/oe/g;
     $line=~s/ö/oe/g;
            $line=~s/פ/p/g;
     $line=~s/ף/p/g;
     $line=~s/п/p/g;
     $line=~s/П/p/g;
            $line=~s/ק/q/g;
     $line=~s/ŕ/r/g;
     $line=~s/ř/r/g;
     $line=~s/Ř/r/g;
     $line=~s/ŗ/r/g;
     $line=~s/Ŗ/r/g;
     $line=~s/ר/r/g;
     $line=~s/Ŕ/r/g;
     $line=~s/Р/r/g;
     $line=~s/р/r/g;
     $line=~s/ș/s/;
     $line=~s/с/s/;
     $line=~s/Ŝ/s/;
     $line=~s/š/s/;
     $line=~s/ś/s/;
     $line=~s/ס/s/;
     $line=~s/ş/s/;
     $line=~s/С/s/;
     $line=~s/ŝ/s/;
     $line=~s/Щ/sch/g;
     $line=~s/щ/sch/g;
     $line=~s/ш/sh/g;
     $line=~s/Ш/sh/g;
     $line=~s/ß/ss/;
     $line=~s/т/t/g;
     $line=~s/ט/t/g;
     $line=~s/ŧ/t/g;
     $line=~s/ת/t/g;
     $line=~s/ť/t/g;
     $line=~s/ţ/t/g;
     $line=~s/Ţ/t/g;
     $line=~s/Т/t/g;
     $line=~s/ț/t/g;
     $line=~s/Ŧ/t/g;
     $line=~s/Ť/t/g;
     #$line=~s/™/tm/g;
     $line=~s/ū/u/g;
     $line=~s/у/u/g;
     $line=~s/Ũ/u/g;
     $line=~s/ũ/u/g;
     $line=~s/Ư/u/g;
     $line=~s/ư/u/g;
     $line=~s/Ū/u/g;
     $line=~s/Ǔ/u/g;
     $line=~s/ų/u/g;
     $line=~s/Ų/u/;
     $line=~s/ŭ/u/g;
     $line=~s/Ŭ/u/g;
     $line=~s/Ů/u/;
     $line=~s/ů/g/g;
     $line=~s/ű/u/g;
     $line=~s/Ű/u/g;
     $line=~s/Ǖ/u/g;
     $line=~s/ǔ/u/g;
     $line=~s/Ǜ/u/g;
     $line=~s/ù/u/g;
     $line=~s/ú/u/g;
     $line=~s/û/u/g;
     $line=~s/У/u/g;
     $line=~s/ǚ/u/g;
     $line=~s/ǜ/u/g;
     $line=~s/Ǚ/u/g;
     $line=~s/Ǘ/u/g;
     $line=~s/ǖ/u/g;
     $line=~s/ǘ/u/g;
     $line=~s/ü/ue/g;
     $line=~s/в/v/g;
     $line=~s/ו/v/g;
     $line=~s/В/v/g;
     $line=~s/ש/w/g;
     $line=~s/ŵ/w/g;
     $line=~s/Ŵ/w/g;
     $line=~s/ы/y/g;
     $line=~s/ŷ/y/g;
     $line=~s/ý/y/g;
     $line=~s/Ÿ/y/g;
     $line=~s/Ŷ/y/g;
     $line=~s/Ы/y/g;
     $line=~s/ž/z/g;
     $line=~s/З/z/g;
     $line=~s/з/z/g;
     $line=~s/ź/z/g;
     $line=~s/ז/z/g;
     $line=~s/ż/z/g;
     $line=~s/ſ/z/g;
     $line=~s/Ж/zh/g;
     $line=~s/ж/zh/g;
     $line=~s/\^@//g;
    $line=~s/[^[:ascii:]]//g; # Remove any remaining non-ASCII characters
#    $line=~s/tr/\0-\177//cd; # Different way of removing non-ASCII characters

    print $line;
}
