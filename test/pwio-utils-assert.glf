package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

if { ![pwio::utils::getSelection Block selectedEnts errMsg] } {
    puts $errMsg
    exit 0;
}
foreach ent $selectedEnts {
	set ndx 99
	pwio::utils::assert "$ndx >= 1 && $ndx < [$ent getPointCount]" \
						"Bad Index $ndx for '[$ent getName]'"
}

# Output (if assert fails):
# assert failed: (99 >= 1 && 99 < 36)
# message      : Bad Index 99 for 'blk-4'
