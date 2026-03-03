# Privacy Policy — Sumber Sinar Emas

**Effective Date:** 3 March 2026
**Last Updated:** 3 March 2026

---

## 1. Introduction

Welcome to **Sumber Sinar Emas** ("the App"), a real estate information application operated by **PT Sumber Sentuhan Emas** ("we", "us", or "our"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application on Android or iOS.

Please read this policy carefully. If you do not agree with its terms, please discontinue use of the App.

---

## 2. Information We Collect

### 2.1 Information You Do Not Directly Provide
The App is primarily a **read-only property catalogue**. We do **not** require you to register an account, and we do **not** collect your name, email address, or personal credentials.

### 2.2 Device Location Data
With your explicit permission, the App accesses your device's location (GPS / network-based) for the following purposes:

- Displaying your position relative to featured property locations on an interactive map (powered by **Google Maps**).
- Showing directions to property sites.

Location access is requested only while you are actively using the App ("When In Use"). We do **not** collect or store your location on our servers. Location data is processed locally on your device and passed directly to Google Maps for rendering.

### 2.3 Data Collected Automatically via Firebase
We use **Google Firebase** (Cloud Firestore & Firebase Storage) as our back-end infrastructure. Firebase may automatically collect:

| Data Type | Purpose |
|---|---|
| App instance identifiers | Analytics and crash diagnostics |
| Device model & OS version | Ensuring compatibility |
| General region / country | Aggregated usage statistics |

Firebase's data practices are governed by [Google's Privacy Policy](https://policies.google.com/privacy).

### 2.4 Images (Admin Panel Only)
The App's admin panel allows authorised staff to upload property images and marketing contact photographs using the device's camera or photo library (`image_picker`). These images are stored in **Firebase Storage** and are publicly accessible via URL as part of the property listings. End-users of the public app cannot upload images.

---

## 3. How We Use the Information

We use the information described above to:

1. Display property listings, images, unit details, pricing, and location information.
2. Show the office location and nearby landmarks on the in-app map.
3. Connect interested users to our marketing agents via **WhatsApp** (the App opens WhatsApp with the agent's number; we do not intercept or store the WhatsApp conversation).
4. Allow administrators to manage property content through the admin panel.
5. Monitor app stability and performance through Firebase diagnostic data.

---

## 4. Third-Party Services

The App integrates the following third-party services, each governed by their own privacy policy:

| Service | Purpose | Privacy Policy |
|---|---|---|
| Google Firebase (Firestore & Storage) | Data storage & media hosting | [Google Privacy Policy](https://policies.google.com/privacy) |
| Google Maps Flutter | Interactive property maps | [Google Maps Privacy](https://maps.google.com/help/terms_maps/) |
| WhatsApp | Direct messaging with agents | [WhatsApp Privacy Policy](https://www.whatsapp.com/legal/privacy-policy) |

---

## 5. Data Storage and Security

- Property content (project listings, images, contact details) is stored in **Firebase Cloud Firestore** and **Firebase Storage**, hosted on Google's infrastructure in accordance with Google's security standards.
- We do **not** store your device location on our servers.
- We implement industry-standard measures to protect the data hosted on Firebase, including Firebase Security Rules and restricted API key access.
- Despite these measures, no electronic transmission or storage is 100% secure. We encourage you to report any security concerns to us immediately.

---

## 6. Permissions Requested

| Permission | Platform | Reason |
|---|---|---|
| `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` | Android | Show your position on the property map |
| `NSLocationWhenInUseUsageDescription` | iOS | Show your position on the property map |
| `READ_EXTERNAL_STORAGE` / `CAMERA` (admin only) | Android | Upload property and contact images |
| `NSPhotoLibraryUsageDescription` / `NSCameraUsageDescription` (admin only) | iOS | Upload property and contact images |

You may revoke location or media permissions at any time through your device's Settings app. Revoking location permission will disable the map-based features; the rest of the App will continue to function normally.

---

## 7. Children's Privacy

The App is intended for general audiences interested in real estate and is **not directed at children under the age of 13**. We do not knowingly collect personal information from children. If you believe a child has provided us with information, please contact us and we will promptly delete it.

---

## 8. Links to External Sites

The App may open external links such as WhatsApp numbers and property brochure URLs. We are not responsible for the privacy practices of those external sites or applications. We encourage you to read their privacy policies before interacting with them.

---

## 9. Changes to This Privacy Policy

We may update this Privacy Policy from time to time. When we do, we will revise the **Last Updated** date at the top of this document. We encourage you to review this page periodically. Continued use of the App after any changes constitutes your acceptance of the revised policy.

---

## 10. Contact Us

If you have any questions or concerns about this Privacy Policy, please contact us at:

**PT Sumber Sentuhan Emas**
📧 Email: *[your-email@sumbersinaremas.com]*
📞 Phone: *[your-phone-number]*
📍 Address: *[your-office-address]*

---

*This Privacy Policy was generated based on the technical implementation of the Sumber Sinar Emas application (Flutter, Firebase, Google Maps). Please review it with a legal professional before publishing it to app stores.*
