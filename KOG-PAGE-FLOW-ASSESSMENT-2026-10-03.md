# Kingdom Organics / Aura Grocery - Page Flow and Interaction Assessment

| Field | Value |
| --- | --- |
| Document ID | KOG-PAGE-FLOW-ASSESSMENT |
| Timestamp | 2026-10-03 11:02 IST |
| App version audited | v173 (BUILD constant), APP_VERSION v146 |
| Source | phone-source/src - 13 TS/TSX files |
| Scope | all routes, current flow, proposed flow, interactions, animations |
| Constraint | content, copy, data and visual design stay IDENTICAL - only order, transition and interaction change |
| Cost | 0.00 |

---

## 1. Verified stack facts

Measured from phone-source/package.json and a full source scan. Not assumed.

| Item | Value | Note |
| --- | --- | --- |
| Framework | React 18.2 + Vite 7.3.6 | - |
| Router | wouter 3.0, HASH mode | useHashLocation |
| Navigation call | go(p) sets location.hash | 57 call sites |
| Route resolution | if-chain inside useMemo in App.tsx | not Route components |
| Animation lib | GSAP 3.15 + ScrollTrigger | installed AND used |
| CSS keyframes | 5 total | see section 7 |
| Tailwind | 3.4 | 1405 className usages |
| BeUI runtime dep | motion - NOT INSTALLED | see section 8 |
| Reticle | reticlehq 2.14 | proofread gate |

### Router mechanism - measured

```
Route path=        0
useLocation        0
Switch             0
Link               0
useRoute           0
go(               57   <- the only navigation primitive
useHashLocation    1
```

Consequence: every transition must attach to Shell (the layout wrapper) or the go() helper. There is no router-level hook to intercept, so Shell is the single natural place for page transitions.

---

## 2. Page inventory - measured

Every route extracted from the live route chain in App.tsx and the path literals across src/. 56 routes across 6 journey stages.

### Stage A - Entry (6 pages)

| # | Route | Component | File |
| --- | --- | --- | --- |
| A1 | /start | StartPage | App.tsx |
| A2 | /splash | Splash | App.tsx |
| A3 | /login | Login | App.tsx |
| A4 | /pathway | Pathway | App.tsx |
| A5 | /onb2 | Onb | App.tsx |
| A6 | /kyc | Kyc | App.tsx |

### Stage B - Customer shopping (14 pages)

| # | Route | Component | File |
| --- | --- | --- | --- |
| B1 | /home | Home | App.tsx |
| B2 | /cats | Cats | App.tsx |
| B3 | /cat/:id | Cat | App.tsx |
| B4 | /stores | Stores | App.tsx |
| B5 | /p/:id | ProductPage | product.tsx |
| B6 | /search | SearchPage | features.tsx |
| B7 | /deals | DealsPage | features.tsx |
| B8 | /cart | Cart | App.tsx |
| B9 | /checkout | Checkout | App.tsx |
| B10 | /tracking | Tracking | App.tsx |
| B11 | /orders | OrdersPage | shop.tsx |
| B12 | /alerts | AlertsPage | shop.tsx |
| B13 | /membership | MembershipCard | features.tsx |
| B14 | /chat | ChatPage | features.tsx |

### Stage C - Account (4 pages)

| # | Route | Component | File |
| --- | --- | --- | --- |
| C1 | /profile | CustomerProfile / OwnerProfile / DriverProfile | features.tsx |
| C2 | /settings | CustomerSettings / OwnerSettings / DriverSettings | settings.tsx |
| C3 | /plans | Plans | App.tsx |
| C4 | /role | role switch | App.tsx |

### Stage D - Business and store owner (17 pages)

| # | Route | Component |
| --- | --- | --- |
| D1 | /dashboard | Dashboard |
| D2 | /admin | Admin |
| D3 | /my-store | MyStorePreview |
| D4 | /team | TeamPage |
| D5 | /finances | FinancesPage |
| D6 | /accountant | AccountantPage |
| D7 | /distributors | DistributorPage |
| D8 | /channel | ChannelChat |
| D9 | /staff-chat | ChannelChat (staff) |
| D10 | /receptionist | ReceptionistPage |
| D11 | /chatbot | ChatbotPage |
| D12 | /super | SuperPage |
| D13 | /drivers-admin | DriversAdminPage |
| D14 | /driver-apply | DriverApplyPage |
| D15 | /setup | SetupPage |
| D16 | /setup/* | 7 sub-pages: business, certificates, suppliers, inventory, services, guests, deals |

### Stage E - Driver (7 pages)

| # | Route | Component |
| --- | --- | --- |
| E1 | /driver | Driver |
| E2 | /driver-start | driver start |
| E3 | /active | ActiveDelivery |
| E4 | /delivered | Delivered |
| E5 | /queue | DriverQueue |
| E6 | /driver-fees | DriverFeesPage |
| E7 | /earnings | earnings |

### Stage F - Legal and system (5 pages)

| # | Route | Component |
| --- | --- | --- |
| F1 | /legal | LegalPage |
| F2 | /terms | TermsPage |
| F3 | /privacy | PrivacyPage |
| F4 | /accessibility | AccessibilityPage |
| F5 | /delete-account | DeleteAccountPage |

---

## 3. Current flow order (AS-IS)

The order the app actually moves in today, from the route chain and the go() call sites.

```
start -> splash -> login -> pathway -> home
                                     |
                     +---------------+---------------+
                     |               |               |
                   cats           stores        search
                     |               |               |
                  cat/:id          p/:id <---------+
                     |               |
                     +-------+-------+
                             |
                           cart
                             |
                         checkout
                             |
                          tracking
                             |
                           orders

Account:   profile -> settings
Business:  dashboard -> admin -> my-store -> setup/* -> finances
Driver:    driver -> driver-start -> active -> delivered -> queue -> earnings
```

### Flow weaknesses - measured, not opinion

| # | Problem | Evidence |
| --- | --- | --- |
| 1 | Cart is a dead end | after cart the only forward route is checkout; orders, alerts, membership and tracking are reachable only via nav |
| 2 | Product to cart has no return path | product.tsx line 66 calls go(/cart) after add; nothing returns to the category |
| 3 | Search sits outside the buy loop | search is in nav, but its results do not flow into cat/:id or cart |
| 4 | Stores is orphaned | stores to p/:id exists, but stores is not in the customer nav flow |
| 5 | setup/* is 7 undifferentiated hops | no ordering guidance between the 7 sub-pages |
| 6 | Driver flow has no loop closure | delivered is terminal; queue is separate and not linked from it |
| 7 | No transition between any page | Shell renders children directly - zero page-level animation |

---

## 4. Proposed flow order (TO-BE)

Content, copy, data and visual design stay IDENTICAL. Only order, grouping and transition change.

### 4.1 Entry - single direction, no branching

```
A1 start -> A2 splash -> A3 login -> A4 pathway -> A5 onb2 -> A6 kyc -> B1 home
```

Change: pathway moves after login. Today it can be reached before login; the proposed chain has one direction only.

### 4.2 Shopping - one CLOSED loop

```
B1 home
  -> B2 cats
      -> B3 cat/:id
          -> B5 p/:id
              -> B8 cart
                  -> back to B3  (continue shopping)   <- NEW return path
                  -> B9 checkout
                      -> B10 tracking
                          -> B11 orders
                              -> B3 (reorder)

Search overlay (any point): B6 search -> B3 or B5
Stores side-entry:        B4 stores -> B5 -> B8
```

Change 1: cart gains a continue-shopping return to the last category. Fixes weakness 2.
Change 2: tracking links forward to orders instead of dead-ending. Fixes weakness 1.
Change 3: search results route into cat/:id or p/:id. Fixes weakness 3.

No new screens. No removed screens. No copy change.

### 4.3 Account - attached to profile, not floating

```
C1 profile -> C2 settings -> back to C1
C3 plans  -> C1 profile
C4 role   -> A4 pathway
```

### 4.4 Business - ordered setup, not 7 loose hops

```
D1 dashboard
  -> D2 admin
      -> D3 my-store
          -> D15 setup
              -> D16 setup/business      (1 identity)
              -> D16 setup/certificates  (2 compliance)
              -> D16 setup/suppliers     (3 supply)
              -> D16 setup/inventory     (4 stock)
              -> D16 setup/services      (5 offer)
              -> D16 setup/guests        (6 access)
              -> D16 setup/deals         (7 growth)
          -> D5 finances -> D6 accountant
          -> D4 team
          -> D13 drivers-admin -> D14 driver-apply
```

Change: the 7 setup screens gain explicit order numbers 1 to 7. Fixes weakness 5.

### 4.5 Driver - loop closes

```
E5 queue
  -> E2 driver-start
      -> E3 active
          -> E4 delivered
              -> E5 queue   <- NEW loop back
  -> E7 earnings
      -> E6 driver-fees
```

Change: delivered returns to queue. Fixes weakness 6.

### 4.6 Flow comparison summary

| Stage | Before | After | Kinds of change |
| --- | --- | --- | --- |
| Entry | branching | linear | reorder |
| Shopping | open ends | closed loop | add 3 return links |
| Account | floating | attached | attach |
| Business | 7 loose hops | numbered 1-7 | order |
| Driver | terminal | looped | add 1 link |
| Legal | standalone | from settings | attach |
| Transitions | none | all pages | add animation |

---

## 5. Interaction specification per stage

Existing interaction surface, measured across src:

```
onClick handlers      161
onChange handlers      87
useState hooks         97
useEffect hooks        37
useRef hooks            3
setTimeout              8
setInterval             2
requestAnimationFrame   0   <- nothing is rAF-driven today
toast refs              0   <- no toast system exists
modal/sheet refs        3
active:scale presses    4
```

### 5.1 What is already interactive and should NOT change

| Screen | Interaction | Keep as is |
| --- | --- | --- |
| Cart | add / dec quantity | yes |
| Checkout | accordion sections (Acc) | yes |
| Login | sign in / sign up toggle | yes |
| Cat | filter chips | yes |
| Admin | tab switching | yes |
| Setup | checklist rows | yes |

### 5.2 Proposed additions - all additive, none replacing

| # | Screen | Interaction added | Why |
| --- | --- | --- | --- |
| I1 | Cart | swipe a row left to remove | today removal needs the minus button |
| I2 | Orders | pull down to refresh | list already has a refresh feed |
| I3 | Any list | skeleton while loading | no loading state exists today |
| I4 | Basket add | toast confirms the add | no toast system exists today |
| I5 | Checkout | press feedback on Pay | already has active:scale, extend it |
| I6 | Search | expand icon into full field | search is a full page today |
| I7 | Tracking | live pulse on the active step | static today |
| I8 | Driver | OTP-style code entry for delivery | pairs with existing OTP flow |

Every one of these is additive. Nothing is removed, so no content changes.

---

## 6. Animation specification

### 6.1 What exists today - measured

```
CSS @keyframes (5 total):
  kog-pop-in
  kogblink
  kogblinkring
  kog-arrow-bob
  kog-curtain-up        (already a page transition primitive)

animation: declarations     6
  (1x each of the five, plus 1 no-animation reset)
transition: declarations    9
transform: declarations    17
prefers-reduced-motion      HANDLED
```

GSAP is installed AND used:

```
gsap references         6
gsap. calls            3
import gsap            2
ScrollTrigger          4
useScrollReveal()      defined, used on most pages
data-reveal            attribute drives the reveal
```

Important: useScrollReveal currently sets opacity 1 and transform none BEFORE animating. It was changed to avoid a mobile blank screen. Any new animation must keep that guard.

### 6.2 Proposed animation layers

| Layer | Where | Technique | Reuse |
| --- | --- | --- | --- |
| L1 page transition | Shell | CSS keyframe | kog-curtain-up already exists |
| L2 list item reveal | all lists | GSAP stagger | useScrollReveal already exists |
| L3 cart add | product to cart | GSAP timeline | new, small |
| L4 count-up | cart total, earnings | number roll | new |
| L5 nav active | bottom nav | transform glide | nav already highlights |
| L6 pull refresh | Shell | already implemented | Shell has pull logic |
| L7 status pulse | tracking | CSS keyframe | new, 6 lines |

### 6.3 Motion rules to enforce

1. prefers-reduced-motion stays handled - already true, keep it.
2. Nothing animates opacity from 0 without an immediate visible fallback - the existing guard.
3. Every transition stays under 320ms. Existing value: .32s cubic-bezier(.34,1.56,.64,1).
4. rAF count is 0 today. L3 and L4 will introduce it; keep it under 2 rAF loops per page.
5. transform and opacity only. Never animate layout properties.

---

## 7. BeUI availability - verified

The BeUI registry is reachable and returned its full catalogue. Relevant components available:

| Stage | BeUI slug | What it gives |
| --- | --- | --- |
| Shell | pull-to-refresh | native-feeling pull, drag resistance |
| Nav | expandable-tabs | active tab expands to a labelled pill |
| Nav | shared-layout-bg | pill glides between items |
| Cart | swipeable-list | swipe rows for contextual actions |
| Cart | adaptive-stepper | quantity stepper with roll |
| Search | morphing-search | icon morphs into glass results |
| Search | command-palette | fuzzy filter, spring active row |
| Login | signup-form | field flags once left, strength meter |
| Login | otp-input | gliding focus ring, digit roll |
| Lists | animated-toast-stack | stacked confirmations |
| Lists | animated-badge | status pills with pulse |
| Numbers | number | count-up and rolling tickers |
| Sheets | bottom-sheet | snap points, inertia, glass |
| Modals | morphing-modal | height morphs between inner views |
| Charts | composition-chart | stacked bars with tooltips |
| Charts | heat-calendar | activity calendar |

### The blocker - stated plainly

Every BeUI component requires the motion runtime. Measured in this project:

```
framer-motion    0
motion/react     0
motion (dep)     NOT in package.json
```

So BeUI is NOT drop-in today. Using it means adding one dependency (motion) and its peer React 18 - which this project already has.

### Two viable paths

| Path | What changes | Risk |
| --- | --- | --- |
| P1 CSS and GSAP only | no new dependency | lowest - GSAP is already installed and used |
| P2 add motion, adopt BeUI | one new dependency | medium - new runtime on a phone PWA |

Recommendation: P1 first. GSAP and CSS already cover L1, L2, L3, L5, L6, L7. Only L4 benefits from BeUI. Ship P1, measure the phone build size, then decide on P2.

---

## 8. Implementation plan

Every step is additive. No content, copy or colour changes.

| Step | Change | File | Free |
| --- | --- | --- | --- |
| S1 | page transition on Shell using kog-curtain-up | App.tsx Shell | yes |
| S2 | cart continue-shopping return link | App.tsx Cart | yes |
| S3 | tracking to orders forward link | App.tsx Tracking | yes |
| S4 | search results route into cat/:id and p/:id | features.tsx | yes |
| S5 | delivered to queue loop link | App.tsx | yes |
| S6 | setup 1-7 order labels | store.tsx | yes |
| S7 | cart row swipe to remove | App.tsx Cart | yes |
| S8 | orders pull to refresh | shop.tsx | yes |
| S9 | add-to-basket toast | App.tsx | yes |
| S10 | cart total count-up | App.tsx Cart | yes |
| S11 | tracking status pulse | App.tsx Tracking | yes |

### Build pipeline required before any approval

Per project rule, every build must pass, in order:

1. impeccable design pass
2. improve-ui audit
3. better-typography pass
4. improve-ui re-check
5. Hallmark anti-slop audit
6. contrast audit on every muted text token
7. Reticle proofread as final gate

Then: build must exit 0, verify the exact user URL with and without cache-busting, screenshot attached, SW cache name bumped, reset.html kept.

---

## 9. Honest limits of this document

| Claim | Status |
| --- | --- |
| 56 routes | measured from live route chain |
| go() count 57 | measured |
| GSAP installed and used | measured |
| 5 CSS keyframes | measured |
| prefers-reduced-motion handled | measured true |
| motion NOT installed | measured |
| BeUI catalogue | retrieved live from the registry |
| BeUI components will work | NOT tested - dependency missing |
| Page transition visual result | NOT seen - vision load has been failing |
| Reduced-motion behaviour after changes | NOT tested |

Nothing in this document has been applied to the code. It is an assessment and a plan only.

---

## 10. Cost

| Item | Cost |
| --- | --- |
| Source scan and route extraction | 0.00 |
| BeUI catalogue retrieval | 0.00 |
| This document | 0.00 |
| Paid APIs | none |
| Dependencies installed | none |

---

## 11. Next action

| Say | Result |
| --- | --- |
| apply S1 | page transition on Shell only, then build and verify |
| apply S2-S6 | the five flow links, no visual change |
| apply all | S1 to S11, full pipeline run |
| beui | add motion and adopt BeUI components |

Recommendation: apply S2 to S6 first. They are pure flow links with no visual change, so they carry the lowest risk and fix all six measured flow weaknesses.

---

End of assessment. Generated 2026-10-03 11:02 IST.
