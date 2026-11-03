# Changelog

All notable changes to **DeepCool MYSTIQUE Control Hub** are documented here.

## [1.3.1] — 2026-11-03

### Improved — USB Device Access

- Improved libusb device discovery and opening for the DeepCool MYSTIQUE USB device (`3633:0009`).
- Added explicit USB interface access verification before First Launch media cleanup.
- Added clearer error reporting for USB permission failures.
- Added separate error handling for busy USB interfaces and disconnected devices.
- Improved distinction between a device being detected and actually being accessible.
- Ensured the USB access preflight does not transmit media cleanup commands.
- Preserved existing first-launch cleanup safety mechanisms and safeguards against automatic retries.

### Improved — First Launch Setup

- Added an early USB access check before presenting the destructive media cleanup confirmation.
- Added clearer notification when USB permissions prevent First Launch Setup.
- Confirmed that a failed USB access check does not attempt media deletion.
- Retained the explicit confirmation requirement before clearing stored GIFs and images.
- Retained the 120-second waiting period and the distinction between USB acknowledgement and actual SD media completion.

### Packaging

- Updated the tested Flatpak packaging workflow to use KDE Platform 6.10.
- Resolved a Qt runtime incompatibility encountered when packaging a host-built Qt 6.11 executable for KDE Platform 6.10.
- Recompiled the application with a compatible Qt 6.10 SDK.
- Produced and installed a new Flatpak bundle containing the updated application executable.
- Confirmed that the new USB access error handling is present in the packaged executable.

### Validation

Maintainer testing confirmed:

- Successful native compilation and application startup.
- Successful Flatpak startup using KDE Platform 6.10.
- Working DeepCool MYSTIQUE device detection.
- Working CPU and GPU metrics.
- Working GIF management.
- Working RGB controls.
- Working autostart functionality.

### Unchanged

Version 1.3.1 does not intentionally change:

- Existing system metrics calculations.
- GIF rendering and upload functionality.
- RGB operating modes.
- Firmware communication behavior beyond the specified USB access handling.
- Display presentation and user interface layout.

### Outstanding Verification

The separate host-side USB permissions installer still requires testing on a fresh Linux installation without pre-existing compatible udev rules.

In particular, the original PikaOS USB access issue has not yet been independently confirmed resolved on that user's system.

---

## [1.3.0] — 2026-10-25

### Qt6 Control Hub Baseline

Version 1.3 established the functional release baseline for the Linux DeepCool MYSTIQUE Control Hub.

The release includes the following capabilities.

### LCD and GIF Management

- Animated GIF management for the cooler display.
- Five available GIF management slots.
- GIF import, crop and preview functionality.
- GIF upload and deletion handling.
- Display rotation and brightness settings.
- Media operation status tracking and safety safeguards.

### Hardware Metrics

- Live CPU temperature, load and clock monitoring.
- Live GPU temperature, load and clock monitoring.
- RAM and VRAM usage monitoring.
- Vendor-aware sensor handling.
- Live metric visualization within the Qt6 interface.

### RGB and Display Controls

- Motherboard RGB mode.
- Temperature RGB mode.
- GIF Motion RGB mode.
- RGB preview and display brightness controls.

### Diagnostics

- Hardware profile information.
- Active sensor source reporting.
- USB and application status reporting.
- Live event logging.
- Temperature warning indicators.

### Desktop Integration

- Qt 6 graphical user interface.
- KDE desktop integration.
- System-tray functionality.
- Background operation.
- Configurable autostart.

### First Launch Safety

- One-time media cleanup workflow for the cooler's stored GIFs and images.
- Explicit user confirmation before the destructive command.
- Persistent cleanup state tracking.
- Protection against automatically repeating uncertain cleanup attempts.
- A 120-second waiting period following a submitted cleanup request.

---

## Release Notes

### Hardware Compatibility

The verified target device is the DeepCool MYSTIQUE 360 ARGB with USB identifier `3633:0009`.

### Flatpak Compatibility

Version 1.3.1 uses a tested KDE Platform 6.10 Flatpak build. The application must be compiled against a compatible Qt runtime to avoid startup failures.

### USB Host Permissions

USB access depends on permissions granted by the host Linux operating system. A Flatpak bundle alone does not install host udev rules.

### Safety

Media cleanup operations can permanently delete stored images and GIFs from the cooler. The application must not automatically repeat cleanup requests with uncertain outcomes.

---

**Project:** DeepCool MYSTIQUE Control Hub  
**Developer:** LionheartTim  
**Repository:** https://github.com/LionheartTim/Deepcool-Mystique-AIO-Linux-with-dashboard
