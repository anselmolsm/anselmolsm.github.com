---
layout: post
title: Qt Platform Abstraction, Lighthouse para os íntimos
comments: true
categories:
- Qt Labs Brazil
- Qt
- pt_BR
- Work
meta:
  syndication_source: Qt Labs Blog Brasil » Anselmo L. S. Melo
  syndication_source_uri: http://blog.qtlabs.org.br
  syndication_source_id: http://blog.qtlabs.org.br/author/anselmo-meloqtlabs-org-br/feed
  rss:comments: http://blog.qtlabs.org.br/2012/03/16/qt-platform-abstraction-lighthouse-para-os-intimos/#comments
  wfw:commentRSS: http://blog.qtlabs.org.br/2012/03/16/qt-platform-abstraction-lighthouse-para-os-intimos/feed/
  syndication_feed: http://blog.qtlabs.org.br/author/anselmo-meloqtlabs-org-br/feed
  syndication_feed_id: '8'
  syndication_permalink: http://blog.qtlabs.org.br/2012/03/16/qt-platform-abstraction-lighthouse-para-os-intimos/
  syndication_item_hash: 0863c92688b422371d0910c06a20d15e
  _edit_last: '1'
---

<em>Originalmente publicado em http://blog.qtlabs.org.br/2012/03/16/qt-platform-abstraction-lighthouse-para-os-intimos/</em>

É do conhecimento de muitos que Qt é oficialmente suportado em várias plataformas. Recentemente, graças aos esforços da comunidade, novas plataformas passaram a ser suportadas - ainda de forma não oficial - com destaque para Android e iOS. No <em>post</em> de hoje, faremos uma breve introdução à nova estrutura que tem como objetivo simplificar novos <em>ports</em> de Qt, o QPA - Qt Platform Abstraction, <em>codename</em> Lighthouse.</p>

***Começo***

Em meados de 2009 alguns dos desenvolvedores baseados em Oslo resolveram refatorar o código existente no chamado Qt for Embedded, que é, resumidamente, focada em dispositivos embarcados sem Xorg (no caso do Qt for Embedded Linux), usando <em>framebuffer</em> para a saída gráfica. Nele, existe o QWS - Q Windowing System - que faz as vezes de sistema de janelas simples. A idéia de refatorar tal código era justamente para reduzir a dependência do QWS, porém foram anos de "contaminação" de código e essa tarefa demonstrou-se maior do que o esperado. Foi então que surgiu uma ideia:

<blockquote>Quão difícil seria remover todo o código específico de plataformas e ter um novo <em>port</em> compilável?</blockquote>

Parte do plano era aproveitar que Qt já contava com a Raster Engine e os [Alien Widgets já haviam invadido e fixado residência no Qt 4.4](http://blog.qt.digia.com/blog/2007/08/09/qt-invaded-by-aliens-the-end-of-all-flicker). Uma semana mais tarde, já existia um código para QtGui independente de plataforma e compilado com sucesso.

***Raster Engine? Alien widgets?***

Ambos são potenciais temas para novos posts, segue uma rápida (e, digamos, superficial) explicação para que possamos seguir com nosso assunto:

  * <em>Raster Engine</em> é um sistema gráfico implementado totalmente em software, ou seja, de forma independente do hardware onde está sendo executado. Foi introduzido no Qt 4.0 após repetidas tentativas de utilizar GDI e GDI+ (APIs nativas do Microsoft Windows) para backend gráfico de Qt no MicrosoftWindows.
  * <em>Alien Widgets</em> é o nome dado à uma forma como os widgets são criados na tela. Para nossa rápida explicação de hoje, usaremos terminologia do Xorg. Tradicionalmente, cada widget era na verdade uma "janela do X". Assim, uma tela com o que costumamos chamar de janela, contendo um botão e um checkbox teria, em termos de estruturas do X, 3 janelas, sendo que 2 delas aninhadas em uma maior. Essa combinação toda era grande responsável por efeitos visuais indesejáveis quando redimensionávamos aplicações, pois o Xserver precisava coordenar a movimentação e redimensionamento desses componentes, o que não acabava bem. Com os Alien Widgets acontece diferente: O Xserver conhece apenas a janela <em>top level</em>, os widgets dentro dela ficam por conta da maquinaria interna do Qt.

***Voltando ao assunto***

O próximo passo seria conseguir criar um processo único com uma janela <em>full-screen</em> utlizando <em>framebuffer</em>, aproveitando-se dessa infra-estrutura. Com o sucesso desse experimento, o projeto tomou forma e recebeu o nome de <em>Lighthouse,</em> tendo como objetivo: "Como tornar mais fácil Qt suportar diferentes hardwares gráficos". Com <em>Lighthouse</em>, um <em>port</em> passa a precisar de um <em>plugin</em> que implemente a representação de janelas (<em>window surfaces</em>) para dado cliente (ex: x11 client) e funcionalidades para envio e recebimento de mensagens para o servidor do sistema de janelas (window system server). Um primeiro <em>port</em> teste feito, utilizando QImage como <em>display device</em>, precisou deapenas 147 linhas de código. Prefere uma comparação de uma classe real? qwidget_x11.cpp: 2424 linhas, qwidget_qpa.cpp: 671 linhas. O código correspondente à essa reengenharia já encontra-se integrado no branch 4.8, com o nome <em>Qt Platform Abstraction</em>. Portanto, aqueles que tiverem o repositório clonado podem observar em src/gui/kernel a existência de arquivos com o sufixo _qpa.h:

  * qplatformclipboard_qpa.h
  * qplatformcursor_qpa.h
  * qplatformeventloopintegration_qpa.h
  * qplatformglcontext_qpa.h
  * qplatformintegrationplugin_qpa.h
  * qplatformintegration_qpa.h
  * qplatformnativeinterface_qpa.h
  * qplatformscreen_qpa.h
  * qplatformwindowformat_qpa.h
  * qplatformwindow_qpa.h

Analisando os nomes desses arquivos (e das classes contidas neles) notamos os componentes que devem ser implementados em um novo port de Qt. Além dos já mencionados ports para Android (Necessitas) e iOS, são outros exemplos que aproveitaram do Lighthouse:

libCaca: convertendo widgets para modo texto. Útil? Não sei, mas vale para exemplificar como ficou mais fácil <em>portar</em> Qt =)

{% youtube ZJyF99uqSbY %}

Qt on [NaCl](http://en.wikipedia.org/wiki/Google_Native_Client):
{% youtube U6xZsqcA-Sk %}


A tarefa de suportar o Wayland também foi beneficiada por essa nova estrutura, que também está tendo um importante papel no desenvovimento do futuro Qt5. Para referência, os artigos no Qt Labs a respeito desse assunto estão dentro da [categoria lighthouse](http://blog.qt.digia.com/blog/category/lighthouse/).

Até a próxima =)
