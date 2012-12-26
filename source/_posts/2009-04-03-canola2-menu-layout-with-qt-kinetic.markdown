---
layout: post
title: Canola2 menu layout with Qt Kinetic
comments: true
categories:
- Development
- en
- examples
- GPSL
- INdT
- Kinetic
- openBossa
- Qt
- Video
- Work
---
Welcome back dear readers. This is my second post of the day talking about what is happening in the development of animated layouts in [Qt Kinetic](http://labs.trolltech.com/page/Projects/Graphics/Kinetic).

As I said in my [previous post](http://www.anselmolsm.org/blog/qt-state-machine-and-animated-layouts-integration/), we discussed about new good examples that could show use cases of this new API. In the end, only one example was created, but it's really cool =) .

Maybe some of you will recognize this interface, it looks like [canola2](http://openbossa.indt.org.br/canola/index.html)'s main menu, another software developed by [INdT](http://www.indt.org.br/) for Nokia [internet tablets](http://en.wikipedia.org/wiki/Internet_Tablet) (e.g. [N810](http://en.wikipedia.org/wiki/N810)) - and as you can read [here](http://etrunko.blogspot.com/2009/03/canola-is-free.html), an [old bug was fixed](https://bugs.maemo.org/show_bug.cgi?id=3881) and canola2 is now a [free software](http://en.wikipedia.org/wiki/Free_software), released under [GPLv3](http://en.wikipedia.org/wiki/Gplv3#Version_3). In [this post](http://wouwlabs.com/blogs/jeez/?p=99) you can read more about the development of that interface.

So, we wrote an example based on that concept. During the development we had nice discussions regarding the algorithm for the engine that controls the icons distribution on the screen.

Check it out:
{% youtube eJcTBJaPRZg %}

The source code is not available yet, but it will be published soon in a git repository near you, then you will be able to check how animated layouts were used and also see that algorithm I've just mentined. So, stay tuned!
