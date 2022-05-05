import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.5   // это версия библиотеки, содержащей Contol (аналоги виджетов) для версии Qt 5.6
import QtQuick.Layouts 1.2


Window {
    id: root
    modality: Qt.ApplicationModal  // окно объявляется модальным
    title: qsTr("Информация о игре")
    minimumWidth: 400
    maximumWidth: 400
    minimumHeight: 350
    maximumHeight: 350

    property bool isEdit: false
    property int currentIndex: -1

    GridLayout {
        anchors { left: parent.left; top: parent.top; right: parent.right; bottom: buttonCancel.top; margins: 10 }
        columns: 2

        Label {
            Layout.alignment: Qt.AlignRight  // выравнивание по правой стороне
            text: qsTr("Название игры:")
        }
        TextField {
            id: textName
            Layout.fillWidth: true
            placeholderText: qsTr("Введите название игры")
        }
        Label {
            Layout.alignment: Qt.AlignRight
            text: qsTr("Платформа:")
        }
        ComboBox {
               id: comboBoxPlatform
               width: 120
               model: ["PC", "Xbox", "PS5", "Nintendo", "Phone"]
        }
        Label {
            Layout.alignment: Qt.AlignRight
            text: qsTr("Создатель игры:")
        }
        TextField {
            id: textCreator
            Layout.fillWidth: true
            placeholderText: qsTr("Введите создателя игры")
        }
        Label {
            Layout.alignment: Qt.AlignRight
            text: qsTr("Жанр:")
        }
        TextField {
            id: textGenre
            Layout.fillWidth: true
            placeholderText: qsTr("Введите Жанр игры")
        }
    }

    Button {
        anchors { right: buttonCancel.left; verticalCenter: buttonCancel.verticalCenter; rightMargin: 10 }
        text: qsTr("ОК")
        width: 100
        onClicked: {
            root.hide()
            if (currentIndex<0)
            {
                add(textName.text, comboBoxPlatform.currentValue, textCreator.text, textGenre.text)
            }
            else
            {
                edit(textName.text, comboBoxPlatform.currentValue, textCreator.text, textGenre.text, root.currentIndex)
            }

        }
    }

    Button {
        id: buttonCancel
        anchors { right: parent.right; bottom: parent.bottom; rightMargin: 10; bottomMargin: 10 }
        text: qsTr("Отменить")
        width: 100
        onClicked: {
             root.hide()
        }
    }

    // изменение статуса видимости окна диалога
    onVisibleChanged: {
      if (visible && currentIndex < 0) {
          textName.text = ""
          comboBoxPlatform.currentIndex = 0
          textCreator.text = ""
          textGenre.text = ""
      }
    }

    function execute(nameGam, platformGam, creatorGam, genreGam, index){
        isEdit = true

        textName.text = nameGam
        comboBoxPlatform.currentIndex = comboBoxPlatform.model.indexOf(platformGam)
        textCreator.text = creatorGam
        textGenre.text = genreGam

        root.currentIndex = index

        root.show()
    }


 }

