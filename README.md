# Ranchi Ride — refreshed website

A responsive, GitHub Pages-compatible front-end redesign inspired by the clean, enquiry-led structure of SAAM Taxi, with Ranchi Ride's own brand and content.

## Files
- `index.html` — redesigned home page and WhatsApp ride-request form
- `track.html` — tracking page UI (live updates require backend setup)
- `admin.html` — admin dashboard starter / backend setup notice
- `driver.html` — driver portal starter / backend setup notice
- `images/` — supplied Ranchi Ride logo and banner
- `supabase-setup.sql` — original database starter schema
- `TRACKING-SETUP.txt` — tracking integration notes

## Publish on GitHub Pages
1. Extract this ZIP.
2. Open your `terasynctech/ranchi-ride` repository.
3. Upload the **contents inside `ranchi-ride-main`** (not the outer folder) to the repository root.
4. Allow GitHub to replace the existing `index.html`, `admin.html`, and `driver.html`; upload the `images` folder and remaining files too.
5. In Settings → Pages, publish from the `main` branch and `/ (root)`.
6. Open `https://terasynctech.github.io/ranchi-ride/` and hard-refresh with `Ctrl + F5`.

## Booking behavior
The booking form opens WhatsApp with the entered journey details to `+91 76338 01161`. The customer must press Send in WhatsApp. This is a booking request, not an automatic confirmed booking.

## Important production notes
- The current booking form is front-end only; it does not store requests in a database.
- The admin and driver pages are interface starters, not authenticated operational dashboards.
- Live cross-device tracking requires a configured backend, authenticated driver accounts, secure database policies and GPS publishing. See `TRACKING-SETUP.txt`.
- Fare calculation / final pricing is confirmed by the operator; do not present indicative values as a final quote.
- Public OpenStreetMap/Nominatim services have usage limits. For commercial scale, use a provider and usage policy suitable for production.
