<!-- Spark folder manifest of Data/Emitters/warhammer (model spark-x2.6-4b, 2026-11-12 19:05). DRAFT. -->

# Data/Emitters/warhammer
- **Role:** This folder holds particle emitter settings for the warhammer game, one configuration block per `.emt` emitter file so particle behavior is defined directly in the file contents. It provides no executable logic beyond declaring emitter settings, with no external dependencies or generated assets.
- **Entry point:** none
- **Files:** attackarrow.emt - particle emitter settings for the attack arrow emitter; bluecircle.emt - particle emitter settings for the blue circle emitter; redfloor.emt - particle emitter settings for the red floor emitter; redfloorvibro.emt - particle emitter settings for the red floor vibro emitter.
- **Shared with other folders:** needs nothing from elsewhere; other folders take emitter settings from this folder when particles are configured for warhammer.
- **Procedure candidates:** none
- **Glossary:** emitter-settings - configuration block defining particle emitter behavior; `.emt` - particle emitter settings file; particle behavior - behavior defined by emitter settings; Emitters folder - folder containing particle emitter settings files.
- **Verdict:** keep - it is a standard reference for emitter configuration used across the Emitters folder, providing one configuration block per emitter file with no external dependencies or generated assets.
