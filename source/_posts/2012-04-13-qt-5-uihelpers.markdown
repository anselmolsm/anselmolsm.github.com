---
layout: post
title: Qt 5 UiHelpers
tags:
- Development
- en
- GPSL
- INdT
- KDE
- openBossa
- Qt
- Qt5
- uihelpers
- Work
---
In [my previous post](http://anselmolsm.org/blog/working-in-the-open-again/) I mentioned one of the experiments [we](http://www.indt.org/?lang=en) are currently working on.
Now it is time to introduce the Qt 5 playground project called UiHelpers - Fortunately, this name will change ;)
Those who follow the [Qt development mailing list](http://lists.qt-project.org/pipermail/development) already read about it, the idea about this post is to reach more people from the community in general.

**Context**

If you are already familiar with the structure of Qt 5 code, feel free to jump to the next section.

In Qt 4, the whole source code is in the same git repository. The traditional widgets derived from QWidget are part of the QtGui module and represent a central piece for the GUI application development.

In Qt 5, things changed. Qt code were splitted in many repositories which group Qt libraries depending on their functionalities.
Examples of repositories are qtbase, qtdeclarative, qtjsbackend, qtxmlpatterns, qtsvg, qttools, etc.
As you may know, QtQuick 2 became a first class citizen in Qt 5, which means qtdeclarative is one of the main repositories, house of QtQuick and QtQml classes.

But, there are classes that provide the base for QtQuick 2 work properly - they are part of the qtbase repo. There you find QtCore,
QtGui, QtNetwork, QtOpenGL, QtPlatformSupport, QtXml, QtWidgets, etc.

Wait: What's the difference between QtGui and QtWidgets?

As part of the changes of Qt 5, QtGui is now focused in the basic infrastructure for GUI work on different platforms. For example, it is the place for the platform abstraction layer, window management, image handling, etc.

QtWidgets, as you can conclude based on its name, contains the children of QWidget: QPushButton, QSpinBox, QMainWindow, etc. Also, there are non-widgets classes in QtWidgets, some of them because they are internally too coupled to QWidget classes.

**Origins**

In this [thread](http://lists.qt-project.org/pipermail/development/2011-December/000932.html) it was mentioned the case of QUndoStack, QUndoCommand that are in QtWidgets but can be useful in other contexts where developers do not want to link against QtWidgets just because of this kind of helper classes.
Later, in the [change 15857](http://codereview.qt-project.org/#change,15857) (with the help of ogoffart), we discussed about moving QUndo* out of QtWidgets. First, we moved these classes to QtGui what as not considered correct given the new motivation of this lib. Then, another idea was to move the classes to a new lib, inside qtbase. It was not considered ideal and the decision was to create a separated repo for these classes, leaving QtWidgets untouched (since the Qt community do not want to introduce new bugs in this lib).

**Current status**

We set a [wiki page](http://qt-project.org/wiki/Qt-5-Ui-Helpers) where it is possible to check the classes made available out of QtWidgets. Also, there are instructions about where to download the source code, build, test and contact us.

Besides moving classes out of QtWidgets, some prototypes of convenience APIs were created for QtQuick 2 developers and we are very interested in receiving feedback about them. It's worth mentioning the QML API for UndoStack and the CompletionModel which is based on the internals of QCompleter and was made available in a QML friendly way.

The following example shows a possible use case for the CompletionModel. Improving the models supported by <em>sourceModel</em> is part of the ToDo list. The ListView is going to show the updated list that currently satisfies what is written in the TextInput.
    
    TextInput {
        id: input
    }

    CompletionModel {
        id: completionModel
        sourceModel: ["Ascension Island", "Andorra", "Afghanistan"]
        completionPrefix: input.text
        caseSensitivity: Qt.CaseInsensitive
    }

    ListView {
        model: completionModel
        delegate: Text { text: modelData }
    }

The two examples bellow show the UndoStack and two items that represent commands. The idea of UndoPropertyCommand is to enable track the changes of some properties. In the example, we are going to track x and y when myRect is moved.

    UndoStack {
        id: stack
        undoLimit: 5
    }

    UndoPropertyCommand {
        id: moveCommand
        properties: ["x", "y"]
    }

    Rectangle {
        id: myRect
    
        (...)
    
        MouseArea {
            (...)
            drag.target: parent
            onPressed: stack.push(moveCommand, myRect);
        }
    }

UndoCommand is another element used to represent commands. The difference here is that it allows the customization of the actions onUndo and onRedo the command.

    UndoCommand {
        id: aCommand
    
        onUndo: doAThing(target);
        onRedo: undoAThing(target);
    }

    Button {
        onClicked: stack.push(aCommand, target);
    }</pre>

**Future**

Maybe one day this playground project gets promoted and become a Qt Add-on, but there is no expectation it will happen before 5.0. In the meanwhile, there is a ToDo list with some topics we consider important to handle, like better examples, more tests, docs, etc.

We are looking forward receiving more opinions about this work and, as always, contributors are welcome!
