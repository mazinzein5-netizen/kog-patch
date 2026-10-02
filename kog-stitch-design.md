---
name: Royal Organic Noir
version: 3
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

# Kingdom Organics - Royal Organic Noir

A dark, premium mobile storefront for a halal and organic grocery business.
Target frame: 390x844 phone, iOS status bar, dark theme.
Fonts: Comfortaa for headings only, DM Sans for everything else.

---

## How to use this file

1. Paste this whole document into Stitch as a design system, named Royal Organic Noir.
2. Stitch reads the front-matter tokens and the body sections below.
3. Then paste one prompt at a time from the Screen Prompt Pack to generate each screen.

Both fonts are native to Stitch, so no font upload is needed.

---

## Brand and Style

Midnight Glassmorphism with Regal Accents. Deep nocturnal surfaces, suspended glass planes with
hairline light catches, and warm harvest gold for primary action. No heavy drop shadows anywhere;
depth comes from translucency and hairline borders.

Tone: regal, calm, premium. Generous whitespace. Never crowded, never loud.

---

## Colors

Use these tokens only.

| Token | Hex | Use |
| --- | --- | --- |
| Base surface | #000026 | primary viewport backdrop |
| Brand purple | #19063B | structural sections, nav backing |
| Purple elevated | #30155E | mid-tier tint behind glass |
| Accent gold | #E8960F | primary CTA, badges, focal actions |
| Gold bright | #E8C454 | prices, emphasis numerals |
| Gold deep | #C9A227 | price accents, never small text on white |
| Emerald | #0B6B4F | success, in-stock, avatars |
| Forest deep | #000157 | deep structural contrast |
| Ink | #111827 | text on white cards only |
| Muted | #C9CFE8 | secondary text on dark |
| Muted dim | #6F6F92 | captions, disabled |

Text hierarchy on dark:

- High emphasis: #FFFFFF
- Medium emphasis: rgba(255,255,255,0.72)
- Muted and caption: rgba(255,255,255,0.44)
- Inverse text on gold: #19063B

Glass treatment: fill rgba(255,255,255,0.06), 1px hairline border rgba(255,255,255,0.14).

### Do not use

These values appear in the old codebase but are NOT brand colours. Never reproduce them:

| Value | Why it is wrong |
| --- | --- |
| #2A00D6 | stray bright blue, not in palette |
| #1A1206 | legacy light-theme brown |
| #8A4B06 | legacy brown |
| #C2410C | legacy orange |
| #EA580C | legacy orange |
| Playfair Display | legacy font, replaced by Comfortaa |
| #0c0f34 | auto-generated surface, use #000026 instead |
| #d1bdfa | auto-generated lilac, use #19063B instead |

---

## Typography

Two fonts only.

- Comfortaa, Bold, headings only. Circular and soft. Never body text, never table rows,
  never small labels.
- DM Sans, everything else. Regular for descriptions and quantities, SemiBold for prices,
  values and nav labels, Bold for badges and buttons.

Scale:

| Level | Font | Size | Weight | Line |
| --- | --- | --- | --- | --- |
| Display | Comfortaa | 32px | 700 | 40px |
| Headline LG | Comfortaa | 26px | 700 | 34px |
| Headline MD | Comfortaa | 22px | 700 | 30px |
| Headline SM | Comfortaa | 18px | 700 | 26px |
| Body LG | DM Sans | 16px | 400 | 24px |
| Body MD | DM Sans | 14px | 400 | 20px |
| Label MD | DM Sans | 12px | 600 | 16px |
| Label SM | DM Sans | 10px | 700 | 14px |

---

## Layout and Spacing

iOS mobile frame 390x844 with safe areas, top 47px and bottom 34px.

- Screen margin 20px
- Grid gutter 16px
- Section rhythm 24px or 32px
- Card inner padding 20px
- Chip padding 4px vertical, 8px horizontal
- Button and input padding 14px vertical, 16px horizontal

---

## Elevation and Depth

Layer 0 Canvas: solid #000026.

Layer 1 Structural sections: #19063B at 40 to 70 percent opacity.

Layer 2 Glass cards:

- fill rgba(255,255,255,0.06)
- border 1px rgba(255,255,255,0.14)
- backdrop blur 8px
- shadow 0 8px 32px rgba(0,0,16,0.45)

Layer 3 Floating bars and modals:

- fill rgba(25,6,59,0.78)
- backdrop blur 12px
- top rim 1px rgba(232,150,15,0.22)

---

## Shapes

- Cards and main panels 24px
- Buttons, inputs, banners 16px
- Pills, badges, chips, floating tabs 9999px
- Images nested inside cards 14px

---

## Components

### Buttons

- Primary: fill #E8960F, text #19063B in DM Sans Bold, radius 16px, height 52px.
- Secondary glass: fill rgba(255,255,255,0.06), border 1px rgba(255,255,255,0.14),
  text #FFFFFF in DM Sans SemiBold, radius 16px, height 52px.
- Ghost: transparent, text #E8960F.

### Cards

Product card radius 24px, glass fill, 1px hairline, 8px blur. Image at top with 14px nested
radius. Price in Comfortaa Bold for whole units and DM Sans for the qualifier such as per lb or
each. Quick add button is a 36px gold circle.

### Chips and Pills

Fully rounded. Inactive fill rgba(255,255,255,0.05), border rgba(255,255,255,0.12), text
rgba(255,255,255,0.72). Active fill #E8960F with text #19063B bold.

### Input Fields

Height 50px, radius 16px, fill rgba(255,255,255,0.04), border rgba(255,255,255,0.14).
On focus the border turns #E8960F with a soft outer glow. Placeholder rgba(255,255,255,0.4).

### Checkboxes and Radios

Radio 20px circle, checkbox 20px square with 6px radius. Unchecked border 1.5px
rgba(255,255,255,0.3). Checked fill #E8960F with a #19063B mark.

### Bottom Navigation

Height 64px plus home indicator clearance. Fill rgba(25,6,59,0.85), blur 12px, top border
1px rgba(255,255,255,0.12).

Five items in this order: Home, Stores, Scan, Cart, Search.

- Icons 24x24, stroke weight 2.25px, round caps and round joins
- Real drawn vector icons only. Never a text character standing in for an icon.
- Inactive icons rgba(255,255,255,0.44), active icon #E8960F
- The centre Scan item sits in an elevated gold circular badge
- Exactly one nav bar per screen. Never two.

### Status Bar

iOS dark status bar, white icons and time, sitting above a translucent glass layer.

---

## Screen Prompt Pack

Paste one at a time. Each one assumes the design system above.

### Stage 1 to 3, entry

1. Splash. Full bleed dark grocery basket hero image, dark gradient overlay from #000026, centred gold Kingdom Organics globe logo, white GROCERY pill below it, single circular white arrow button bottom right.

2. Login. Dark #000026 background, small gold globe logo at top, Comfortaa heading Welcome back, glass card with email field and password field, gold primary button reading Sign in, divider reading or continue with, three glass pills for Apple, Google and PayPal, muted DM Sans link at the bottom reading Continue as guest.

3. Choose your path. Dark background, Comfortaa heading Choose how you shop, subtitle in muted text, three tall glass cards stacked vertically each with a 24px icon, a bold Comfortaa title and one line of DM Sans description, reading Shop for home, Run a store, and Deliver orders. Each card has a gold chevron on the right.

### Stage 4, shopping

4. Home. Dark background, top bar with location and a small avatar, glass search bar, horizontal category rail of six circular thumbnails labelled Vegetables, Fruits, Grains, Spices, Dairy and Meats, a featured product grid of two columns using glass product cards, and a gold promo strip near the bottom.

5. Categories. Dark background, Comfortaa heading Shop by category, grid of six category tiles each with a full bleed photo, a dark gradient, and a white DM Sans SemiBold label. Tiles use 24px radius.

6. Category Meat. Full bleed hero photo of a butcher counter at the top with a dark gradient and a Comfortaa title Meat and Poultry, a back button in glass, a partner badge in glass, a horizontal row of filter pills, then a two column grid of glass product cards with gold quick add buttons.

7. Partner Stores. Dark background, Comfortaa heading Nearby stores, vertical list of store cards each with a round photo, store name in DM Sans Bold, distance and rating in muted text, and a gold View button.

8. Search. Dark background, a focused glass search input at the top with a gold border, a Recent searches section as chips, and a Suggestions list of rows each with a small product thumbnail, name, and price in gold.

9. Deals. Dark background, Comfortaa heading Today's deals, one large hero banner card with a photo and gold price badge, then a two column grid of deal tiles each with a strikethrough old price in muted text and a new price in gold.

### Stage 5, transaction

10. Cart. Dark background, Comfortaa heading Your basket, a vertical list of glass line items each with a product thumbnail, name, unit price and a quantity stepper with minus and plus, a sticky summary bar at the bottom showing subtotal in gold and a full width gold button reading Checkout.

11. Checkout. Dark background, Comfortaa heading Checkout, three glass sections stacked: Delivery address with a Change link, Pick a window with three selectable time chips, Payment with a selected card row, and a sticky gold button reading Place order with the total in Comfortaa.

12. Tracking. Dark background, a map panel at the top with a route line in gold, a glass driver card with a round avatar, driver name and a call button, a progress stepper with four steps, and an estimated arrival time in Comfortaa Bold.

### Stage 6, account

13. My Orders. Dark background, Comfortaa heading My orders, vertical list of order cards each with an order number, date in muted text, item count, a status chip in emerald or gold, and a total in gold.

14. Settings. Dark background, Comfortaa heading Settings, grouped glass rows with labels and toggle switches, groups for Account, Notifications, Appearance and Support, with the appearance row showing a theme selector.

15. Profile. Dark background, a large round avatar at the top with the member name in Comfortaa Bold and email in muted text, then grouped glass rows for Personal details, Addresses and Payment methods, and a gold Save button at the bottom.

16. Plans. Dark background, Comfortaa heading Plans, two or three tall glass cards side by side or stacked with a tier name, a gold price in Comfortaa Bold, a checklist of DM Sans features, and the middle plan marked Most popular with a gold border and gold button.

### Stage 7, business

17. Dashboard. Dark background, Comfortaa heading Business overview, a row of KPI tiles in glass each with a label, a large value in Comfortaa Bold and a small trend arrow, then a glass card with a simple revenue line chart in gold, then an alerts list.

18. Store Admin. Dark background, Comfortaa heading Inventory, a search field, a list of glass product rows each with a thumbnail, name, SKU in muted text, a stock count, and a small gold edit button, plus a floating gold scan button bottom right.

19. My-Store. Dark background, a store hero photo at the top with a dark gradient, store name in Comfortaa Bold, an Open or Closed status chip, then glass sections for Opening hours, Store details and Photos, with a gold Save changes button.

20. Setup. Dark background, Comfortaa heading Set up your store, a progress bar in gold showing completion, then a vertical checklist of glass rows each with a tick circle, a task title and a one line description, and a gold Continue button.

21. Finances. Dark background, Comfortaa heading Finances, a summary glass card with total revenue in Comfortaa Bold and payout date in muted text, then a ledger list of rows each with a date, description, amount in gold or red, and a Download statement button.

22. Distributors. Dark background, Comfortaa heading Distributors, a vertical list of supplier cards each with a round logo, supplier name in DM Sans Bold, contact line in muted text, and two small glass buttons for call and message.

23. Channel. Dark background, Comfortaa heading Delivery channel, glass rows for channel name, delivery radius with a value, delivery fee, and a toggle for accepting new orders, with a gold Save button.

24. Team. Dark background, a header with a back button and the brand mark, Comfortaa title Team members and staff, DM Sans subtitle People who help run the store. Invite staff here. Then three staff rows, each a white card with a round emerald avatar showing initials, the name in DM Sans Bold, the role and email in muted text. Below them an invite card with an email field, a role field and a gold Send invite button.

### Stage 8, driver

25. Driver. Dark background, Comfortaa heading Today's runs, a vertical list of run cards each with an order number, pickup store, drop address, a distance in muted text, and a gold Accept button, plus a small map preview panel.

26. Earnings. Dark background, Comfortaa heading Earnings, a large total in Comfortaa Bold gold, a period selector as chips, then a breakdown list of runs each with date, distance, and amount in gold, plus a Withdraw button.

---

## Asset Map

70 assets exist in the project, 19.16 MB total. Use them by role:

| Role | Count | Use on |
| --- | --- | --- |
| Hero backgrounds | 9 | Splash, category heroes, store pages |
| Product photos | 20 | Product cards and grids |
| Category tiles | 12 | Categories grid |
| Brand logos | 3 | Splash, headers, badges |
| Posters | 6 | Home hero strip, promo rails |
| Deals art | 8 | Deals screen |
| Onboarding | 2 | Choose your path |
| Templates | 2 | Store samples |

Rules for every image: cover the slot without stretching, never crop a subject, and place hero
images under a dark gradient so white text stays readable.
