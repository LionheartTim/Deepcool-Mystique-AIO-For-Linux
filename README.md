# DeepCool MYSTIQUE Control Hub

**Version 1.3.1 | Linux | Qt 6 | Flatpak**

A graphical Linux application for monitoring and controlling the **DeepCool MYSTIQUE 360 ARGB** liquid cooler.

DeepCool MYSTIQUE Control Hub provides live system metrics, LCD display management, GIF uploads, RGB controls, diagnostics and desktop integration.

> **Unofficial community project.** This software is not affiliated with, sponsored by or endorsed by DeepCool.

## Features

### LCD and GIF Management

- Upload and manage animated GIFs on the cooler's LCD display.
- Manage up to five GIF slots.
- Drag-and-drop GIF import.
- GIF cropping, positioning and preview controls.
- Display rotation and brightness controls.
- Delete selected GIFs.
- Local upload status tracking and recovery safeguards.

### Live System Metrics

Monitor eight system measurements:

- CPU temperature
- CPU load
- CPU clock speed
- RAM usage
- GPU temperature
- GPU load
- GPU clock speed
- VRAM usage

The application includes vendor-aware sensor handling for supported AMD, Intel and NVIDIA hardware. Sensor availability depends on the system and drivers.

### RGB Controls

Three selectable RGB modes:

- Motherboard RGB
- Temperature RGB
- GIF Motion RGB

The interface includes RGB preview effects and brightness controls. Some effects are visual simulations; the application does not independently read back every hardware lighting state.

### Diagnostics

A dedicated Diagnostics tab provides:

- CPU and GPU hardware information.
- Active sensor sources.
- USB connection information.
- GIF management status.
- Upload and deletion safety information.
- Live application event logging.
- Temperature warning indicators.

Diagnostics are designed to provide information without changing hardware settings.

### Desktop Integration

- Native Qt 6 desktop interface.
- KDE Plasma and system-tray integration.
- Optional automatic startup at login.
- Minimized background operation.
- Persistent application settings.
- Wayland and X11 support through Flatpak.

Closing the main window can leave the application running in the system tray so live hardware updates continue.

## Supported Hardware

| Device | USB ID | Status |
|---|---|---|
| DeepCool MYSTIQUE 360 ARGB | `3633:0009` | Tested |
| Other DeepCool models | Varies | Not verified |

Support for other DeepCool devices must not be assumed.

## Installation

### Recommended: Flatpak

Download the latest release bundle from:

https://github.com/LionheartTim/Deepcool-Mystique-AIO-Linux-with-dashboard/releases

For version 1.3.1, the tested package is built against **KDE Platform 6.10**.

Install the downloaded bundle:

```bash
flatpak install --user ./io.github.lionhearttim.deepcool-gui-v1.3.1-qt610.flatpak
```

Launch the application:

```bash
flatpak run io.github.lionhearttim.deepcool-gui
```

The KDE Platform 6.10 runtime must be available. If Flatpak cannot resolve it automatically, make sure Flathub is configured and install the appropriate runtime.

### Important: USB Permissions

**Flatpak installation does not automatically grant access to the cooler's USB interface.**

The host operating system must allow the current desktop user to open and claim the device:

- USB vendor ID: `3633`
- USB product ID: `0009`
- USB interface: `0`

On a system without suitable host permissions, the cooler may appear in `lsusb` while remaining inaccessible to the application.

A separate host-side USB permissions installer may be supplied with the release. It requires explicit user approval and must be executed outside the Flatpak sandbox.

Do not assume that installing the `.flatpak` bundle also installs udev rules.

The new USB access handling has been tested locally. Fresh-installation behavior on PikaOS and other Linux distributions still requires independent verification.

## First Launch Setup — Important Warning

On an installation without a recorded successful First Launch Setup, the application may request one-time media initialization.

**Warning: This operation permanently deletes all GIFs and images stored in the cooler's internal media storage.**

Specifically, the cleanup targets:

- `SD:GIF`
- `SD:IMG`

The operation does not format the complete SD card, replace firmware or reset general firmware settings.

Before asking for confirmation, version 1.3.1 checks whether the application can access the USB device. This access check does not send a media cleanup command.

If you approve the cleanup:

1. The application submits a single cleanup request.
2. Keep the cooler connected.
3. Do not interrupt the application during the 120-second waiting period.
4. Follow the application's completion instructions.

A USB acknowledgement confirms that the command was accepted. It does **not** independently prove that media deletion has finished.

For safety, the application will not automatically repeat a previously attempted cleanup with an uncertain result.

**Do not delete or reset first-launch state records merely to force the cleanup to run again.**

## Using the Application

### Display Management

Open the **Display management** tab to select a GIF slot, import media, adjust the crop and configure the LCD presentation.

The interface provides controls for display rotation, brightness and RGB modes.

### System Metrics

Open **Systeem Metrics** to view the live CPU, GPU and memory monitoring panels.

Sensor values depend on available drivers and Linux hardware interfaces.

### Diagnostics

Open **Diagnostics** to inspect hardware information, active sensor sources, USB connection details and application events.

### Autostart

The application can configure per-user desktop autostart following successful First Launch Setup.

Autostart can be managed in the **About** tab.

The application may run minimized through the system tray.

## Building from Source

### Requirements

- A Linux development environment
- C++17-compatible compiler
- Qt 6 development packages, including Qt Widgets
- Qt 6 qmake
- libusb 1.0 development files
- GNU Make

From the project source directory:

```bash
qmake6 -o Makefile deepcool-gui-qt6.pro
make -j2
```

Run the resulting native executable:

```bash
./deepcool-gui-qt6
```

### Flatpak Build Compatibility

The v1.3.1 Flatpak was successfully tested after compiling the application with the **KDE 6.10 SDK**.

Do not package an executable built against Qt 6.11 directly into a Qt 6.10 runtime. Doing so can cause:

```text
version `Qt_6.11' not found
```

Compile the Flatpak executable within a compatible SDK and verify its runtime library dependencies before distributing the bundle.

The Flatpak manifest and packaging files should be kept consistent with the runtime and application executable used for the release.

## Troubleshooting

### Device detected, but not accessible

Check USB detection:

```bash
lsusb | grep -i '3633:0009'
```

If the device is listed but the application reports USB access denied, inspect host-side udev permissions.

A Flatpak sandbox permission such as `--device=all` does not by itself correct missing host filesystem permissions or device access controls.

### USB interface busy

Close other applications that may be communicating with the cooler, then retry.

### Flatpak does not start

Run it from a terminal:

```bash
flatpak run io.github.lionhearttim.deepcool-gui
```

Inspect the reported error, including any missing runtime libraries or incompatible Qt versions.

Check the installed runtime:

```bash
flatpak info --show-runtime io.github.lionhearttim.deepcool-gui
```

### Missing system metrics

Open the Diagnostics tab and inspect the active sensor sources.

Some sensors require hardware-specific Linux interfaces or installed GPU drivers.

### GIF operation interrupted

Do not automatically repeat an interrupted upload, deletion or first-launch cleanup.

Review the application's error message and diagnostics before retrying hardware operations.

## Tested Release Status

Version 1.3.1 was functionally tested by the maintainer on Bazzite Linux with a KDE Platform 6.10 Flatpak.

The maintainer confirmed:

- Successful compilation.
- Successful application startup.
- Cooler recognition.
- Working system metrics.
- Working GIF management.
- Working RGB controls.
- Working autostart.

The USB permission improvements are included in the tested release, but the separate host permissions installer has not yet been independently validated on a clean PikaOS installation.

## Reporting Issues

Report problems through the project's GitHub Issues page:

https://github.com/LionheartTim/Deepcool-Mystique-AIO-Linux-with-dashboard/issues

Please include:

- Linux distribution and version.
- Desktop environment.
- Application version.
- Whether installed natively or through Flatpak.
- Relevant USB detection details.
- Terminal error messages.
- Steps required to reproduce the problem.

Avoid including personal or sensitive system information in public reports.

## Project

**Developer:** LionheartTim

**Repository:** https://github.com/LionheartTim/Deepcool-Mystique-AIO-Linux-with-dashboard

**Platform:** Linux

**Language:** C++

**GUI Framework:** Qt 6

**USB Communication:** libusb 1.0

**Packaging:** Flatpak

## License

The existing application metadata declares GPL-3.0. Consult the repository's license file for the authoritative licensing terms.

---

DeepCool MYSTIQUE Control Hub is an independent community-developed Linux project.
