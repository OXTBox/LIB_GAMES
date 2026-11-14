<!-- Spark folder manifest of Data/Fluid/3Dnetserver (model spark-x2.6-4b, 2026-11-13 00:13). DRAFT. -->

# Data/Fluid/3Dnetserver
- **Role:** This folder holds the FLUID UI twin for the 3Dnetserver, providing the FLTK interface for the engine's 3D network server functionality. It contains only the FLUID designer text for the corresponding Lua interface, with no supporting code files.
- **Entry point:** none
- **Files:** 3Dnetserver.fl - FLUID twin of the 3Dnetserver Lua interface (FLTK UI designer text)
- **Shared with other folders:** Needs the engine's shared globals and Data folder path conventions to build and load its FLUID interface. No other folders take from it.
- **Procedure candidates:** none
- **Glossary:**
  - FLUID: FLTK user interface designer used to author the UI files.
  - FLTK: the user interface toolkit used by the engine's FLUID files.
  - FLUID twin: the `.fl` file paired with the same-named `.lua` file for the same interface.
- **Verdict:** keep
  Reason: The folder contains only the FLUID twin file needed for the 3Dnetserver interface; it is a valid, self-contained UI asset for the engine.
