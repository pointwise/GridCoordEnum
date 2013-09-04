package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

proc doit { blk ijk } {
    # do a round-trip mapping from ijk to ndx and back to ijk
    set ndx [pwio::utils::entIjkToIndex $blk $ijk]
    set ijk2 [pwio::utils::entIndexToIjk $blk $ndx]
    puts [format "\{%s\} ::> %3s ::> \{%s\}" $ijk $ndx $ijk2]
}

if { ![pwio::utils::getSelection Block blks errMsg] } {
    puts $errMsg
    exit 0
}
foreach blk $blks {
    set ijkdim [$blk getDimensions]
    lassign $ijkdim imax jmax kmax
    puts "--- [$blk getName] ($blk) dim\{$ijkdim\} ---"
    for {set k 1} {$k <= $kmax} {incr k} {
        for {set j 1} {$j <= $jmax} {incr j} {
            for {set i 1} {$i <= $imax} {incr i} {
                doit $blk [list $i $j $k]
            }
        }
    }
    puts ""
}
puts "bad ijk \{[list $i $j $k]\}"

# This will throw a TCL Glyph error if last block is structured.
# This will pwio::utils::assert{} if last block is unstructured.
doit $blk [list $i $j $k]

# Output:

# --- blk-4 (::pw::BlockStructured_1) dim{3 4 3} ---
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
#    ...SNIP...
# {2 4 3} ::>  35 ::> {2 4 3}
# {3 4 3} ::>  36 ::> {3 4 3}
# 
# --- blk-5 (::pw::BlockStructured_2) dim{3 4 3} ---
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
#    ...SNIP...
# {2 4 3} ::>  35 ::> {2 4 3}
# {3 4 3} ::>  36 ::> {3 4 3}
# 
# --- blk-1 (::pw::BlockUnstructured_1) dim{92 1 1} ---
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
#    ...SNIP...
# {91 1 1} ::>  91 ::> {91 1 1}
# {92 1 1} ::>  92 ::> {92 1 1}
# 
# bad ijk {93 2 2}

# ----- TCL TRACE -----
# ERROR: value outside the range [(1,1,1),(3,4,3)]
# ERROR: usage (argument 2): ::pw::BlockStructured_1 getLinearIndex ijk_index
#    OR
# assert failed: (93 >= 1 && 93 <= 92)
# message      : entIndexToIjk: Bad Index 93 for ::pw::BlockUnstructured_1
