# Numberical Algorithms - Space Bodies

## Building the code
// To build and run this file:
// - cd to it's parent directory
// - type 'make serial' or 'make parallel' based on how you want to run it

## Running in Paraview
- Open Paraview (www.paraview.org)
- Select File/open and select all the results files. Press the Apply button.
- Click into the left visualisation window (usually titled Layout #1).
- Click the result-* item in the window Pipeline Browser. Ensure that your Layout #1 and the item result-* is marked.
- Select Filters/Alphabetical/TableToPoints. Press Apply button.
- Switch the representation (on top) from Surface into Points.
- Press the play button and adopt colours and point sizes.
- For some Paraview versions, you have to mark your TableToPoints item (usually called TableToPoints1) and explicitly select that X Column is x, Y Column is y, and Z Column is z.
- What is pretty cool is the Filter TemporalParticlesToPathlines. If you set Mask Points to 1, you see a part of the trajactory.

## To do
- Seperate concerns
