---
layout: post
title: A script to configure Qt-S60 environment on Linux
comments: true
categories:
- Development
- en
- GPSL
- INdT
- linux
- Qt
- Qt-S60
- S60
- script
---
You may have noticed that Qt is being ported to [S60]("http://en.wikipedia.org/wiki/S60_(software_platform)"), and as you can read [here](http://labs.trolltech.com/blogs/2009/09/24/daily-binaries-of-qt-for-symbians60-available/), daily builds are available as technology preview since the end of September. At first, there are only MS Windows installers, but [Lizardo](http://lizardo.wordpress.com/) did a [great job](http://lizardo.wordpress.com/2009/09/24/installing-qt-for-s60-daily-snapshots-on-linux/) collecting and writing patches and instructions to make it possible to develop with Qt for S60 on Linux.

To ease this process, I wrote a small script that does almost the same described in Lizardo's post, with some new pseudo features. It needs some improvements, the known ones are marked with #XXX - contributions are welcome!

It consists in 2 files, the script and a config file where the user can customize the directories where things will be installed, the directory of the downloaded files, the version of S60 that will be used. Initially it's ready for S60 3rd edition FP2 and S60 5th edition (Check [here](http://wiki.forum.nokia.com/index.php/Which_S60_SDK_should_I_use%3F) the version of your target device), etc.

Running the script, the first step shows the URLs to files you have to download, but need login or other kind of interaction with the website. The script is a nice guy, when it's possible "he" asks if you allow him to open those URLs in your default browser =)

The script then downloads other files that are direct accessible and the installation begins. If everything goes right, in the end your environment will be ready for Qt-S60 development.

Wanna try? Download a it [here](https://gitorious.org/anselmolsm-labs/setupqts60env/archive-tarball/master) or git clone it:

```
git clone git://gitorious.org/anselmolsm-labs/setupqts60env.git
```

That's it =)

**ToDo:**

  * Simplify updates of Qt-S60 in a environment already in use.
  * Solve the #XXX in the script
  * Probably there are other things that I don't remember now =)
  * UPDATE: 2009-10-17: There are some issues in qmake when using DEPLOYMENT
  * UPDATE2: 2009-10-19: The old daily builds aren't available anymore, a message there says that they "back tonight hopefully"
  * UPDATE3: 2009-10-20: Builds are back =)
  * UPDATE4: 2009-11-01: The gnupoc patch for Qt-S60 needs to be uptaded =/ .
  * Hopefully it's going to save us =) [http://labs.trolltech.com/blogs/2009/10/28/a-new-symbian-toolchain-for-linux/](http://labs.trolltech.com/blogs/2009/10/28/a-new-symbian-toolchain-for-linux/)
