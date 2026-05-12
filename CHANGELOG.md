# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0] - 2026-05-13

### Added
- **Deployment Infrastructure**:
    - Added `vercel.json` configuration for Vercel Serverless Functions deployment.
    - Added a multi-stage `Dockerfile` for efficient containerization and binary compilation.
    - Implemented a GitHub Actions CI/CD pipeline (`ci.yml`) for automated builds and integration testing.
    - Added `.gitignore` and `.dockerignore` for improved repository hygiene.

### Changed
- **Code Quality & Maintenance**:
    - Refactored `app.py` to use absolute paths for the lexer binary and added robust existence checks.
    - Properly formatted `src/lexer/lexer.l` with logical grouping, aligned actions, and modular regex components.
    - Updated `requirements.txt` with `gunicorn` for production-grade web serving.
- **Documentation**:
    - Professionally overhauled `README.md` with technical specifications, removing non-technical elements for an authoritative presentation.

### Fixed
- **Lexer Path Resolution**: Resolved potential path issues in serverless environments by implementing dynamic directory discovery in the backend.

## [2.0.0] - 2026-05-13

### Added
- **GSAP Motion System**:
    - Integrated GSAP for high-energy entrance reveals and scroll-triggered animations.
    - Implemented a "Floating Blob" background system with semi-transparent, moving color gradients for a modern, fluid aesthetic.
- **Smart Floating Navigation**:
    - Overhauled the navbar with a "Smart Floating" behavior that responds to scroll depth.
    - Implemented a "Fluid Active Indicator" that slides between navigation links on hover and initializes based on the current active page.
    - Enhanced navbar visibility with higher contrast glass-morphism effects.

### Improved
- **Visual Continuity**:
    - Unified the design language across Home, Academy, and Lab pages using consistent motion profiles and backgrounds.
    - Improved page load transitions with orchestrated timelines for headers, content, and footers.
- **Responsiveness**:
    - Refined mobile navigation with smooth GSAP transitions and improved touch targets.
    - Optimized tabular data layout in Lexical Lab for ultra-small screens.

### Fixed
- **HTML Integrity**: Resolved a stray `ody>` tag and duplicate closing tags in `templates/lab.html` that were causing layout issues.

## [1.9.0] - 2026-05-13

### Improved
- **Mobile UX & Responsiveness**:
    - Overhauled the navigation header into a centered, floating capsule design.
    - Implemented a more robust mobile menu with backdrop dimming and localized blurring.
    - Redesigned hero buttons with responsive scaling and vertical stacking on small screens.
    - Optimized the footer with a vertical layout on mobile to prevent cramping.
    - Refined the Lexical Lab interface for mobile, including responsive table padding and input area heights.
- **Copywriting**:
    - Updated landing page messaging to be more informative and technically focused.

### Fixed
- **Visual Artifacts**: Fixed a critical issue where the italicized "x" in the "PyLex" hero text was being clipped.
- **HTML Cleanup**: Removed redundant and broken HTML tags that were causing source code artifacts to appear on the frontend.

## [1.8.0] - 2026-05-13

### Changed
- **Rebranding**:
    - Officially renamed the project from **LEXICALMOTION** to **PyLex**.
    - Updated "Lexical Motion Lab" to **LEXICAL LAB**.
    - Rebranded "Motion Engine" to **PyLex Engine**.
- **User Interface**:
    - Updated all navigation links, headers, and footers to reflect the new identity.
    - Refined action buttons from "Analyze Motion" to **Analyze Tokens**.

### Improved
- **Lexical Element Dictionary**:
    - Completely restructured the dictionary in the Academy with a new responsive grid layout.
    - Added comprehensive documentation for **Operators**, **Punctuation**, **Numbers**, **Comments**, and **Error** handling.

## [1.7.0] - 2026-05-12

### Added
- **High-Precision Literal Classification**:
    - Distinguishes between `INTEGER`, `FLOAT`, and `COMPLEX` numeric tokens.
    - Added explicit `BOOLEAN` (`True`/`False`) and `NONE` (`None`) token types.
- **Enhanced Visual Feedback**:
    - New vibrant color-coded badges in the Lexical Lab for high-precision types (Orange for Ints, Amber for Floats, Rose for Complex, Indigo for Booleans).
- New integration test `test_bool_and_none`.

## [1.6.1] - 2026-05-12
...
