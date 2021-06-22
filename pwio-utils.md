| [README.md](README.md) | [pwio-cell.md](pwio-cell.md) |

# glyph-pwio::utils
Copyright 2021 Cadence Design Systems, Inc. All rights reserved worldwide.

A collection of utility procs.


## Table Of Contents

* [Namespace pwio::utils](#namespace-pwioutils)
* [Library Reference pwio::utils](#library-reference-pwioutils)
* [Example Usage](#example-usage)
    * [Example 1](#example-1)
    * [Example 2](#example-2)
* [Disclaimer](#disclaimer)


## Namespace pwio::utils

All of the procs in this collection reside in the **pwio::utils** namespace.

To call a proc in this collection, you must prefix the proc name with a **pwio::utils::** namespace specifier.

For example:
```Tcl
pwio::utils::entBaseType $ent
```


## Library Reference pwio::utils

```Tcl
pwio::utils::assert { cond msg {exitVal -1} }
```
Asserts that `cond` evaluates to **true**. If **false**, `msg` is displayed and the script is terminated returning `exitVal`.
<dl>
  <dt><code>cond</code></dt>
  <dd>The condition to test.</dd>
  <dt><code>msg</code></dt>
  <dd>The message to display if <code>cond</code> evaluates to <b>false</b>.</dd>
  <dt><code>exitVal</code></dt>
  <dd>The fail exit value. If 0, the script will <b>not</b> exit and execution will continue.</dd>
</dl>

**Usage:**
```Tcl
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
```


----------------------------------------------

```Tcl
pwio::utils::entBaseType { ent {subTypeVarName ""} }
```
Returns `ent`'s base grid entity type.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>subTypeVarName</code></dt>
  <dd>If provided, <code>ent</code>'s subtype is stored in this variable.</dd>
</dl>

Base grid types are one of **Node**, **Connector**, **Domain**, or **Block**.

For blocks, the subtype will be one of **Structured**, **Unstructured** or **Extruded**.

For domains, the subtype will be one of **Structured** or **Unstructured**.

For connectors, the subtype is set to **Connector**.

For nodes, the subtype is set to **Node**.

**Usage:**
```Tcl
package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

foreach selType {Block Domain Connector} {
    if { ![pwio::utils::getSelection $selType selectedEnts errMsg] } {
        puts $errMsg
        continue;
    }
    puts "$selType selection:"
    foreach ent $selectedEnts {
        set baseType [pwio::utils::entBaseType $ent subType]
        puts "  [$ent getName]($ent) baseType='$baseType' subType='$subType'"
    }
}

# Output:
# Block selection:
#   blk-4(::pw::BlockStructured_1) baseType='Block' subType='Structured'
#   blk-5(::pw::BlockStructured_2) baseType='Block' subType='Structured'
# Domain selection:
#   dom-14(::pw::DomainUnstructured_2) baseType='Domain' subType='Unstructured'
#   dom-27(::pw::DomainStructured_14) baseType='Domain' subType='Structured'
# Connector selection:
#   con-44(::pw::Connector_20) baseType='Connector' subType='Connector'
#   con-56(::pw::Connector_33) baseType='Connector' subType='Connector'
```


----------------------------------------------

```Tcl
pwio::utils::getBlockFaces { blk }
```
Returns an list of `blk`'s face entities.
<dl>
  <dt><code>blk</code></dt>
  <dd>A block entity.</dd>
</dl>

The returned list contains [pw::Face][pwFace] entities.

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getBlockDomains { blk }
```
Returns `blk`'s domains as a list of [pw::Domain][pwDomain] entities. It is possible for a domain to appear in the list more than once.
<dl>
  <dt><code>blk</code></dt>
  <dd>A block entity.</dd>
</dl>

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getFaceDomains { face }
```
Returns `face`'s domains as a list of [pw::Domain][pwDomain] entities. It is possible for a domain to appear in the list more than once.
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getFaceEdges { face }
```
Returns `face`'s edges as a list of [pw::Edge][pwEdge] entities. The first edge is `face`'s outer loop. Any additional edges are inner loops (holes).
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getEdgeConnectors { edge }
```
Returns `edge`'s connectors as a list of [pw::Connector][pwConnector] entities. It is possible for a connector to appear in the list more than once.
<dl>
  <dt><code>edge</code></dt>
  <dd>An edge entity.</dd>
</dl>

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getFaceEdgeConnectors { face }
```
Returns `face`'s connectors as a list of [pw::Connector][pwConnector] entities. It is possible for a connector to appear in the list more than once.
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::utils::getPerimeterPointCount { ent }
```
Returns the number of [grid points][point] on `ent`'s outer perimeter. This count includes any holes or voids. Nodes will always return 0. Connectors will always return 2.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

`ent` must be a [pw::Node][pwNode], [pw::Connector][pwConnector], [pw::Domain][pwDomain], [pw::Face][pwFace] or [pw::Block][pwBlock] entity.

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getOwnedPointCount { ent }
```
Returns the number of [grid points][point] on `ent`'s interior (non-perimeter points). Nodes will always return 1.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

`ent` must be a [pw::Node][pwNode], [pw::Connector][pwConnector], [pw::Domain][pwDomain], [pw::Face][pwFace] or [pw::Block][pwBlock] entity.

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::isBndryEnt { ent allEnts }
```
Returns **true** if `ent` lies on the boundary of `allEnts`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>allEnts</code></dt>
  <dd>A list of grid entites.</dd>
</dl>

An error will occur if `ent` is anything other than a [pw::Connector][pwConnector] entity in 2D and anything other than a [pw::Domain][pwDomain] entity in 3D.

For usage, see [Example 2](#example-2).


----------------------------------------------

```Tcl
pwio::utils::getNodeDbEnt { node dbEntVarName }
```
Returns **true** if `node` is constrained to a DB entity.
<dl>
  <dt><code>node</code></dt>
  <dd>A node entity.</dd>
  <dt><code>dbEntVarName</code></dt>
  <dd>Required. If constrained, the DB entity is stored in this variable.</dd>
</dl>

`node` must be a [pw::Node][pwNode] entity.


----------------------------------------------

```Tcl
pwio::utils::entLockInterior { ent }
```
Locks `ent`'s [grid points][point].
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

A corresponding call to **pwio::utils::entUnlockInterior** must be made when
finished.

Locking and unlocking entities is typically not needed in scripts using
**pwio**. Locking and unlocking is already performed by **pwio::beginIO** and
**pwio::endIO** respectively.

Locking interior points improves I/O performance. A locked entity cannot be
changed until it is unlocked. Consequently, Pointwise is able to skip
potentially *expensive* data operations when accessing locked entities.
Currently, only unrefined, structured blocks benefit from locking. However, more
entity types may use locking in the future.

**Usage:**
```Tcl
pwio::utils::entLockInterior $ent
# do something with $ent
pwio::utils::entUnlockInterior $ent
```


----------------------------------------------

```Tcl
pwio::utils::entUnlockInterior { ent {clearAllLocks 0} }
```
Unlocks `ent`'s [grid points][point].
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity previously locked with a call to <b>pwio::utils::entLockInterior</b>.</dd>
  <dt><code>clearAllLocks</code></dt>
  <dd>If 1, all active locks on <code>ent</code> will be released.</dd>
</dl>

Under normal circumstances, `clearAllLocks` should be 0.

For usage and more information about entity locking, see
**pwio::utils::entLockInterior**.


----------------------------------------------

```Tcl
pwio::utils::ijkToIndexStructured { ijk ijkdim }
```
Returns the linear index corresponding to `ijk` within the given `ijkdim` extents.
<dl>
  <dt><code>ijk</code></dt>
  <dd>The ijk index list to convert.</dd>
  <dt><code>ijkdim</code></dt>
  <dd>A list defining the full structured extents used for conversion.</dd>
</dl>

This proc does **not** check if `ijk` lies within the given `ijkdim` extents. If `ijk` is invalid, the returned index is invalid.

The reverse mapping is done with **pwio::utils::indexToIjkStructured**.

**Usage:**
```Tcl
package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

proc doit { ijk ijkdim } {
    # do a round-trip mapping from ijk to ndx and back to ijk
    set ndx [pwio::utils::ijkToIndexStructured $ijk $ijkdim]
    set ijk2 [pwio::utils::indexToIjkStructured $ndx $ijkdim]
    puts [format "\{%s\} ::> %3s ::> \{%s\}" $ijk $ndx $ijk2]
}

# Define the ijkdim index space (indices 1..max)
set ijkdim [list 5 4 3]
lassign $ijkdim imax jmax kmax
puts "Using ijkdim \{$ijkdim\}"
for {set k 1} {$k <= $kmax} {incr k} {
    for {set j 1} {$j <= $jmax} {incr j} {
        for {set i 1} {$i <= $imax} {incr i} {
            doit [list $i $j $k] $ijkdim
        }
    }
}
# this will fail
puts "bad ijk \{[list $i $j $k]\}"
doit [list $i $j $k] $ijkdim

# Output:
# Using ijkdim {5 4 3}
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
#    ...SNIP...
# {4 4 3} ::>  59 ::> {4 4 3}
# {5 4 3} ::>  60 ::> {5 4 3}
# bad ijk {6 5 4}
# assert failed: (86 > 0 && 86 <= (5 * 4 * 3))
# message      : indexToIjkStructured: Invalid ndx (86)
```


----------------------------------------------

```Tcl
pwio::utils::indexToIjkStructured { ndx ijkdim }
```
Returns the ijk index corresponding to `ndx` within the given `ijkdim` extents.
<dl>
  <dt><code>ndx</code></dt>
  <dd>The linear index to convert.</dd>
  <dt><code>ijkdim</code></dt>
  <dd>A list defining the full structured extents used for conversion.</dd>
</dl>

The reverse mapping is done with **pwio::utils::ijkToIndexStructured**.

For usage, see **pwio::utils::ijkToIndexStructured**.


----------------------------------------------

```Tcl
pwio::utils::entIjkToIndex { ent ijk }
```
Returns `ent`'s linear index that corresponds to `ijk`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ijk</code></dt>
  <dd>The ijk index list to convert.</dd>
</dl>

The reverse mapping is done with **pwio::utils::entIndexToIjk**.

**Usage:**
```Tcl
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
```


----------------------------------------------

```Tcl
pwio::utils::entIndexToIjk { ent ndx }
```
Returns `ent`'s ijk index that corresponds to `ndx`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The linear index to convert.</dd>
</dl>

The reverse mapping is done with **pwio::utils::entIjkToIndex**.

For usage, see **pwio::utils::entIjkToIndex**.


----------------------------------------------

```Tcl
pwio::utils::makeCoord { ent ijk }
```
Returns a [grid coord][coord] for the given `ent` and `ijk`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ijk</code></dt>
  <dd>An ijk index list.</dd>
</dl>

**Usage:**
```Tcl
# $strBlk is a 5x5x5 structured block
set sCoord [pwio::utils::makeCoord $strBlk {3 2 1}]

# $unsBlk is a 128 point unstructured block
set uCoord [pwio::utils::makeCoord $unsBlk {64 1 1}]
```


----------------------------------------------

```Tcl
pwio::utils::makeCoordFromIjkVals { ent i j k }
```
Returns a [grid coord][coord] for the given `ent` and `i`, `j` and `k` index values.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>i</code> <code>j</code> <code>k</code></dt>
  <dd>The individual i, j and k index values.</dd>
</dl>

**Usage:**
```Tcl
# $strBlk is a 5x5x5 structured block
set sCoord [pwio::utils::makeCoordFromIjkVals $strBlk 3 2 1]

# $unsBlk is a 128 point unstructured block
set uCoord [pwio::utils::makeCoordFromIjkVals $unsBlk 64 1 1]
```


----------------------------------------------

```Tcl
pwio::utils::makeCoordFromEntIndex { ent ndx }
```
Returns a [grid coord][coord] for the given `ent` and linear index.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>A 1-based index relative to <code>ent</code>'s index space.</dd>
</dl>

**Usage:**
```Tcl
# $strBlk is a 5x5x5 structured block
set sCoord [pwio::utils::makeCoordFromEntIndex $strBlk 8]

# $unsBlk is a 128 point unstructured block
set uCoord [pwio::utils::makeCoordFromEntIndex $unsBlk 64]
```


----------------------------------------------

```Tcl
pwio::utils::sortEntsByType { ents }
```
Returns a list containing `ents` in base type sorted order.
<dl>
  <dt><code>ents</code></dt>
  <dd>The list of grid entites to sort.</dd>
</dl>

The returned list will be in **Block**, **Domain**, **Connector**, **Node** order.

For usage, see [Example 1](#example-1).


----------------------------------------------

```Tcl
pwio::utils::pointToString { pt }
```
Returns a string representation of `pt`.
<dl>
  <dt><code>pt</code></dt>
  <dd>A grid point list.</dd>
</dl>

`pt` is a [grid point][point].

The resulting string will be one of *"{x y z}"* or *"{u v dbEnt}"*.


----------------------------------------------

```Tcl
pwio::utils::xyzEqual { xyz1 xyz2 {tol 1e-8} }
```
Returns **true** if two xyz points are equal within the given tolerance.
<dl>
  <dt><code>xyz1</code></dt>
  <dd>First point as an <b>{x y z}</b> list.</dd>
  <dt><code>xyz2</code></dt>
  <dd>Second point as an <b>{x y z}</b> list.</dd>
  <dt><code>tol</code></dt>
  <dd>The optional comparison tolerance.</dd>
</dl>

**Usage:**
```Tcl
# default tolerance
puts [pwio::utils::xyzEqual {1.0 2.0 3.0} {1.1 2.0 3.0}]

# 0.2 tolerance
puts [pwio::utils::xyzEqual {1.0 2.0 3.0} {1.1 2.0 3.0} 0.2]

# Output:
# 0
# 1
```


----------------------------------------------

```Tcl
pwio::utils::valEqual { val1 val2 {tol 1e-8} }
```
Returns **true** if two values are equal within the given tolerance.
<dl>
  <dt><code>val1</code></dt>
  <dd>First value.</dd>
  <dt><code>val2</code></dt>
  <dd>Second value.</dd>
  <dt><code>tol</code></dt>
  <dd>The optional comparison tolerance.</dd>
</dl>

**Usage:**
```Tcl
# default tolerance
puts [pwio::utils::valEqual 1.0 1.1]

# 0.2 tolerance
puts [pwio::utils::valEqual 1.0 1.1 0.2]

# Output:
# 0
# 1
```


----------------------------------------------

```Tcl
pwio::utils::coordToPtString { coord }
```
Returns a string representation of a [grid coord][coord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>

**Usage:**
```Tcl
# $unsBlk is a 128 point unstructured block
set coord [pwio::utils::makeCoordFromEntIndex $unsBlk 64]
puts [pwio::utils::coordToPtString $coord]

# Output if coord is not DB constrained:
# {1.0 2.0 3.0}

# Output if coord is DB constrained:
# {1.0 2.0 3.0} @ {0.73 0.48 ::pw::Blockunstructured_1}
```


----------------------------------------------

```Tcl
pwio::utils::vcToString { vc }
```
Returns a string representation of a [pw::VolumeCondition][pwVolumeCondition].
<dl>
  <dt><code>vc</code></dt>
  <dd>The volume condition.</dd>
</dl>

The resulting string format will be *"vcName vcId vcPhysicalType"*

**Usage:**
```Tcl
# "myVC" must exist
set vc [pw::VolumeCondition getByName "myVC"]
puts "'[pwio::utils::vcToString $vc]'"

# Output:
# 'myVC 3 Wall'
```


----------------------------------------------

```Tcl
pwio::utils::labelPt { ndx pt }
```
Returns a [pw::Note][pwNote] entity positioned at `pt`.
<dl>
  <dt><code>ndx</code></dt>
  <dd>The note text value.</dd>
  <dt><code>pt</code></dt>
  <dd>The note's position.</dd>
</dl>

This proc is primarily used for debugging.

**Usage:**
```Tcl
pwio::utils::labelPt 3 {1.0 2.0 3.0}
pwio::utils::labelPt "hello" {10.0 2.0 3.0}
```


----------------------------------------------

```Tcl
pwio::utils::printEntInfo { title ents {dim 0} {allEnts {}} }
```
Dumps a table of information about `ents`.
<dl>
  <dt><code>title</code></dt>
  <dd>The dump's title string.</dd>
  <dt><code>ents</code></dt>
  <dd>A list of grid entites to dump.</dd>
  <dt><code>dim</code></dt>
  <dd>The optional dimensionality used for the dump. If specified, it must be 2 or 3.</dd>
  <dt><code>allEnts</code></dt>
  <dd>An optional list of grid entites used to classify the dumped entities as either a boundary or connection.</dd>
</dl>

`allEnts` is ignored if `dim` is 0.

For usage, see [Example 1](#example-1).


----------------------------------------------

```Tcl
pwio::utils::getSelection { selType selectedVarName errMsgVarName }
```
Prompts the user and returns **true** if one or more entities have been selected.
<dl>
  <dt><code>selType</code></dt>
  <dd>The entity base type to select.</dd>
  <dt><code>selectedVarName</code></dt>
  <dd>Required. The selected entities are stored in this variable.</dd>
  <dt><code>errMsgVarName</code></dt>
  <dd>Required. If <b>false</b> is returned, a failure message is stored in this variable.</dd>
</dl>

The valid `selType` values are **Connector**, **Domain**, **Block**, **Database**, **Spacing** or **Boundary**.

Only visible and enabled entities are considered for selection.

If only 1 entity of the the given `selType` is selectable, it is returned **without** prompting the user.

See also, **pwio::getSelectType**.

For usage, see [Example 1](#example-1), [Example 2](#example-2), **pwio::utils::entBaseType**.


----------------------------------------------

```Tcl
pwio::utils::getSupportEnts { ents supEntsVarName {addEnts false}}
```
Returns **true** if the number of unique support entities stored in `supEntsVarName` is greater than 0.
<dl>
  <dt><code>ents</code></dt>
  <dd>A list of grid entites for which to get support entities.</dd>
  <dt><code>supEntsVarName</code></dt>
  <dd>Required. The lower level support entities are stored in this variable.</dd>
  <dt><code>addEnts</code></dt>
  <dd>If <b>true</b>, <code>ents</code> will also be added to <code>supEntsVarName</code>.</dd>
</dl>

A support entity is any lower level grid entity used to construct a higher level grid entity.

A [pw::Domain][pwDomain]'s support entities are its defining [pw::Connector][pwConnector]s and [pw::Node][pwNode]s.

A [pw::Block][pwBlock]'s support entities are its defining [pw::Domain][pwDomain]s, [pw::Connector][pwConnector]s and [pw::Node][pwNode]s.

Only [pw::Domain][pwDomain]s, [pw::Connector][pwConnector]s and [pw::Node][pwNode]s can be support entities.

Shared support entities are only included in `supEntsVarName` once.

For usage, see [Example 1](#example-1).


## Example Usage

The output for these examples was generated from the grid file [example.pw][2].

![The example grid][1]

[1]: https://raw.github.com/pointwise/GridCoordEnum/master/GridModel.png  "The example grid"
[2]: https://raw.github.com/pointwise/GridCoordEnum/master/test/example.pw  "The example grid file"


### Example 1

```Tcl
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
```

*Output:*

    CAE Dimension : 3
    Selection Type: Block
    
    UNSORTED:
      Node_4   Node_5   Node_6   Node_7   Node_8   dom-23   dom-24   Node_9
      dom-26    blk-5   dom-27   dom-28   dom-29  Node_10  Node_11  Node_12
      con-26   con-27   con-28   con-19   con-40   con-41   con-42   con-43
      con-46    con-1   con-47   con-48   con-49   con-50   con-51   con-52
      dom-11   con-55   con-56   con-57   dom-20   dom-21    dom-1   dom-22
      Node_3                                                               
    
    SORTED:
       blk-4    blk-5   dom-23   dom-24   dom-25   dom-26   dom-27   dom-28
      dom-20   dom-21    dom-1   dom-22   con-26   con-27   con-28   con-19
      con-42   con-43   con-44   con-45   con-46    con-1   con-47   con-48
      con-51   con-52   con-53   con-54   con-55   con-56   con-57   Node_4
      Node_7   Node_8   Node_9  Node_10  Node_11  Node_12  Node_13  Node_14
      Node_3                                                               
    
    TEST
    | Entity                      | Name       |   NumPts |  DbPts | Dim     | BaseType   | BorC  |
    | --------------------------- | ---------- | -------- | ------ | ------- | ---------- | ----- |
    | ::pw::BlockStructured_1     | blk-4      |       36 |        | 3 4 3   | Block      |       |
    | ::pw::BlockStructured_2     | blk-5      |       36 |        | 3 4 3   | Block      |       |
    | ::pw::DomainStructured_10   | dom-23     |        9 |        | 3 3     | Domain     | Bndry |
    | ::pw::DomainStructured_11   | dom-24     |       12 |      1 | 4 3     | Domain     | Bndry |
    ...SNIP...
    | ::pw::DomainStructured_8    | dom-1      |       12 |        | 3 4     | Domain     | Cnxn  |
    | ::pw::DomainStructured_9    | dom-22     |        9 |        | 3 3     | Domain     | Bndry |
    | ::pw::Connector_10          | con-26     |        4 |        | 4       | Connector  |       |
    | ::pw::Connector_11          | con-27     |        3 |      3 | 3       | Connector  |       |
    ...SNIP...
    | ::pw::Connector_28          | con-51     |        4 |        | 4       | Connector  |       |
    | ::pw::Connector_29          | con-52     |        3 |      1 | 3       | Connector  |       |
    | ::pw::Connector_30          | con-53     |        3 |        | 3       | Connector  |       |
    | ::pw::Connector_31          | con-54     |        3 |        | 3       | Connector  |       |
    | ::pw::Connector_32          | con-55     |        3 |      1 | 3       | Connector  |       |
    | ::pw::Connector_33          | con-56     |        3 |        | 3       | Connector  |       |
    | ::pw::Connector_34          | con-57     |        4 |        | 4       | Connector  |       |
    | ::pw::Node_4                | Node_4     |        1 |      1 | 1       | Node       |       |
    ...SNIP...
    | ::pw::Node_2                | Node_2     |        1 |        | 1       | Node       |       |
    | ::pw::Node_3                | Node_3     |        1 |      1 | 1       | Node       |       |


### Example 2

```Tcl
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
```

*Output:*

    --------------------------------------------------------------------
    BLOCK blk-4 (::pw::BlockStructured_1) | perim 34 | owned 2
      BLOCK DOM dom-11(::pw::DomainStructured_3) | perim 10 | owned 2 | usage Connection
      BLOCK DOM dom-28(::pw::DomainStructured_15) | perim 10 | owned 2 | usage Boundary
      BLOCK DOM dom-22(::pw::DomainStructured_9) | perim 8 | owned 1 | usage Boundary
      BLOCK DOM dom-24(::pw::DomainStructured_11) | perim 10 | owned 2 | usage Boundary
      BLOCK DOM dom-26(::pw::DomainStructured_13) | perim 8 | owned 1 | usage Boundary
      BLOCK DOM dom-1(::pw::DomainStructured_8) | perim 10 | owned 2 | usage Boundary
      BLOCK FACE ::pw::FaceStructured_1 | perim 10 | owned 0
        FACE DOM dom-11 (::pw::DomainStructured_3)
        FACE EDGE ::pw::Edge_67
          EDGE CON con-19 (::pw::Connector_3) | perim 2 | owned 1
        FACE EDGE ::pw::Edge_68
          EDGE CON con-26 (::pw::Connector_10) | perim 2 | owned 2
        FACE EDGE ::pw::Edge_69
          EDGE CON con-27 (::pw::Connector_11) | perim 2 | owned 1
        FACE EDGE ::pw::Edge_70
          EDGE CON con-28 (::pw::Connector_12) | perim 2 | owned 2
    ...SNIP...
      BLOCK FACE ::pw::FaceStructured_6 | perim 10 | owned 0
        FACE DOM dom-1 (::pw::DomainStructured_8)
        FACE EDGE ::pw::Edge_87
          EDGE CON con-1 (::pw::Connector_23) | perim 2 | owned 1
        FACE EDGE ::pw::Edge_88
          EDGE CON con-51 (::pw::Connector_28) | perim 2 | owned 2
        FACE EDGE ::pw::Edge_89
          EDGE CON con-54 (::pw::Connector_31) | perim 2 | owned 1
        FACE EDGE ::pw::Edge_90
          EDGE CON con-57 (::pw::Connector_34) | perim 2 | owned 2

    --------------------------------------------------------------------
    BLOCK blk-1 (::pw::BlockUnstructured_1) | perim 48 | owned 44
      BLOCK DOM dom-8(::pw::DomainUnstructured_1) | perim 10 | owned 4 | usage Boundary
      BLOCK DOM dom-9(::pw::DomainStructured_1) | perim 10 | owned 2 | usage Boundary
      BLOCK DOM dom-10(::pw::DomainStructured_2) | perim 10 | owned 2 | usage Boundary
      BLOCK DOM dom-11(::pw::DomainStructured_3) | perim 10 | owned 2 | usage Connection
      BLOCK DOM dom-12(::pw::DomainStructured_4) | perim 10 | owned 2 | usage Boundary
      BLOCK DOM dom-13(::pw::DomainStructured_5) | perim 10 | owned 2 | usage Boundary
      BLOCK DOM dom-14(::pw::DomainUnstructured_2) | perim 10 | owned 4 | usage Boundary
      BLOCK FACE ::pw::FaceUnstructured_1 | perim 0 | owned 0
        FACE DOM dom-8 (::pw::DomainUnstructured_1)
        FACE DOM dom-9 (::pw::DomainStructured_1)
        FACE DOM dom-10 (::pw::DomainStructured_2)
        FACE DOM dom-11 (::pw::DomainStructured_3)
        FACE DOM dom-12 (::pw::DomainStructured_4)
        FACE DOM dom-13 (::pw::DomainStructured_5)
        FACE DOM dom-14 (::pw::DomainUnstructured_2)


### Disclaimer
This file is licensed under the Cadence Public License Version 1.0 (the "License"), a copy of which is found in the LICENSE file, and is distributed "AS IS." 
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE. 
Please see the License for the full text of applicable terms.

[coord]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GgGlyph-cxx.html#coord "What is a grid coord?"

[point]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GgGlyph-cxx.html#point "What is a grid point?"

[pwVolumeCondition]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphVolumeCondition-cxx.html "What is a volume condition?"

[pwBoundaryCondition]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphBoundaryCondition-cxx.html "What is a boundary condition?"

[pwNote]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphNote-cxx.html "What is a pw::Note?"

[pwBlock]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphBlock-cxx.html "What is a pw::Block?"

[pwDomain]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphDomain-cxx.html "What is a pw::Domain?"

[pwConnector]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphConnector-cxx.html "What is a pw::Connector?"

[pwNode]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphNode-cxx.html "What is a pw::Node?"

[pwEdge]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphEdge-cxx.html "What is a pw::Edge?"

[pwFace]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphFace-cxx.html "What is a pw::Face?"
