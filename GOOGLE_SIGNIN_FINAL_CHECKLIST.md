# ✅ Google Sign-In Final Troubleshooting Checklist

This checklist will help us find the configuration mismatch causing `ApiException: 10`. Please verify every single point carefully.

---

### **Part 1: Google Cloud Console Configuration**

**Project:** `sylonow-85de9` (`828054656956`)

**1. Web Client ID Verification:**
   - [ ] Go to **APIs & Services > Credentials**.
   - [ ] Find your **Web application** OAuth Client.
   - [ ] **Confirm Client ID is:** `828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com`.
   - [ ] **Confirm Authorized redirect URI is exactly:** `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`.

**2. Android Client ID Verification:**
   - [ ] Go to **APIs & Services > Credentials**.
   - [ ] Find your **Android** OAuth Client.
   - [ ] **Confirm Package name is exactly:** `com.example.sylonow_vendor`.
   - [ ] **Confirm SHA-1 fingerprint is exactly:** `56:DC:06:41:C0:31:2A:CE:30:49:48:FC:01:E4:EC:D6:88:38:41:8E`.

---

### **Part 2: `google-services.json` File Verification**

**File Location:** `android/app/google-services.json`

**1. File Structure:**
   - [ ] Open the file.
   - [ ] **Confirm the structure is for mobile apps**, starting with `"project_info"` and `"client": [...]`. It **MUST NOT** contain `"installed":{...}`.

**2. File Content:**
   - [ ] Inside the file, find `"client_info"`.
   - [ ] **Confirm `"package_name"` is:** `com.example.sylonow_vendor`.
   - [ ] Find the `"oauth_client"` array.
   - [ ] **Confirm the `client_id` inside this array matches your NEW Android Client ID** from Part 1.

---

### **Part 3: Supabase Dashboard Configuration**

**1. Google Provider Settings:**
   - [ ] Go to your Supabase project > **Authentication > Providers > Google**.
   - [ ] **Confirm Status is:** ✅ Enabled.
   - [ ] **Confirm "Client ID" field contains the WEB Client ID:** `828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com`.
   - [ ] **ADD THE ANDROID CLIENT ID** to this list as well. You should have **TWO** client IDs listed here (Web and Android).
   - [ ] **Confirm "Client Secret" field is filled.**
   - [ ] **Confirm "Skip Nonce Check" is:** ✅ Enabled.

---

### **Part 4: Flutter Code & Build**

**1. Code Verification:**
   - [ ] Open `lib/core/services/google_auth_service.dart`.
   - [ ] **Confirm `serverClientId` is the WEB Client ID:** `828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com`.

**2. Clean Build:**
   - [ ] After verifying all the above, run these commands in your terminal:
     ```bash
     flutter clean
     flutter pub get
     ```
   - [ ] Uninstall the app from your emulator/device completely.
   - [ ] Run the app again.

---

### **Conclusion**

If the error still persists after ticking every single box on this list, the only remaining possibility is a propagation delay on Google's side, which can sometimes take more than 10-15 minutes. The mismatch *will* be in one of these items. Let's find it. 