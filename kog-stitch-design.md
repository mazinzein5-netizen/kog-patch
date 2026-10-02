---
name: Royal Organic Noir
version: 2
audited: 2026-10-02
source-of-truth: phone-source/src/index.css
colors:
  base: '#000026'
  brand-purple: '#19063B'
  purple-elevated: '#30155E'
  on-gold: '#19063B'
  accent-gold: '#E8960F'
  gold-bright: '#E8C454'
  gold-deep: '#C9A227'
  emerald: '#0B6B4F'
  forest-deep: '#000157'
  ink: '#111827'
  on-page: '#F0F0F0'
  muted: '#C9CFE8'
  muted-dim: '#6F6F92'
  danger: '#B91C1C'
  glass-fill: 'rgba(255,255,255,0.06)'
  glass-hairline: 'rgba(255,255,255,0.14)'
  text-high: '#FFFFFF'
  text-medium: 'rgba(255,255,255,0.72)'
  text-muted: 'rgba(255,255,255,0.44)'
typography:
  display-lg:
    fontFamily: Comfortaa
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Comfortaa
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Comfortaa
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 30px
    letterSpacing: 0em
  headline-sm:
    fontFamily: Comfortaa
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 26px
    letterSpacing: 0em
  body-lg:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-lg-bold:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  body-md-semibold:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: DM Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.06em
rounded:
  card: 24px
  button: 16px
  nested-image: 14px
  chip: 9999px
spacing:
  margin: 1.25rem
  gutter: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
frame:
  width: 390px
  height: 844px
  safe-top: 47px
  safe-bottom: 34px
---

## Brand & Style

Midnight Glassmorphism with Regal Accents. A regal, modern storefront for high-end organic
groceries. Deep nocturnal surfaces, suspended glass planes with hairline light catches, and warm
harvest gold for primary action. No heavy drop shadows anywhere - depth comes from translucency.

Palette engine: deep OLED-safe navy and purple, punctuated by harvest metallics.

## Colors

Authoritative dark palette. These are the only colours screens should use.

| Token | Hex | Use |
| --- | --- | --- |
| Base surface | #000026 | primary viewport backdrop |
| Brand purple | #19063B | structural sections, nav backing |
| Purple elevated | #30155E | mid-tier tint behind glass |
| Accent gold | #E8960F | primary CTA, badges, focal actions |
| Gold bright | #E8C454 | prices, emphasis numerals |
| Gold deep | #C9A227 | price accents - never small text on white |
| Emerald | #0B6B4F | success, in-stock, avatars |
| Forest deep | #000157 | deep structural contrast |
| Ink | #111827 | text on white cards only |
| Muted | #C9CFE8 | secondary text on dark |
| Muted dim | #6F6F92 | captions, disabled |

Text hierarchy on dark:

- High emphasis: #FFFFFF
- Medium emphasis: rgba(255,255,255,0.72)
- Muted / caption: rgba(255,255,255,0.44)
- Inverse on gold: #19063B

Glass: fill rgba(255,255,255,0.06), 1px hairline rgba(255,255,255,0.14).

### DO NOT USE

Palette drift found in the live code audit. These appear in code but are NOT brand colours.
Never reproduce them in new screens:

| Value | Occurrences | What it is |
| --- | --- | --- |
| #2A00D6 | 39 | stray bright blue, not in palette |
| #1A1206 | 37 | legacy light-theme brown |
| #8A4B06 | 10 | legacy brown |
| #C2410C / #EA580C | 10 | legacy orange |
| Playfair Display | - | legacy font still preloaded in index.html |

The live codebase contains 71 distinct hex values. The target is the table above only.

## Typography

Two fonts, no others.

- Comfortaa - headings only. Bold weight, circular geometry. Never body text, never tabular
  lists, never compact labels; its curves need spatial scale to stay legible.
- DM Sans - everything else. Regular for descriptions and quantities, SemiBold for values,
  prices and nav labels, Bold for badges and action triggers.

Both fonts are available in Stitch's font list, so no font upload is required.

## Layout & Spacing

iOS mobile frame 390x844 with safe area insets (top 47px, bottom 34px).

- Screen margin: 1.25rem (20px)
- Grid gutter: 1rem (16px)
- Section rhythm: 24px or 32px
- Card internal padding: 1.25rem (20px)
- Chip padding: 4px vertical, 8px horizontal
- Button and input padding: 12-14px vertical, 16px horizontal

## Elevation & Depth

Layer 0 - Canvas: solid #000026.

Layer 1 - Structural sections: #19063B at 40-70% opacity.

Layer 2 - Floating glass panels and cards:

- Fill rgba(255,255,255,0.06)
- Border 1px rgba(255,255,255,0.14)
- backdrop-filter: blur(8px), tolerance 6-9px
- Shadow 0 8px 32px 0 rgba(0,0,16,0.45)

Layer 3 - Floating bars and modals:

- Fill rgba(25,6,59,0.78)
- backdrop-filter: blur(12px)
- Perimeter 1px rgba(232,150,15,0.22) top rim

## Shapes

- Cards and primary panels: 24px
- Buttons, inputs, banners: 16px
- Pills, badges, chips, floating tabs: 9999px
- Images nested in cards: 14px

## Components

### Buttons

- Primary: solid #E8960F, text #19063B in DM Sans Bold, radius 16px, height 52px.
  Press: scale 0.98.
- Secondary glass: fill rgba(255,255,255,0.06), border 1px rgba(255,255,255,0.14),
  text #FFFFFF DM Sans SemiBold, radius 16px, height 52px.
- Ghost: transparent, text #E8960F.

### Cards

Product card: radius 24px, fill rgba(255,255,255,0.06), 1px rgba(255,255,255,0.14) hairline,
8px backdrop blur. Image at top with 14px nested radius. Price in Comfortaa Bold for the whole
units and DM Sans for the qualifier (/lb, /each). Quick-add 36px circle or 16px square in #E8960F.

### Chips & Pills

Fully rounded. Inactive: fill rgba(255,255,255,0.05), border rgba(255,255,255,0.12),
text rgba(255,255,255,0.72). Active: fill #E8960F, text #19063B bold.

### Input Fields

Height 50px, radius 16px, fill rgba(255,255,255,0.04), border rgba(255,255,255,0.14).
Focus: border #E8960F plus glow 0 0 0 3px rgba(232,150,15,0.18). Placeholder rgba(255,255,255,0.4).

### Checkboxes & Radios

Radio 20px circle, checkbox 20px square with 6px radius. Unchecked border 1.5px
rgba(255,255,255,0.3). Checked solid #E8960F with #19063B checkmark.

### Bottom Navigation

Height 64px plus home-indicator clearance. Fill rgba(25,6,59,0.85), backdrop blur 12px,
top border 1px rgba(255,255,255,0.12).

Five items, in this order: Home, Stores, Scan/Camera, Cart, Search.

- Icons 24x24 bounding box, stroke weight 2.25px, round caps and joins
- Real drawn vector icons only. Never a text glyph standing in for an icon.
- Inactive icons rgba(255,255,255,0.44), active #E8960F
- Centre Scan/Camera gets an elevated circular badge in #E8960F
- Exactly ONE nav bar per screen

### Status Bar

iOS dark status bar, pure white icons and time, above a non-blocking translucent glass layer.

## Screen Inventory

26 screens. Every screen is a 390x844 frame on the #000026 base unless noted.

Stages 1-3: entry

| # | Screen | Key elements |
| --- | --- | --- |
| 1 | Splash | full-bleed basket hero, dark gradient overlay, gold logo, GROCERY pill |
| 2 | Login | glass card, email + password inputs, gold CTA, Apple/Google/PayPal |
| 3 | Choose your path | customer / store / driver role cards |

Stage 4: shopping

| # | Screen | Key elements |
| --- | --- | --- |
| 4 | Home | glass search bar, category rail, featured grid, gold promo strip |
| 5 | Categories | tile grid: Vegetables, Fruits, Grains, Spices, Dairy, Meats |
| 6 | Category - Meat | full-bleed hero, filter pills, 2-col product grid, quick-add |
| 7 | Partner Stores | store cards with distance and rating |
| 8 | Search | input, recent searches, suggestion list |
| 9 | Deals | hero banners plus deal tiles, gold price badges |

Stage 5: transaction

| # | Screen | Key elements |
| --- | --- | --- |
| 10 | Cart | line items, quantity steppers, summary bar, gold checkout |
| 11 | Checkout | address, pick-a-window, payment method, confirm |
| 12 | Tracking | map panel, driver card, progress steps |

Stage 6: account

| # | Screen | Key elements |
| --- | --- | --- |
| 13 | My Orders | order history list with status chips |
| 14 | Settings | grouped rows, toggles, theme switch |
| 15 | Profile | avatar, details, addresses, payment methods |
| 16 | Plans | subscription tiers, gold featured tier |

Stage 7: business

| # | Screen | Key elements |
| --- | --- | --- |
| 17 | Dashboard | KPI tiles, revenue sparkline, alerts |
| 18 | Store Admin | inventory list, stock levels, scan action |
| 19 | My-Store | storefront setup, hours, imagery |
| 20 | Setup | onboarding checklist, progress |
| 21 | Finances | ledger, payout summary, invoice rows |
| 22 | Distributors | supplier list with contact rows |
| 23 | Channel | delivery channel config |
| 24 | Team | header, title Team members and staff, 3 staff rows with round initial
avatars, invite card with email + role + gold Send invite |

Stage 8: driver

| # | Screen | Key elements |
| --- | --- | --- |
| 25 | Driver | run list, accept action, route panel |
| 26 | Earnings | earnings summary, per-run breakdown |

## Asset Map

70 assets, 19.16 MB total. Assign by page role:

| Role | Count | Size | Use |
| --- | --- | --- | --- |
| Hero / full-bleed backgrounds | 9 | 7.55 MB | Splash, Category heroes, Store pages |
| Product photos | 20 | 5.52 MB | Product cards and grids |
| Category tiles | 12 | 1.06 MB | Categories grid (webp grid + tile pairs) |
| Brand logos | 3 | 141 KB | Splash, header, badges |
| Posters | 6 | 549 KB | Home hero strip, promo rails |
| Deals art | 8 | 286 KB | Deals screen |
| Onboarding | 2 | 277 KB | Choose your path |
| Templates | 2 | 1.51 MB | Store page samples |

Heaviest files, worth optimising before anything else:

- bg-spices.jpg 1.95 MB
- store-hero-supermarket.png 1.63 MB
- bg-butcher.jpg 1.33 MB
- bg-produce.jpg 1.24 MB
- splash-bg.jpg 1.19 MB

Rule for every image: object-cover to the slot, never stretch, never crop a subject. Hero images
sit under a dark gradient overlay for text legibility.
