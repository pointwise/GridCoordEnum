| [README.md](README.md) | [pwio-utils.md](pwio-utils.md) |

# glyph-pwio::cell
Copyright 2021 Cadence Design Systems, Inc. All rights reserved worldwide.

A collection of procs supporting the manipulation of cells.


## Table Of Contents

* [Namespace pwio::cell](#namespace-pwiocell)
* [Library Reference pwio::cell](#library-reference-pwiocell)
* [Disclaimer](#disclaimer)


## Namespace pwio::cell

All of the procs in this collection reside in the `pwio::cell` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::cell::` namespace specifier.

For example:
```Tcl
pwio::cell::getEdges $cell
```

The cell and face lists passed to these procs are required to be in [Pointwise cannonical order](README.md#pointwise-cannonical-order).

These procs determine the `cell` and `face` dimensionality using `pwio::getCaeDim`.

* If `pwio::getCaeDim` is 2
    * `cell` can be a quad (4 indices) or a tri (3 indices)
    * `face` can only be a bar (2 indices)
* If `pwio::getCaeDim` is 3
    * `cell` can be a hex (8 indices), prism/wedge (6 indices), pyramid (5 indices) or a tet (4 indices)
    * `face` can be a quad (4 indices) or a tri (3 indices)


## Library Reference pwio::cell

```Tcl
pwio::cell::getEdges { cell {minFirstOrder 0} {revVarName ""} }
```
Returns `cell`'s edges as a list. Each edge is itself a list (a list of lists).
<dl>
  <dt><code>cell</code></dt>
  <dd>The cell as a list of indices.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, cell indices are rearranged with the minimum index first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
	  corresponding edge was min first reversed.</dd>
</dl>


----------------------------------------------

```Tcl
pwio::cell::getFaces { cell {minFirstOrder 0} }
```
Returns `cell`'s faces as a list. Each face is itself a list (a list of lists).
<dl>
  <dt><code>cell</code></dt>
  <dd>The cell as a list of indices.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, the face indices are *rotated* such that the minimum index is
      first. The relative ordering of the vertices is not changed (the face
      normal is *not* flipped).</dd>
</dl>


----------------------------------------------

```Tcl
pwio::cell::getFaceEdges { face {minFirstOrder 0} {revVarName ""} }
```
Returns `face`'s edges as a list. Each edge is itself a list (a list of lists).
<dl>
  <dt><code>face</code></dt>
  <dd>The face as a list of indices.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
	  corresponding edge was min first reversed.</dd>
</dl>



### Disclaimer
This file is licensed under the Cadence Public License Version 1.0 (the "License"), a copy of which is found in the LICENSE file, and is distributed "AS IS." 
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE. 
Please see the License for the full text of applicable terms.
