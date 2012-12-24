---
layout: post
title: CoolerMaster X-Craft & Linux
categories:
- Geek
- hw
- linux
- patch
- pt_BR
- usb
---
EDIT: Veja nos comentários o que foi postado pelo Luis. Ele indica como contornar o problema sem precisar de patch e recompilar o kernel. =)

Adquiri recentemente um case para HD externo CoolerMaster X-Craft 310 e acabei sendo pego de surpresa quando vi que ele não era devidamente reconhecido. Nos logs apareciam mensagens do tipo:

```
usb 7-3: new high speed USB device using ehci_hcd and address 13
usb 7-3: device descriptor read/64, error -32
usb 7-3: device descriptor read/64, error -32
usb 7-3: new high speed USB device using ehci_hcd and address 14
usb 7-3: device descriptor read/64, error -32
usb 7-3: device descriptor read/64, error -32
usb 7-3: new high speed USB device using ehci_hcd and address 15
usb 7-3: device not accepting address 15, error -110
usb 7-3: new high speed USB device using ehci_hcd and address 16
usb 7-3: device not accepting address 16, error -110
hub 7-0:1.0: unable to enumerate USB device on port 3
usb 5-1: new full speed USB device using uhci_hcd and address 20
usb 5-1: device descriptor read/64, error -32
```

Bateu a dúvida se o problema era com o hardware, mas isso foi descartado ao verificar que o o case+HD funcionaram no Windão. Procurando na Internet, acabei encontrando várias queixas no (http://forum.coolermaster.com/search.php?st=0&amp;sk=t&amp;sd=d&amp;keywords=x+craft+linux)[fórum] da CoolerMaster sobre problemas com vários outros modelos. Todos eles receberam respostas (sobre o suporte a Linux) do tipo: "Unfortunately it isn't.  We apologize for any inconvenience."

Resolvi então dar uma olhada no [bugzilla](http://bugzilla.kernel.org/) do kernel, onde encontrei o bug report [8639](http://bugzilla.kernel.org/show_bug.cgi?id=8639) que fala sobre o modelo X-Craft 360 e de uma solução para o mesmo problema que eu estava tendo.

Há um [e-mail](http://kerneltrap.org/mailarchive/linux-usb/2008/9/16/3311254) enviado por Jaroslav Kysela para a lista [linux-usb](http://vger.kernel.org/vger-lists.html#linux-usb) que explica com mais detalhes o problema e a solução. O problema parece residir no fato de que em geral os chips USB 2.0 levam cerca de 5 segundos para responderem à requisição [USB_REQ_GET_DESCRIPTOR](http://www.gelato.unsw.edu.au/lxr/source/include/linux/usb_ch9.h#L56), entretanto o chip utilizado na linha X-Craft demora cerca de 10 segundos. Assim, com o timeout, não há a correta identificação do dispositivo.

Até o kernel 2.6.27-rc8 a alteração não havia sido incorporada ao código, mas provavelmente algo será feito nesse sentido numa versão futura. Até lá, o [patch](http://www.anselmolsm.org/blog/files/patch-2.6.27-rc8.patch) sugerido dá conta do serviço. O que é feito nele é a simples alteração do timeout de 5 para 12 segundos.

Testei com a versão 2.6.27-rc8, mas a alteração deve funcionar também com a 2.6.26.

---

  * PS1: O patch aqui disponibilizado não é meu (infelizmente =P), mas sim a versão da segunda solução proposta por J. Kysela.
  * PS2: o usuário "(http://forum.coolermaster.com/viewtopic.php?f=6&amp;t=10947&amp;sid=5564807c06799b5b330592f12371d15c#p85556)[tinga]" usado no fórum da CoolerMaster é uma homenagem à uma grande personalidade da Unicamp =)
  * PS3: Correções sobre eventuais bobagens que eu tenha escrito aqui são bem vindas.
  * EDIT PS4: Pessoas, não adianta só aplicar o patch e esperar algo acontecer, precisa recompilar o kernel, instalar e rebootar...