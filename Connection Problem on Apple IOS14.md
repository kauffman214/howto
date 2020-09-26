Connection Problem on Apple IOS14

Problem:  Two ipads (definitely) on the same (home) network.  One ipad could not join the world the other ipad was running receving a message "Unable to join the world".  It took about an hour to figure this out, because of the new configuration option introduced in IOS 14.

SPOILER: turned out it was local network access in IOS14. More on that in bullet 4 ...

![unable-to-connect-to-world.png](../../_resources/bcedf5660ce14ed4a0e2d6cd46f82687.png)

After a recent update to IOS14, the two ipads in our house could not join the same Mincraft World.  There were a few things to check, not all related to IOS14, but to the game and game network (Microsoft) itself.
* * *
1. Ability to talk to XBOX Live and log in
2. Parental controls to allow Minecraft access and multiplayer play
3. DNS filter (pihole and cleanbrowsing.org rules)
4. Local network access

* * *

1. Ability to talk to XBOX Live and log in

Because of the parental controls in place, the two accounts need to log in to Live and the two accounts that want to play together had to be added as friends on each device.   Initially, the account was not even logged into the services.  Once this happpened, the friend server on the network was visible to request to join.

2. Parental controls to allow Minecraft access and multiplayer play
 
In the parental controls of live, you can determine who can play what and when.  However, there are options for overrides to the broader categories.  In addition, the configuraiton also offers the option of including multiplayer access.  This needs to be enabled, and was.  

3. DNS filter (pihole and cleanbrowsing.org rules)

PIHOLE and Cleanbrowsing (upstream) DNS services help to keep approximately 10% of all network activity from occurring by filtering out ads, adult materials, and tracking sites.  Occassionally, I need to check the DNS filters to see if a dependent service for registration and login needs to be allowed (whitelisted) to enable a features.  This is does not happen frequenly, and was not the case this time.

4. Local network access (answer this time)

In IOS 14, it will become obvious the programs that want to talk to the local network as you launch each one the first time after an upgrade.   Apparently, my children had clicked "no" when launching Minecraft.   They are younger and did the right thing from a security mindset.  "Deny by default" unless you trust it.  Without them understanding the implicatioons of that action, the iPad was doing its job and not allowing Minecraft to the local network.  However, the game could talk to the internet to play, so it took them a couple weeks until they realized the issue, making it harder to track down.    The solutions was to go into the SETTINGS > MINECRAFT and enable the **Local Network** on both iPads.



![ios14-local-network-minecraft.png](../../_resources/7d1112b16d814341a5dabf3f147d3eb9.png)

