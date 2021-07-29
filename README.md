# GridCoordEnum
Copyright 2021 Cadence Design Systems, Inc. All rights reserved worldwide.

A Glyph library that helps with the export of 2D or 3D grid data to an unstructured format.

Exporting grid data to an unstructured format requires the serial enumeration (1 to N) of all unique grid points. However, because Pointwise grid entites share points, *non-trivial* data management is needed to efficiently serialize the grid points. The **pwio** library provides the required data management.

The **pwio** library supports both structured and unstructured Pointwise grid entities. However, structured entities are exported as unstructured quads and hexes.


## Limitations
* Support for 2D boundaries needs work
    * For more information, see the [Access Cell Connectivity / Entity By Entity](#entity-by-entity-access) section.


## Table Of Contents

* [Namespace pwio](#namespace-pwio)
* [Library Reference pwio](#library-reference-pwio)
* [The Export Sequence](#the-export-sequence)
* [Example Usage](#example-usage)
    * [Access Grid Points](#access-grid-points)
    * [Access Cell Connectivity](#access-cell-connectivity)
        * [Entity By Entity Access](#entity-by-entity-access)
        * [Global Access](#global-access)
* [Library Reference pwio::utils](#library-reference-pwioutils)
* [Library Reference pwio::cell](#library-reference-pwiocell)
* [Pointwise Cannonical Order](#pointwise-cannonical-order)
* [Disclaimer](#disclaimer)


## Namespace pwio

All of the procs in this collection reside in the **pwio** namespace.

To call a proc in this collection, you must prefix the proc name with a **pwio::** namespace specifier.

For example:
```Tcl
pwio::beginIO $ents
```

## Library Reference pwio

```Tcl
pwio::beginIO { ents }
```
Prepare a list of grid entities for export. Must be called once at the beginning of an export.
<dl>
  <dt><code>ents</code></dt>
  <dd>The entities to export.</dd>
</dl>

For a 2D grid, `ents` should contain [pw::Domain][pwDomain] entities.

For a 3D grid, `ents` should contain [pw::Block][pwBlock] entities.


----------------------------------------------

```Tcl
pwio::endIO { {clearAllLocks 0} }
```
Cleans up after an export. Must be called once at the end of an export.
<dl>
  <dt><code>clearAllLocks</code></dt>
  <dd>If 1, all entity locks will be released even if <b>pwio</b> did not make them.</dd>
</dl>

Typically, `clearAllLocks` should be 0.


----------------------------------------------

```Tcl
pwio::getCoordCount {}
```
Returns the number of unique grid points in this export.


----------------------------------------------

```Tcl
pwio::getCoord { enumNdx }
```
Get an export grid coord.
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>The grid coord index from 1 to <b>pwio::getCoordCount</b>.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::getCoordIndex { coord {mapCoordToOwner 1} }
```
Returns the index corresponding to a [grid coord][coord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
  <dt><code>mapCoordToOwner</code></dt>
  <dd>If 1, <code>coord</code> needs to be mapped to its owning entity.</dd>
</dl>

If you know that the [grid coord][coord]'s entity is already the owner, this call is faster if you set `mapCoordToOwner` to 0.


----------------------------------------------

```Tcl
pwio::getCellCount {}
```
Returns the number of unique, serialized grid cells in this export.

For a 2D grid, the cells will be of type **tri** or **quad**.

For a 3D grid, the cells will be of type **tet**, **pyramid**, **prism**, or **hex**.


----------------------------------------------

```Tcl
pwio::getCell { enumNdx {vcVarName ""} }
```
Returns an export grid cell as a list of global pwio indices.
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>A grid cell index from 1 to <b>pwio::getCellCount</b>.</dd>
  <dt><code>vcVarName</code></dt>
  <dd>If provided, the cell's volume condition is stored in this variable.</dd>
</dl>

The object stored in vcVarName is a [pw::VolumeCondition][pwVolumeCondition].


----------------------------------------------

```Tcl
pwio::getCellIndex { ent entNdx }
```
Returns the global, export cell index corresponding to an entity's local cell index.
<dl>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>entNdx</code></dt>
  <dd>A cell index in <code>ent</code>'s local index space.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::getCellEdges { enumNdx {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
```
Returns an export cell's edges as a list of global pwio indices.
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>A grid cell index from 1 to <b>pwio::getCellCount</b>.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are reversed, if needed, so that the minimum index value is first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of edge flags. A flag is set to 1 if the
	  edge was min first reversed.</dd>
</dl>

See also, **pwio::getCell**


----------------------------------------------

```Tcl
pwio::getMinFirstCellEdges { enumNdx {cellVarName ""} {revVarName ""} }
```
Returns an export cell's edges as a list of global pwio indices in min first order.
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>A grid cell index from 1 to <b>pwio::getCellCount</b>.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of edge flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

See also, **pwio::getCell**


----------------------------------------------

```Tcl
pwio::getFaceEdges { face {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
```
Returns a list of `face`'s edges. Each edge is a list of global pwio indices (a list of lists).
<dl>
  <dt><code>face</code></dt>
  <dd>A face as a list of global pwio indices.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives a copy of face.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are reversed, if needed, so that the minimum index value is first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of edge flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

See also, **pwio::getCellFaces**


----------------------------------------------

```Tcl
pwio::getMinFirstFaceEdges { face {cellVarName ""} {revVarName ""} }
```
Returns `face`'s edges as a list of global pwio indices in min first order.
<dl>
  <dt><code>face</code></dt>
  <dd>A face as a list of global pwio indices.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives a copy of face.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of edge flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

See also, **pwio::getCellFaces**


----------------------------------------------

```Tcl
pwio::getCellFaces { enumNdx {cellVarName ""} {minFirstOrder 0} }
```
Returns a list of a grid cell's faces. Each face is a list of global pwio indices (a list of lists).
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to <b>pwio::getCellCount</b>.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's unmodified indices.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, the face indices are rotated so that the minimum index value is
      first. The relative ordering of the vertices is not changed (the face
      normal is not flipped).</dd>
</dl>

See also, **pwio::getCell**.


----------------------------------------------

```Tcl
pwio::getMinFirstCellFaces { enumNdx {cellVarName ""} }
```
Returns a list of a grid cell's faces in min first order. Each face is a list of global pwio indices (a list of lists).
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to <b>pwio::getCellCount</b>.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's unmodified indices.</dd>
</dl>

See also, **pwio::getCell**.


----------------------------------------------

```Tcl
pwio::getCellType { enumNdx }
```
Returns the grid cell's type.
<dl>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to <b>pwio::getCellCount</b>.</dd>
</dl>

For a 2D grid, the cell type will be one **tri** or **quad**.

For a 3D grid, the cell type will be one **tet**, **pyramid**, **prism**, or **hex**.


----------------------------------------------

```Tcl
pwio::getFaceType { face }
```
Returns the face type.
<dl>
  <dt><code>face</code></dt>
  <dd>A face as a list of global pwio indices.</dd>
</dl>

For a 2D grid, the face type will be **bar**.

For a 3D grid, the face type will be one **tri** or **quad**.

See also, **pwio::getCellFaces**.


----------------------------------------------

```Tcl
pwio::getEntityCell { ent ndx {localCellVarName ""} }
```
Returns an entity cell as a list of global pwio indices. These indices are only valid for calls to **pwio::getCoord**.
<dl>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
  <dt><code>localCellVarName</code></dt>
  <dd>If provided, this var receives the cell's local indices.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::getEntityCellEdges { ent ndx {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
```
Returns an entity cell's edges as a list of global pwio indices. These indices are only valid for calls to **pwio::getCoord**.
<dl>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are reversed, if needed, so that the minimum index value is first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of edge flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

See also, **pwio::getCell**.


----------------------------------------------

```Tcl
pwio::getMinFirstEntityCellEdges { ent ndx {cellVarName ""} {revVarName ""} }
```
Returns an entity cell's edges as a list of global pwio indices in min first order. These indices are only valid for calls to **pwio::getCoord**.
<dl>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of edge flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

See also, **pwio::getCell**.


----------------------------------------------

```Tcl
pwio::getCaeDim {}
```
Returns 2 if the grid dimensionality is 2D or 3 if the grid dimensionality is 3D.


----------------------------------------------

```Tcl
pwio::getSelectType {}
```
Returns **Domain** if the grid dimensionality is 2D or **Block** if the grid dimensionality is 3D.

See `pwio::utils::getSelection`.


----------------------------------------------

```Tcl
pwio::fixCoord { coordVarName }
```
Returns the [grid coord][coord] corrected to use proper indexing form.
<dl>
  <dt><code>coordVarName</code></dt>
  <dd>Required. The grid coord to be modifed if needed.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::coordMapLower { coord }
```
Returns the [grid coord][coord] mapped to its next lower level entity.
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord to be mapped.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::mapToOwner { coord {trace 0} }
```
Returns the [grid coord][coord] mapped to its owning entity.
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord to be mapped.</dd>
  <dt><code>trace</code></dt>
  <dd>For debugging only. If 1, the mapping sequence is dumped to stdout.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::coordGetEntity { coord }
```
Returns the entity of the [grid coord][coord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::coordGetIjk { coord }
```
Returns the ijk index of the [grid coord][coord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>

----------------------------------------------

```Tcl
pwio::Level
```
Enumerated entity level integer values.

Accessed as:

* **pwio::Level::Block**
* **pwio::Level::Domain**
* **pwio::Level::Connector**
* **pwio::Level::Node**

See also **pwio::coordMapToLevel**, and **pwio::entGetLevel**.


----------------------------------------------

```Tcl
pwio::entGetLevel { entOrBaseType }
```
Returns an entity level value.
<dl>
  <dt><code>entOrBaseType</code></dt>
  <dd>A grid entity or an entity base type.</dd>
</dl>

See also, **pwio::utils::entBaseType**.


----------------------------------------------

```Tcl
pwio::coordGetLevel { coord }
```
Returns an entity level value for the entity in the [grid coord][coord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::coordMapToEntity { fromCoord toEnt coordsVarName }
```
Returns non-zero if `fromCoord` can be mapped to a [grid coord][coord] in `toEnt`.
<dl>
  <dt><code>fromCoord</code></dt>
  <dd>The starting grid coord.</dd>
  <dt><code>toEnt</code></dt>
  <dd>The target grid entity.</dd>
  <dt><code>coordsVarName</code></dt>
  <dd>Required. Receives the list of mapped grid coords.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::coordMapToLevel { coord toLevel coordsVarName }
```
Returns non-zero if `coord` can be mapped to a specific grid level.
<dl>
  <dt><code>coord</code></dt>
  <dd>The starting grid coord.</dd>
  <dt><code>toLevel</code></dt>
  <dd>The target grid level.</dd>
  <dt><code>coordsVarName</code></dt>
  <dd>Required. Receives the list of mapped grid coords.</dd>
</dl>


## The Export Sequence

Exporting a grid using **pwio** requires the same basic sequence:

* Call `pwio::beginIO` with a list of entites to export.
    * A list of [pw::Domain][pwDomain] entites for a 2D export.
    * A list of [pw::Block][pwBlock] entites for a 3D export.
* Access the grid data using **pwio** and Glyph procs.
    * See the [Example Usage](#ExampleUsage) section.
    * See the [Pointwise Cannonical Order](#pointwise-cannonical-order) section.
* Call `pwio::endIO` when finished.


## Example Usage
The following section show how to use **pwio** in conjuction with the standard Glyph calls.

While many formats have a lot in common, each export format will have differing needs. The usage examples given below will not be needed by every exporter.


### Access Grid Points

```Tcl
pwio::beginIO $gridEntsToExport

# Get the number of unique grid points in $gridEntsToExport.
set coordCnt [pwio::getCoordCount]
for {set ii 1} {$ii <= $coordCnt} {incr ii} {
  # Get the grid coord for grid point $ii.
  set coord [pwio::getCoord $ii]

  # Get the physical xyz location of coord. The returned xyz is always in the
  # form {x y z}
  set xyz [pw::Grid getXYZ $coord]

  # Get the location of coord. If coord is database constrained, pt will be in
  # the form {u v dbentity}. If *not* database constrained, pt will be in the
  # form {x y z}.
  set pt [pw::Grid getPoint $coord]

  # Get grid entity that owns this coord.
  set ownerEnt [pw::Grid getEntity $coord]
}

pwio::endIO
```

### Access Cell Connectivity

#### Entity By Entity Access

Accessing interior and boundary cell connectivity is done on an entity by entity
basis.

```Tcl
pwio::beginIO $gridEntsToExport

# Access the top-level pw::Domain (2D) or pw::Block (3D) volume cells.
foreach ent $gridEntsToExport {
  # Get vc asigned to $ent
  set vc [$ent getVolumeCondition]
  # Get the number of cells in $ent.
  set cellCnt [$ent getCellCount]
  for {set ii 1} {$ii <= $cellCnt} {incr ii} {
    # Get $ent cell $ii as a list of global pwio indices. These indices are only
    # valid for calls to pwio::getCoord.
    set cell [pwio::getEntityCell $ent $ii]
  }
}

# Access the pw::Connector (2D) or a pw::Domain (3D) boundary cells.
set bcNames [pw::BoundaryCondition getNames]
foreach bcName $bcNames {
  set bc [pw::BoundaryCondition getByName $bcName]
  # Get the boundary grid entites using $bc. $bcEnts will contain
  # pw::Connector (2D) or a pw::Domain (3D) entities.
  set bcEnts [$bc getEntities]
  # See notes below about handling the boundary entities.
}

pwio::endIO
```

Properly handling the boundary entities is beyond the scope of this example.

Things to consider:

* Only items in `$bcEnts` that are used by `$gridEntsToExport` entities should
  be exported (connectors used by domains, domains used by blocks).
* When exporting 2D boundaries:
   * The [pw::Connector][pwConnector] (linear) cells are defined as two consecutive local connector points *{0 1}, {1 2}*, etc.
   * The local cell indices must be mapped to global **pwio** indices using `pwio::getCoordIndex`.
* When exporting 3D boundaries:
   * The [pw::Domain][pwDomain] boundary cells can be enumerated in a manner similar to the volume cells example.


#### Global Access
Like grid points, some export formats require the serial enumeration (1 to N) of
all unique cells.

```Tcl
pwio::beginIO $gridEntsToExport

# Get the number of cells in $gridEntsToExport.
set cellCnt [pwio::getCellCount]
for {set ii 1} {$ii <= $cellCnt} {incr ii} {
  # Get grid cell $ii. cell is a list of grid coord indices.
  # These indices correspond to the coords returned by [pwio::getCoord $ii]
  set cell [pwio::getCell $ii vc]
}

pwio::endIO
```


## Library Reference pwio::utils

[Documentation for pwio::utils](pwio-utils.md)


## Library Reference pwio::cell

[Documentation for pwio::cell](pwio-cell.md)


## Pointwise Cannonical Order

The cell and face lists returned by these procs arrange the indices in Pointwise cannonical order.

The ordering is defined as follows:

![Pointwise Cell and Face Cannonical Ordering][1]

[1]: https://raw.github.com/pointwise/GridCoordEnum/master/CellConnectivity.png  "Pointwise Cell and Face Cannonical Ordering"



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
