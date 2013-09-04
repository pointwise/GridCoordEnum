package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

proc nm { ent } {
    if { "" != "$ent" } {
        return [$ent getName]
    }
    return ""
}

proc dumpEnts { title ents } {
    puts ""
    puts "$title"
    while { 0 != [llength $ents] } {
        set ents [lassign $ents ent1 ent2 ent3 ent4 ent5 ent6 ent7 ent8 ent9 ent10]
        puts [format "%8s %8s %8s %8s %8s %8s %8s %8s" \
            [nm $ent1] [nm $ent2] [nm $ent3] [nm $ent4] [nm $ent5] \
            [nm $ent6] [nm $ent7] [nm $ent8] [nm $ent9] [nm $ent10]]
    }
}

set dim [pwio::getCaeDim]
puts "CAE Dimension : $dim"

set selType [pwio::getSelectType]
puts "Selection Type: $selType"

if { ![pwio::utils::getSelection $selType selectedEnts errMsg] } {
    puts $errMsg
} elseif { ![pwio::utils::getSupportEnts $selectedEnts selAndSupEnts true] } {
    puts "pwio::utils::getSupportEnts failed"
} else {
    dumpEnts "UNSORTED:" $selAndSupEnts
    dumpEnts "SORTED:" [pwio::utils::sortEntsByType $selAndSupEnts]
    puts ""
    pwio::utils::printEntInfo "TEST" $selAndSupEnts $dim $selectedEnts
}
