# UDEV and Yubikey

This works on my Ubuntu 20.04 LTS laptop.  Use monitor rule (at bottom) to verify the USB device attributes and actions.

Lock screen with Yubikey removal by leveraging UDEV.  
```
sudo vi /etc/udev/rules.d/95-yubikey.rules
```

Content of rule (this is working with my YubiKey 5C NFC)
```
ACTION=="remove", ENV{ID_BUS}=="usb", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}="0407", RUN+="/usr/bin/loginctl lock-sessions"
```

Reload udev:
```
sudo udevadm control --reload-rules && sudo udevadm trigger
```

Monitor udev and udev attributes.  This can be used to validate the values in the udev rule.
```
udevadm monitor --environment --udev
```

Example of udev monitor dump:
```
UDEV  [52222.811250] remove   /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/0003:1050:0407.00C3/input/input205/event8 (input)
ACTION=remove
DEVPATH=/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/0003:1050:0407.00C3/input/input205/event8
SUBSYSTEM=input
DEVNAME=/dev/input/event8
SEQNUM=20151
USEC_INITIALIZED=<value removed>
ID_INPUT=1
ID_INPUT_KEY=1
ID_INPUT_KEYBOARD=1
ID_VENDOR=Yubico
ID_VENDOR_ENC=Yubico
ID_VENDOR_ID=1050
ID_MODEL=YubiKey_OTP+FIDO+CCID
ID_MODEL_ENC=YubiKey\x20OTP+FIDO+CCID
ID_MODEL_ID=0407
ID_REVISION=0543
ID_SERIAL=Yubico_YubiKey_OTP+FIDO+CCID
ID_TYPE=hid
ID_BUS=usb
ID_USB_INTERFACES=:030101:030000:0b0000:
ID_USB_INTERFACE_NUM=00
ID_USB_DRIVER=usbhid
ID_PATH=pci-0000:00:14.0-usb-0:2:1.0
ID_PATH_TAG=pci-0000_00_14_0-usb-0_2_1_0
XKBMODEL=pc105
XKBLAYOUT=us
BACKSPACE=guess
ID_SECURITY_TOKEN=1
ID_FOR_SEAT=input-pci-0000_00_14_0-usb-0_2_1_0
LIBINPUT_DEVICE_GROUP=3/1050/407:usb-0000:00:14.0-2
MAJOR=13
MINOR=72
DEVLINKS=/dev/input/by-path/pci-0000:00:14.0-usb-0:2:1.0-event-kbd /dev/input/by-id/usb-Yubico_YubiKey_OTP+FIDO+CCID-event-kbd
TAGS=:uaccess:power-switch:seat:
```
