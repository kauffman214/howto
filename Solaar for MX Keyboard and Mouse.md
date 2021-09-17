Solaar for MX Keyboard and Mouse

# Solaar for MX Keys keyboard and MX Master mouse

https://github.com/pwr-Solaar/Solaar 
>Solaar is a Linux manager for many Logitech keyboards, mice, and trackpads that connect wirelessly to a USB Unifying, Lightspeed, or Nano receiver, connect directly via a USB cable, or connect via Bluetooth. Solaar does not work with peripherals from other companies.

I've had a few issues with Ubuntu and Solaar with MX series products.  

The issues were:
- Constant low battery alerts (upower)
- Constant power on alerts (solaar)
- Feature options missing from Ubuntu native package (e.g. FN swap)

## Process
In order to get around all the issues and have a reliable, functional, and less naggy version of solaar and ubuntu:
- [ ] Install the solaar ppa release from solaar
- [ ] modify the notify.py file
- [ ] Freeze (hold) the ppa package to prevent over writing notify code changes
- [ ] Patch upower

## Alerting issue details and fixes
**Battery Life**
- Constant alerts about battery life.   The constant notification does not come from solaar but rather upower
``` 
aptitude show upower 
```
> Description: abstraction for power management
 upower provides an interface to enumerate power sources on the system and control system-wide power management.  Any application can access the org.freedesktop.UPower service on the system message bus. Some operations (such as
 suspending the system) are restricted using PolicyKit.
 
 Thanks for Gui Ambros for identifying and providing a fix for this here:
 https://wrgms.com/disable-mouse-battery-low-spam-notification/
 
 As of 2021-09-17, he patches the up-device.c package as follows: 
 ```
 --- up-device.c	2021-07-18 00:27:11.329004126 -0400
+++ up-device-silent.c	2021-07-18 00:27:51.785006055 -0400
@@ -63,6 +63,15 @@
 	UpDeviceLevel warning_level, battery_level;
 	UpExportedDevice *skeleton = UP_EXPORTED_DEVICE (device);
 
+        /* Disable warning notifications for wireless mice with rechargeable batteries */
+        int type = up_exported_device_get_type_ (skeleton);
+        int state = up_exported_device_get_state(skeleton);
+        if (type == UP_DEVICE_KIND_MOUSE && state == UP_DEVICE_STATE_DISCHARGING) {
+                warning_level = UP_DEVICE_LEVEL_NONE;
+                up_exported_device_set_warning_level (skeleton, warning_level);
+                return;
+        }
+
 	/* If the battery level is available, and is critical,
 	 * we need to fallback to calculations to get the warning
 	 * level, as that might be "action" at this point */
```
He does offer a patch script on his site.   Important note, sometimes the keyboard is being picked up by the power management utility too and it is necessary to pass the --keyboard switch into the script.    If you must rebuild the package he provides, removing the build location is necessary since the script offers no "clean" option in his script.  The location of the build is ~/upower.

**Power On Notifications**
This is probalby the most annoying of the two alerts. After being idle, the power on alert notification appears a lot.  The fix is to patch the notify.py file.  
```
sudo vi /usr/share/solaar/lib/solaar/ui/notify.py
```
Change every instance of 
```
n.show();
```
to 
```
if(reason != _("powered on")):
    n.show()
```
Restart the program.
```
killall solaar && solaar -w hide &
```
*Note: remove -w hide if you want to see the window open up.   I use this option on startup to hide the window, but the status icon still appears in the Ubuntu panel (e.g. top bar).*

## Package configuration

The other issue I ran into is that the native version of Solaar on the Ubuntu distribution (20.04 LTS for me) was not working well with my MX Master mouse and MX Keys keyboard.   To get around this, I installed the latest developer build and froze it.

```
sudo add-apt-repository ppa:solaar-unifying/ppa
sudo apt-get update
sudo apt-get install solaar
sudo apt-mark hold solaar
```
I put a hold on the package once I confirmed it was working.  Putting a hold on the package prevents an upgrade from overwriting the changes made to notify.py.
