# ❄️ Winter Hide

> **Spoof it. Hide it. Winter does it.**

**Winter Hide** is a dynamic Magisk / KernelSU module designed for device spoofing and system customization through a simple recovery-based interface controlled entirely with the **volume buttons**.

Instead of hardcoding every supported device into the module logic, Winter Hide dynamically detects available spoofers and customization packs from the module itself.

---

## ✨ Features

### 📱 Device Spoofing

Choose from multiple device profiles and spoof your device properties using dynamically loaded `system.prop` files.

Supported profiles can include devices such as:

* Galaxy A26
* Galaxy A35
* Galaxy A51
* Galaxy A56
* Galaxy S22
* Galaxy S22 Ultra
* Galaxy S23 FE
* Galaxy S24 Ultra
* Galaxy S25 FE
* Galaxy S26 Ultra

> Available spoofers depend on the folders included in the module.

---

### 🎨 Dynamic Font Changer

Winter Hide supports dynamically loaded font packs.

A font pack only needs to contain:

```text
Roboto-Regular.ttf
```

Optional files can include:

```text
NotoColorEmoji.ttf
OneUISans-VF.ttf
```

Simply add another valid folder inside:

```text
Fonts/
```

and Winter Hide can detect it automatically.

---

### 🎛️ OneUI & Non-OneUI Profiles

Winter Hide separates spoofers into two categories:

```text
SpoofersOneUI/
SpoofersNonOneUI/
```

This allows different device profiles to be provided depending on the user's ROM environment.

---

## 🔊 Volume Button Control

Winter Hide does **not** use WebUI.

The entire configuration process is controlled directly from the recovery/module installation interface using the device's **volume buttons**.

### Controls

| Button         | Action          |
| -------------- | --------------- |
| 🔊 Volume Up   | Next / Confirm  |
| 🔉 Volume Down | Select / Change |

This allows the module to be configured even when no WebUI or Android interface is available.

During installation, Winter Hide guides the user through:

* User profile selection
* Device spoofer selection
* Font pack selection
* Live Blur configuration
* Native AI configuration
* Confirmation screens
* Final configuration summary

---

## 📂 Dynamic Architecture

One of Winter Hide's main goals is to avoid unnecessary hardcoding.

### Spoofers

Add a new spoofer by creating:

```text
SpoofersOneUI/MyDevice/
└── system.prop
```

or:

```text
SpoofersNonOneUI/MyDevice/
└── system.prop
```

The module automatically detects valid spoofer folders during installation.

### Font Packs

Add a new font pack:

```text
Fonts/MyFont/
├── Roboto-Regular.ttf
├── NotoColorEmoji.ttf
└── OneUISans-VF.ttf
```

`Roboto-Regular.ttf` is required for a font pack to be considered valid.

---

## 🧩 Module Structure

```text
WinterHide/
├── META-INF/
│   └── com/
│       └── google/
│           └── android/
│               ├── update-binary
│               └── updater-script
│
├── Fonts/
│   └── <Font Packs>/
│
├── SpoofersOneUI/
│   └── <Device Profiles>/
│       └── system.prop
│
├── SpoofersNonOneUI/
│   └── <Device Profiles>/
│       └── system.prop
│
├── action.sh
├── customize.sh
├── module.prop
└── update.json
```

---

## ⚙️ Requirements

* Android device
* Magisk or KernelSU
* Android 13 or newer recommended
* A ROM compatible with the selected customization
* No conflicting modules modifying the same properties or system fonts

---

## 📥 Installation

1. Download the latest Winter Hide release.
2. Open Magisk or KernelSU.
3. Install the Winter Hide ZIP.
4. Follow the instructions displayed during installation.
5. Use **Volume Up** and **Volume Down** to navigate and configure Winter Hide.
6. Reboot when requested.

No WebUI is required.

---

## 🔄 OTA Updates

Winter Hide supports module update checking through `update.json`.

Current update endpoint:

```text
https://raw.githubusercontent.com/xv2ice/WinterHide/main/update.json
```

The update system uses:

```text
version
versionCode
zipUrl
```

to determine whether a newer module release is available.

---

## 🛠️ Development

Winter Hide is designed to be expandable.

Adding a new spoofer generally does not require modifying the core detection logic.

Example:

```text
SpoofersOneUI/
└── S99Ultra/
    └── system.prop
```

Once the folder contains a valid `system.prop`, it can be detected as an available spoofer.

The same concept applies to font packs.

---

## ⚠️ Compatibility & Conflicts

Do **not** use multiple modules that modify the same properties simultaneously.

Potential conflicts include:

* Other build.prop spoofing modules
* Device identity spoofers
* Font replacement modules
* Modules modifying `floating_feature.xml`
* ROMs that already perform device spoofing

If another module modifies the same property after Winter Hide, the final value may depend on module mounting and property-loading order.

---

## 🔐 Disclaimer

Winter Hide modifies system properties and system resources.

Use it at your own risk.

The developer is not responsible for:

* Bootloops
* Application incompatibility
* Broken System UI
* Conflicting modules
* Data loss
* Incorrect device spoofing
* ROM-specific issues

Always keep a recovery method available before modifying system-level components.

---

## 🧪 Tested On

- KernelSU Fork
- One UI 8.0
- One UI 8.5
- LineageOS (LOS)

---

## 📝 Important Notes

### 🛡️ NoMount

**NoMount is recommended when using Winter Hide.**

For the best experience:

* Install and configure **NoMount** first.
* Reboot your device.
* Flash and configure **Winter Hide** after reboot.
* Avoid using multiple modules that mount or replace the same system files.

NoMount is **not included** with Winter Hide and must be installed separately.

> ⚠️ If you experience unexpected behavior, boot issues, or changes not being applied correctly, check for mounting conflicts first.

---

### 🔧 UN1CA ROM & Customized AOSP

If you are using **UN1CA** or a **Customized AOSP ROM**, use the Device Spoofing feature carefully.

Some ROMs may already modify or spoof device properties. Running another spoofing solution at the same time can cause conflicting values.

Before applying a Winter Hide spoofer:

* Check whether your ROM already performs device spoofing.
* Avoid running multiple spoofing modules simultaneously.
* Make sure another module or ROM component is not overriding the same properties.
* If possible, test Winter Hide with other spoofing modules disabled.

> ⚠️ Winter Hide does **not** require UN1CA and is **not affiliated with the UN1CA project**.

---

### ⚠️ General Recommendation

For the cleanest setup, avoid having multiple modules modify the same components, especially:

```text
system.prop
build.prop
floating_feature.xml
system/fonts/
```

If something does not behave as expected, temporarily disable other modules that modify the same components and test Winter Hide by itself.

This makes it easier to identify conflicts and determine whether the issue is caused by Winter Hide or another module.

---

## 🙏 Credits

### Winter Hide

**Developer:** Xv2Ice

Special thanks to:

* **MRX7014** — S26 Ultra Spoofer + All Devices Spoofer Idea
* @chirag_thisside Testing The Module
* Everyone contributing device profiles, testing, and feedback

---

## 📢 Community

**Better Call ICE**

Stay tuned for updates, releases, and projects.


---

<p align="center">

### ❄️ Winter Hide

**Spoof it. Hide it. Winter does it.**

Made with ❤️ by **Xv2Ice**

</p>
