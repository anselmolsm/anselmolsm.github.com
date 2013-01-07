---
layout: post
title: Alguns erros comuns ao herdar de QObject
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
  rss:comments: http://blog.qtlabs.org.br/2011/07/11/alguns-erros-comuns-ao-herdar-de-qobject/#comments
  wfw:commentRSS: http://blog.qtlabs.org.br/2011/07/11/alguns-erros-comuns-ao-herdar-de-qobject/feed/
  syndication_feed: http://blog.qtlabs.org.br/author/anselmo-meloqtlabs-org-br/feed
  syndication_feed_id: '8'
  syndication_permalink: http://blog.qtlabs.org.br/2011/07/11/alguns-erros-comuns-ao-herdar-de-qobject/
  syndication_item_hash: b6299358af2b7bf1a0af7af466c31a09
  _edit_last: '1'
---

<em>Originalmente publicado em http://blog.qtlabs.org.br/2011/07/11/alguns-erros-comuns-ao-herdar-de-qobject</em>

Com o passar do tempo, os erros de uma determinada ferramenta tornam-se familiares de tal forma que solucioná-los passa a ser automático. Entretanto, muitos destes erros não são triviais entre iniciantes, que vez ou outra acabam gastando tempo para contorná-los.
Pois vamos tratar de dois que ultimamente tem sido a causa frequente de vários tópicos criados na [Qt Devnet](http://developer.qt.nokia.com/). Portanto, se você ainda está se familiarizando com Qt, o texto de hoje é para você. Se você já tem alguma experiência com Qt, vai se lembrar da primeira vez que passou por isso ;)

Consideremos a seguinte declaração de classe:

```
class MyClass:public QObject
{
    public:
    MyClass(QObject * parent=0);

signals:
    void aSignal();

public slots:
    void aSlot();
};
```

Pois bem, você declarou uma classe herdando de QObject e criou um novo sinal e um novo slot. Após conectar este sinal e/ou este slot, você partiu feliz para testar sua aplicação porém nada funciona e você recebe o seguinte alerta:

```
No such signal QObject::aSignal()
```

E por alguns instantes a pergunta que fica é:
<blockquote><p>Mas afinal, o que terá acontecido?</p></blockquote>

Aí que entra um detalhe que passa muitas vezes despercebido entre aqueles que partem estusiasmados para o código: Você esqueceu-se da macro Q_OBJECT na declaração de sua classe. Com alguma prática, alguns resolverão a questão rapidamente e serão felizes. No entanto, outros adicionarão a macro citada e acabarão agora "ouvindo" as seguintes palavras do compilador:

```
main.cpp:(.text+0x54): undefined reference to `vtable for MyClass'
```

(ok, ok, senhor purista, é um erro do <em>linker</em>, não do compilador)

Afinal, por que eu disse que alguns resolverão este problema e serão felizes e outros enfrentarão este erro? O que eles fizeram de diferente?

Bem, caro leitor, a diferença é que o primeiro lembrou-se de executar ***qmake*** depois de adicionar a macro Q_OBJECT, enquanto o segundo partiu ansioso para apenas compilar o projeto.

<strong>qmake? Q_OBJECT?</strong>

Bem, vamos entender o que aconteceu.

Conforme está escrito na documentação, quando uma classe herda QObject, seja direta ou indiretamente, *e* declara novas propriedades [Q_PROPERTY](http://doc.qt.nokia.com/4.7/qobject.html#Q_PROPERTY) e/ou novos sinais e/ou slots (vale também para reimplementações), torna-se necessária a adição da macro Q_OBJECT em sua declaração. De forma resumida, esta macro serve como indicador de que o [Qt Meta-Object Compiler](http://doc.qt.nokia.com/4.7/moc.html) - mas pode chamar de <strong>moc</strong> - deve processar esta classe e gerar o arquivo .moc correspondete.

Assim, na primeira situação descrita no início deste texto, o código de fato herda de QObject e declara um novo sinal e um novo slot, porém não apresenta a macro Q_OBJECT. A classe é compilada normalmente, entretanto, não acontece a resolução das informações adicionadas pelo sistema de meta objetos do Qt (no exemplo, o sinal aSignal() não é encontrado). Na sequência, quando segundo usuário adiciona Q_OBJECT e parte direto para o ***make***, acontece um erro de ligação pois falta o arquivo .moc correspondente, onde estariam os símbolos faltantes. Este arquivo .moc não foi gerado pois, ao não executar qmake, não houve a verificação da necessidade do moc entrar em ação.


Portanto, a declaração correta da classe MyClass é:

```
class MyClass:public QObject
{
    Q_OBJECT
public:
    MyClass(QObject * parent=0);

signals:
    void aSignal();

public slots:
    void aSlot();
};
```

Existe ainda um outro caso recorrente cuja solução apresenta uma particularidade. Consideremos a nossa class MyClass,  agora declarada no mesmo arquivo que a função main (digamos, num arquivo chamado main.cpp):

```
class MyClass:public QObject
{
    Q_OBJECT
public:
    MyClass(QObject * parent=0)
        : QObject(parent)
    {
    }
signals:
    void aSignal();

public slots:
    void aSlot()
    {
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    MyClass myClass;

    return app.exec();
}
```


<em>O que há de diferente?</em> - Pergunta você.

A princípio nada demais. Porém, atente ao fato da classe MyClass agora estar no mesmo arquivo que a função main. Ao tentar compilar esta versão do nosso exemplo, mais uma vez aparecerá um erro parecido com:

```
undefined reference to `vtable for MyClass'
```

Ao observar a saída da compilação, você nota que o moc nem é executado. Assim, a classe que necessita ser tratada por ele passa em branco. Para contornar este caso, insira a linha:

```
#include "main.moc"
```

após a declaração da classe e execute qmake. Isso forçará a execução do moc para criar este arquivo main.moc onde estarão os símbolos referentes aos sinais e slots. (Sim, existe ***automake***, mas não estou tratando de ferramentas adicionais aqui, ok?).

Hoje ficamos concentrados na solução de erros comuns envolvendo moc e a macro Q_OBJECT. Futuramente voltaremos a abordar o tema, entrando em mais detalhes quanto ao papel exercido pelo moc e o conteúdo dos arquivos por ele gerados.

Tem mais algum caso comum de erro que seria interessante abordarmos, para auxiliar os iniciantes? Envie suas sugestões ;)