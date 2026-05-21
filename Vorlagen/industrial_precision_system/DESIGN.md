---
name: Industrial Precision System
colors:
  surface: '#f4faff'
  surface-dim: '#cfdce4'
  surface-bright: '#f4faff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e9f6fd'
  surface-container: '#e3f0f8'
  surface-container-high: '#ddeaf2'
  surface-container-highest: '#d7e4ec'
  on-surface: '#111d23'
  on-surface-variant: '#424750'
  inverse-surface: '#263238'
  inverse-on-surface: '#e6f3fb'
  outline: '#727781'
  outline-variant: '#c2c6d1'
  surface-tint: '#27609d'
  primary: '#003461'
  on-primary: '#ffffff'
  primary-container: '#004b87'
  on-primary-container: '#8abcff'
  inverse-primary: '#a3c9ff'
  secondary: '#48626e'
  on-secondary: '#ffffff'
  secondary-container: '#cbe7f5'
  on-secondary-container: '#4e6874'
  tertiary: '#572500'
  on-tertiary: '#ffffff'
  tertiary-container: '#793701'
  on-tertiary-container: '#ffa46a'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e4ff'
  primary-fixed-dim: '#a3c9ff'
  on-primary-fixed: '#001c38'
  on-primary-fixed-variant: '#004882'
  secondary-fixed: '#cbe7f5'
  secondary-fixed-dim: '#afcbd8'
  on-secondary-fixed: '#021f29'
  on-secondary-fixed-variant: '#304a55'
  tertiary-fixed: '#ffdbc8'
  tertiary-fixed-dim: '#ffb68b'
  on-tertiary-fixed: '#321300'
  on-tertiary-fixed-variant: '#753400'
  background: '#f4faff'
  on-background: '#111d23'
  surface-variant: '#d7e4ec'
typography:
  headline-lg:
    fontFamily: IBM Plex Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: IBM Plex Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: IBM Plex Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: IBM Plex Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: IBM Plex Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
  status-label:
    fontFamily: IBM Plex Sans
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 16px
  headline-lg-mobile:
    fontFamily: IBM Plex Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  edge_margin: 16px
  stack_gap: 12px
---

## Brand & Style
The design system is engineered for high-stakes technical environments where clarity, speed of input, and reliability are paramount. The aesthetic is **Industrial Modern**—a synthesis of corporate reliability and rugged utility. It prioritizes a "tool-first" philosophy, minimizing decorative elements in favor of structural integrity and clear information hierarchy.

The UI should evoke a sense of professional authority. It is designed to be used by technicians in the field, often under varying lighting conditions, necessitating high-contrast ratios and a distinct lack of visual ambiguity. The style utilizes a structured grid, purposeful use of negative space, and a refined color palette that distinguishes between data entry, status indication, and navigation.

## Colors
The palette is rooted in **Industrial Blues** and **Slate Grays**. The primary blue represents stability and technical precision, while the neutral scales are used to create depth and distinguish between container layers. 

Status colors are highly saturated to ensure they are immediately recognizable at a glance:
- **Success Green:** Used for "Bestanden" (Pass) states.
- **Error Red:** Used for "Durchgefallen" (Fail) states.
- **Warning Amber:** Used for cautionary data or pending items.
- **Neutral Blue-Gray:** Used for "N/A" or inactive states.

Backgrounds utilize a very subtle cool-gray tint to reduce screen glare compared to pure white, improving long-term legibility during extended inspection sessions.

## Typography
**IBM Plex Sans** is selected for its engineered, technical character and exceptional legibility. It features distinct letterforms that prevent confusion between similar characters (like 'I', 'l', and '1'), which is critical when reading serial numbers or technical specs.

- **Headlines:** Use semi-bold weights to anchor sections of the inspection report.
- **Labels:** Use "label-caps" for technical metadata and form field headers to provide a clear distinction from user input.
- **Data Points:** For technical values, ensure a consistent `body-lg` weight to maintain readability in industrial environments.

## Layout & Spacing
The layout follows a **structured fluid model** optimized for one-handed mobile operation. 

- **Grid:** A standard 4-column mobile grid with 16px side margins.
- **Vertical Rhythm:** Elements are stacked using a 4px baseline shift. Most interactive elements (buttons, inputs) maintain a minimum height of 48px to accommodate gloved hands or rapid tapping.
- **Grouping:** Use 24px (lg) spacing to separate major inspection categories and 12px (stack_gap) for items within a single category list.

## Elevation & Depth
This design system avoids heavy shadows, opting instead for **Tonal Layering** and **Low-Contrast Outlines**.

1.  **Level 0 (Base):** The `background_subtle` layer.
2.  **Level 1 (Cards/Items):** Pure white surfaces with a 1px solid border (#E0E4E7). No shadow.
3.  **Level 2 (Active/Floating):** Use a very tight, low-opacity shadow (0px 2px 4px rgba(0,0,0,0.08)) only for elements that require immediate attention or are currently being edited.

This "flat-but-layered" approach ensures the UI feels stable and integrated, like a physical control panel rather than a series of floating apps.

## Shapes
A **Soft (0.25rem)** roundedness is applied throughout the system. This provides a modern feel while maintaining the "precise" and "utilitarian" edges associated with industrial equipment. 

- **Buttons & Inputs:** 4px radius.
- **Status Chips:** 4px radius (avoiding full pills to maintain the technical aesthetic).
- **Photo Cards:** 8px (rounded-lg) to subtly soften the visual weight of image content.

## Components
### Status Toggles (The "Tristate" Switch)
Inspection items must use a segmented control or a group of three distinct buttons for **Bestanden (Pass)**, **Durchgefallen (Fail)**, and **N/A**. 
- Active states should use the full status color (Green/Red/Gray).
- Inactive states should use a hollow outline with the `secondary_color`.

### Photo Upload Cards
Cards should display a thumbnail preview, a filename, and a timestamp. Include a large, centered "+" icon for empty states with a "Capture Photo" label.

### Form Fields
Technical data fields (e.g., Voltage, Resistance) should use an inset label or a top-aligned `label-caps` header. Use a monospaced-adjacent look for numerical input to emphasize precision.

### Signature Pad
A dedicated full-width container with a light-gray background and a crisp 1px border. Include a "Clear" text button in the top right and a timestamp of the signature in the bottom left.

### Lists
Inspection lists should use 16px internal padding. Each row is separated by a 1px divider. The right side of the row is reserved for the status toggle, while the left side contains the requirement text and a sub-label for "Reference Standard."