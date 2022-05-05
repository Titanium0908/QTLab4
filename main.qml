import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.5  // это версия библиотеки, содержащей Contol (аналоги виджетов) для версии Qt 5.6
import QtQuick.Layouts 1.2


Window {
    visible: true
    width: 720
    height: 480
    title: qsTr("Каталог геймера")

    // объявляется системная палитра
    SystemPalette {
          id: palette;
          colorGroup: SystemPalette.Active
       }

    Rectangle{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: btnAdd.top
        anchors.bottomMargin: 8
        border.color: "gray"

    ScrollView {
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        //flickableItem.interactive: true  // сохранять свойство "быть выделенным" при потере фокуса мыши

        Text {
            anchors.fill: parent
            text: "Could not connect to SQL"
            color: "red"
            font.pointSize: 20
            font.bold: true
            visible: IsConnectionOpen == false
        }

        ListView {
            id: gameList
            anchors.fill: parent
            model: gameModel // назначение модели, данные которой отображаются списком
            delegate: DelegateForGames{}
            clip: true //
            activeFocusOnTab: true  // реагирование на перемещение между элементами ввода с помощью Tab
            focus: true  // элемент может получить фокус
            opacity: {if (IsConnectionOpen == true) {100} else {0}}
        }
    }
   }

    Button {
        id: btnAdd
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        anchors.right:btnEdit.left
        text: "Добавить"
        width: 100

        onClicked: {
            windowAddEdit.currentIndex = -1
            windowAddEdit.show()
        }
    }

    Button {
        id: btnEdit
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: btnDel.left
        anchors.rightMargin: 8
        text: "Редактировать"
        width: 100
        onClicked: {
            var nameGam = gameList.currentItem.gameData.NameOfGame
            var platformGam = gameList.currentItem.gameData.PlatformOfGame
            var creatorGam = gameList.currentItem.gameData.CreatorOfGame
            var genreGam = gameList.currentItem.gameData.GenreOfGame
            var index = gameList.currentItem.gameData.Id

            windowAddEdit.execute(nameGam, platformGam, creatorGam, genreGam,index)
        }
    }
    ComboBox
       {
           id: comboBoxPlatform
           anchors.bottom: parent.bottom
           anchors.bottomMargin: 3
           anchors.left:parent.left
           width: 120
           model: ["PC", "Xbox", "PS5", "Nintendo", "Phone"]
       }
    Button {
               id: butCount
               // Устанавливаем расположение кнопки
               anchors.bottom: parent.bottom
               anchors.bottomMargin: 8
               anchors.left: comboBoxPlatform.right
               anchors.leftMargin: 8

               text: "Подсчитать"

               width: 100

               onClicked: {
                   windowAnswer.countGames(comboBoxPlatform.currentValue.toString())
               }
           }


    Button {
        id: btnDel
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right:parent.right
        anchors.rightMargin: 8
        text: "Удалить"
        width: 100
        enabled: {
            if (gameList.currentItem==null || gameList.currentItem.gameData == null)
            {false}
            else
            {gameList.currentItem.gameData.Id >= 0} }
        onClicked: del(gameList.currentItem.gameData.Id)
    }

    Label {
        id: labelArea
        // Устанавливаем расположение надписи
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.left: parent.left
        anchors.rightMargin: 8
        anchors.leftMargin: 3
        // Выравниваем по правой стороне
        Layout.alignment: Qt.AlignRight
        // Настраиваем текст
        text: qsTr("Выберете Платформу:")
    }


   /* Button {
        id: butCount
        // Устанавливаем расположение кнопки
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: textSelArea.right
        anchors.leftMargin: 8
        // Устанавливаем текст
        text: "Подсчитать"
        // Устанавливаем ширину кнопки
        width: 100
        onClicked: {
            windowAnswer.countGames(textSelArea.text)
        }
    }
 */
    DialogForAddorEdit {
        id: windowAddEdit
    }

    DialogForAnswer {
        id: windowAnswer
    }
}
