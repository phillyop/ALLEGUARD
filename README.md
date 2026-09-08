# AllerGuard

**Stay safe. Scan smarter.**

AllerGuard is an iOS app that helps people with food allergies check ingredient labels in seconds — scan a label with the camera, and get an instant verdict on whether it's safe to eat, based on your personal allergen profile.

## Why

Reading ingredient labels is slow, and cross-contact warnings ("may contain traces of...") are easy to miss under stress or time pressure. AllerGuard automates that check: point your camera at a label, and it tells you — clearly and immediately — whether something in your allergen profile shows up.

## Features

- **Label scanning (OCR)** — Take a photo of an ingredient panel and the app extracts the text on-device using Apple's Vision framework. No photo or text ever leaves your phone.
- **Personalized allergen profile** — Track any of 9 major allergen categories (milk, egg, fish, shellfish, tree nuts, peanuts, wheat, soy, sesame) plus custom allergens, each with its own sensitivity level:
  - **Strict** — flags both direct matches and "may contain" cross-contact warnings as unsafe/caution
  - **Moderate** — flags direct matches as unsafe; cross-contact is noted but doesn't block
  - **Informational** — logs matches for awareness without affecting the safety verdict
- **Verdict engine** — Ingredient text is checked against curated allergen term dictionaries (including alternate names like "casein" for milk or "arachis" for peanuts) and common cross-contact phrasing, then classified as **Unsafe**, **Caution**, **Looks Clear**, or **Uncertain**, with a confidence score.
- **Scan history** — Every scan is saved locally with its verdict, flagged allergens, and confidence level. Filter by time range or result type.
- **Reaction logging** — Optionally log how you actually felt after eating (No reaction / Mild / Serious), building a personal record alongside your scan history.
- **Emergency contacts** — Save emergency contacts and dial or text them directly from the app in one tap.
- **Product lookup (in progress)** — UI for searching or scanning a barcode to check previously logged products. Not yet wired up to a live barcode scanner or product database.

## How it works

1. Camera or photo library → image of the label
2. On-device OCR (Vision framework) extracts the raw text
3. Text is normalized and checked against your allergen list and sensitivity settings
4. The engine looks for direct ingredient matches and "may contain" / shared-facility language separately
5. You get a verdict, a confidence score, and the specific evidence (which words triggered the match)

This is a deterministic, rule-based matching engine over curated allergen dictionaries — not a trained ML model. The only ML involved is Apple's built-in Vision OCR for text recognition.

## Privacy

AllerGuard does not use a backend. There are no network calls other than placing a phone call or opening the Messages app when you use the emergency contact feature. Your photos, scan history, and allergen profile stay on your device.

## Tech stack

- SwiftUI
- SwiftData (local persistence for profile, scan history, emergency contacts)
- Vision (on-device OCR)
- AVFoundation (camera capture)

## Requirements

- iOS 26.0+
- Xcode 16+
- Swift 5.0

## Getting started

1. Clone the repo
2. Open `ALLEGUARD.xcodeproj` in Xcode
3. Build and run on a simulator or device (camera features require a physical device)

## Roadmap

- [ ] Live barcode scanning and product database lookup
- [ ] iCloud sync for scan history across devices
- [ ] Widget for quick-scan from the home screen

## Disclaimer

AllerGuard is a personal project built for learning and portfolio purposes. It is **not a medical device** and should not be relied on as a sole safety check for severe allergies. Always verify ingredients independently and consult an allergist for medical guidance.

## License

MIT — feel free to explore, learn from, or build on this project.
