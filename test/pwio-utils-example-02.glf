package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

if { ![pwio::utils::getSelection Block blks errMsg] } {
    puts $errMsg
    exit 0
}
foreach blk $blks {
    set perimPtCnt [pwio::utils::getPerimeterPointCount $blk]
    set ownedPtCnt [pwio::utils::getOwnedPointCount $blk]
    puts "--------------------------------------------------------------------"
    puts "BLOCK [$blk getName] ($blk) | perim $perimPtCnt | owned $ownedPtCnt"
    set doms [pwio::utils::getBlockDomains $blk]
    foreach dom $doms {
        if { [pwio::utils::isBndryEnt $dom $blks] } {
            set domUsage "Boundary"
        } else {
            set domUsage "Connection"
        }
        set perimPtCnt [pwio::utils::getPerimeterPointCount $dom]
        set ownedPtCnt [pwio::utils::getOwnedPointCount $dom]
        puts "  BLOCK DOM [$dom getName]($dom) | perim $perimPtCnt | owned $ownedPtCnt | usage $domUsage"
    }

    set faces [pwio::utils::getBlockFaces $blk]
    foreach face $faces {
        set perimPtCnt [pwio::utils::getPerimeterPointCount $face]
        set ownedPtCnt [pwio::utils::getOwnedPointCount $face]
        puts "  BLOCK FACE $face | perim $perimPtCnt | owned $ownedPtCnt"
        set doms [pwio::utils::getFaceDomains $face]
        foreach dom $doms {
            puts "    FACE DOM [$dom getName] ($dom)"
        }
        set edges [pwio::utils::getFaceEdges $face]
        foreach edge $edges {
            puts "    FACE EDGE $edge"
            set cons [pwio::utils::getEdgeConnectors $edge]
            foreach con $cons {
                set perimPtCnt [pwio::utils::getPerimeterPointCount $con]
                set ownedPtCnt [pwio::utils::getOwnedPointCount $con]
                puts "      EDGE CON [$con getName] ($con) | perim $perimPtCnt | owned $ownedPtCnt"
            }
        }
    }
    puts ""
}
