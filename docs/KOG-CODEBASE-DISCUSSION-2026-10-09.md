# Kingdom Organics - Codebase Technical Discussion

## Current Technical State
- **Backend**: FastAPI, 98 routes, SQLite, driver queue, KYC, fee table, payouts, health checks. Live on Render.
- **Frontend**: React/Vite, PWA, 3 role pathways (Customer, Store Admin, Driver), service worker (aura-v172), live on Vercel.
- **Routing**: Distance bands (6/9/14 EUR), zone logic, queue/claim system, driver earnings tracking.
- **Payments**: Stripe integration, invoice generation, receipt scanning.
- **Security**: HTTPS, SW cache-busting, reset.html, role-based access.

## What Is Working & Dependable
- End-to-end order flow: customer orders, store accepts, driver claims, delivery completes, payout triggers.
- Driver KYC, vehicle record, runs, queue and claim, distance tracking.
- Store Admin panel with single-store views, inventory management, and order tracking.
- PWA with offline support, auto-update banner, and reset.html kill-switch.
- Live deployment pipeline via Vercel CLI and Termux.

## What Is Missing for 22 Stores
1. **Multi-tenant isolation**: Currently single-tenant. All stores share one database. No store_id on orders, inventory, or payouts.
2. **Store onboarding**: No self-service signup. Admin must manually create each store.
3. **Store-specific pricing**: One fee table for all. No per-store commission or delivery radius.
4. **Bulk reporting**: No consolidated dashboard for 22 stores. Only single-store admin views.
5. **Automated invoicing**: Manual receipt scanning. No bulk invoice generation or tax reporting.
6. **Inventory sync**: No real-time stock sync with store POS systems. Manual entry only.

## Open-Source Dispatch Integration Plan
- **Target engines**: open-dispatch, RL-Delivery-Dispatcher, Ai-Order-Dispatch (all free, production-ready, no vendor fees).
- **Integration point**: Wire to existing /api/driver/queue endpoint.
- **Timeline**: 1-2 days for initial wiring, 1 week for testing and optimization.
- **Cost**: EUR 0. Open-source, locally deployable, no API subscriptions.

## AI Inventory Onboarding Approach
- **Input methods**: Camera scan, PDF upload, manual entry.
- **Processing**: AI organizes into app structure within 24-48 hours.
- **No POS sync required**: Replaces traditional integration for pilot phase.
- **Data protection**: Strict GDPR compliance. No private customer data stored.

## Technical Roadmap
### Phase 1: Pilot (Weeks 1-3)
- Deploy to 3 stores (single-tenant)
- Manual onboarding, AI inventory, distance-band pricing
- Track metrics, fix bugs, stabilize
- Produce proof report for LEADER/LEO funding

### Phase 2: Multi-Tenant Refactor (Weeks 4-6)
- Add store_id to all database tables
- Build self-service store onboarding flow
- Implement per-store pricing and delivery radius
- Develop consolidated bulk reporting dashboard
- Add automated invoicing and tax reporting

### Phase 3: Scale to 22 Stores (Months 2-3)
- Deploy multi-tenant architecture
- Integrate open-source dispatch engine
- Launch bulk reporting and automated invoicing
- Scale to 22 stores with zero capital lock-up

## Zero-Capital Deployment Strategy
- **Cohort C only**: Rely on drivers with own vehicles. No fleet purchase or lease.
- **Open-source routing**: No vendor fees, no black-box dispatch.
- **Free hosting**: Vercel (frontend), Render (backend), GitHub (code).
- **AI inventory**: Replaces expensive POS integration.
- **Pilot revenue**: Funds Phase 2 development.

## Technical Debt & Risks
- **Single-tenant architecture**: Must refactor before 22 stores.
- **Manual inventory**: AI onboarding reduces but does not eliminate manual work.
- **Driver KYC**: Requires insurance and vehicle verification process.
- **Payment processing**: Stripe fees apply per transaction.
- **Data compliance**: GDPR requires strict data handling procedures.

## Next Steps
1. Finalize 3-store pilot list (Tralee/Killarney organic/halal/independent)
2. Deploy open-source dispatch engine to /api/driver/queue
3. Build AI inventory onboarding pipeline
4. Launch pilot, track metrics, produce proof report
5. Submit LEADER/LEO EOI with pilot data

Cost: EUR 0. Free open-source tools, existing code, no paid APIs. Next step: say "deploy dispatch" and I wire open-dispatch to your backend, or "pilot" and I draft the 3-store onboarding checklist.