#include "gamelistsql.h"
#include "QObject"

gameListSQL::gameListSQL(QObject *parent) :
    QSqlQueryModel(parent)
{

//    QSqlDatabase::removeDatabase("myConnection");

//    db = QSqlDatabase::addDatabase("QODBC3", "myConnection");

//    QString connectString = "Driver={SQL Server Native Client 11.0};";
//    connectString.append("Server=localhost\\SQLEXPRESS;");
//    connectString.append("Database=Lab4Students;");
//    connectString.append("Trusted_Connection=yes;");

//    db.setDatabaseName(connectString);

    db = QSqlDatabase::addDatabase("QPSQL", "myConnection");

    db.setHostName("127.0.0.1");
    db.setPort(5432);
    db.setUserName("postgres");
    db.setPassword("1234");
    db.setDatabaseName("games");

     _isConnectionOpen = true;

    if(!db.open())
    {
        qDebug() << db.lastError().text();
        _isConnectionOpen = false;
    }

    QString m_schema = QString( "CREATE TABLE IF NOT EXISTS games (Id SERIAL PRIMARY KEY, "
                                "Name text, "
                                "Platform text, "
                                "Creator text, "
                                "Genre text); " );


    QSqlQuery qry(m_schema, db);

    if( !qry.exec() )
    {
        //qDebug() << db.lastError().text();
        //_isConnectionOpen = false;
    }

    refresh();
}

QSqlQueryModel* gameListSQL::getModel(){
    return this;
}
bool gameListSQL::isConnectionOpen(){
    return _isConnectionOpen;
}
//!!!!
QHash<int, QByteArray> gameListSQL::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::UserRole + 1] = "NameOfGame";
    roles[Qt::UserRole + 2] = "PlatformOfGame";
    roles[Qt::UserRole + 3] = "CreatorOfGame";
    roles[Qt::UserRole + 4] = "GenreOfGame";
    roles[Qt::UserRole + 5] = "Id";

    return roles;
}


QVariant gameListSQL::data(const QModelIndex &index, int role) const
{
    QVariant value = QSqlQueryModel::data(index, role);
    if(role < Qt::UserRole-1)
    {
        value = QSqlQueryModel::data(index, role);
    }
    else
    {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

const char* gameListSQL::SQL_SELECT =
        "SELECT Name, Platform, Creator, Genre, Id FROM games";

void gameListSQL::refresh()
{
    this->setQuery(gameListSQL::SQL_SELECT,db);
}

void gameListSQL::add(const QString& nameGam,
                       const QString& platformGam,
                       const QString& creatorGam,
                      const QString& genreGam){

    QSqlQuery query(db);
    QString strQuery= QString("INSERT INTO games (Name, Platform, Creator, Genre) VALUES ('%1', '%2', '%3', '%4')")
            .arg(nameGam)
            .arg(platformGam)
            .arg(creatorGam)
            .arg(genreGam);
    query.exec(strQuery);

    refresh();

}
void gameListSQL::edit(const QString& nameGam,
                        const QString& platformGam,
                        const QString& creatorGam,
                        const QString& genreGam,
                        const int index){

    QSqlQuery query(db);
    QString strQuery= QString("UPDATE games SET Name = '%1', Platform = '%2', Creator = '%3', Genre = '%4' WHERE Id = %5")
            .arg(nameGam)
            .arg(platformGam)
            .arg(creatorGam)
            .arg(genreGam)
            .arg(index);
    query.exec(strQuery);

    refresh();

}
void gameListSQL::del(const int index){


    QSqlQuery query(db);
    QString strQuery= QString("DELETE FROM games WHERE Id = %1")
            .arg(index);
    query.exec(strQuery);

    refresh();
}

QString gameListSQL::count(const QString& selectedPlatform)
{
    QSqlQuery query(db);
    QString strQuery= QString("SELECT COUNT(Id) FROM games WHERE Platform = '%1'")
            .arg(selectedPlatform);

    query.exec(strQuery);
    QString info;
    while (query.next())
    {
        info = query.value(0).toString();
        qDebug() << info;
    }

    return(info);
}
