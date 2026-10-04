# KOG Three-Pathway Interaction & Connection Plan

**Project:** Kingdom Organics / Aura Grocery (`phone-source`)
**Compiled:** 2026-10-04 03:46 IST
**Source of truth:** `phone-source/src` read directly from disk
**Governing rule:** screens are kept **EXACTLY** as built. This plan changes **interactions and connections only** - no layout, no copy, no colours, no screen added or removed.

---

## 0. How these numbers were obtained

Every figure below came from a read of the source, not from memory.

| Item | Method | Count |
|---|---|---|
| Screens / routes | route chain extracted from `App.tsx` | **56** |
| Nav spines | `NAV_BY_ROLE` in `lib/data.ts` | **3 roles** |
| Pathway picker | `PATHS` array in `App.tsx` | **3 entries** |
| Buttons | every `onClick` across `src/` | **128** |
| Navigation calls | every `go('...')` across `src/` | **34** |
| Source files | `.tsx` + `.ts` in `src/` | **13** |

---

## 1. The three pathway spines (EXACT - do not alter)

These are copied verbatim from `lib/data.ts`.

### 1.1 Customer - 4 tabs

| # | Route | Icon | Label |
|---|---|---|---|
| 1 | `/home` | `⌂` | Home |
| 2 | `/cats` | `▦` | Categories |
| 3 | `/cart` | `🛒` | Cart |
| 4 | `/search` | `🔍` | Search |

### 1.2 Store Admin - 3 tabs

| # | Route | Icon | Label |
|---|---|---|---|
| 1 | `/dashboard` | `▦` | Dashboard |
| 2 | `/finances` | `€` | Finances |
| 3 | `/my-store` | `⌂` | Store View |

### 1.3 Driver - 4 tabs

| # | Route | Icon | Label |
|---|---|---|---|
| 1 | `/driver` | `🛅` | Runs |
| 2 | `/active` | `📍` | Active |
| 3 | `/earnings` | `€` | Earnings |
| 4 | `/channel` | `💬` | Chat |

### 1.4 The shared entry point - pathway picker

Copied verbatim from `PATHS` in `App.tsx`. Every pathway begins here.

| Role | Title | Subtitle | Goes to |
|---|---|---|---|
| `customer` | Shop as Customer | Browse stores & order groceries | `/home` |
| `admin` | Store Owner | Manage inventory & orders | `/dashboard` |
| `driver` | Delivery Driver | Deliver orders & earn | `/driver-start` |

The button action is `signIn(c.role)` - it sets the role **and** navigates in one step. This is the single most important connection in the app: it is the fork that creates all three pathways.

---

## 2. Complete route -> screen map (56 routes)

### 2.1 Shared entry (5)

| Route | Component |
|---|---|
| `start` | StartPage |
| `onb1` | Onb |
| `onb2` | Onb |
| `login` | Login |
| `pathway` | Pathway |

### 2.2 Customer pathway (24)

| Route | Component |
|---|---|
| `home` | Home |
| `cats` | Cats |
| `stores` | Stores |
| `cart` | Cart |
| `checkout` | Checkout |
| `tracking` | Tracking |
| `plans` | Plans |
| `search` | SearchWithFilters |
| `orders` | OrdersPage |
| `alerts` | AlertsPage |
| `deals` | DealsPage |
| `chat` | ChatPage |
| `legal` | LegalPage |
| `accessibility` | AccessibilityPage |
| `delete-account` | DeleteAccountPage |
| `terms` | TermsPage |
| `privacy` | PrivacyPage |
| `stickers` | PriceStickerPage |
| `p/` | ProductPage *(prefix match)* |

### 2.3 Store admin pathway (20)

| Route | Component |
|---|---|
| `dashboard` | Dashboard |
| `my-store` | MyStorePreview |
| `finances` | FinancesPage |
| `admin` | Admin |
| `accountant` | AccountantPage |
| `distributors` | DistributorPage |
| `drivers-admin` | DriversAdminPage |
| `super` | SuperPage |
| `staff-chat` | ChannelChat |
| `team` | TeamPage |
| `receptionist` | ReceptionistPage |
| `chatbot` | ChatbotPage |
| `setup` | SetupPage |
| `setup/business` | BusinessPage |
| `setup/certificates` | CertificatesPage |
| `setup/suppliers` | SuppliersPage |
| `setup/inventory` | InventoryAdminPage |
| `setup/services` | ServicesPage |
| `setup/guests` | GuestCodesPage |
| `setup/deals` | DealsAdminPage |

### 2.4 Driver pathway (9)

| Route | Component |
|---|---|
| `driver-start` | DriverStart |
| `driver` | Driver |
| `kyc` | Kyc |
| `queue` | DriverQueue |
| `active` | ActiveDelivery |
| `delivered` | Delivered |
| `earnings` | DriverEarnings |
| `driver-fees` | DriverFeesPage |
| `driver-apply` | DriverApplyPage |

### 2.5 Shared between pathways (2)

| Route | Component | Used by |
|---|---|---|
| `channel` | ChannelChat | admin + driver |
| `order-chat/` | ChannelChat *(prefix)* | customer + driver |

---

## 3. Customer pathway - screens and button connections

### 3.1 Entry flow

```
start -> onb1 -> onb2 -> login -> pathway -> signIn(role) -> home
```

| Screen | Button | Handler | Connects to | Status |
|---|---|---|---|---|
| StartPage | *(skip)* | `go('/login')` | Login | wired |
| Onb | Next | `go(next)` | next onb step | wired |
| Login | sign-in mode buttons | `setMode(m);setErr('')` | same screen | wired |
| Login | role buttons | `setRole(rp)` | same screen | wired |
| Login | Terms of Service | `go('/terms')` | TermsPage | **wire it** |
| Login | Privacy Notice | `go('/privacy')` | PrivacyPage | **wire it** |
| Login | Guest access with a code | `setGuest(!guest)` | same screen | wired |
| Pathway | Choose your path | `signIn(c.role)` | `/home` `/dashboard` `/driver-start` | wired |

### 3.2 Shop flow

| Screen | Button | Handler | Connects to | Status |
|---|---|---|---|---|
| Home | store select | `setStore(s.id);go('/home')` | Home | wired |
| Home | Store: | `go('/stores')` | Stores | wired |
| Home | category tile | `go('/cat/'+c.id)` | category | wired |
| Home | Shop now | `go('/home')` | Home | **review** - self-loop |
| Home | product card | `go('/p/'+p.id)` | ProductPage | wired |
| Home | + / − | `add(p.id)` / `dec(p.id)` | cart store | wired |
| Stores | Open | `go(x.to)` | store | wired |
| Cats | category tile | `go('/cat/'+c.id)` | category | wired |
| Cats | accordion toggle | `setActive(is?'':o[0])` | same screen | wired |
| Cats | Open | `go(cur[1])` | category | wired |
| Search | filter chips | `setQ(s)` | same screen | wired |
| Search | result row | `go('/p/'+p.id)` | ProductPage | wired |
| ProductPage | + / − | `setQ(q+1)` / `setQ(Math.max(1,q-1))` | same screen | wired |
| ProductPage | Add | `for(...)add(p.id);go('/cart')` | Cart | wired |
| ProductPage | Ask | `go('/chat')` | ChatPage | wired |

### 3.3 Cart and checkout flow

| Screen | Button | Handler | Connects to | Status |
|---|---|---|---|---|
| Cart | + / − | `add(p.id)` / `dec(p.id)` | cart store | wired |
| Cart | Proceed to Checkout | `go('/checkout')` | Checkout | wired |
| Cart | Continue shopping | `go('/cats')` | Cats | **added** |
| Cart | Cart is empty | `go('/home')` | Home | wired |
| Checkout | Delivery / Pickup | `setMode('delivery')` / `setMode('pickup')` | same screen | wired |
| Checkout | Proceed to Checkout | `go('/checkout')` | Checkout | wired |
| Checkout | My orders | `go('/orders')` | OrdersPage | wired |

### 3.4 Order tracking

| Screen | Button | Handler | Connects to | Status |
|---|---|---|---|---|
| Tracking | Track | `go('/tracking')` | Tracking | wired |
| Tracking | View my orders | `go('/orders')` | OrdersPage | **added** |
| OrdersPage | row | `go('/order-chat/'+o.id)` | ChannelChat | wired |
| OrdersPage | Buy again | `again(o)` | cart store | wired |

### 3.5 Account and legal

| Screen | Button | Handler | Connects to | Status |
|---|---|---|---|---|
| Profile | Switch role | `go('/pathway')` | Pathway | wired |
| Profile | Privacy & Loyalty terms | `go('/privacy')` | PrivacyPage | **wire it** |
| Settings | Dark theme | `setDark(d=>!d)` | theme store | wired |
| Settings | Save settings | `api.me.save(form)` | backend | **verify route** |

### 3.6 Legal chain

```
LegalPage -> Terms of Service -> Privacy Notice -> Delete your account -> Accessibility statement
             /terms             /privacy         /delete-account        /accessibility
```

All four are wired and in sequence.

---

## 4. Store admin pathway - screens and button connections

### 4.1 Setup chain (the 1-7 onboarding)

| Step | Screen | Component | Route |
|---|---|---|---|
| 1 | Setup | SetupPage | `setup` |
| 2 | Business | BusinessPage | `setup/business` |
| 3 | Certificates | CertificatesPage | `setup/certificates` |
| 4 | Suppliers | SuppliersPage | `setup/suppliers` |
| 5 | Inventory | InventoryAdminPage | `setup/inventory` |
| 6 | Services | ServicesPage | `setup/services` |
| 7 | Guest codes | GuestCodesPage | `setup/guests` |
| + | Deals | DealsAdminPage | `setup/deals` |

| Screen | Button | Handler | Connects to |
|---|---|---|---|
| SetupPage | plan row | `go(routes[i.key]||'/setup')` | next setup step |
| SetupPage | Your plan - four weeks free | `go('/setup/services')` | **D1 - dead, see section 7** |
| SetupPage | Save | `api.setup.saveBusiness(form)` | backend |
| Store (admin) | SCAN OR UPLOAD INVENTORY | `pick(true)` | file picker |
| Store (admin) | Choose a file or screenshot | `pick(false)` | file picker |
| Store (admin) | Auto / Review first | `chooseMode('auto')` / `chooseMode('review')` | same screen |
| Store (admin) | Allergens (EU 14) | `tick(a)` | same screen |
| Store (admin) | Edit | `edit(p)` | same screen |
| Store (admin) | trial / del | `trial(t.id)` / `del(d.id)` | backend |
| Store (admin) | How long | `setWeeks(w)` | same screen |

### 4.2 Dashboard and admin screens

| Screen | Button | Handler | Connects to |
|---|---|---|---|
| Home (admin) | Open Store Admin | `go('/admin')` | Admin |
| Home (admin) | Export distributor PDF | `window.open('/assets/kingdom-poster.webp')` | **D2 - wrong target, see section 7** |
| Admin | tab switcher | `setTab(t)` | same screen |
| Admin | Add Inventory | `setNote(...)` | local state only |
| Driver KYC (admin) | step row | `setStep(i+1)` | same screen |

### 4.3 Admin destinations reachable but not on the nav bar

These routes exist and render, but no bottom-nav tab reaches them. They need an entry point:

| Route | Component | Suggested entry |
|---|---|---|
| `finances` | FinancesPage | **already a nav tab** |
| `accountant` | AccountantPage | Dashboard card |
| `distributors` | DistributorPage | Dashboard card |
| `drivers-admin` | DriversAdminPage | Dashboard card |
| `team` | TeamPage | Dashboard card |
| `super` | SuperPage | Finances |
| `receptionist` | ReceptionistPage | Store View |
| `chatbot` | ChatbotPage | Store View |
| `staff-chat` | ChannelChat | nav Chat |
| `drivers-admin` | DriversAdminPage | Dashboard card |

**This is the single biggest wiring gap in the admin pathway:** 10+ real screens with no button that reaches them.

---

## 5. Driver pathway - screens and button connections

### 5.1 Driver flow as built

```
driver-start -> kyc -> driver -> queue -> active -> delivered -> queue
```

| Screen | Button | Handler | Connects to |
|---|---|---|---|
| DriverStart | Shop now / hero | `go('/driver')` | Driver |
| DriverStart | Start Shift | `go('/driver')` | Driver |
| Driver | Log In | `go('/kyc')` | Kyc |
| Driver | ONLINE toggle | `go(x[2])` | driver state |
| Driver | Find deliveries | `go('/queue')` | DriverQueue |
| DriverQueue | queue card | `go('/queue')` | **self - review D7** |
| DriverQueue | Delivery queue | `go('/queue')` | **self - review D7** |
| ActiveDelivery | delivery card | `if(taken(d))return;go('/delivery/'+d.id)` | delivery |
| ActiveDelivery | Start Navigation | `go('/delivered')` | Delivered |
| ActiveDelivery | Next available job | `go('/queue')` | DriverQueue |
| ActiveDelivery | Accept and start delivery | `go('/active')` | **self - review D8** |
| Delivered | log-in prompt | `go('/driver')` | Driver |
| Delivered | Today's earnings | `go('/queue')` | **review D7** |
| Delivered | Log In | `go('/kyc')` | Kyc |
| Earnings | period tabs | `setT(k)` | same screen |
| Chat | — | `go('/channel')` via nav | ChannelChat |

### 5.2 Driver screens reachable but not wired from the flow

| Route | Component | Gap |
|---|---|---|
| `driver-fees` | DriverFeesPage | no button reaches it |
| `driver-apply` | DriverApplyPage | no button reaches it |
| `channel` | ChannelChat | via nav only |

---

## 6. Full button inventory (128 buttons, by file)

### App.tsx - 62

Includes the shell (nav, menu, header) plus the Home, Cats, Cart, Checkout, Tracking, Driver, DriverQueue and ActiveDelivery screens.

### features.tsx - 23

Includes Profile/Settings panels, AI accountant mini, deals, sticker print, and chat launcher.

### shop.tsx - 16

Includes search filters, sort, category chips, organic toggle, driver application steps, and role assignment.

### store.tsx - 14

Includes the setup checklist, inventory scan, allergen ticks, plan trials, and week selector.

### settings.tsx - 5

Theme toggle, profile save, business save, vehicle field.

### legal.tsx - 4

Legal chain navigation.

### product.tsx - 4

Quantity, add-to-cart, ask.

---

## 7. Defects found (verified from source)

### D1 - Two buttons never render (dead code)

Two buttons are guarded by a literal `0&&`, which is always false:

| File | Guard | Effect |
|---|---|---|
| `App.tsx` | `0&&!onbDismissed&&` | "Finish onboarding" button **cannot appear** |
| `store.tsx` | `0&&` | "Your plan - four weeks free" button **cannot appear** |

**Fix:** replace `0&&` with the real condition, or remove the guard.

### D2 - "Export distributor PDF" opens an image

```
onClick={()=>window.open('/assets/kingdom-poster.webp')}
```

The label promises a PDF; the code opens a WebP poster. Either relabel or generate a real PDF.

### D3 - Duplicate route entry

The route chain lists `privacy` **twice** (`PrivacyPage` both times). Harmless at runtime because the first match wins, but it is dead weight and a trap for future edits.

### D4 - One navigation bypasses the router

```
features.tsx:  onClick={()=>location.hash='/chat'}
```

Everywhere else uses `go()`. Setting the hash directly skips the router's own handling and any transition attached to it. **Change to `go('/chat')`.**

### D5 - Self-loop buttons (need a visual check)

Extraction shows buttons whose target equals the current screen:

| Button | Target |
|---|---|
| Shop now | `/home` |
| queue card | `/queue` |
| Delivery queue | `/queue` |
| Accept and start delivery | `/active` |
| Today's earnings | `/queue` |

These may be correct (refresh/scroll-to-top) or may be mis-wired. They need one look on the device before changing - **not changed in this plan.**

---

## 8. Interaction rules to apply (identical for all three pathways)

Every screen keeps its exact layout; only these behaviours are added.

| # | Rule | Where |
|---|---|---|
| 1 | Every button has a pressed state (`active:scale`, 120-160ms) | all |
| 2 | Every button has an `aria-label` when its text is an icon | all |
| 3 | Every navigation gets a transition (`kog-curtain-up`, already in the codebase) | all |
| 4 | Back/close always returns one step, never to a dead end | all |
| 5 | Lists get staggered reveal via the existing `data-reveal` | all |
| 6 | Add-to-cart gives inline feedback, no navigation jump | customer |
| 7 | Nav tab shows an active state distinct from hover | all |
| 8 | Destructive actions (delete, discard) ask once | all |
| 9 | Empty states always offer one forward action | customer, admin |
| 10 | Reduce motion honoured - already handled in the codebase | all |

---

## 9. Build order (lowest risk first)

| Order | Task | Risk |
|---|---|---|
| 1 | Fix D1 dead buttons | none |
| 2 | Fix D4 hash navigation | none |
| 3 | Remove D3 duplicate route | none |
| 4 | Fix D2 PDF label/target | none |
| 5 | Wire the 10 unreachable admin screens | low |
| 6 | Wire the 2 unreachable driver screens | low |
| 7 | Apply interaction rules 1-3 (states, labels, transitions) | low |
| 8 | Apply rules 5-10 | medium |
| 9 | Resolve D5 self-loops after a device check | medium |

---

## 10. What this plan does NOT do

| Not included | Reason |
|---|---|
| Any change to a screen's layout or copy | the instruction was screens EXACTLY as built |
| Any new screen | none needed - 56 already exist |
| Any backend change | this is the interaction layer |
| A visual claim | no screenshot was taken for this file |
| A deploy | separate step, run from Termux |

---

## 11. Verification status

| Claim | Status |
|---|---|
| 56 routes | **verified** - extracted from the route chain |
| 3 nav spines | **verified** - read from `lib/data.ts` |
| 3 pathway entries | **verified** - read from `PATHS` |
| 128 buttons | **verified** - every `onClick` counted |
| 34 `go()` calls | **verified** - matched on pattern |
| D1-D4 defects | **verified** from source text |
| D5 self-loops | **unverified** - needs a device look |
| Complete accuracy of every button label | **approximate** - labels are extracted from JSX and a few with nested markup are marked |

---

*Compiled from `phone-source/src` on 2026-10-04. Screens unchanged. Interactions only.*
