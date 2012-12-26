---
layout: post
title: Living on the edge
comments: true
categories:
- danger
- Geek
- linux
- Misc
- nilba
- pc
- pt_BR
---
Querendo formatar um [cartão SD](http://en.wikipedia.org/wiki/Secure_Digital_card) como [ext2](http://en.wikipedia.org/wiki/Ext2), digitei **mkfs.ext2 /dev/sd \<TAB\>** ... só que cartão SD não é mapeado como /dev/sdb (como acontece com pendrives, por exemplo), e sim /dev/mmcblk0. Com isso, o \<TAB\> completou com /dev/sda (o HD do meu notebook)...

```
anselmo@persephone:~$ mkfs.ext2 /dev/sda
mke2fs 1.40.8 (13-Mar-2008)
/dev/sda is entire device, not just one partition!
Proceed anyway? (y,n)
```

por sorte não o fiz como root heheh... Tá, podem me chamar de [nilba](http://en.wikipedia.org/wiki/Newbie) agora.

PS: pra galera [Windera](http://en.wikipedia.org/wiki/Windows), quase fiz um "format c:"

PS2: Embora [alguns](http://www.libertatia.org/blog/) acreditem que "[Living on the Edge](http://en.wikipedia.org/wiki/Livin%27_on_the_Edge)" é do [Bon Jovi](http://en.wikipedia.org/wiki/Bon_Jovi), obviamente é do [Aerosmith](http://en.wikipedia.org/wiki/Aerosmith) =P
