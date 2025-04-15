# Сценарий.

## Пункт 1.
- Создал модель DataFile с колонками file:string, status:integer (enum)
- Создал контроллер DataController с экшеном input, в котором на основании входных данных, создаем объекты и сохраняем в БД со статусом "НЕобработанные" (raw)
- Прописал пути новоиспеченного контроллера в config/routes.rb

## Пункт 2.
- Создал файл publisher.rb где в цикле буду запускать задачу по обработке файлов DataHandlerJob
- Соответственно создал саму задачу DataHandlerJob по изменению состояния объектов на "ОБРАБОТАННЫЕ" (processed)

## Пункт 3.
- Для проверки данного этапа стартую сервер и запускаю с POSTMAN запрос на адрес http://localhost:3000/data/input, с параметрами в теле запроса files = ["file_1", "file_2", "file_3", "file_3"] -> Создалось 4 объекта DataFile со статусом raw
- Открываю дополнительные 2 вкладки и в одной запускаю Listener (rails r ./redis_listerner.rb), в другой Publisher (rails r publisher.rb)

*[ActiveJob] [DataHandlerJob] [8b0fcba0-996c-4946-ae78-12797619588e] Processed 3 files*
*[ActiveJob] [DataHandlerJob] [8b0fcba0-996c-4946-ae78-12797619588e] Performed DataHandlerJob (Job ID: ...*
*[ActiveJob] [DataHandlerJob] [96defa3f-6b8a-473a-b3b9-2c0b4edf5b57] Processed 1 files*
*[ActiveJob] [DataHandlerJob] [96defa3f-6b8a-473a-b3b9-2c0b4edf5b57] Performed DataHandlerJob (Job ID: ...*
*[ActiveJob] [DataHandlerJob] [87602116-9b82-4fca-a8b6-2a075d4cbbd3] No files to process*
*[ActiveJob] [DataHandlerJob] [87602116-9b82-4fca-a8b6-2a075d4cbbd3] Performed DataHandlerJob (Job ID: ...*

- Все 4 файла обработались, т.е. их статус стал ОБРАТБОТАННЫЕ (proccessed) (в DataHandlerJob берется пачка по 3 файла)
