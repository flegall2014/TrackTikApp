/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.3

Rectangle {
    id: propertyPopup

    property alias model : view.model
    property variant currentValue
    property variant currentItem : model.get(view.currentIndex)

    property int itemWidth: 100*display.scale
    property int itemHeight: 70*display.scale
    property int columns: 2

    width: columns*itemWidth + view.anchors.margins*2
    height: Math.ceil(model.count/columns)*itemHeight + view.anchors.margins*2 + 25

    radius: 5
    border.color: "#000000"
    border.width: 2
    smooth: true
    color: "#5e5e5e"

    signal selected

    function indexForValue(value) {
        for (var i = 0; i < view.count; i++) {
            if (model.get(i).value == value) {
                return i;
            }
        }

        return 0;
    }

    GridView {
        id: view
        anchors.fill: parent
        anchors.margins: 5*display.scale
        cellWidth: propertyPopup.itemWidth
        cellHeight: propertyPopup.itemHeight
        snapMode: ListView.SnapOneItem
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "gray"; radius: 5 }
        currentIndex: indexForValue(propertyPopup.currentValue)

        delegate: Item {
            width: propertyPopup.itemWidth
            height: 70*display.scale

            Image {
                anchors.centerIn: parent
                source: icon
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    propertyPopup.currentValue = value
                    propertyPopup.selected(value)
                }
            }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8*display.scale
        anchors.left: parent.left
        anchors.leftMargin: 16*display.scale

        color: "#ffffff"
        font.bold: true
        style: Text.Raised;
        styleColor: "black"
        font.pixelSize: 14*display.scale

        text: view.model.get(view.currentIndex).text
    }
}
