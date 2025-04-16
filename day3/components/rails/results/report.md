# Сценарий.

## Пункт 1.
- Создал модель DataFile с колонками file:string, status:integer (enum)
- Создал контроллер DataController с экшеном input, в котором на основании входных данных, создаем объекты и сохраняем в БД со статусом "НЕобработанные" (raw)
- Прописал пути новоиспеченного контроллера в config/routes.rb

## Пункт 2.
- Создал файл publisher.rb где в цикле буду запускать задачу по обработке файлов DataHandlerJob
- Соответственно создал саму задачу DataHandlerJob по изменению состояния объектов на "ОБРАБОТАННЫЕ" (processed)

## Пункт 3.
- Для проверки данного этапа стартую сервер и запускаю с POSTMAN запрос на адрес http://localhost:3000/data/input, с параметрами в теле запроса files = ["file_1", "file_2", "file_3", "file_4"] -> Создалось 4 объекта DataFile со статусом raw
- Открываю дополнительные 2 вкладки и в одной запускаю Listener (rails r ./redis_listerner.rb), в другой Publisher (rails r publisher.rb)

*[ActiveJob] [DataHandlerJob] [8b0fcba0-996c-4946-ae78-12797619588e] Processed 3 files*
*[ActiveJob] [DataHandlerJob] [8b0fcba0-996c-4946-ae78-12797619588e] Performed DataHandlerJob (Job ID: ...*
*[ActiveJob] [DataHandlerJob] [96defa3f-6b8a-473a-b3b9-2c0b4edf5b57] Processed 1 files*
*[ActiveJob] [DataHandlerJob] [96defa3f-6b8a-473a-b3b9-2c0b4edf5b57] Performed DataHandlerJob (Job ID: ...*
*[ActiveJob] [DataHandlerJob] [87602116-9b82-4fca-a8b6-2a075d4cbbd3] No files to process*
*[ActiveJob] [DataHandlerJob] [87602116-9b82-4fca-a8b6-2a075d4cbbd3] Performed DataHandlerJob (Job ID: ...*

- Все 4 файла обработались, т.е. их статус стал ОБРАТБОТАННЫЕ (proccessed) (в DataHandlerJob берется пачка по 3 файла)

## Пункт 4.
- Создал задачу по удалению обработанных данных DataDeleteJob. Удаляю данные, делая блокировку на процесс с помощью with_advisory_lock.
- Запускаю rails r ./scheduler.rb и смотрю логи:

*[2025-04-15T22:16:44.623952 #34837]  INFO -- : [ActiveJob] [DataDeleteJob] [37b73118-cce1-4049-ab91-475bd8fe7bc8] Deleted 4 files*
*[ActiveJob] [DataDeleteJob] [37b73118-cce1-4049-ab91-475bd8fe7bc8] Performed DataDeleteJob (Job ID: ...*
*[ActiveJob] Enqueued TestSchedulerJob (Job ID: 5a469095-3f3d-4f0e-ab51-f28a9ef19334) to DelayedJob(default)*
*...*
*[ActiveJob] [DataDeleteJob] [ef975175-a31b-4809-b715-2ed02fce92d7] No files to delete*
*[ActiveJob] [DataDeleteJob] [ef975175-a31b-4809-b715-2ed02fce92d7] Performed DataDeleteJob (Job ID: ...*

- Все 4 файла были удалены пакетно, последующие логи нам дают информацию, что файлов для удаления нет

## Метрики.
- Создал свои метрики для подсчета НЕобработанных, обработанных и удаленных данных (raw_data_count, processed_data_count, deleted_data_count), пришлось переработать Jobs

*# TYPE raw_data_count counter*
*# HELP raw_data_count Total number of raw data_files*
*raw_data_count 28.0*
*# TYPE processed_data_count counter*
*# HELP processed_data_count Total number of processed data_files*
*processed_data_count 28.0*
*# TYPE deleted_data_count counter*
*# HELP deleted_data_count Total number of deleted data_files*
*deleted_data_count{source="data_deleted"} 28.0*

## Выводы:
- Благодаря метрикам увидел нарастание обработанных данных и увеличил частоту удаления данных с 20 до 10 секунд
- Разделил работу задачи на отдельные компоненты, контролируя процесс с помощью метрик