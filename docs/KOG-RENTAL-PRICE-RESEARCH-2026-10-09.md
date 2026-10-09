# Kingdom Organics - Rental Price Research

Date 2026-10-09. Internal planning. Read-only research.

## The question

Set the daily rental price for the cargo e-bike and the electric van so that it
undercuts every comparable cost a courier can get elsewhere, the courier still
clears Irish minimum wage comfortably, and the platform still makes a margin.

## Market rates found, 2026-10-09

Van hire, Ireland:

- Enterprise Rent-A-Car, average EUR 18 per day, KAYAK aggregate
- Skyscanner, from EUR 26 per day
- KAYAK popular commercial truck class, EUR 51 per day

Cargo e-bike:

- Hygglo peer to peer, about EUR 31 per day
- OurBike UK community share, about EUR 40 per 8 hour day, EUR 5 per hour
- Riese and Muller GBP 4 per day on 3 month terms, UK
- Bleeper LeaseBike EUR 39.99 per week, EUR 5.71 per day, Dublin, family e-bike not cargo

Minimum wage:

- The live search returned nothing this run. The model of record uses EUR 13.50 per
  hour, EUR 108 per 8 hour day. NOT re-verified this run. Flagged.

## The key insight about the van

The headline rental rate is not the courier real cost. A diesel van from Enterprise
at EUR 18 a day still needs fuel. A van doing 180 km a day burns about EUR 25 of
diesel. The true cost is closer to EUR 43 a day, not EUR 18.

Our electric van includes charging in the rent. That is the real advantage and it is
where the undercut comes from.

## Costs the platform carries per van per day

| Item | Per day | Source |
| --- | --- | --- |
| Van lease | 13.16 | model of record, ESTIMATE |
| Charging, grid, blended | 8.00 | 20 kWh per 100 km at EUR 0.30 |
| Insurance, servicing, damage | 5.00 | ESTIMATE, not in model of record |
| TRUE COST | 26.16 | |

Important: the model of record claimed a margin of EUR 21.84 a day at EUR 35 rent.
That figure only subtracts the lease. It ignores charging. The real margin at EUR 35
is closer to EUR 8.84. That gap is an error in the model of record and should be
corrected.

My first pass on this said van rent of EUR 17 a day. That was wrong for the same
reason and is withdrawn.

## Recommended prices

| Vehicle | New price per day | Old price per day |
| --- | --- | --- |
| Cargo e-bike | 9 | 12 |
| Electric van | 30 | 35 |
| Electric moped | 20 | 20 |

## Undercut proof, cargo e-bike

| Comparable | Their price per day | Our EUR 9 | Undercut |
| --- | --- | --- | --- |
| Hygglo casual | 31 | 9 | 71 pct |
| OurBike hourly share | 40 | 9 | 78 pct |
| Bleeper weekly, long term | 5.71 | 9 | we are above |

Honest gap: we do not beat the long term Dublin subscriptions at EUR 4.70 to 5.71 a
day. Those are long commitments on a different bike class. A no commitment, no
deposit, charging included cargo bike at EUR 9 a day is a different product. To
compete there, offer a weekly rate of EUR 40.

## Undercut proof, electric van

| Comparable | Their all in cost per day | Our EUR 30 | Undercut |
| --- | --- | --- | --- |
| Enterprise 18 plus fuel 25 | 43 | 30 | 30 pct |
| Skyscanner 26 plus fuel 25 | 51 | 30 | 41 pct |
| Commercial truck 51 plus fuel 25 | 76 | 30 | 61 pct |

## Courier profitability proof

Minimum wage EUR 13.50 per hour, EUR 108 per 8 hour day. Unverified this run.

| Vehicle | Zone | Drops | Gross | Rent | Net | Per hour | Clears floor |
| --- | --- | --- | --- | --- | --- | --- | --- |
| E-bike | Z1 town | 22.9 | 137.40 | 9 | 128.40 | 16.05 | YES |
| Van | Z2 ring | 16.0 | 144.00 | 30 | 114.00 | 14.25 | YES |
| Van | Z3 inter-town | 10.7 | 149.80 | 30 | 119.80 | 14.98 | YES |

Break-even drops to cover the rent:

- E-bike Z1: 1.5 drops
- Van Z2: 3.3 drops
- Van Z3: 2.1 drops

Renting our van beats using their own car. On Z3, own car nets 108.98 a day, which is
13.62 per hour, after fixed costs and fuel. Our van nets 119.80, which is 14.98 per
hour. The van rental is better for the courier by EUR 10.82 a day, because we carry
the lease and the charging.

## Platform margin at the new prices

| Line | Units | Rent per day | Days | Income |
| --- | --- | --- | --- | --- |
| E-bikes | 6 | 9 | 260 | 14,040 |
| Vans, margin 3.84 per day | 3 | - | 260 | 2,995 |
| Total | | | | 17,035 |

The model of record projected 46,020 at the old prices. The new prices cut platform
rental income by about 63 pct.

State this plainly: rental is not the profit centre. The profit is the store
commission. Rental exists to put a courier on the road.

## When the van gets cheaper again

Charging is the big variable at EUR 8 a day on grid power. With depot solar, marginal
charging cost approaches zero. That drops true cost from about 26.16 to about 18.16 a
day, and the rent can fall from 30 to about 22 and still hold a margin. Solar is what
makes the van cheap later.

## Recommendation summary

1. Cargo e-bike at EUR 9 a day now. Undercuts casual hire by 71 pct, pays for itself
   in 161 rental days.
2. Van at EUR 30 a day now. It cannot go far below that without running at a loss on
   grid charging.
3. Drop the van to about EUR 22 a day once depot solar is live.
4. Keep the moped at EUR 20. No local market rate to undercut, no confirmed Irish
   cargo moped price.
5. Correct the model of record: the EUR 21.84 van margin at EUR 35 ignores charging.

## Open items

1. Van lease at 13.16 a day is an ESTIMATE. Get a real quote.
2. Insurance and servicing at EUR 5 a day is my ESTIMATE, not sourced.
3. Minimum wage EUR 13.50 an hour was not verified this run.
4. No confirmed Irish electric cargo moped purchase price.

## Sources

- KAYAK van hire Ireland, average and popular classes
- Skyscanner van hire Ireland
- Enterprise Rent-A-Car Ireland
- Hygglo cargo bike category
- OurBike UK
- Riese and Muller via Cycling Electric
- Bleeper LeaseBike Dublin

Compiled 2026-10-09. Read only. No code changed. Cost EUR 0.
